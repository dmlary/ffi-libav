# encoding: UTF-8
require 'spec_helper.rb'
include Libav

describe Frame::Video, ".new" do
  context 'when allocating with attributes' do
    subject do
      Frame::Video.new :width => 1200, :height => 100,
                       :pixel_format => :gray8
    end
    its(:width) { is_expected.to eq(1200) }
    its(:height) { is_expected.to eq(100) }
    its(:pixel_format) { is_expected.to eq(:gray8) }
    its("data.first.address") { is_expected.to_not eq(0x0) }
  end

  context 'when not allocating, with attributes' do
    subject do
      Frame::Video.new :width => 1200, :height => 100,
                       :pixel_format => :gray8, :alloc => false
    end
    its(:width) { is_expected.to eq(1200) }
    its(:height) { is_expected.to eq(100) }
    its(:pixel_format) { is_expected.to eq(:gray8) }
    its("data.first.address") { is_expected.to eq(0x0) }
  end

  context 'when allocating, with :stream' do
    subject do
      stream = Object.new
      allow(stream).to receive(:width) { 1200 }
      allow(stream).to receive(:height) { 100 }
      allow(stream).to receive(:pixel_format) { :gray8 }
      Frame::Video.new :stream => stream
    end
    its(:width) { is_expected.to eq(1200) }
    its(:height) { is_expected.to eq(100) }
    its(:pixel_format) { is_expected.to eq(:gray8) }
    its("data.first.address") { is_expected.to_not eq(0x0) }
  end
end

describe Frame::Video do
  subject do
    Frame::Video.new :width => 1200, :height => 100,
                     :pixel_format => :gray8
  end

  describe "#pts=" do
    before { subject.pts = 0xFEEDFACE }
    its(:pts) { is_expected.to eq(0xFEEDFACE) }
    it "should set av_frame[:pts]" do
      expect(subject.av_frame[:pts]).to eq(0xFEEDFACE)
    end
  end

  describe "#key_frame?" do
    context 'when av_frame[:key_frame] == 1' do
      before { subject.av_frame[:key_frame] = 1 }
      its(:key_frame?) { is_expected.to eq(true) }
    end

    context 'when av_frame[:key_frame] == 0' do
      before { subject.av_frame[:key_frame] = 0 }
      its(:key_frame?) { is_expected.to eq(false) }
    end

    context 'when av_frame[:key_frame] == 0xBEEF' do
      before { subject.key_frame = 0xBEEF }
      its(:key_frame?) { is_expected.to eq(true) }
    end
  end

  describe "#key_frame=" do
    context 'when frame.key_frame=(1)' do
      before { subject.key_frame = 1 }
      its(:key_frame?) { is_expected.to eq(true) }
      it "should set av_frame[:key_frame]" do
        expect(subject.av_frame[:key_frame]).to eq(1)
      end
    end

    context 'when frame.key_frame=(0)' do
      before { subject.key_frame = 0 }
      its(:key_frame?) { is_expected.to eq(false) }
      it "should set av_frame[:key_frame]" do
        expect(subject.av_frame[:key_frame]).to eq(0)
      end
    end

    context 'when frame.key_frame=(0xBEEF)' do
      before { subject.key_frame = 0xBEEF }
      its(:key_frame?) { is_expected.to eq(true) }
      it "should set av_frame[:key_frame]" do
        expect(subject.av_frame[:key_frame]).to eq(0xBEEF)
      end
    end
  end

  describe "#pixel_format" do
    before { subject.av_frame[:format] = :rgba }
    its(:pixel_format) { is_expected.to eq(:rgba) }
  end

  describe "#[]" do
    let(:pts) { rand(0xFFFFFFFF) }
    before { subject.av_frame[:pts] = pts }
    it "should delegate to frame.av_frame" do
      expect(subject[:pts]).to eq pts
    end
  end

  describe "#av_frame" do
    its('av_frame.class') { is_expected.to be FFI::Libav::AVFrame }
  end

  describe "#timestamp" do
    subject do
      # fake a stream
      stream = Object.new
      allow(stream).to receive(:width) { 1200 }
      allow(stream).to receive(:height) { 100 }
      allow(stream).to receive(:pixel_format) { :gray8 }

      # We stub out the [] method to return the :time_base for 24 FPS
      allow(stream).to receive(:[]) do
        f = FFI::Libav::AVRational.new
        f[:num] = 1
        f[:den] = 24
        f
      end
      
      # Make a frame from this stream
      frame = Frame::Video.new :stream => stream
      frame.pts = 25
      frame
    end
    its(:timestamp) { is_expected.to eq(1/24.0 * 25) }
  end

  describe "#release" do
    it "calls stream.release_frame(self)" do
      stream = Object.new
      allow(stream).to receive(:width) { 1200 }
      allow(stream).to receive(:height) { 100 }
      allow(stream).to receive(:pixel_format) { :gray8 }
      allow(stream).to receive(:release_frame) { @released = true }
      allow(stream).to receive(:released) { @released }
      frame = Frame::Video.new :stream => stream

      expect(stream.released).to be nil
      frame.release()
      expect(stream.released).to be true
    end
  end
end

describe Libav::Frame, "#scale" do
  subject(:src_frame) do
    # Craft a frame by hand that has an obvious pattern that we can verify
    # after we scale.
    frame = Frame::Video.new :width => 1000, :height => 1000,
                             :pixel_format => :gray8

    # Set some fields in the source frame that we know should be copied to the
    # scaled frame
    frame.number = rand(0xEFFFFFFF)
    frame.pts = rand(0xEFFFFFFF)
    frame.key_frame = rand(2)

    # We're dividing the entire image into a 4x4 grid
    rows = 4
    cols = 4
    row_height = frame.height / rows
    col_width = frame.width / cols

    # calculate how many extra bytes we need to pad for the linesize for each
    # row.
    pad_length = frame.linesize[0] - frame.width

    pattern = [ 0xFF.chr, 0x00.chr, 0xFF.chr, 0x00.chr ].map { |c| c * col_width }

    rows.times do |row|
      # figure out the contents of a single line in our row
      line = pattern.join("")
      line += " " * pad_length

      # Now construct the data for the entire row
      buf = line * row_height

      # Write our row out
      frame.data[0].put_bytes(row * row_height * frame.linesize[0], buf)

      # rotate our pattern (to make checker board)
      pattern.rotate!
    end

    frame
  end

  context 'scale(:width => 100, :height => 100)' do
    subject { src_frame.scale(:width => 100, :height => 100) }
    its(:class) { is_expected.to eq(Libav::Frame::Video) }
    its(:__id__) { is_expected.to_not eq src_frame.__id__ }
    its(:width) { is_expected.to eq(100) }
    its(:height) { is_expected.to eq(100) }
    its(:pixel_format) { is_expected.to eq(src_frame.pixel_format) }
    its(:pts) { is_expected.to eq src_frame.pts }
    its(:number) { is_expected.to eq src_frame.number }
    its(:key_frame?) { is_expected.to eq src_frame.key_frame? }
  end

  context 'scale(:pixel_format => rgba)' do
    subject { src_frame.scale(:pixel_format => :rgba) }
    its(:class) { is_expected.to be(Libav::Frame::Video) }
    its(:__id__) { is_expected.to_not eq src_frame.__id__ }
    its(:width) { is_expected.to eq src_frame.width }
    its(:height) { is_expected.to eq src_frame.height }
    its(:pixel_format) { is_expected.to eq :rgba }
    its(:pts) { is_expected.to eq src_frame.pts }
    its(:number) { is_expected.to eq src_frame.number }
    its(:key_frame?) { is_expected.to eq src_frame.key_frame? }
  end

  context 'scale(:output_frame => frame)' do
    subject(:dst_frame) do
      Frame::Video.new :pixel_format => :rgba, :width => 120, :height => 120
    end
    subject do
      src_frame.scale(:output_frame => dst_frame)
    end
    its(:class) { is_expected.to be(Libav::Frame::Video) }
    its(:__id__) { is_expected.to eq dst_frame.__id__ }
    its(:width) { is_expected.to eq 120 }
    its(:height) { is_expected.to eq 120 }
    its(:pixel_format) { is_expected.to eq :rgba }
    its(:pts) { is_expected.to eq src_frame.pts }
    its(:number) { is_expected.to eq src_frame.number }
    its(:key_frame?) { is_expected.to eq src_frame.key_frame? }
  end

  context 'scale(:scale_ctx => ctx)' do
    # There's really not much we can do here to verify that the context is
    # being passed short of examining the data of the scaled frame.  So we're
    # going to create a 150x150 dest frame, but create the scaling context to
    # be 100x100.  We also set all the pixels in the dest frame to 0xBE.  To
    # verify that we're using the scaling context, we make sure that the tail
    # of frame.data[0][100..149] to eq(0xBE*50)
    subject(:dst_frame) do
      frame = Frame::Video.new :width => 150, :height => 150,
                               :pixel_format => :gray8
      frame.data[0].write_bytes(0xBE.chr * 150 * frame.linesize[0])
      frame
    end
    subject do
      ctx = FFI::Libav.sws_getCachedContext(nil, src_frame.width,
                                            src_frame.height,
                                            src_frame.pixel_format, 100, 100,
                                            :gray8, FFI::Libav::SWS_BICUBIC,
                                            nil, nil, nil)
      src_frame.scale(:scale_ctx => ctx, :output_frame => dst_frame)
    end
    its(:class) { is_expected.to be(Libav::Frame::Video) }
    its(:__id__) { is_expected.to_not eq src_frame.__id__ }
    its(:pts) { is_expected.to eq src_frame.pts }
    its(:number) { is_expected.to eq src_frame.number }
    its(:key_frame?) { is_expected.to eq src_frame.key_frame? }
    it "contains a 100x100 image" do
      linesize = subject.linesize[0]
      expect(subject.data[0].get_bytes(104, 46)).to eq(0xBE.chr * 46) # skip first 4 bytes, because for some platforms they're 0x00 instead of 0xBE
      expect(subject.data[0].get_bytes(linesize * 99, 100)).to_not eq(0xBE.chr * 100)
      expect(subject.data[0].get_bytes(linesize * 100, 100)).to eq(0xBE.chr * 100)
    end
  end
end
