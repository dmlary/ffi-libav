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
    its(:ffs) { should eq [[], []] }
  end
end
