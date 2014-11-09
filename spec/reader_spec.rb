# encoding: UTF-8
require 'spec_helper.rb'

describe Libav::Reader do
  # This is the fast frame seek data for the test video.  It is used for the
  # AFS related contexts.
  subject(:afs_data) do
    YAML.load_file \
      File.join(File.dirname(__FILE__), "data/big_buck_bunny-afs.yml")
  end

  subject(:test_video) do
    File.join(File.dirname(__FILE__),
      "data/big_buck_bunny_480p_surround-fix.avi")
  end
  subject(:reader) { Libav::Reader.new(test_video) }

  context "with :afs => true" do
    subject(:reader) { Libav::Reader.new(test_video, :afs => true) }
    its(:afs) { should eq [[], []] }
  end

  describe "::open" do
    it "will yield a Libav::Reader" do
      expect { |r| Libav::Reader.open(test_video, &r) }.to yield_with_args(Libav::Reader)
    end
  end
end
