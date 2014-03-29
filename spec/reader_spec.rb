require 'ffi-libav'
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

  context "with :ffs => true" do
    subject(:reader) { Libav::Reader.new(test_video, :ffs => true) }

    its(:ffs) { should eq [[reader.default_stream.index]] }

    describe "#each_frame" do
      context "before seeking" do
        it "updates ffs data for key frames read" do
          # Read until we see 10 key frames for our default stream, then verify
          # that there are 10 entries in the ffs data, exclusing the stream
          # index record at the top.

          count = 0
          reader.each_frame do |frame|
            next unless frame.stream == reader.default_stream

            count += 1 if f.stream == reader.default_stream && 
          end
          stream.each_frame { |f| count += 1 if f.key_frame?; count < 20 }
          expect(stream.ffs).to eq ffs_data[stream.index][0..19]
        end
        it "updates last frame data for each frame read" do
          count = 0
          stream.each_frame do |frame|
            count += 1
            expect(stream.ffs.last[0]).to eq frame.number
            expect(stream.ffs.last[1]).to eq frame.pts
            count < 100
          end
        end
      end

      context "after seeking" do
        it "does not update ffs data for key frames read" do
          stream.seek(:byte => 100_000)
          count = 0
          stream.each_frame { |f| count += 1 if f.key_frame?; count < 20 }
          expect(stream.ffs).to eq []
        end
        it "does not update last frame data"
      end
    end
  end
  end
    
end
