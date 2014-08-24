require 'ffi-libav'
require 'yaml'
require 'timeout'
require 'zlib'

# For testing
class Libav::Frame::Video
  def crc
    height.times.inject(0) do |crc,row|
      Zlib::crc32(data[0].get_bytes(linesize[0] * row, width), crc)
    end
  end
end

describe Libav::Stream::Video do
  TEST_VIDEO = File.join(File.dirname(__FILE__),
      "data/big_buck_bunny_480p_surround-fix.avi")

  subject(:test_video) { TEST_VIDEO }

  # Generate a subset of ffs data for our test video.  We read the file until
  # we see 50 entries in the ffs data.
  r = Libav::Reader.new(TEST_VIDEO, :ffs => true)
  r.each_frame { break if r.ffs.size == 25 }
  ffs_data = r.ffs
  r = nil
  subject(:ffs_data) { ffs_data }

  # Set up our reader and stream subjects
  subject(:reader) { Libav::Reader.new(test_video) }
  subject(:stream) { reader.streams.find { |stream| stream.type == :video } }

  its(:class) { should be Libav::Stream::Video }
  its(:width) { should be 854 }
  its(:height) { should be 480 }
  its(:pixel_format) { should be :yuv420p }
  its(:reader) { should be reader }
  its(:fps) { should eq 24.0 }

  describe "#each_frame" do
    shared_examples "video frame yielder" do
      it "yields Frame::Video objects" do
        frame = nil
        stream.each_frame { |f| frame = f; break }
        expect(frame.class).to be Libav::Frame::Video
      end
      
      it "only yields frames from this stream" do
        # This test is invalid right now because we only support video streams
        # and our test video only contains a single video stream.
        index = []
        subject.each_frame(:buffer => buffer_size) do |f|
          index << f.stream.index
          stream.release_frame(f)
          break if index.size == 250
        end

        expect(index.uniq).to eq [ subject.index ]
      end

      it "yields sequential frame numbers" do
        frames = []
        subject.each_frame(:buffer => buffer_size) do |f|
          frames << f.number
          stream.release_frame(f)
          break if frames.size == 250
        end

        expect(frames).to eq (1..250).to_a
      end

      it "adjusts the output frame number for the frame number offset" do
        subject.instance_eval { @frame_offset = 100_000 }
        subject.each_frame(:buffer => buffer_size) do |frame|
          expect(frame.number).to be 100_001
          stream.release_frame(frame)
          break
        end
      end

      it "adjusts the output frame pts for the frame pts offset" do
        subject.instance_eval { @pts_offset = 100_000_000 }
        subject.each_frame(:buffer => buffer_size) do |frame|
          # PTS of the first frame is 8
          expect(frame.pts).to be 100_000_008
          stream.release_frame(frame)
          break
        end
      end

      it "will yield frames with correct pts values" do
        pts = []
        stream.each_frame(:buffer => buffer_size) do |frame|
          pts << frame.pts
          stream.release_frame(frame)
          break if pts.size == 10
        end

        # test video starts at pts 8, increments by 1
        expect(pts).to eq (8..17).to_a
      end

      it "will yield frames with correct timestamps" do
        stamps = []
        stream.each_frame(:buffer => buffer_size) do |frame|
          stamps << frame.timestamp
          stream.release_frame(frame)
          break if stamps.size == 10
        end
        
        expect(stamps).to eq (8..17).to_a.map { |pts| pts * (1/stream.fps) }
      end

      it "will yield a frame with data" do
        # if one has data, assume they all have it
        expect(frame.data.first.address).to_not eq 0
      end

      it "will yield a frame with key_frame set correctly" do
        keys = []
        stream.each_frame(:buffer => buffer_size) do |frame|
          keys << frame.key_frame?
          stream.release_frame(frame)
          break if keys.size == 10
        end
       
        expect(keys).to eq [true, false, false, false, false, true, false,
                            false, true, true]
      end

      context "file is at EOF" do
        before { subject.seek :byte => File.size(reader.filename) }
        it "yields the block a nil frame" do
          count = 0
          subject.each_frame(:buffer => buffer_size) do |frame|
            stream.release_frame(frame)
            count += 1
            expect(count).to be < 2
            expect(count).to be nil
          end
        end
      end
    end

    shared_examples "scaling video frame yielder" do
      context "without scaling" do
        let(:frame) do
          stream.each_frame(:buffer => buffer_size) { |f| f.release; break f }
        end
        after(:each) { stream.release_frame(frame) }

        it_should_behave_like "video frame yielder"

        it "will preserve frame width" do
          expect(frame.width).to be stream.av_codec_ctx[:width]
        end

        it "will preserve frame height" do
          expect(frame.height).to be stream.av_codec_ctx[:height]
        end
           
        it "will preserve pixel format" do
          expect(frame.pixel_format).to be stream.av_codec_ctx[:pix_fmt]
        end
      end

      context "with scaling" do
        before do
          stream.width /= 2
          stream.height /= 2
          stream.pixel_format = :gray8
        end
        
        let(:frame) do
          frame = nil
          stream.each_frame { |f| frame = f; break }
          frame
        end

        after(:each) { stream.release_frame(frame) }

        it_should_behave_like "video frame yielder"

        it "should scale frame width" do
          expect(frame.width).to be stream.av_codec_ctx[:width] / 2
        end

        it "should scale frame height" do
          expect(frame.height).to be stream.av_codec_ctx[:height] / 2
        end
           
        it "should change pixel format" do
          expect(frame.pixel_format).to be :gray8
        end
      end
    end

    context "without buffer" do
      let(:buffer_size) { 0 }
      it_behaves_like "scaling video frame yielder"

      shared_examples "unbuffered frame yielder" do
        it "yields the same Frame object for each frame" do
          frames = []
          subject.each_frame(:buffer => buffer_size) do |frame|
            frames << frame
            break if frames.size == 100
          end
          expect(frames.uniq).to eq [frames.first]
        end
      end

      context "without scaling" do
        it_should_behave_like "unbuffered frame yielder"
      end

      context "with scaling" do
        before do
          stream.width /= 2
          stream.height /= 2
          stream.pixel_format = :gray8
        end

        it_should_behave_like "unbuffered frame yielder"
      end

    end

    context "with buffer" do
      let(:buffer_size) { 5 }

      it_behaves_like "scaling video frame yielder"

      shared_examples "buffered frame yielder" do
        it "yields multiple Frame objects" do
          frames = []
          stream.each_frame(:buffer => buffer_size) do |frame|
            frames << frame
            stream.release_frame(frame)
            break if frames.size == 100
          end
          expect(frames.uniq.size).to eq stream.buffer
        end

        it "blocks if the caller doesn't release frames" do
          expect do
            Timeout.timeout(2) do
              count = 0
              stream.each_frame(:buffer => buffer_size) do
                count += 1
                break if count > stream.buffer
              end
            end
          end.to raise_error(Timeout::Error)
        end

        it "reuses released frames" do
          frame = nil
          count = 0

          # Set up a scenario where we drain the frame buffer, and save off one
          # of the frames we receive.
          stream.each_frame(:buffer => buffer_size) do |f|
            frame ||= f
            count += 1
            break if count == stream.buffer
          end

          # Release our saved frame, then pull another 100 frames, saving them to
          # an array, and releasing them to be reused.  The idea is that the next
          # 100 frames should be the same object as our saved frame.
          frames = []
          stream.release_frame(frame)
          stream.each_frame(:buffer => buffer_size) do |f|
            frames << f
            stream.release_frame(f)
            break if frames.size == 100
          end

          expect(frames.uniq).to eq [frame]
        end

        it "preserves the buffer size across calls unless explicitly set" do
          stream.each_frame(:buffer => 3) { break }
          expect(stream.buffer).to eq 3
          stream.each_frame { break }
          expect(stream.buffer).to eq 3
        end
      end

      context "without scaling" do
        it_should_behave_like "buffered frame yielder"
      end

      context "with scaling" do
        before do
          stream.width /= 2
          stream.height /= 2
          stream.pixel_format = :gray8
        end

        it_should_behave_like "buffered frame yielder"
      end
    end
  end

  describe "#next_frame" do
    shared_examples "frame reader" do
      it "returns Frame::Video object" do
        expect(stream.next_frame.class).to be Libav::Frame::Video
      end
      it "only returns frames for this stream" do
        streams = 100.times.map { stream.next_frame.stream.index }.uniq
        expect(streams).to eq [ stream.index ]
      end
      it "returns the next frame in the stream" do
        last_frame = nil
        stream.each_frame do |frame|
          last_frame = frame.number and break if rand(50) == 0
        end

        expect(stream.next_frame.number).to eq last_frame + 1
      end
    end

    context "without scaling" do
      it_should_behave_like "frame reader"
    end

    context "with scaling" do
      before do
        stream.width /= 2
        stream.height /= 2
        stream.pixel_format = :gray8
      end

      it_should_behave_like "frame reader"
    end
  end

  describe "#skip_frames" do
    before { subject.skip_frames(100) }
    its("next_frame.number") { should eq 101 }
  end

  describe "#rewind" do
    it "causes #each_frame to yield previously yielded frames" do
      first = []
      stream.each_frame(:buffer => 5) do |frame|
        first << frame.number
        frame.release
        break if first.size == 5
      end

      stream.rewind(5)
      second = []
      stream.each_frame do |frame|
        second << frame.number
        frame.release
        break if second.size == 5
      end

      expect(first).to eq second
    end

    it "returns 0 when no frames have been decoded" do
      # XXX should be in reader_spec
      expect(stream.rewind).to eq 0
    end

    it "returns 0 when count is 0" do
      # XXX should be in reader_spec
      expect(stream.rewind(0)).to eq 0
    end

    it "rewinds as many frames as possible when count exceeds buffer" do
      first = []
      stream.each_frame(:buffer => 5) do |frame|
        first << frame.number
        frame.release
        break if first.size == 10
      end

      expect(stream.rewind(10)).to eq 5
      expect(stream.each_frame { |f| break f }.number).to be 6
    end

    it "removes rewound frames from decoding queue" do
      frames = []
      stream.each_frame(:buffer => 5) do |frame|
        frames << frame.object_id
        frame.release
        break if frames.size == 5
      end
      expect(frames.uniq.size).to eq 5

      # rewind the last five frames
      stream.rewind(5)
    
      # skip the next five frames
      stream.skip_frames(5)

      # the sixth frame should be a new object id
      expect(frames).to_not include(stream.next_frame.object_id)
    end

    it "can be called multiple times" do
      frames = []
      stream.each_frame(:buffer => 5) do |frame|
        frames << frame.number
        frame.release
        break if frames.size == 5
      end
     
      stream.rewind(1)
      expect(stream.next_frame.number).to eq frames[4]

      stream.rewind(2)
      expect(stream.next_frame.number).to eq frames[3]

      stream.rewind(2)
      expect(stream.next_frame.number).to eq frames[2]

      stream.rewind(2)
      expect(stream.next_frame.number).to eq frames[1]

      stream.rewind(2)
      expect(stream.next_frame.number).to eq frames[0]
      expect(stream.next_frame.number).to eq frames[1]
      expect(stream.next_frame.number).to eq frames[2]
      expect(stream.next_frame.number).to eq frames[3]
      expect(stream.next_frame.number).to eq frames[4]
      expect(stream.next_frame.number).to eq frames[4] + 1
    end

    it "does rewind over re-used frames" do
      first = stream.next_frame
      second = stream.next_frame
      expect(stream.next_frame.number).to eq second.number
    end
  end

  describe "#index" do
    its("index") { should be subject.av_stream[:index] }
  end

  describe "#[]" do
    let(:num) { rand(0xFFFFFFFF) }
    before { subject.av_stream[:nb_frames] = num }
    it "delegates to stream.av_stream" do
      expect(subject[:nb_frames]).to eq num
    end
  end

  describe "#discard" do
    before { subject.av_stream[:discard] = :nonkey }
    its(:discard) { should be :nonkey }
  end

  describe "#type" do
    its(:type) { should be :video }
    its(:type) { should be subject.av_stream[:codec][:codec_type] }
  end

  context "with FFS disabled" do
    describe "#each_frame" do
      it "does not update FFS data" do
        count = 0
        subject.each_frame do |f|
          count += 1 if f.key_frame
          break if count == 20
        end
        expect(reader.ffs).to be nil
      end
    end

    describe "#seek" do
      context "by pts" do
        before { subject.seek :pts => 30 * subject.fps }
        its("next_frame.pts") { should be >= 30 * subject.fps }
        its("next_frame.key_frame?") { should be true }
      end
      context "non-key frames" do
        before { subject.seek :pts => 30 * subject.fps, :any => true }
        its("next_frame.pts") { should be >= 30 * subject.fps }
        its("next_frame.key_frame?") { should be false }
      end
      context "by byte" do
        before { subject.seek :byte => 100_000_000 }
        # The codec used in our test video does not correctly adjust the pts
        # following a seek.
        # its("next_frame.pts") { should be ??? }
        its("next_frame.pos") { should be >= 100_000_000 }

        # Also, seeking by byte does not care about key frames.
        # its("next_frame.key_frame?") { should be true }
      end
    end
  end

  context "with FFS enabled" do
    subject(:reader) { Libav::Reader.new(test_video, :ffs => true) }
    subject(:stream) { reader.streams.find { |stream| stream.type == :video } }

    its(:ffs) { should be_empty }

    describe "#each_frame" do
      context "before seeking" do
        it "updates the ffs data for the last frame read" do
          count = 0
          stream.each_frame do |frame|
            count += 1
            expect(stream.ffs.last[0]).to eq frame.number
            expect(stream.ffs.last[1]).to eq frame.pts
            expect(stream.ffs.last[2]).to eq frame.pos
            expect(stream.ffs.last[3]).to eq frame.key_frame?
            break if count == 200
          end
        end

        it "only preserves ffs data for key frames" do
          count = 0
          stream.each_frame do |frame|
            next unless frame.key_frame?
            count += 1
            break if count == 20
          end
          expect(stream.ffs.size).to eq count
        end
      end

      context "after seeking" do
        before { stream.seek(:byte => 100_000) }

        it "does not update ffs data for key frames read" do
          count = 0
          stream.each_frame { |f| count += 1 if f.key_frame?; count < 20 }
          expect(stream.ffs).to eq []
        end
        it "does not update last frame data" do
          count = 0
          stream.each_frame do |frame|
            count += 1
            break if count == 100
          end
          expect(stream.ffs).to be_empty
        end
      end
    end
  end

  context "with FFS data provided" do
    subject(:reader) { Libav::Reader.new(test_video, :ffs => ffs_data) }
    subject(:stream) { reader.streams.find { |stream| stream.type == :video } }

    its(:ffs) { should be ffs_data[stream.index] }

    describe "#each_frame" do
      it "does not update ffs for known frames" do
        count = 0
        stream.each_frame { |f| break if (count += 1) == 100 }
        expect(stream.ffs).to eq ffs_data[stream.index]
      end

      it "updates ffs data for frames beyond existing ffs data" do
        stream.seek(:frame => stream.ffs[-1][0])

        count = 0
        stream.each_frame do |frame|
          count += 1
          expect(stream.ffs.last[0]).to eq frame.number
          expect(stream.ffs.last[1]).to eq frame.pts
          expect(stream.ffs.last[2]).to eq frame.pos
          expect(stream.ffs.last[3]).to eq frame.key_frame?
          break if count == 200
        end
      end
    end

    describe "#seek" do
      shared_examples "frame accurate seek" do
        context "within ffs data" do
          it "can find a key frame by pts" do
            stream.seek(:pts => 22)
            frame = stream.next_frame
            expect(frame.number).to eq 15
            expect(frame.pts).to eq 22
            expect(frame.pos).to eq 157836
            expect(frame.crc.to_s(16)).to eq "6c56942e"
          end

          it "can find a non-key frame by pts" do
            stream.seek(:pts => 54)
            frame = stream.next_frame
            expect(frame.number).to eq 47
            expect(frame.pts).to eq 54
            expect(frame.pos).to eq 658930
            expect(frame.crc.to_s(16)).to eq "496919b1"
          end

          it "can find a key frame by byte" do
            # [270, 277, 4942848, 1, "0xf8ea5eb2"],
            stream.seek(:byte => 4942848)
            frame = stream.next_frame
            expect(frame.number).to eq 270
            expect(frame.pts).to eq 277
            expect(frame.pos).to eq 4942848
            expect(frame.crc.to_s(16)).to eq "f8ea5eb2"
          end

          it "can find a non-key frame by byte" do
            # [350, 357, 6901944, 0, "0x3ea2c2ff"]]
            stream.seek(:byte => 6901944)
            frame = stream.next_frame
            expect(frame.number).to eq 350
            expect(frame.pts).to eq 357
            expect(frame.pos).to eq 6901944
            expect(frame.crc.to_s(16)).to eq "3ea2c2ff"
          end

          it "finds key frame by frame number" do
            stream.seek(:frame => 20)
            frame = stream.next_frame
            expect(frame.number).to eq 20
            expect(frame.pts).to eq 27
            expect(frame.pos).to eq 213188
            expect(frame.crc.to_s(16)).to eq "85190ba9"
          end

          it "can find a non-key frame by frame number" do
            stream.seek(:frame => 21)
            frame = stream.next_frame
            expect(frame.number).to eq 21
            expect(frame.pts).to eq 28
            expect(frame.pos).to eq 224996
          end
        end

        context "outside of ffs data" do
          # Seek past the end of our ffs data
          before { stream.seek :frame => stream.ffs.last[0] + 1 }

          it "disables ffs updates" do
            expect(stream.instance_eval { @update_ffs }).to be false
          end

          it "re-enables ffs updates" do
            stream.seek :frame => 100
            expect(stream.instance_eval { @update_ffs }).to be true
          end
        end
      end

      context "before reading frames" do
        it_should_behave_like "frame accurate seek"
      end
      context "after seeking to the end" do
        before { stream.seek :byte => File.size(reader.filename) }
        it_should_behave_like "frame accurate seek"
      end
      context "after reading 100 frames" do
        before { c = 0; stream.each_frame { break if (c += 1) == 100 } }
        it_should_behave_like "frame accurate seek"
      end
      context "after seeking to the middle, and reading 100 frames" do
        before do
          stream.seek :byte => File.size(reader.filename)/2
          count = 0
          stream.each_frame { break if (count += 1) == 100 }
        end
        it_should_behave_like "frame accurate seek"
      end
    end
  end
end
