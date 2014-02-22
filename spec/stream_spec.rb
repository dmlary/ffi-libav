require 'yaml'

describe Libav::Stream::Video do
  # This is the fast frame seek data for the test video.  It is used for the
  # FFS related contexts.
  subject(:ffs_data) do
    YAML.load_file \
      File.join(File.dirname(__FILE__), "data/big_buck_bunny-ffs.yml")
  end

  subject(:test_video) do
    File.join(File.dirname(__FILE__),
      "data/big_buck_bunny_480p_surround-fix.avi")
  end
  subject(:reader) { Libav::Reader.new(test_video) }
  subject(:stream) { reader.streams.find { |stream| stream.type == :video } }

  its(:class) { should be Libav::Stream::Video }
  its(:width) { should be 854 }
  its(:height) { should be 480 }
  its(:pixel_format) { should be :yuv420p }
  its(:reader) { should be reader }
  its(:fps) { should eq 24.0 }

  describe "#each_frame" do
    context "file is not at EOF" do
      it "stops looping if the block returns false" do
        count = 0
        subject.each_frame do |frame|
          expect(count).to be < 5
          count += 1
          count < 5
        end
        expect(count).to be 5
      end
    end

    context "file is at EOF" do
      before { subject.seek :pos => File.size(reader.filename) }
      it "calls the block with nil only once" do
        count = 0
        subject.each_frame do |frame|
          count += 1
          expect(count).to be < 2
          expect(count).to be nil
        end
      end
    end

    it "adjusts the output frame number for the frame number offset" do
      subject.instance_eval { @frame_offset = 100_000 }
      subject.each_frame do |frame|
        expect(frame.number).to be 100_001
        break
      end
    end

    it "adjusts the output frame pts for the frame pts offset" do
      subject.instance_eval { @pts_offset = 100_000_000 }
      subject.each_frame do |frame|
        # PTS of the first frame is 8
        expect(frame.pts).to be 100_000_008
        break
      end
    end
  end

  describe "#next_frame" do
    context "first frame" do
      its("next_frame.class") { should be Libav::Frame::Video }
      its("next_frame.number") { should eq 1 }
      its("next_frame.width") { should eq subject.width }
      its("next_frame.height") { should eq subject.height }
      its("next_frame.pixel_format") { should eq subject.pixel_format }

      # First frame that comes out of big buck bunny has pts 8
      its("next_frame.pts") { should eq 8 }
      its("next_frame.timestamp") { should eq 8 * (1/subject.fps) }

      # Make sure we have some sort of frame data
      its("next_frame.data.first.address") { should_not eq 0x0 }

      # We should be a key frame
      its("next_frame.key_frame?") { should be true }
    end

    context "second frame" do
      before { subject.next_frame }
      its("next_frame.number") { should eq 2 }

      # First frame that comes out of big buck bunny has pts 8
      its("next_frame.pts") { should eq 9 }
      its("next_frame.timestamp") { should eq 9 * (1/subject.fps) }

      # Make sure we have some sort of frame data
      its("next_frame.data.first.address") { should_not eq 0x0 }

      # We should be a key frame
      its("next_frame.key_frame?") { should be false }
    end

    context "100th frame" do
      before { subject.skip_frames(99) }
      its("next_frame.number") { should eq 100 }

      # First frame that comes out of big buck bunny has pts 8
      its("next_frame.pts") { should eq 107 }
      its("next_frame.timestamp") { should eq 107 * (1/subject.fps) }

      # Make sure we have some sort of frame data
      its("next_frame.data.first.address") { should_not eq 0x0 }

      # We should be a key frame
      its("next_frame.key_frame?") { should be false }
    end

    context "with scaling" do
      before do
        subject.width = 640
        subject.height = 480
        subject.pixel_format = :gray8
      end

      its("next_frame.number") { should eq 1 }
      its("next_frame.width") { should eq 640 }
      its("next_frame.height") { should eq 480 }
      its("next_frame.pixel_format") { should eq :gray8 }

      # First frame that comes out of big buck bunny has pts 8
      its("next_frame.pts") { should eq 8 }
      its("next_frame.timestamp") { should eq 8 * (1/subject.fps) }

      # Make sure we have some sort of frame data
      its("next_frame.data.first.address") { should_not eq 0x0 }

      # We should be a key frame
      its("next_frame.key_frame?") { should be true }
    end

    context "file is at EOF" do
      before { subject.seek :pos => File.size(reader.filename) }
      its("next_frame") { should be nil }
    end
  end

  describe "#skip_frames" do
    let!(:offset) { rand(10000) }
    before { subject.skip_frames(offset) }
    its("next_frame.number") { should eq 1 + offset }
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
    its(:ffs) { should be nil }

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
        before { subject.seek :pos => 100_000_000 }
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
        it "updates ffs data for key frames read" do
          count = 0
          stream.each_frame { |f| count += 1 if f.key_frame?; count < 20 }
          expect(stream.ffs).to eq ffs_data[stream.index][0..19]
        end
      end

      context "after seeking" do
        it "does not update ffs data for key frames read" do
          stream.seek(:pos => 100_000)
          count = 0
          stream.each_frame { |f| count += 1 if f.key_frame?; count < 20 }
          expect(stream.ffs).to eq []
        end
      end
    end
  end

  context "with FFS data provided" do
    subject(:reader) { Libav::Reader.new(test_video, :ffs => ffs_data) }
    subject(:stream) { reader.streams.find { |stream| stream.type == :video } }

    its(:ffs) { should be ffs_data[stream.index] }

    describe "#each_frame" do
      it "does not update ffs for known keyframes" do
        count = 0
        stream.each_frame { |f| count += 1 if f.key_frame?; count < 20 }
        expect(stream.ffs).to eq ffs_data[stream.index]
      end
      xit "updates ffs data for unknown keyframes" do
        # seek to the last key frame we saw by file position
        stream.seek(:pos => ffs_data[0].last.last)

        # Make a copy of the FFS data
        starting_ffs = stream.ffs.dup

        # Read 20 key frames
        count = 0
        stream.each_frame { |f| count += 1 if f.key_frame?; count < 20 }

        expect(stream.ffs.size).to eq 120
        expect(stream.ffs).to_not eq starting_ffs
        expect(stream.ffs[100]).to_not eq stream.ffs[101]
      end
    end

    describe "#seek" do
      it "can find a key frame by pts"
      it "can find a non-key frame by pts"
      it "can find a key frame by frame number"
      it "can find a non-key frame by frame number"
      it "adjusts frame number offset"
      it "adjusts frame pts offset"
      context "seeking outside of FFS data" do
        it "stops FFS updates"
      end
      context "seeking into FFS data" do
        it "resumes FFS updates"
      end
    end
  end
end
