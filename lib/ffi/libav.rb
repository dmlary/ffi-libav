
require 'ffi'

module FFI::Libav
  extend FFI::Library

  ffi_lib [ "libavutil.so.51", "libavutil.51.dylib" ]

  LIBAVUTIL_VERSION_MAJOR = 51
  LIBAVUTIL_VERSION_MINOR = 22
  LIBAVUTIL_VERSION_MICRO = 1
  LIBAVUTIL_VERSION_INT = (51 << 16|22 << 8|1)
  LIBAVUTIL_BUILD = (51 << 16|22 << 8|1)
  LIBAVUTIL_IDENT = 'Lavu51.22.1'
  attach_function :avutil_version, :avutil_version, [  ], :uint
  attach_function :avutil_configuration, :avutil_configuration, [  ], :string
  attach_function :avutil_license, :avutil_license, [  ], :string
  AVMEDIA_TYPE_UNKNOWN = -1
  AVMEDIA_TYPE_VIDEO = AVMEDIA_TYPE_UNKNOWN + 1
  AVMEDIA_TYPE_AUDIO = AVMEDIA_TYPE_VIDEO + 1
  AVMEDIA_TYPE_DATA = AVMEDIA_TYPE_AUDIO + 1
  AVMEDIA_TYPE_SUBTITLE = AVMEDIA_TYPE_DATA + 1
  AVMEDIA_TYPE_ATTACHMENT = AVMEDIA_TYPE_SUBTITLE + 1
  AVMEDIA_TYPE_NB = AVMEDIA_TYPE_ATTACHMENT + 1
  AVMediaType = enum :AVMediaType, [
    :unknown, -1,
    :video,
    :audio,
    :data,
    :subtitle,
    :attachment,
    :nb,
  ]

  FF_LAMBDA_SHIFT = 7
  FF_LAMBDA_SCALE = (1 << 7)
  FF_QP2LAMBDA = 118
  FF_LAMBDA_MAX = (256*128-1)
  FF_QUALITY_SCALE = (1 << 7)
  AV_NOPTS_VALUE = 0x8000000000000000
  AV_TIME_BASE = 1000000
  AV_PICTURE_TYPE_I = 1
  AV_PICTURE_TYPE_P = AV_PICTURE_TYPE_I + 1
  AV_PICTURE_TYPE_B = AV_PICTURE_TYPE_P + 1
  AV_PICTURE_TYPE_S = AV_PICTURE_TYPE_B + 1
  AV_PICTURE_TYPE_SI = AV_PICTURE_TYPE_S + 1
  AV_PICTURE_TYPE_SP = AV_PICTURE_TYPE_SI + 1
  AV_PICTURE_TYPE_BI = AV_PICTURE_TYPE_SP + 1
  AVPictureType = enum :AVPictureType, [
    :i, 1,
    :p,
    :b,
    :s,
    :si,
    :sp,
    :bi,
  ]

  attach_function :av_get_picture_type_char, :av_get_picture_type_char, [ AVPictureType ], :char
  PIX_FMT_NONE = -1
  PIX_FMT_YUV420P = PIX_FMT_NONE + 1
  PIX_FMT_YUYV422 = PIX_FMT_YUV420P + 1
  PIX_FMT_RGB24 = PIX_FMT_YUYV422 + 1
  PIX_FMT_BGR24 = PIX_FMT_RGB24 + 1
  PIX_FMT_YUV422P = PIX_FMT_BGR24 + 1
  PIX_FMT_YUV444P = PIX_FMT_YUV422P + 1
  PIX_FMT_YUV410P = PIX_FMT_YUV444P + 1
  PIX_FMT_YUV411P = PIX_FMT_YUV410P + 1
  PIX_FMT_GRAY8 = PIX_FMT_YUV411P + 1
  PIX_FMT_MONOWHITE = PIX_FMT_GRAY8 + 1
  PIX_FMT_MONOBLACK = PIX_FMT_MONOWHITE + 1
  PIX_FMT_PAL8 = PIX_FMT_MONOBLACK + 1
  PIX_FMT_YUVJ420P = PIX_FMT_PAL8 + 1
  PIX_FMT_YUVJ422P = PIX_FMT_YUVJ420P + 1
  PIX_FMT_YUVJ444P = PIX_FMT_YUVJ422P + 1
  PIX_FMT_XVMC_MPEG2_MC = PIX_FMT_YUVJ444P + 1
  PIX_FMT_XVMC_MPEG2_IDCT = PIX_FMT_XVMC_MPEG2_MC + 1
  PIX_FMT_UYVY422 = PIX_FMT_XVMC_MPEG2_IDCT + 1
  PIX_FMT_UYYVYY411 = PIX_FMT_UYVY422 + 1
  PIX_FMT_BGR8 = PIX_FMT_UYYVYY411 + 1
  PIX_FMT_BGR4 = PIX_FMT_BGR8 + 1
  PIX_FMT_BGR4_BYTE = PIX_FMT_BGR4 + 1
  PIX_FMT_RGB8 = PIX_FMT_BGR4_BYTE + 1
  PIX_FMT_RGB4 = PIX_FMT_RGB8 + 1
  PIX_FMT_RGB4_BYTE = PIX_FMT_RGB4 + 1
  PIX_FMT_NV12 = PIX_FMT_RGB4_BYTE + 1
  PIX_FMT_NV21 = PIX_FMT_NV12 + 1
  PIX_FMT_ARGB = PIX_FMT_NV21 + 1
  PIX_FMT_RGBA = PIX_FMT_ARGB + 1
  PIX_FMT_ABGR = PIX_FMT_RGBA + 1
  PIX_FMT_BGRA = PIX_FMT_ABGR + 1
  PIX_FMT_GRAY16BE = PIX_FMT_BGRA + 1
  PIX_FMT_GRAY16LE = PIX_FMT_GRAY16BE + 1
  PIX_FMT_YUV440P = PIX_FMT_GRAY16LE + 1
  PIX_FMT_YUVJ440P = PIX_FMT_YUV440P + 1
  PIX_FMT_YUVA420P = PIX_FMT_YUVJ440P + 1
  PIX_FMT_VDPAU_H264 = PIX_FMT_YUVA420P + 1
  PIX_FMT_VDPAU_MPEG1 = PIX_FMT_VDPAU_H264 + 1
  PIX_FMT_VDPAU_MPEG2 = PIX_FMT_VDPAU_MPEG1 + 1
  PIX_FMT_VDPAU_WMV3 = PIX_FMT_VDPAU_MPEG2 + 1
  PIX_FMT_VDPAU_VC1 = PIX_FMT_VDPAU_WMV3 + 1
  PIX_FMT_RGB48BE = PIX_FMT_VDPAU_VC1 + 1
  PIX_FMT_RGB48LE = PIX_FMT_RGB48BE + 1
  PIX_FMT_RGB565BE = PIX_FMT_RGB48LE + 1
  PIX_FMT_RGB565LE = PIX_FMT_RGB565BE + 1
  PIX_FMT_RGB555BE = PIX_FMT_RGB565LE + 1
  PIX_FMT_RGB555LE = PIX_FMT_RGB555BE + 1
  PIX_FMT_BGR565BE = PIX_FMT_RGB555LE + 1
  PIX_FMT_BGR565LE = PIX_FMT_BGR565BE + 1
  PIX_FMT_BGR555BE = PIX_FMT_BGR565LE + 1
  PIX_FMT_BGR555LE = PIX_FMT_BGR555BE + 1
  PIX_FMT_VAAPI_MOCO = PIX_FMT_BGR555LE + 1
  PIX_FMT_VAAPI_IDCT = PIX_FMT_VAAPI_MOCO + 1
  PIX_FMT_VAAPI_VLD = PIX_FMT_VAAPI_IDCT + 1
  PIX_FMT_YUV420P16LE = PIX_FMT_VAAPI_VLD + 1
  PIX_FMT_YUV420P16BE = PIX_FMT_YUV420P16LE + 1
  PIX_FMT_YUV422P16LE = PIX_FMT_YUV420P16BE + 1
  PIX_FMT_YUV422P16BE = PIX_FMT_YUV422P16LE + 1
  PIX_FMT_YUV444P16LE = PIX_FMT_YUV422P16BE + 1
  PIX_FMT_YUV444P16BE = PIX_FMT_YUV444P16LE + 1
  PIX_FMT_VDPAU_MPEG4 = PIX_FMT_YUV444P16BE + 1
  PIX_FMT_DXVA2_VLD = PIX_FMT_VDPAU_MPEG4 + 1
  PIX_FMT_RGB444LE = PIX_FMT_DXVA2_VLD + 1
  PIX_FMT_RGB444BE = PIX_FMT_RGB444LE + 1
  PIX_FMT_BGR444LE = PIX_FMT_RGB444BE + 1
  PIX_FMT_BGR444BE = PIX_FMT_BGR444LE + 1
  PIX_FMT_Y400A = PIX_FMT_BGR444BE + 1
  PIX_FMT_BGR48BE = PIX_FMT_Y400A + 1
  PIX_FMT_BGR48LE = PIX_FMT_BGR48BE + 1
  PIX_FMT_YUV420P9BE = PIX_FMT_BGR48LE + 1
  PIX_FMT_YUV420P9LE = PIX_FMT_YUV420P9BE + 1
  PIX_FMT_YUV420P10BE = PIX_FMT_YUV420P9LE + 1
  PIX_FMT_YUV420P10LE = PIX_FMT_YUV420P10BE + 1
  PIX_FMT_YUV422P10BE = PIX_FMT_YUV420P10LE + 1
  PIX_FMT_YUV422P10LE = PIX_FMT_YUV422P10BE + 1
  PIX_FMT_YUV444P9BE = PIX_FMT_YUV422P10LE + 1
  PIX_FMT_YUV444P9LE = PIX_FMT_YUV444P9BE + 1
  PIX_FMT_YUV444P10BE = PIX_FMT_YUV444P9LE + 1
  PIX_FMT_YUV444P10LE = PIX_FMT_YUV444P10BE + 1
  PIX_FMT_YUV422P9BE = PIX_FMT_YUV444P10LE + 1
  PIX_FMT_YUV422P9LE = PIX_FMT_YUV422P9BE + 1
  PIX_FMT_VDA_VLD = PIX_FMT_YUV422P9LE + 1
  PIX_FMT_GBRP = PIX_FMT_VDA_VLD + 1
  PIX_FMT_GBRP9BE = PIX_FMT_GBRP + 1
  PIX_FMT_GBRP9LE = PIX_FMT_GBRP9BE + 1
  PIX_FMT_GBRP10BE = PIX_FMT_GBRP9LE + 1
  PIX_FMT_GBRP10LE = PIX_FMT_GBRP10BE + 1
  PIX_FMT_GBRP16BE = PIX_FMT_GBRP10LE + 1
  PIX_FMT_GBRP16LE = PIX_FMT_GBRP16BE + 1
  PIX_FMT_NB = PIX_FMT_GBRP16LE + 1
  PixelFormat = enum :PixelFormat, [
    :none, -1,
    :yuv420p,
    :yuyv422,
    :rgb24,
    :bgr24,
    :yuv422p,
    :yuv444p,
    :yuv410p,
    :yuv411p,
    :gray8,
    :monowhite,
    :monoblack,
    :pal8,
    :yuvj420p,
    :yuvj422p,
    :yuvj444p,
    :xvmc_mpeg2_mc,
    :xvmc_mpeg2_idct,
    :uyvy422,
    :uyyvyy411,
    :bgr8,
    :bgr4,
    :bgr4_byte,
    :rgb8,
    :rgb4,
    :rgb4_byte,
    :nv12,
    :nv21,
    :argb,
    :rgba,
    :abgr,
    :bgra,
    :gray16be,
    :gray16le,
    :yuv440p,
    :yuvj440p,
    :yuva420p,
    :vdpau_h264,
    :vdpau_mpeg1,
    :vdpau_mpeg2,
    :vdpau_wmv3,
    :vdpau_vc1,
    :rgb48be,
    :rgb48le,
    :rgb565be,
    :rgb565le,
    :rgb555be,
    :rgb555le,
    :bgr565be,
    :bgr565le,
    :bgr555be,
    :bgr555le,
    :vaapi_moco,
    :vaapi_idct,
    :vaapi_vld,
    :yuv420p16le,
    :yuv420p16be,
    :yuv422p16le,
    :yuv422p16be,
    :yuv444p16le,
    :yuv444p16be,
    :vdpau_mpeg4,
    :dxva2_vld,
    :rgb444le,
    :rgb444be,
    :bgr444le,
    :bgr444be,
    :y400a,
    :bgr48be,
    :bgr48le,
    :yuv420p9be,
    :yuv420p9le,
    :yuv420p10be,
    :yuv420p10le,
    :yuv422p10be,
    :yuv422p10le,
    :yuv444p9be,
    :yuv444p9le,
    :yuv444p10be,
    :yuv444p10le,
    :yuv422p9be,
    :yuv422p9le,
    :vda_vld,
    :gbrp,
    :gbrp9be,
    :gbrp9le,
    :gbrp10be,
    :gbrp10le,
    :gbrp16be,
    :gbrp16le,
    :nb,
  ]

  class AVRational < FFI::Struct
    layout(
           :num, :int,
           :den, :int
    )
    def to_f
      self[:num].to_f / self[:den]
    end
  end

  AV_TIME_BASE_Q = AVRational.new
  AV_TIME_BASE_Q[:num] = 1
  AV_TIME_BASE_Q[:den] = AV_TIME_BASE

  # inline function av_cmp_q
  # inline function av_q2d
  attach_function :av_reduce, :av_reduce, [ :pointer, :pointer, :int64, :int64, :int64 ], :int
  attach_function :av_mul_q, :av_mul_q, [ AVRational.by_value, AVRational.by_value ], AVRational.by_value
  attach_function :av_div_q, :av_div_q, [ AVRational.by_value, AVRational.by_value ], AVRational.by_value
  attach_function :av_add_q, :av_add_q, [ AVRational.by_value, AVRational.by_value ], AVRational.by_value
  attach_function :av_sub_q, :av_sub_q, [ AVRational.by_value, AVRational.by_value ], AVRational.by_value
  attach_function :av_d2q, :av_d2q, [ :double, :int ], AVRational.by_value
  attach_function :av_nearer_q, :av_nearer_q, [ AVRational.by_value, AVRational.by_value, AVRational.by_value ], :int
  attach_function :av_find_nearest_q_idx, :av_find_nearest_q_idx, [ AVRational.by_value, :pointer ], :int
  attach_function :av_malloc, :av_malloc, [ :uint ], :pointer
  attach_function :av_realloc, :av_realloc, [ :pointer, :uint ], :pointer
  attach_function :av_free, :av_free, [ :pointer ], :void
  attach_function :av_mallocz, :av_mallocz, [ :uint ], :pointer
  attach_function :av_strdup, :av_strdup, [ :string ], :string
  attach_function :av_freep, :av_freep, [ :pointer ], :void
  M_E = 2.7182818284590452354
  M_LN2 = 0.69314718055994530942
  M_LN10 = 2.30258509299404568402
  M_LOG2_10 = 3.32192809488736234787
  M_PHI = 1.61803398874989484820
  M_PI = 3.14159265358979323846
  M_SQRT1_2 = 0.70710678118654752440
  M_SQRT2 = 1.41421356237309504880
  NAN = (0.0/0.0)
  INFINITY = (1.0/0.0)
  AV_ROUND_ZERO = 0
  AV_ROUND_INF = 1
  AV_ROUND_DOWN = 2
  AV_ROUND_UP = 3
  AV_ROUND_NEAR_INF = 5
  AVRounding = enum :AVRounding, [
    :zero, 0,
    :inf, 1,
    :down, 2,
    :up, 3,
    :near_inf, 5,
  ]

  attach_function :av_gcd, :av_gcd, [ :int64, :int64 ], :int64
  attach_function :av_rescale, :av_rescale, [ :int64, :int64, :int64 ], :int64
  attach_function :av_rescale_rnd, :av_rescale_rnd, [ :int64, :int64, :int64, AVRounding ], :int64
  attach_function :av_rescale_q, :av_rescale_q, [ :int64, AVRational.by_value, AVRational.by_value ], :int64
  attach_function :av_compare_ts, :av_compare_ts, [ :int64, AVRational.by_value, :int64, AVRational.by_value ], :int
  attach_function :av_compare_mod, :av_compare_mod, [ :uint64, :uint64, :uint64 ], :int64


  ffi_lib [ "libavcodec.so.53", "libavcodec.53.dylib" ]

  class AVPacket < FFI::Struct; end
  class AVPacketSideData < FFI::Struct; end
  class AVPanScan < FFI::Struct; end
  class AVCodecContext < FFI::Struct; end
  class AVCodec < FFI::Struct; end
  class AVFrame < FFI::Struct; end
  class RcOverride < FFI::Struct; end
  class AVPaletteControl < FFI::Struct; end
  class AVHWAccel < FFI::Struct; end
  class AVPicture < FFI::Struct; end
  class AVSubtitle < FFI::Struct; end
  class AVCodecParser < FFI::Struct; end
  class AVCodecParserContext < FFI::Struct; end
  class AVBitStreamFilter < FFI::Struct; end
  class AVBitStreamFilterContext < FFI::Struct; end
  LIBAVCODEC_VERSION_MAJOR = 53
  LIBAVCODEC_VERSION_MINOR = 35
  LIBAVCODEC_VERSION_MICRO = 0
  LIBAVCODEC_VERSION_INT = (53 << 16|35 << 8|0)
  LIBAVCODEC_BUILD = (53 << 16|35 << 8|0)
  LIBAVCODEC_IDENT = 'Lavc53.35.0'
  CODEC_ID_NONE = 0
  CODEC_ID_MPEG1VIDEO = CODEC_ID_NONE + 1
  CODEC_ID_MPEG2VIDEO = CODEC_ID_MPEG1VIDEO + 1
  CODEC_ID_MPEG2VIDEO_XVMC = CODEC_ID_MPEG2VIDEO + 1
  CODEC_ID_H261 = CODEC_ID_MPEG2VIDEO_XVMC + 1
  CODEC_ID_H263 = CODEC_ID_H261 + 1
  CODEC_ID_RV10 = CODEC_ID_H263 + 1
  CODEC_ID_RV20 = CODEC_ID_RV10 + 1
  CODEC_ID_MJPEG = CODEC_ID_RV20 + 1
  CODEC_ID_MJPEGB = CODEC_ID_MJPEG + 1
  CODEC_ID_LJPEG = CODEC_ID_MJPEGB + 1
  CODEC_ID_SP5X = CODEC_ID_LJPEG + 1
  CODEC_ID_JPEGLS = CODEC_ID_SP5X + 1
  CODEC_ID_MPEG4 = CODEC_ID_JPEGLS + 1
  CODEC_ID_RAWVIDEO = CODEC_ID_MPEG4 + 1
  CODEC_ID_MSMPEG4V1 = CODEC_ID_RAWVIDEO + 1
  CODEC_ID_MSMPEG4V2 = CODEC_ID_MSMPEG4V1 + 1
  CODEC_ID_MSMPEG4V3 = CODEC_ID_MSMPEG4V2 + 1
  CODEC_ID_WMV1 = CODEC_ID_MSMPEG4V3 + 1
  CODEC_ID_WMV2 = CODEC_ID_WMV1 + 1
  CODEC_ID_H263P = CODEC_ID_WMV2 + 1
  CODEC_ID_H263I = CODEC_ID_H263P + 1
  CODEC_ID_FLV1 = CODEC_ID_H263I + 1
  CODEC_ID_SVQ1 = CODEC_ID_FLV1 + 1
  CODEC_ID_SVQ3 = CODEC_ID_SVQ1 + 1
  CODEC_ID_DVVIDEO = CODEC_ID_SVQ3 + 1
  CODEC_ID_HUFFYUV = CODEC_ID_DVVIDEO + 1
  CODEC_ID_CYUV = CODEC_ID_HUFFYUV + 1
  CODEC_ID_H264 = CODEC_ID_CYUV + 1
  CODEC_ID_INDEO3 = CODEC_ID_H264 + 1
  CODEC_ID_VP3 = CODEC_ID_INDEO3 + 1
  CODEC_ID_THEORA = CODEC_ID_VP3 + 1
  CODEC_ID_ASV1 = CODEC_ID_THEORA + 1
  CODEC_ID_ASV2 = CODEC_ID_ASV1 + 1
  CODEC_ID_FFV1 = CODEC_ID_ASV2 + 1
  CODEC_ID_4XM = CODEC_ID_FFV1 + 1
  CODEC_ID_VCR1 = CODEC_ID_4XM + 1
  CODEC_ID_CLJR = CODEC_ID_VCR1 + 1
  CODEC_ID_MDEC = CODEC_ID_CLJR + 1
  CODEC_ID_ROQ = CODEC_ID_MDEC + 1
  CODEC_ID_INTERPLAY_VIDEO = CODEC_ID_ROQ + 1
  CODEC_ID_XAN_WC3 = CODEC_ID_INTERPLAY_VIDEO + 1
  CODEC_ID_XAN_WC4 = CODEC_ID_XAN_WC3 + 1
  CODEC_ID_RPZA = CODEC_ID_XAN_WC4 + 1
  CODEC_ID_CINEPAK = CODEC_ID_RPZA + 1
  CODEC_ID_WS_VQA = CODEC_ID_CINEPAK + 1
  CODEC_ID_MSRLE = CODEC_ID_WS_VQA + 1
  CODEC_ID_MSVIDEO1 = CODEC_ID_MSRLE + 1
  CODEC_ID_IDCIN = CODEC_ID_MSVIDEO1 + 1
  CODEC_ID_8BPS = CODEC_ID_IDCIN + 1
  CODEC_ID_SMC = CODEC_ID_8BPS + 1
  CODEC_ID_FLIC = CODEC_ID_SMC + 1
  CODEC_ID_TRUEMOTION1 = CODEC_ID_FLIC + 1
  CODEC_ID_VMDVIDEO = CODEC_ID_TRUEMOTION1 + 1
  CODEC_ID_MSZH = CODEC_ID_VMDVIDEO + 1
  CODEC_ID_ZLIB = CODEC_ID_MSZH + 1
  CODEC_ID_QTRLE = CODEC_ID_ZLIB + 1
  CODEC_ID_SNOW = CODEC_ID_QTRLE + 1
  CODEC_ID_TSCC = CODEC_ID_SNOW + 1
  CODEC_ID_ULTI = CODEC_ID_TSCC + 1
  CODEC_ID_QDRAW = CODEC_ID_ULTI + 1
  CODEC_ID_VIXL = CODEC_ID_QDRAW + 1
  CODEC_ID_QPEG = CODEC_ID_VIXL + 1
  CODEC_ID_PNG = CODEC_ID_QPEG + 1
  CODEC_ID_PPM = CODEC_ID_PNG + 1
  CODEC_ID_PBM = CODEC_ID_PPM + 1
  CODEC_ID_PGM = CODEC_ID_PBM + 1
  CODEC_ID_PGMYUV = CODEC_ID_PGM + 1
  CODEC_ID_PAM = CODEC_ID_PGMYUV + 1
  CODEC_ID_FFVHUFF = CODEC_ID_PAM + 1
  CODEC_ID_RV30 = CODEC_ID_FFVHUFF + 1
  CODEC_ID_RV40 = CODEC_ID_RV30 + 1
  CODEC_ID_VC1 = CODEC_ID_RV40 + 1
  CODEC_ID_WMV3 = CODEC_ID_VC1 + 1
  CODEC_ID_LOCO = CODEC_ID_WMV3 + 1
  CODEC_ID_WNV1 = CODEC_ID_LOCO + 1
  CODEC_ID_AASC = CODEC_ID_WNV1 + 1
  CODEC_ID_INDEO2 = CODEC_ID_AASC + 1
  CODEC_ID_FRAPS = CODEC_ID_INDEO2 + 1
  CODEC_ID_TRUEMOTION2 = CODEC_ID_FRAPS + 1
  CODEC_ID_BMP = CODEC_ID_TRUEMOTION2 + 1
  CODEC_ID_CSCD = CODEC_ID_BMP + 1
  CODEC_ID_MMVIDEO = CODEC_ID_CSCD + 1
  CODEC_ID_ZMBV = CODEC_ID_MMVIDEO + 1
  CODEC_ID_AVS = CODEC_ID_ZMBV + 1
  CODEC_ID_SMACKVIDEO = CODEC_ID_AVS + 1
  CODEC_ID_NUV = CODEC_ID_SMACKVIDEO + 1
  CODEC_ID_KMVC = CODEC_ID_NUV + 1
  CODEC_ID_FLASHSV = CODEC_ID_KMVC + 1
  CODEC_ID_CAVS = CODEC_ID_FLASHSV + 1
  CODEC_ID_JPEG2000 = CODEC_ID_CAVS + 1
  CODEC_ID_VMNC = CODEC_ID_JPEG2000 + 1
  CODEC_ID_VP5 = CODEC_ID_VMNC + 1
  CODEC_ID_VP6 = CODEC_ID_VP5 + 1
  CODEC_ID_VP6F = CODEC_ID_VP6 + 1
  CODEC_ID_TARGA = CODEC_ID_VP6F + 1
  CODEC_ID_DSICINVIDEO = CODEC_ID_TARGA + 1
  CODEC_ID_TIERTEXSEQVIDEO = CODEC_ID_DSICINVIDEO + 1
  CODEC_ID_TIFF = CODEC_ID_TIERTEXSEQVIDEO + 1
  CODEC_ID_GIF = CODEC_ID_TIFF + 1
  CODEC_ID_FFH264 = CODEC_ID_GIF + 1
  CODEC_ID_DXA = CODEC_ID_FFH264 + 1
  CODEC_ID_DNXHD = CODEC_ID_DXA + 1
  CODEC_ID_THP = CODEC_ID_DNXHD + 1
  CODEC_ID_SGI = CODEC_ID_THP + 1
  CODEC_ID_C93 = CODEC_ID_SGI + 1
  CODEC_ID_BETHSOFTVID = CODEC_ID_C93 + 1
  CODEC_ID_PTX = CODEC_ID_BETHSOFTVID + 1
  CODEC_ID_TXD = CODEC_ID_PTX + 1
  CODEC_ID_VP6A = CODEC_ID_TXD + 1
  CODEC_ID_AMV = CODEC_ID_VP6A + 1
  CODEC_ID_VB = CODEC_ID_AMV + 1
  CODEC_ID_PCX = CODEC_ID_VB + 1
  CODEC_ID_SUNRAST = CODEC_ID_PCX + 1
  CODEC_ID_INDEO4 = CODEC_ID_SUNRAST + 1
  CODEC_ID_INDEO5 = CODEC_ID_INDEO4 + 1
  CODEC_ID_MIMIC = CODEC_ID_INDEO5 + 1
  CODEC_ID_RL2 = CODEC_ID_MIMIC + 1
  CODEC_ID_8SVX_EXP = CODEC_ID_RL2 + 1
  CODEC_ID_8SVX_FIB = CODEC_ID_8SVX_EXP + 1
  CODEC_ID_ESCAPE124 = CODEC_ID_8SVX_FIB + 1
  CODEC_ID_DIRAC = CODEC_ID_ESCAPE124 + 1
  CODEC_ID_BFI = CODEC_ID_DIRAC + 1
  CODEC_ID_CMV = CODEC_ID_BFI + 1
  CODEC_ID_MOTIONPIXELS = CODEC_ID_CMV + 1
  CODEC_ID_TGV = CODEC_ID_MOTIONPIXELS + 1
  CODEC_ID_TGQ = CODEC_ID_TGV + 1
  CODEC_ID_TQI = CODEC_ID_TGQ + 1
  CODEC_ID_AURA = CODEC_ID_TQI + 1
  CODEC_ID_AURA2 = CODEC_ID_AURA + 1
  CODEC_ID_V210X = CODEC_ID_AURA2 + 1
  CODEC_ID_TMV = CODEC_ID_V210X + 1
  CODEC_ID_V210 = CODEC_ID_TMV + 1
  CODEC_ID_DPX = CODEC_ID_V210 + 1
  CODEC_ID_MAD = CODEC_ID_DPX + 1
  CODEC_ID_FRWU = CODEC_ID_MAD + 1
  CODEC_ID_FLASHSV2 = CODEC_ID_FRWU + 1
  CODEC_ID_CDGRAPHICS = CODEC_ID_FLASHSV2 + 1
  CODEC_ID_R210 = CODEC_ID_CDGRAPHICS + 1
  CODEC_ID_ANM = CODEC_ID_R210 + 1
  CODEC_ID_BINKVIDEO = CODEC_ID_ANM + 1
  CODEC_ID_IFF_ILBM = CODEC_ID_BINKVIDEO + 1
  CODEC_ID_IFF_BYTERUN1 = CODEC_ID_IFF_ILBM + 1
  CODEC_ID_KGV1 = CODEC_ID_IFF_BYTERUN1 + 1
  CODEC_ID_YOP = CODEC_ID_KGV1 + 1
  CODEC_ID_VP8 = CODEC_ID_YOP + 1
  CODEC_ID_PICTOR = CODEC_ID_VP8 + 1
  CODEC_ID_ANSI = CODEC_ID_PICTOR + 1
  CODEC_ID_A64_MULTI = CODEC_ID_ANSI + 1
  CODEC_ID_A64_MULTI5 = CODEC_ID_A64_MULTI + 1
  CODEC_ID_R10K = CODEC_ID_A64_MULTI5 + 1
  CODEC_ID_MXPEG = CODEC_ID_R10K + 1
  CODEC_ID_LAGARITH = CODEC_ID_MXPEG + 1
  CODEC_ID_PRORES = CODEC_ID_LAGARITH + 1
  CODEC_ID_JV = CODEC_ID_PRORES + 1
  CODEC_ID_DFA = CODEC_ID_JV + 1
  CODEC_ID_WMV3IMAGE = CODEC_ID_DFA + 1
  CODEC_ID_VC1IMAGE = CODEC_ID_WMV3IMAGE + 1
  CODEC_ID_G723_1 = CODEC_ID_VC1IMAGE + 1
  CODEC_ID_G729 = CODEC_ID_G723_1 + 1
  CODEC_ID_UTVIDEO = CODEC_ID_G729 + 1
  CODEC_ID_BMV_VIDEO = CODEC_ID_UTVIDEO + 1
  CODEC_ID_VBLE = CODEC_ID_BMV_VIDEO + 1
  CODEC_ID_DXTORY = CODEC_ID_VBLE + 1
  CODEC_ID_V410 = CODEC_ID_DXTORY + 1
  CODEC_ID_FIRST_AUDIO = 0x10000
  CODEC_ID_PCM_S16LE = 0x10000
  CODEC_ID_PCM_S16BE = CODEC_ID_PCM_S16LE + 1
  CODEC_ID_PCM_U16LE = CODEC_ID_PCM_S16BE + 1
  CODEC_ID_PCM_U16BE = CODEC_ID_PCM_U16LE + 1
  CODEC_ID_PCM_S8 = CODEC_ID_PCM_U16BE + 1
  CODEC_ID_PCM_U8 = CODEC_ID_PCM_S8 + 1
  CODEC_ID_PCM_MULAW = CODEC_ID_PCM_U8 + 1
  CODEC_ID_PCM_ALAW = CODEC_ID_PCM_MULAW + 1
  CODEC_ID_PCM_S32LE = CODEC_ID_PCM_ALAW + 1
  CODEC_ID_PCM_S32BE = CODEC_ID_PCM_S32LE + 1
  CODEC_ID_PCM_U32LE = CODEC_ID_PCM_S32BE + 1
  CODEC_ID_PCM_U32BE = CODEC_ID_PCM_U32LE + 1
  CODEC_ID_PCM_S24LE = CODEC_ID_PCM_U32BE + 1
  CODEC_ID_PCM_S24BE = CODEC_ID_PCM_S24LE + 1
  CODEC_ID_PCM_U24LE = CODEC_ID_PCM_S24BE + 1
  CODEC_ID_PCM_U24BE = CODEC_ID_PCM_U24LE + 1
  CODEC_ID_PCM_S24DAUD = CODEC_ID_PCM_U24BE + 1
  CODEC_ID_PCM_ZORK = CODEC_ID_PCM_S24DAUD + 1
  CODEC_ID_PCM_S16LE_PLANAR = CODEC_ID_PCM_ZORK + 1
  CODEC_ID_PCM_DVD = CODEC_ID_PCM_S16LE_PLANAR + 1
  CODEC_ID_PCM_F32BE = CODEC_ID_PCM_DVD + 1
  CODEC_ID_PCM_F32LE = CODEC_ID_PCM_F32BE + 1
  CODEC_ID_PCM_F64BE = CODEC_ID_PCM_F32LE + 1
  CODEC_ID_PCM_F64LE = CODEC_ID_PCM_F64BE + 1
  CODEC_ID_PCM_BLURAY = CODEC_ID_PCM_F64LE + 1
  CODEC_ID_PCM_LXF = CODEC_ID_PCM_BLURAY + 1
  CODEC_ID_S302M = CODEC_ID_PCM_LXF + 1
  CODEC_ID_PCM_S8_PLANAR = CODEC_ID_S302M + 1
  CODEC_ID_ADPCM_IMA_QT = 0x11000
  CODEC_ID_ADPCM_IMA_WAV = CODEC_ID_ADPCM_IMA_QT + 1
  CODEC_ID_ADPCM_IMA_DK3 = CODEC_ID_ADPCM_IMA_WAV + 1
  CODEC_ID_ADPCM_IMA_DK4 = CODEC_ID_ADPCM_IMA_DK3 + 1
  CODEC_ID_ADPCM_IMA_WS = CODEC_ID_ADPCM_IMA_DK4 + 1
  CODEC_ID_ADPCM_IMA_SMJPEG = CODEC_ID_ADPCM_IMA_WS + 1
  CODEC_ID_ADPCM_MS = CODEC_ID_ADPCM_IMA_SMJPEG + 1
  CODEC_ID_ADPCM_4XM = CODEC_ID_ADPCM_MS + 1
  CODEC_ID_ADPCM_XA = CODEC_ID_ADPCM_4XM + 1
  CODEC_ID_ADPCM_ADX = CODEC_ID_ADPCM_XA + 1
  CODEC_ID_ADPCM_EA = CODEC_ID_ADPCM_ADX + 1
  CODEC_ID_ADPCM_G726 = CODEC_ID_ADPCM_EA + 1
  CODEC_ID_ADPCM_CT = CODEC_ID_ADPCM_G726 + 1
  CODEC_ID_ADPCM_SWF = CODEC_ID_ADPCM_CT + 1
  CODEC_ID_ADPCM_YAMAHA = CODEC_ID_ADPCM_SWF + 1
  CODEC_ID_ADPCM_SBPRO_4 = CODEC_ID_ADPCM_YAMAHA + 1
  CODEC_ID_ADPCM_SBPRO_3 = CODEC_ID_ADPCM_SBPRO_4 + 1
  CODEC_ID_ADPCM_SBPRO_2 = CODEC_ID_ADPCM_SBPRO_3 + 1
  CODEC_ID_ADPCM_THP = CODEC_ID_ADPCM_SBPRO_2 + 1
  CODEC_ID_ADPCM_IMA_AMV = CODEC_ID_ADPCM_THP + 1
  CODEC_ID_ADPCM_EA_R1 = CODEC_ID_ADPCM_IMA_AMV + 1
  CODEC_ID_ADPCM_EA_R3 = CODEC_ID_ADPCM_EA_R1 + 1
  CODEC_ID_ADPCM_EA_R2 = CODEC_ID_ADPCM_EA_R3 + 1
  CODEC_ID_ADPCM_IMA_EA_SEAD = CODEC_ID_ADPCM_EA_R2 + 1
  CODEC_ID_ADPCM_IMA_EA_EACS = CODEC_ID_ADPCM_IMA_EA_SEAD + 1
  CODEC_ID_ADPCM_EA_XAS = CODEC_ID_ADPCM_IMA_EA_EACS + 1
  CODEC_ID_ADPCM_EA_MAXIS_XA = CODEC_ID_ADPCM_EA_XAS + 1
  CODEC_ID_ADPCM_IMA_ISS = CODEC_ID_ADPCM_EA_MAXIS_XA + 1
  CODEC_ID_ADPCM_G722 = CODEC_ID_ADPCM_IMA_ISS + 1
  CODEC_ID_AMR_NB = 0x12000
  CODEC_ID_AMR_WB = CODEC_ID_AMR_NB + 1
  CODEC_ID_RA_144 = 0x13000
  CODEC_ID_RA_288 = CODEC_ID_RA_144 + 1
  CODEC_ID_ROQ_DPCM = 0x14000
  CODEC_ID_INTERPLAY_DPCM = CODEC_ID_ROQ_DPCM + 1
  CODEC_ID_XAN_DPCM = CODEC_ID_INTERPLAY_DPCM + 1
  CODEC_ID_SOL_DPCM = CODEC_ID_XAN_DPCM + 1
  CODEC_ID_MP2 = 0x15000
  CODEC_ID_MP3 = CODEC_ID_MP2 + 1
  CODEC_ID_AAC = CODEC_ID_MP3 + 1
  CODEC_ID_AC3 = CODEC_ID_AAC + 1
  CODEC_ID_DTS = CODEC_ID_AC3 + 1
  CODEC_ID_VORBIS = CODEC_ID_DTS + 1
  CODEC_ID_DVAUDIO = CODEC_ID_VORBIS + 1
  CODEC_ID_WMAV1 = CODEC_ID_DVAUDIO + 1
  CODEC_ID_WMAV2 = CODEC_ID_WMAV1 + 1
  CODEC_ID_MACE3 = CODEC_ID_WMAV2 + 1
  CODEC_ID_MACE6 = CODEC_ID_MACE3 + 1
  CODEC_ID_VMDAUDIO = CODEC_ID_MACE6 + 1
  CODEC_ID_SONIC = CODEC_ID_VMDAUDIO + 1
  CODEC_ID_SONIC_LS = CODEC_ID_SONIC + 1
  CODEC_ID_FLAC = CODEC_ID_SONIC_LS + 1
  CODEC_ID_MP3ADU = CODEC_ID_FLAC + 1
  CODEC_ID_MP3ON4 = CODEC_ID_MP3ADU + 1
  CODEC_ID_SHORTEN = CODEC_ID_MP3ON4 + 1
  CODEC_ID_ALAC = CODEC_ID_SHORTEN + 1
  CODEC_ID_WESTWOOD_SND1 = CODEC_ID_ALAC + 1
  CODEC_ID_GSM = CODEC_ID_WESTWOOD_SND1 + 1
  CODEC_ID_QDM2 = CODEC_ID_GSM + 1
  CODEC_ID_COOK = CODEC_ID_QDM2 + 1
  CODEC_ID_TRUESPEECH = CODEC_ID_COOK + 1
  CODEC_ID_TTA = CODEC_ID_TRUESPEECH + 1
  CODEC_ID_SMACKAUDIO = CODEC_ID_TTA + 1
  CODEC_ID_QCELP = CODEC_ID_SMACKAUDIO + 1
  CODEC_ID_WAVPACK = CODEC_ID_QCELP + 1
  CODEC_ID_DSICINAUDIO = CODEC_ID_WAVPACK + 1
  CODEC_ID_IMC = CODEC_ID_DSICINAUDIO + 1
  CODEC_ID_MUSEPACK7 = CODEC_ID_IMC + 1
  CODEC_ID_MLP = CODEC_ID_MUSEPACK7 + 1
  CODEC_ID_GSM_MS = CODEC_ID_MLP + 1
  CODEC_ID_ATRAC3 = CODEC_ID_GSM_MS + 1
  CODEC_ID_VOXWARE = CODEC_ID_ATRAC3 + 1
  CODEC_ID_APE = CODEC_ID_VOXWARE + 1
  CODEC_ID_NELLYMOSER = CODEC_ID_APE + 1
  CODEC_ID_MUSEPACK8 = CODEC_ID_NELLYMOSER + 1
  CODEC_ID_SPEEX = CODEC_ID_MUSEPACK8 + 1
  CODEC_ID_WMAVOICE = CODEC_ID_SPEEX + 1
  CODEC_ID_WMAPRO = CODEC_ID_WMAVOICE + 1
  CODEC_ID_WMALOSSLESS = CODEC_ID_WMAPRO + 1
  CODEC_ID_ATRAC3P = CODEC_ID_WMALOSSLESS + 1
  CODEC_ID_EAC3 = CODEC_ID_ATRAC3P + 1
  CODEC_ID_SIPR = CODEC_ID_EAC3 + 1
  CODEC_ID_MP1 = CODEC_ID_SIPR + 1
  CODEC_ID_TWINVQ = CODEC_ID_MP1 + 1
  CODEC_ID_TRUEHD = CODEC_ID_TWINVQ + 1
  CODEC_ID_MP4ALS = CODEC_ID_TRUEHD + 1
  CODEC_ID_ATRAC1 = CODEC_ID_MP4ALS + 1
  CODEC_ID_BINKAUDIO_RDFT = CODEC_ID_ATRAC1 + 1
  CODEC_ID_BINKAUDIO_DCT = CODEC_ID_BINKAUDIO_RDFT + 1
  CODEC_ID_AAC_LATM = CODEC_ID_BINKAUDIO_DCT + 1
  CODEC_ID_QDMC = CODEC_ID_AAC_LATM + 1
  CODEC_ID_CELT = CODEC_ID_QDMC + 1
  CODEC_ID_BMV_AUDIO = CODEC_ID_CELT + 1
  CODEC_ID_FIRST_SUBTITLE = 0x17000
  CODEC_ID_DVD_SUBTITLE = 0x17000
  CODEC_ID_DVB_SUBTITLE = CODEC_ID_DVD_SUBTITLE + 1
  CODEC_ID_TEXT = CODEC_ID_DVB_SUBTITLE + 1
  CODEC_ID_XSUB = CODEC_ID_TEXT + 1
  CODEC_ID_SSA = CODEC_ID_XSUB + 1
  CODEC_ID_MOV_TEXT = CODEC_ID_SSA + 1
  CODEC_ID_HDMV_PGS_SUBTITLE = CODEC_ID_MOV_TEXT + 1
  CODEC_ID_DVB_TELETEXT = CODEC_ID_HDMV_PGS_SUBTITLE + 1
  CODEC_ID_SRT = CODEC_ID_DVB_TELETEXT + 1
  CODEC_ID_FIRST_UNKNOWN = 0x18000
  CODEC_ID_TTF = 0x18000
  CODEC_ID_PROBE = 0x19000
  CODEC_ID_MPEG2TS = 0x20000
  CODEC_ID_MPEG4SYSTEMS = 0x20001
  CODEC_ID_FFMETADATA = 0x21000
  CodecID = enum :CodecID, [
    :none,
    :mpeg1video,
    :mpeg2video,
    :mpeg2video_xvmc,
    :h261,
    :h263,
    :rv10,
    :rv20,
    :mjpeg,
    :mjpegb,
    :ljpeg,
    :sp5x,
    :jpegls,
    :mpeg4,
    :rawvideo,
    :msmpeg4v1,
    :msmpeg4v2,
    :msmpeg4v3,
    :wmv1,
    :wmv2,
    :h263p,
    :h263i,
    :flv1,
    :svq1,
    :svq3,
    :dvvideo,
    :huffyuv,
    :cyuv,
    :h264,
    :indeo3,
    :vp3,
    :theora,
    :asv1,
    :asv2,
    :ffv1,
    :'4xm',
    :vcr1,
    :cljr,
    :mdec,
    :roq,
    :interplay_video,
    :xan_wc3,
    :xan_wc4,
    :rpza,
    :cinepak,
    :ws_vqa,
    :msrle,
    :msvideo1,
    :idcin,
    :'8bps',
    :smc,
    :flic,
    :truemotion1,
    :vmdvideo,
    :mszh,
    :zlib,
    :qtrle,
    :snow,
    :tscc,
    :ulti,
    :qdraw,
    :vixl,
    :qpeg,
    :png,
    :ppm,
    :pbm,
    :pgm,
    :pgmyuv,
    :pam,
    :ffvhuff,
    :rv30,
    :rv40,
    :vc1,
    :wmv3,
    :loco,
    :wnv1,
    :aasc,
    :indeo2,
    :fraps,
    :truemotion2,
    :bmp,
    :cscd,
    :mmvideo,
    :zmbv,
    :avs,
    :smackvideo,
    :nuv,
    :kmvc,
    :flashsv,
    :cavs,
    :jpeg2000,
    :vmnc,
    :vp5,
    :vp6,
    :vp6f,
    :targa,
    :dsicinvideo,
    :tiertexseqvideo,
    :tiff,
    :gif,
    :ffh264,
    :dxa,
    :dnxhd,
    :thp,
    :sgi,
    :c93,
    :bethsoftvid,
    :ptx,
    :txd,
    :vp6a,
    :amv,
    :vb,
    :pcx,
    :sunrast,
    :indeo4,
    :indeo5,
    :mimic,
    :rl2,
    :'8svx_exp',
    :'8svx_fib',
    :escape124,
    :dirac,
    :bfi,
    :cmv,
    :motionpixels,
    :tgv,
    :tgq,
    :tqi,
    :aura,
    :aura2,
    :v210x,
    :tmv,
    :v210,
    :dpx,
    :mad,
    :frwu,
    :flashsv2,
    :cdgraphics,
    :r210,
    :anm,
    :binkvideo,
    :iff_ilbm,
    :iff_byterun1,
    :kgv1,
    :yop,
    :vp8,
    :pictor,
    :ansi,
    :a64_multi,
    :a64_multi5,
    :r10k,
    :mxpeg,
    :lagarith,
    :prores,
    :jv,
    :dfa,
    :wmv3image,
    :vc1image,
    :g723_1,
    :g729,
    :utvideo,
    :bmv_video,
    :vble,
    :dxtory,
    :v410,
    :first_audio, 0x10000,
    :pcm_s16le, 0x10000,
    :pcm_s16be,
    :pcm_u16le,
    :pcm_u16be,
    :pcm_s8,
    :pcm_u8,
    :pcm_mulaw,
    :pcm_alaw,
    :pcm_s32le,
    :pcm_s32be,
    :pcm_u32le,
    :pcm_u32be,
    :pcm_s24le,
    :pcm_s24be,
    :pcm_u24le,
    :pcm_u24be,
    :pcm_s24daud,
    :pcm_zork,
    :pcm_s16le_planar,
    :pcm_dvd,
    :pcm_f32be,
    :pcm_f32le,
    :pcm_f64be,
    :pcm_f64le,
    :pcm_bluray,
    :pcm_lxf,
    :s302m,
    :pcm_s8_planar,
    :adpcm_ima_qt, 0x11000,
    :adpcm_ima_wav,
    :adpcm_ima_dk3,
    :adpcm_ima_dk4,
    :adpcm_ima_ws,
    :adpcm_ima_smjpeg,
    :adpcm_ms,
    :adpcm_4xm,
    :adpcm_xa,
    :adpcm_adx,
    :adpcm_ea,
    :adpcm_g726,
    :adpcm_ct,
    :adpcm_swf,
    :adpcm_yamaha,
    :adpcm_sbpro_4,
    :adpcm_sbpro_3,
    :adpcm_sbpro_2,
    :adpcm_thp,
    :adpcm_ima_amv,
    :adpcm_ea_r1,
    :adpcm_ea_r3,
    :adpcm_ea_r2,
    :adpcm_ima_ea_sead,
    :adpcm_ima_ea_eacs,
    :adpcm_ea_xas,
    :adpcm_ea_maxis_xa,
    :adpcm_ima_iss,
    :adpcm_g722,
    :amr_nb, 0x12000,
    :amr_wb,
    :ra_144, 0x13000,
    :ra_288,
    :roq_dpcm, 0x14000,
    :interplay_dpcm,
    :xan_dpcm,
    :sol_dpcm,
    :mp2, 0x15000,
    :mp3,
    :aac,
    :ac3,
    :dts,
    :vorbis,
    :dvaudio,
    :wmav1,
    :wmav2,
    :mace3,
    :mace6,
    :vmdaudio,
    :sonic,
    :sonic_ls,
    :flac,
    :mp3adu,
    :mp3on4,
    :shorten,
    :alac,
    :westwood_snd1,
    :gsm,
    :qdm2,
    :cook,
    :truespeech,
    :tta,
    :smackaudio,
    :qcelp,
    :wavpack,
    :dsicinaudio,
    :imc,
    :musepack7,
    :mlp,
    :gsm_ms,
    :atrac3,
    :voxware,
    :ape,
    :nellymoser,
    :musepack8,
    :speex,
    :wmavoice,
    :wmapro,
    :wmalossless,
    :atrac3p,
    :eac3,
    :sipr,
    :mp1,
    :twinvq,
    :truehd,
    :mp4als,
    :atrac1,
    :binkaudio_rdft,
    :binkaudio_dct,
    :aac_latm,
    :qdmc,
    :celt,
    :bmv_audio,
    :first_subtitle, 0x17000,
    :dvd_subtitle, 0x17000,
    :dvb_subtitle,
    :text,
    :xsub,
    :ssa,
    :mov_text,
    :hdmv_pgs_subtitle,
    :dvb_teletext,
    :srt,
    :first_unknown, 0x18000,
    :ttf, 0x18000,
    :probe, 0x19000,
    :mpeg2ts, 0x20000,
    :mpeg4systems, 0x20001,
    :ffmetadata, 0x21000,
  ]

  AVCODEC_MAX_AUDIO_FRAME_SIZE = 192000
  FF_INPUT_BUFFER_PADDING_SIZE = 8
  FF_MIN_BUFFER_SIZE = 16384
  ME_ZERO = 1
  ME_FULL = ME_ZERO + 1
  ME_LOG = ME_FULL + 1
  ME_PHODS = ME_LOG + 1
  ME_EPZS = ME_PHODS + 1
  ME_X1 = ME_EPZS + 1
  ME_HEX = ME_X1 + 1
  ME_UMH = ME_HEX + 1
  ME_ITER = ME_UMH + 1
  ME_TESA = ME_ITER + 1
  Motion_Est_ID = enum :Motion_Est_ID, [
    :zero, 1,
    :full,
    :log,
    :phods,
    :epzs,
    :x1,
    :hex,
    :umh,
    :iter,
    :tesa,
  ]

  AVDISCARD_NONE = -16
  AVDISCARD_DEFAULT = 0
  AVDISCARD_NONREF = 8
  AVDISCARD_BIDIR = 16
  AVDISCARD_NONKEY = 32
  AVDISCARD_ALL = 48
  AVDiscard = enum :AVDiscard, [
    :none, -16,
    :default, 0,
    :nonref, 8,
    :bidir, 16,
    :nonkey, 32,
    :all, 48,
  ]

  AVCOL_PRI_BT709 = 1
  AVCOL_PRI_UNSPECIFIED = 2
  AVCOL_PRI_BT470M = 4
  AVCOL_PRI_BT470BG = 5
  AVCOL_PRI_SMPTE170M = 6
  AVCOL_PRI_SMPTE240M = 7
  AVCOL_PRI_FILM = 8
  AVCOL_PRI_NB = AVCOL_PRI_FILM + 1
  AVColorPrimaries = enum :AVColorPrimaries, [
    :bt709, 1,
    :unspecified, 2,
    :bt470m, 4,
    :bt470bg, 5,
    :smpte170m, 6,
    :smpte240m, 7,
    :film, 8,
    :nb,
  ]

  AVCOL_TRC_BT709 = 1
  AVCOL_TRC_UNSPECIFIED = 2
  AVCOL_TRC_GAMMA22 = 4
  AVCOL_TRC_GAMMA28 = 5
  AVCOL_TRC_NB = AVCOL_TRC_GAMMA28 + 1
  AVColorTransferCharacteristic = enum :AVColorTransferCharacteristic, [
    :bt709, 1,
    :unspecified, 2,
    :gamma22, 4,
    :gamma28, 5,
    :nb,
  ]

  AVCOL_SPC_RGB = 0
  AVCOL_SPC_BT709 = 1
  AVCOL_SPC_UNSPECIFIED = 2
  AVCOL_SPC_FCC = 4
  AVCOL_SPC_BT470BG = 5
  AVCOL_SPC_SMPTE170M = 6
  AVCOL_SPC_SMPTE240M = 7
  AVCOL_SPC_NB = AVCOL_SPC_SMPTE240M + 1
  AVColorSpace = enum :AVColorSpace, [
    :rgb, 0,
    :bt709, 1,
    :unspecified, 2,
    :fcc, 4,
    :bt470bg, 5,
    :smpte170m, 6,
    :smpte240m, 7,
    :nb,
  ]

  AVCOL_RANGE_UNSPECIFIED = 0
  AVCOL_RANGE_MPEG = 1
  AVCOL_RANGE_JPEG = 2
  AVCOL_RANGE_NB = AVCOL_RANGE_JPEG + 1
  AVColorRange = enum :AVColorRange, [
    :unspecified, 0,
    :mpeg, 1,
    :jpeg, 2,
    :nb,
  ]

  AVCHROMA_LOC_UNSPECIFIED = 0
  AVCHROMA_LOC_LEFT = 1
  AVCHROMA_LOC_CENTER = 2
  AVCHROMA_LOC_TOPLEFT = 3
  AVCHROMA_LOC_TOP = 4
  AVCHROMA_LOC_BOTTOMLEFT = 5
  AVCHROMA_LOC_BOTTOM = 6
  AVCHROMA_LOC_NB = AVCHROMA_LOC_BOTTOM + 1
  AVChromaLocation = enum :AVChromaLocation, [
    :unspecified, 0,
    :left, 1,
    :center, 2,
    :topleft, 3,
    :top, 4,
    :bottomleft, 5,
    :bottom, 6,
    :nb,
  ]

  AV_LPC_TYPE_DEFAULT = -1
  AV_LPC_TYPE_NONE = 0
  AV_LPC_TYPE_FIXED = 1
  AV_LPC_TYPE_LEVINSON = 2
  AV_LPC_TYPE_CHOLESKY = 3
  AV_LPC_TYPE_NB = AV_LPC_TYPE_CHOLESKY + 1
  AVLPCType = enum :AVLPCType, [
    :default, -1,
    :none, 0,
    :fixed, 1,
    :levinson, 2,
    :cholesky, 3,
    :nb,
  ]

  AV_AUDIO_SERVICE_TYPE_MAIN = 0
  AV_AUDIO_SERVICE_TYPE_EFFECTS = 1
  AV_AUDIO_SERVICE_TYPE_VISUALLY_IMPAIRED = 2
  AV_AUDIO_SERVICE_TYPE_HEARING_IMPAIRED = 3
  AV_AUDIO_SERVICE_TYPE_DIALOGUE = 4
  AV_AUDIO_SERVICE_TYPE_COMMENTARY = 5
  AV_AUDIO_SERVICE_TYPE_EMERGENCY = 6
  AV_AUDIO_SERVICE_TYPE_VOICE_OVER = 7
  AV_AUDIO_SERVICE_TYPE_KARAOKE = 8
  AV_AUDIO_SERVICE_TYPE_NB = AV_AUDIO_SERVICE_TYPE_KARAOKE + 1
  AVAudioServiceType = enum :AVAudioServiceType, [
    :main, 0,
    :effects, 1,
    :visually_impaired, 2,
    :hearing_impaired, 3,
    :dialogue, 4,
    :commentary, 5,
    :emergency, 6,
    :voice_over, 7,
    :karaoke, 8,
    :nb,
  ]

  class RcOverride < FFI::Struct
    layout(
           :start_frame, :int,
           :end_frame, :int,
           :qscale, :int,
           :quality_factor, :float
    )
  end
  FF_MAX_B_FRAMES = 16
  CODEC_FLAG_QSCALE = 0x0002
  CODEC_FLAG_4MV = 0x0004
  CODEC_FLAG_QPEL = 0x0010
  CODEC_FLAG_GMC = 0x0020
  CODEC_FLAG_MV0 = 0x0040
  CODEC_FLAG_INPUT_PRESERVED = 0x0100
  CODEC_FLAG_PASS1 = 0x0200
  CODEC_FLAG_PASS2 = 0x0400
  CODEC_FLAG_GRAY = 0x2000
  CODEC_FLAG_EMU_EDGE = 0x4000
  CODEC_FLAG_PSNR = 0x8000
  CODEC_FLAG_TRUNCATED = 0x00010000
  CODEC_FLAG_NORMALIZE_AQP = 0x00020000
  CODEC_FLAG_INTERLACED_DCT = 0x00040000
  CODEC_FLAG_LOW_DELAY = 0x00080000
  CODEC_FLAG_GLOBAL_HEADER = 0x00400000
  CODEC_FLAG_BITEXACT = 0x00800000
  CODEC_FLAG_AC_PRED = 0x01000000
  CODEC_FLAG_CBP_RD = 0x04000000
  CODEC_FLAG_QP_RD = 0x08000000
  CODEC_FLAG_LOOP_FILTER = 0x00000800
  CODEC_FLAG_INTERLACED_ME = 0x20000000
  CODEC_FLAG_CLOSED_GOP = 0x80000000
  CODEC_FLAG2_FAST = 0x00000001
  CODEC_FLAG2_STRICT_GOP = 0x00000002
  CODEC_FLAG2_NO_OUTPUT = 0x00000004
  CODEC_FLAG2_LOCAL_HEADER = 0x00000008
  CODEC_FLAG2_SKIP_RD = 0x00004000
  CODEC_FLAG2_CHUNKS = 0x00008000
  CODEC_FLAG_OBMC = 0x00000001
  CODEC_FLAG_H263P_AIV = 0x00000008
  CODEC_FLAG_PART = 0x0080
  CODEC_FLAG_ALT_SCAN = 0x00100000
  CODEC_FLAG_H263P_UMV = 0x02000000
  CODEC_FLAG_H263P_SLICE_STRUCT = 0x10000000
  CODEC_FLAG_SVCD_SCAN_OFFSET = 0x40000000
  CODEC_FLAG2_INTRA_VLC = 0x00000800
  CODEC_FLAG2_DROP_FRAME_TIMECODE = 0x00002000
  CODEC_FLAG2_NON_LINEAR_QUANT = 0x00010000
  CODEC_FLAG_EXTERN_HUFF = 0x1000
  CODEC_FLAG2_BPYRAMID = 0x00000010
  CODEC_FLAG2_WPRED = 0x00000020
  CODEC_FLAG2_MIXED_REFS = 0x00000040
  CODEC_FLAG2_8X8DCT = 0x00000080
  CODEC_FLAG2_FASTPSKIP = 0x00000100
  CODEC_FLAG2_AUD = 0x00000200
  CODEC_FLAG2_BRDO = 0x00000400
  CODEC_FLAG2_MBTREE = 0x00040000
  CODEC_FLAG2_PSY = 0x00080000
  CODEC_FLAG2_SSIM = 0x00100000
  CODEC_FLAG2_INTRA_REFRESH = 0x00200000
  CODEC_FLAG2_MEMC_ONLY = 0x00001000
  CODEC_FLAG2_BIT_RESERVOIR = 0x00020000
  CODEC_CAP_DRAW_HORIZ_BAND = 0x0001
  CODEC_CAP_DR1 = 0x0002
  CODEC_CAP_PARSE_ONLY = 0x0004
  CODEC_CAP_TRUNCATED = 0x0008
  CODEC_CAP_HWACCEL = 0x0010
  CODEC_CAP_DELAY = 0x0020
  CODEC_CAP_SMALL_LAST_FRAME = 0x0040
  CODEC_CAP_HWACCEL_VDPAU = 0x0080
  CODEC_CAP_SUBFRAMES = 0x0100
  CODEC_CAP_EXPERIMENTAL = 0x0200
  CODEC_CAP_CHANNEL_CONF = 0x0400
  CODEC_CAP_NEG_LINESIZES = 0x0800
  CODEC_CAP_FRAME_THREADS = 0x1000
  CODEC_CAP_SLICE_THREADS = 0x2000
  CODEC_CAP_PARAM_CHANGE = 0x4000
  CODEC_CAP_AUTO_THREADS = 0x8000
  CODEC_CAP_VARIABLE_FRAME_SIZE = 0x10000
  MB_TYPE_INTRA4x4 = 0x0001
  MB_TYPE_INTRA16x16 = 0x0002
  MB_TYPE_INTRA_PCM = 0x0004
  MB_TYPE_16x16 = 0x0008
  MB_TYPE_16x8 = 0x0010
  MB_TYPE_8x16 = 0x0020
  MB_TYPE_8x8 = 0x0040
  MB_TYPE_INTERLACED = 0x0080
  MB_TYPE_DIRECT2 = 0x0100
  MB_TYPE_ACPRED = 0x0200
  MB_TYPE_GMC = 0x0400
  MB_TYPE_SKIP = 0x0800
  MB_TYPE_P0L0 = 0x1000
  MB_TYPE_P1L0 = 0x2000
  MB_TYPE_P0L1 = 0x4000
  MB_TYPE_P1L1 = 0x8000
  MB_TYPE_L0 = (0x1000|0x2000)
  MB_TYPE_L1 = (0x4000|0x8000)
  MB_TYPE_L0L1 = ((0x1000|0x2000)|(0x4000|0x8000))
  MB_TYPE_QUANT = 0x00010000
  MB_TYPE_CBP = 0x00020000
  class AVPanScan < FFI::Struct
    layout(
           :id, :int,
           :width, :int,
           :height, :int,
           :position, [[:int16, 2], 3]
    )
  end
  FF_QSCALE_TYPE_MPEG1 = 0
  FF_QSCALE_TYPE_MPEG2 = 1
  FF_QSCALE_TYPE_H264 = 2
  FF_QSCALE_TYPE_VP56 = 3
  FF_BUFFER_TYPE_INTERNAL = 1
  FF_BUFFER_TYPE_USER = 2
  FF_BUFFER_TYPE_SHARED = 4
  FF_BUFFER_TYPE_COPY = 8
  FF_BUFFER_HINTS_VALID = 0x01
  FF_BUFFER_HINTS_READABLE = 0x02
  FF_BUFFER_HINTS_PRESERVE = 0x04
  FF_BUFFER_HINTS_REUSABLE = 0x08
  AV_PKT_DATA_PALETTE = 0
  AV_PKT_DATA_NEW_EXTRADATA = AV_PKT_DATA_PALETTE + 1
  AV_PKT_DATA_PARAM_CHANGE = AV_PKT_DATA_NEW_EXTRADATA + 1
  AVPacketSideDataType = enum :AVPacketSideDataType, [
    :palette,
    :new_extradata,
    :param_change,
  ]

  class AVPacketSideData < FFI::Struct
    layout(
           :data, :pointer,
           :size, :int,
           :type, AVPacketSideDataType
    )
  end
  class AVPacket < FFI::Struct
    layout(
           :pts, :int64,
           :dts, :int64,
           :data, :pointer,
           :size, :int,
           :stream_index, :int,
           :flags, :int,
           :side_data, AVPacketSideData.ptr,
           :side_data_elems, :int,
           :duration, :int,
           :destruct, callback([ AVPacket.ptr ], :void),
           :priv, :pointer,
           :pos, :int64,
           :convergence_duration, :int64,
    )
    def destruct=(cb)
      @destruct = cb
      self[:destruct] = @destruct
    end
    def destruct
      @destruct
    end

  end
  AV_PKT_FLAG_KEY = 0x0001
  AV_PKT_FLAG_CORRUPT = 0x0002
  AV_SIDE_DATA_PARAM_CHANGE_CHANNEL_COUNT = 0x0001
  AV_SIDE_DATA_PARAM_CHANGE_CHANNEL_LAYOUT = 0x0002
  AV_SIDE_DATA_PARAM_CHANGE_SAMPLE_RATE = 0x0004
  AV_SIDE_DATA_PARAM_CHANGE_DIMENSIONS = 0x0008
  AVSideDataParamChangeFlags = enum :AVSideDataParamChangeFlags, [
    :channel_count, 0x0001,
    :channel_layout, 0x0002,
    :sample_rate, 0x0004,
    :dimensions, 0x0008,
  ]

  AV_NUM_DATA_POINTERS = 4
  class AVFrame < FFI::Struct
    layout(
           :data, [:pointer, 4],
           :linesize, [:int, 4],
           :base, [:pointer, 4],
           :key_frame, :int,
           :pict_type, AVPictureType,
           :pts, :int64,
           :coded_picture_number, :int,
           :display_picture_number, :int,
           :quality, :int,
           :age, :int,
           :reference, :int,
           :qscale_table, :pointer,
           :qstride, :int,
           :mbskip_table, :pointer,
           :motion_val, [:pointer, 2],
           :mb_type, :pointer,
           :motion_subsample_log2, :uint8,
           :opaque, :pointer,
           :error, [:uint64, 4],
           :type, :int,
           :repeat_pict, :int,
           :qscale_type, :int,
           :interlaced_frame, :int,
           :top_field_first, :int,
           :pan_scan, AVPanScan.ptr,
           :palette_has_changed, :int,
           :buffer_hints, :int,
           :dct_coeff, :pointer,
           :ref_index, [:pointer, 2],
           :reordered_opaque, :int64,
           :hwaccel_picture_private, :pointer,
           :pkt_pts, :int64,
           :pkt_dts, :int64,
           :owner, AVCodecContext.ptr,
           :thread_opaque, :pointer,
           :nb_samples, :int,
           :extended_data, :pointer,
           :sample_aspect_ratio, AVRational.by_value,
           :width, :int,
           :height, :int,
           :format, PixelFormat,
    )
  end
  AV_FIELD_UNKNOWN = 0
  AV_FIELD_PROGRESSIVE = AV_FIELD_UNKNOWN + 1
  AV_FIELD_TT = AV_FIELD_PROGRESSIVE + 1
  AV_FIELD_BB = AV_FIELD_TT + 1
  AV_FIELD_TB = AV_FIELD_BB + 1
  AV_FIELD_BT = AV_FIELD_TB + 1
  AVFieldOrder = enum :AVFieldOrder, [
    :unknown,
    :progressive,
    :tt,
    :bb,
    :tb,
    :bt,
  ]

  FF_ASPECT_EXTENDED = 15
  FF_RC_STRATEGY_XVID = 1
  FF_BUG_AUTODETECT = 1
  FF_BUG_OLD_MSMPEG4 = 2
  FF_BUG_XVID_ILACE = 4
  FF_BUG_UMP4 = 8
  FF_BUG_NO_PADDING = 16
  FF_BUG_AMV = 32
  FF_BUG_AC_VLC = 0
  FF_BUG_QPEL_CHROMA = 64
  FF_BUG_STD_QPEL = 128
  FF_BUG_QPEL_CHROMA2 = 256
  FF_BUG_DIRECT_BLOCKSIZE = 512
  FF_BUG_EDGE = 1024
  FF_BUG_HPEL_CHROMA = 2048
  FF_BUG_DC_CLIP = 4096
  FF_BUG_MS = 8192
  FF_BUG_TRUNCATED = 16384
  FF_COMPLIANCE_VERY_STRICT = 2
  FF_COMPLIANCE_STRICT = 1
  FF_COMPLIANCE_NORMAL = 0
  FF_COMPLIANCE_UNOFFICIAL = -1
  FF_COMPLIANCE_EXPERIMENTAL = -2
  FF_ER_CAREFUL = 1
  FF_ER_COMPLIANT = 2
  FF_ER_AGGRESSIVE = 3
  FF_ER_VERY_AGGRESSIVE = 4
  FF_ER_EXPLODE = 5
  FF_DCT_AUTO = 0
  FF_DCT_FASTINT = 1
  FF_DCT_INT = 2
  FF_DCT_MMX = 3
  FF_DCT_MLIB = 4
  FF_DCT_ALTIVEC = 5
  FF_DCT_FAAN = 6
  FF_IDCT_AUTO = 0
  FF_IDCT_INT = 1
  FF_IDCT_SIMPLE = 2
  FF_IDCT_SIMPLEMMX = 3
  FF_IDCT_LIBMPEG2MMX = 4
  FF_IDCT_PS2 = 5
  FF_IDCT_MLIB = 6
  FF_IDCT_ARM = 7
  FF_IDCT_ALTIVEC = 8
  FF_IDCT_SH4 = 9
  FF_IDCT_SIMPLEARM = 10
  FF_IDCT_H264 = 11
  FF_IDCT_VP3 = 12
  FF_IDCT_IPP = 13
  FF_IDCT_XVIDMMX = 14
  FF_IDCT_CAVS = 15
  FF_IDCT_SIMPLEARMV5TE = 16
  FF_IDCT_SIMPLEARMV6 = 17
  FF_IDCT_SIMPLEVIS = 18
  FF_IDCT_WMV2 = 19
  FF_IDCT_FAAN = 20
  FF_IDCT_EA = 21
  FF_IDCT_SIMPLENEON = 22
  FF_IDCT_SIMPLEALPHA = 23
  FF_IDCT_BINK = 24
  FF_EC_GUESS_MVS = 1
  FF_EC_DEBLOCK = 2
  FF_PRED_LEFT = 0
  FF_PRED_PLANE = 1
  FF_PRED_MEDIAN = 2
  FF_DEBUG_PICT_INFO = 1
  FF_DEBUG_RC = 2
  FF_DEBUG_BITSTREAM = 4
  FF_DEBUG_MB_TYPE = 8
  FF_DEBUG_QP = 16
  FF_DEBUG_MV = 32
  FF_DEBUG_DCT_COEFF = 0x00000040
  FF_DEBUG_SKIP = 0x00000080
  FF_DEBUG_STARTCODE = 0x00000100
  FF_DEBUG_PTS = 0x00000200
  FF_DEBUG_ER = 0x00000400
  FF_DEBUG_MMCO = 0x00000800
  FF_DEBUG_BUGS = 0x00001000
  FF_DEBUG_VIS_QP = 0x00002000
  FF_DEBUG_VIS_MB_TYPE = 0x00004000
  FF_DEBUG_BUFFERS = 0x00008000
  FF_DEBUG_THREADS = 0x00010000
  FF_DEBUG_VIS_MV_P_FOR = 0x00000001
  FF_DEBUG_VIS_MV_B_FOR = 0x00000002
  FF_DEBUG_VIS_MV_B_BACK = 0x00000004
  FF_CMP_SAD = 0
  FF_CMP_SSE = 1
  FF_CMP_SATD = 2
  FF_CMP_DCT = 3
  FF_CMP_PSNR = 4
  FF_CMP_BIT = 5
  FF_CMP_RD = 6
  FF_CMP_ZERO = 7
  FF_CMP_VSAD = 8
  FF_CMP_VSSE = 9
  FF_CMP_NSSE = 10
  FF_CMP_W53 = 11
  FF_CMP_W97 = 12
  FF_CMP_DCTMAX = 13
  FF_CMP_DCT264 = 14
  FF_CMP_CHROMA = 256
  FF_DTG_AFD_SAME = 8
  FF_DTG_AFD_4_3 = 9
  FF_DTG_AFD_16_9 = 10
  FF_DTG_AFD_14_9 = 11
  FF_DTG_AFD_4_3_SP_14_9 = 13
  FF_DTG_AFD_16_9_SP_14_9 = 14
  FF_DTG_AFD_SP_4_3 = 15
  FF_DEFAULT_QUANT_BIAS = 999999
  FF_CODER_TYPE_VLC = 0
  FF_CODER_TYPE_AC = 1
  FF_CODER_TYPE_RAW = 2
  FF_CODER_TYPE_RLE = 3
  FF_CODER_TYPE_DEFLATE = 4
  SLICE_FLAG_CODED_ORDER = 0x0001
  SLICE_FLAG_ALLOW_FIELD = 0x0002
  SLICE_FLAG_ALLOW_PLANE = 0x0004
  FF_MB_DECISION_SIMPLE = 0
  FF_MB_DECISION_BITS = 1
  FF_MB_DECISION_RD = 2
  FF_AA_AUTO = 0
  FF_AA_FASTINT = 1
  FF_AA_INT = 2
  FF_AA_FLOAT = 3
  FF_PROFILE_UNKNOWN = -99
  FF_PROFILE_RESERVED = -100
  FF_PROFILE_AAC_MAIN = 0
  FF_PROFILE_AAC_LOW = 1
  FF_PROFILE_AAC_SSR = 2
  FF_PROFILE_AAC_LTP = 3
  FF_PROFILE_DTS = 20
  FF_PROFILE_DTS_ES = 30
  FF_PROFILE_DTS_96_24 = 40
  FF_PROFILE_DTS_HD_HRA = 50
  FF_PROFILE_DTS_HD_MA = 60
  FF_PROFILE_MPEG2_422 = 0
  FF_PROFILE_MPEG2_HIGH = 1
  FF_PROFILE_MPEG2_SS = 2
  FF_PROFILE_MPEG2_SNR_SCALABLE = 3
  FF_PROFILE_MPEG2_MAIN = 4
  FF_PROFILE_MPEG2_SIMPLE = 5
  FF_PROFILE_H264_CONSTRAINED = (1 << 9)
  FF_PROFILE_H264_INTRA = (1 << 11)
  FF_PROFILE_H264_BASELINE = 66
  FF_PROFILE_H264_CONSTRAINED_BASELINE = (66|(1 << 9))
  FF_PROFILE_H264_MAIN = 77
  FF_PROFILE_H264_EXTENDED = 88
  FF_PROFILE_H264_HIGH = 100
  FF_PROFILE_H264_HIGH_10 = 110
  FF_PROFILE_H264_HIGH_10_INTRA = (110|(1 << 11))
  FF_PROFILE_H264_HIGH_422 = 122
  FF_PROFILE_H264_HIGH_422_INTRA = (122|(1 << 11))
  FF_PROFILE_H264_HIGH_444 = 144
  FF_PROFILE_H264_HIGH_444_PREDICTIVE = 244
  FF_PROFILE_H264_HIGH_444_INTRA = (244|(1 << 11))
  FF_PROFILE_H264_CAVLC_444 = 44
  FF_PROFILE_VC1_SIMPLE = 0
  FF_PROFILE_VC1_MAIN = 1
  FF_PROFILE_VC1_COMPLEX = 2
  FF_PROFILE_VC1_ADVANCED = 3
  FF_PROFILE_MPEG4_SIMPLE = 0
  FF_PROFILE_MPEG4_SIMPLE_SCALABLE = 1
  FF_PROFILE_MPEG4_CORE = 2
  FF_PROFILE_MPEG4_MAIN = 3
  FF_PROFILE_MPEG4_N_BIT = 4
  FF_PROFILE_MPEG4_SCALABLE_TEXTURE = 5
  FF_PROFILE_MPEG4_SIMPLE_FACE_ANIMATION = 6
  FF_PROFILE_MPEG4_BASIC_ANIMATED_TEXTURE = 7
  FF_PROFILE_MPEG4_HYBRID = 8
  FF_PROFILE_MPEG4_ADVANCED_REAL_TIME = 9
  FF_PROFILE_MPEG4_CORE_SCALABLE = 10
  FF_PROFILE_MPEG4_ADVANCED_CODING = 11
  FF_PROFILE_MPEG4_ADVANCED_CORE = 12
  FF_PROFILE_MPEG4_ADVANCED_SCALABLE_TEXTURE = 13
  FF_PROFILE_MPEG4_SIMPLE_STUDIO = 14
  FF_PROFILE_MPEG4_ADVANCED_SIMPLE = 15
  FF_LEVEL_UNKNOWN = -99
  X264_PART_I4X4 = 0x001
  X264_PART_I8X8 = 0x002
  X264_PART_P8X8 = 0x010
  X264_PART_P4X4 = 0x020
  X264_PART_B8X8 = 0x100
  FF_COMPRESSION_DEFAULT = -1
  FF_THREAD_FRAME = 1
  FF_THREAD_SLICE = 2
  AV_EF_CRCCHECK = (1 << 0)
  AV_EF_BITSTREAM = (1 << 1)
  AV_EF_BUFFER = (1 << 2)
  AV_EF_EXPLODE = (1 << 3)
  class AVCodecContext < FFI::Struct
    layout(
           :av_class, :pointer,
           :bit_rate, :int,
           :bit_rate_tolerance, :int,
           :flags, :int,
           :sub_id, :int,
           :me_method, :int,
           :extradata, :pointer,
           :extradata_size, :int,
           :time_base, AVRational.by_value,
           :width, :int,
           :height, :int,
           :gop_size, :int,
           :pix_fmt, PixelFormat,
           :draw_horiz_band, callback([ AVCodecContext.ptr, :pointer, :pointer, :int, :int, :int ], :void),
           :sample_rate, :int,
           :channels, :int,
           :sample_fmt, :int,
           :frame_size, :int,
           :frame_number, :int,
           :delay, :int,
           :qcompress, :float,
           :qblur, :float,
           :qmin, :int,
           :qmax, :int,
           :max_qdiff, :int,
           :max_b_frames, :int,
           :b_quant_factor, :float,
           :rc_strategy, :int,
           :b_frame_strategy, :int,
           :codec, AVCodec.ptr,
           :priv_data, :pointer,
           :rtp_payload_size, :int,
           :rtp_callback, callback([ AVCodecContext.ptr, :pointer, :int, :int ], :void),
           :mv_bits, :int,
           :header_bits, :int,
           :i_tex_bits, :int,
           :p_tex_bits, :int,
           :i_count, :int,
           :p_count, :int,
           :skip_count, :int,
           :misc_bits, :int,
           :frame_bits, :int,
           :opaque, :pointer,
           :codec_name, [:char, 32],
           :codec_type, AVMediaType,
           :codec_id, CodecID,
           :codec_tag, :uint,
           :workaround_bugs, :int,
           :luma_elim_threshold, :int,
           :chroma_elim_threshold, :int,
           :strict_std_compliance, :int,
           :b_quant_offset, :float,
           :error_recognition, :int,
           :get_buffer, callback([ AVCodecContext.ptr, AVFrame.ptr ], :int),
           :release_buffer, callback([ AVCodecContext.ptr, AVFrame.ptr ], :void),
           :has_b_frames, :int,
           :block_align, :int,
           :parse_only, :int,
           :mpeg_quant, :int,
           :stats_out, :pointer,
           :stats_in, :pointer,
           :rc_qsquish, :float,
           :rc_qmod_amp, :float,
           :rc_qmod_freq, :int,
           :rc_override, RcOverride.ptr,
           :rc_override_count, :int,
           :rc_eq, :pointer,
           :rc_max_rate, :int,
           :rc_min_rate, :int,
           :rc_buffer_size, :int,
           :rc_buffer_aggressivity, :float,
           :i_quant_factor, :float,
           :i_quant_offset, :float,
           :rc_initial_cplx, :float,
           :dct_algo, :int,
           :lumi_masking, :float,
           :temporal_cplx_masking, :float,
           :spatial_cplx_masking, :float,
           :p_masking, :float,
           :dark_masking, :float,
           :idct_algo, :int,
           :slice_count, :int,
           :slice_offset, :pointer,
           :error_concealment, :int,
           :dsp_mask, :uint,
           :bits_per_coded_sample, :int,
           :prediction_method, :int,
           :sample_aspect_ratio, AVRational.by_value,
           :coded_frame, AVFrame.ptr,
           :debug, :int,
           :debug_mv, :int,
           :error, [:uint64, 4],
           :me_cmp, :int,
           :me_sub_cmp, :int,
           :mb_cmp, :int,
           :ildct_cmp, :int,
           :dia_size, :int,
           :last_predictor_count, :int,
           :pre_me, :int,
           :me_pre_cmp, :int,
           :pre_dia_size, :int,
           :me_subpel_quality, :int,
           :get_format, callback([ AVCodecContext.ptr, :pointer ], PixelFormat),
           :dtg_active_format, :int,
           :me_range, :int,
           :intra_quant_bias, :int,
           :inter_quant_bias, :int,
           :color_table_id, :int,
           :internal_buffer_count, :int,
           :internal_buffer, :pointer,
           :global_quality, :int,
           :coder_type, :int,
           :context_model, :int,
           :slice_flags, :int,
           :xvmc_acceleration, :int,
           :mb_decision, :int,
           :intra_matrix, :pointer,
           :inter_matrix, :pointer,
           :stream_codec_tag, :uint,
           :scenechange_threshold, :int,
           :lmin, :int,
           :lmax, :int,
           :palctrl, AVPaletteControl.ptr,
           :noise_reduction, :int,
           :reget_buffer, callback([ AVCodecContext.ptr, AVFrame.ptr ], :int),
           :rc_initial_buffer_occupancy, :int,
           :inter_threshold, :int,
           :flags2, :int,
           :error_rate, :int,
           :antialias_algo, :int,
           :quantizer_noise_shaping, :int,
           :thread_count, :int,
           :execute, callback([ AVCodecContext.ptr, callback([ AVCodecContext.ptr, :pointer ], :int), :pointer, :pointer, :int, :int ], :int),
           :thread_opaque, :pointer,
           :me_threshold, :int,
           :mb_threshold, :int,
           :intra_dc_precision, :int,
           :nsse_weight, :int,
           :skip_top, :int,
           :skip_bottom, :int,
           :profile, :int,
           :level, :int,
           :lowres, :int,
           :coded_width, :int,
           :coded_height, :int,
           :frame_skip_threshold, :int,
           :frame_skip_factor, :int,
           :frame_skip_exp, :int,
           :frame_skip_cmp, :int,
           :border_masking, :float,
           :mb_lmin, :int,
           :mb_lmax, :int,
           :me_penalty_compensation, :int,
           :skip_loop_filter, AVDiscard,
           :skip_idct, AVDiscard,
           :skip_frame, AVDiscard,
           :bidir_refine, :int,
           :brd_scale, :int,
           :crf, :float,
           :cqp, :int,
           :keyint_min, :int,
           :refs, :int,
           :chromaoffset, :int,
           :bframebias, :int,
           :trellis, :int,
           :complexityblur, :float,
           :deblockalpha, :int,
           :deblockbeta, :int,
           :partitions, :int,
           :directpred, :int,
           :cutoff, :int,
           :scenechange_factor, :int,
           :mv0_threshold, :int,
           :b_sensitivity, :int,
           :compression_level, :int,
           :min_prediction_order, :int,
           :max_prediction_order, :int,
           :lpc_coeff_precision, :int,
           :prediction_order_method, :int,
           :min_partition_order, :int,
           :max_partition_order, :int,
           :timecode_frame_start, :int64,
           :request_channels, :int,
           :drc_scale, :float,
           :reordered_opaque, :int64,
           :bits_per_raw_sample, :int,
           :channel_layout, :uint64,
           :request_channel_layout, :uint64,
           :rc_max_available_vbv_use, :float,
           :rc_min_vbv_overflow_use, :float,
           :hwaccel, AVHWAccel.ptr,
           :ticks_per_frame, :int,
           :hwaccel_context, :pointer,
           :color_primaries, AVColorPrimaries,
           :color_trc, AVColorTransferCharacteristic,
           :colorspace, AVColorSpace,
           :color_range, AVColorRange,
           :chroma_sample_location, AVChromaLocation,
           :execute2, callback([ AVCodecContext.ptr, callback([ AVCodecContext.ptr, :pointer, :int, :int ], :int), :pointer, :pointer, :int ], :int),
           :weighted_p_pred, :int,
           :aq_mode, :int,
           :aq_strength, :float,
           :psy_rd, :float,
           :psy_trellis, :float,
           :rc_lookahead, :int,
           :crf_max, :float,
           :log_level_offset, :int,
           :lpc_type, AVLPCType,
           :lpc_passes, :int,
           :slices, :int,
           :subtitle_header, :pointer,
           :subtitle_header_size, :int,
           :pkt, AVPacket.ptr,
           :is_copy, :int,
           :thread_type, :int,
           :active_thread_type, :int,
           :thread_safe_callbacks, :int,
           :vbv_delay, :uint64,
           :audio_service_type, AVAudioServiceType,
           :request_sample_fmt, :int,
           :err_recognition, :int,
           :internal, :pointer,
           :field_order, AVFieldOrder
    )
    def draw_horiz_band=(cb)
      @draw_horiz_band = cb
      self[:draw_horiz_band] = @draw_horiz_band
    end
    def draw_horiz_band
      @draw_horiz_band
    end
    def rtp_callback=(cb)
      @rtp_callback = cb
      self[:rtp_callback] = @rtp_callback
    end
    def rtp_callback
      @rtp_callback
    end
    def get_buffer=(cb)
      @get_buffer = cb
      self[:get_buffer] = @get_buffer
    end
    def get_buffer
      @get_buffer
    end
    def release_buffer=(cb)
      @release_buffer = cb
      self[:release_buffer] = @release_buffer
    end
    def release_buffer
      @release_buffer
    end
    def stats_out=(str)
      @stats_out = FFI::MemoryPointer.from_string(str)
      self[:stats_out] = @stats_out
    end
    def stats_out
      @stats_out.get_string(0)
    end
    def stats_in=(str)
      @stats_in = FFI::MemoryPointer.from_string(str)
      self[:stats_in] = @stats_in
    end
    def stats_in
      @stats_in.get_string(0)
    end
    def rc_eq=(str)
      @rc_eq = FFI::MemoryPointer.from_string(str)
      self[:rc_eq] = @rc_eq
    end
    def rc_eq
      @rc_eq.get_string(0)
    end
    def get_format=(cb)
      @get_format = cb
      self[:get_format] = @get_format
    end
    def get_format
      @get_format
    end
    def reget_buffer=(cb)
      @reget_buffer = cb
      self[:reget_buffer] = @reget_buffer
    end
    def reget_buffer
      @reget_buffer
    end
    def execute=(cb)
      @execute = cb
      self[:execute] = @execute
    end
    def execute
      @execute
    end
    def execute2=(cb)
      @execute2 = cb
      self[:execute2] = @execute2
    end
    def execute2
      @execute2
    end

  end
  class AVProfile < FFI::Struct
    layout(
           :profile, :int,
           :name, :pointer
    )
    def name=(str)
      @name = FFI::MemoryPointer.from_string(str)
      self[:name] = @name
    end
    def name
      @name.get_string(0)
    end

  end
  class AVCodec < FFI::Struct
    layout(
           :name, :pointer,
           :type, AVMediaType,
           :id, CodecID,
           :priv_data_size, :int,
           :init, callback([ AVCodecContext.ptr ], :int),
           :encode, callback([ AVCodecContext.ptr, :pointer, :int, :pointer ], :int),
           :close, callback([ AVCodecContext.ptr ], :int),
           :decode, callback([ AVCodecContext.ptr, :pointer, :pointer, AVPacket.ptr ], :int),
           :capabilities, :int,
           :next, AVCodec.ptr,
           :flush, callback([ AVCodecContext.ptr ], :void),
           :supported_framerates, :pointer,
           :pix_fmts, :pointer,
           :long_name, :pointer,
           :supported_samplerates, :pointer,
           :sample_fmts, :pointer,
           :channel_layouts, :pointer,
           :max_lowres, :uint8,
           :priv_class, :pointer,
           :profiles, :pointer,
           :init_thread_copy, callback([ AVCodecContext.ptr ], :int),
           :update_thread_context, callback([ AVCodecContext.ptr, :pointer ], :int),
           :defaults, :pointer,
           :init_static_data, callback([ AVCodec.ptr ], :void),
           :encode2, callback([ AVCodecContext.ptr, AVPacket.ptr, :pointer, :pointer ], :int)
    )
    def name=(str)
      @name = FFI::MemoryPointer.from_string(str)
      self[:name] = @name
    end
    def name
      @name.get_string(0)
    end
    def init=(cb)
      @init = cb
      self[:init] = @init
    end
    def init
      @init
    end
    def encode=(cb)
      @encode = cb
      self[:encode] = @encode
    end
    def encode
      @encode
    end
    def close=(cb)
      @close = cb
      self[:close] = @close
    end
    def close
      @close
    end
    def decode=(cb)
      @decode = cb
      self[:decode] = @decode
    end
    def decode
      @decode
    end
    def flush=(cb)
      @flush = cb
      self[:flush] = @flush
    end
    def flush
      @flush
    end
    def long_name=(str)
      @long_name = FFI::MemoryPointer.from_string(str)
      self[:long_name] = @long_name
    end
    def long_name
      @long_name.get_string(0)
    end
    def init_thread_copy=(cb)
      @init_thread_copy = cb
      self[:init_thread_copy] = @init_thread_copy
    end
    def init_thread_copy
      @init_thread_copy
    end
    def update_thread_context=(cb)
      @update_thread_context = cb
      self[:update_thread_context] = @update_thread_context
    end
    def update_thread_context
      @update_thread_context
    end
    def init_static_data=(cb)
      @init_static_data = cb
      self[:init_static_data] = @init_static_data
    end
    def init_static_data
      @init_static_data
    end
    def encode2=(cb)
      @encode2 = cb
      self[:encode2] = @encode2
    end
    def encode2
      @encode2
    end

  end
  class AVHWAccel < FFI::Struct
    layout(
           :name, :pointer,
           :type, AVMediaType,
           :id, CodecID,
           :pix_fmt, PixelFormat,
           :capabilities, :int,
           :next, AVHWAccel.ptr,
           :start_frame, callback([ AVCodecContext.ptr, :pointer, :uint32 ], :int),
           :decode_slice, callback([ AVCodecContext.ptr, :pointer, :uint32 ], :int),
           :end_frame, callback([ AVCodecContext.ptr ], :int),
           :priv_data_size, :int
    )
    def name=(str)
      @name = FFI::MemoryPointer.from_string(str)
      self[:name] = @name
    end
    def name
      @name.get_string(0)
    end
    def start_frame=(cb)
      @start_frame = cb
      self[:start_frame] = @start_frame
    end
    def start_frame
      @start_frame
    end
    def decode_slice=(cb)
      @decode_slice = cb
      self[:decode_slice] = @decode_slice
    end
    def decode_slice
      @decode_slice
    end
    def end_frame=(cb)
      @end_frame = cb
      self[:end_frame] = @end_frame
    end
    def end_frame
      @end_frame
    end

  end
  class AVPicture < FFI::Struct
    layout(
           :data, [:pointer, 4],
           :linesize, [:int, 4]
    )
  end
  AVPALETTE_SIZE = 1024
  AVPALETTE_COUNT = 256
  class AVPaletteControl < FFI::Struct
    layout(
           :palette_changed, :int,
           :palette, [:uint, 256]
    )
  end
  SUBTITLE_NONE = 0
  SUBTITLE_BITMAP = SUBTITLE_NONE + 1
  SUBTITLE_TEXT = SUBTITLE_BITMAP + 1
  SUBTITLE_ASS = SUBTITLE_TEXT + 1
  AVSubtitleType = enum :AVSubtitleType, [
    :none,
    :bitmap,
    :text,
    :ass,
  ]

  class AVSubtitleRect < FFI::Struct
    layout(
           :x, :int,
           :y, :int,
           :w, :int,
           :h, :int,
           :nb_colors, :int,
           :pict, AVPicture.by_value,
           :type, AVSubtitleType,
           :text, :pointer,
           :ass, :pointer
    )
    def text=(str)
      @text = FFI::MemoryPointer.from_string(str)
      self[:text] = @text
    end
    def text
      @text.get_string(0)
    end
    def ass=(str)
      @ass = FFI::MemoryPointer.from_string(str)
      self[:ass] = @ass
    end
    def ass
      @ass.get_string(0)
    end

  end
  class AVSubtitle < FFI::Struct
    layout(
           :format, :uint16,
           :start_display_time, :uint32,
           :end_display_time, :uint32,
           :num_rects, :uint,
           :rects, :pointer,
           :pts, :int64
    )
  end
  attach_function :av_destruct_packet_nofree, :av_destruct_packet_nofree, [ AVPacket.ptr ], :void
  attach_function :av_destruct_packet, :av_destruct_packet, [ AVPacket.ptr ], :void
  attach_function :av_init_packet, :av_init_packet, [ AVPacket.ptr ], :void
  attach_function :av_new_packet, :av_new_packet, [ AVPacket.ptr, :int ], :int
  attach_function :av_shrink_packet, :av_shrink_packet, [ AVPacket.ptr, :int ], :void
  attach_function :av_grow_packet, :av_grow_packet, [ AVPacket.ptr, :int ], :int
  attach_function :av_dup_packet, :av_dup_packet, [ AVPacket.ptr ], :int
  attach_function :av_free_packet, :av_free_packet, [ AVPacket.ptr ], :void
  attach_function :av_packet_new_side_data, :av_packet_new_side_data, [ AVPacket.ptr, AVPacketSideDataType, :int ], :pointer
  attach_function :av_packet_get_side_data, :av_packet_get_side_data, [ AVPacket.ptr, AVPacketSideDataType, :pointer ], :pointer
  attach_function :av_audio_resample_init, :av_audio_resample_init, [ :int, :int, :int, :int, :int, :int, :int, :int, :int, :double ], :pointer
  attach_function :audio_resample, :audio_resample, [ :pointer, :pointer, :pointer, :int ], :int
  attach_function :audio_resample_close, :audio_resample_close, [ :pointer ], :void
  attach_function :av_resample_init, :av_resample_init, [ :int, :int, :int, :int, :int, :double ], :pointer
  attach_function :av_resample, :av_resample, [ :pointer, :pointer, :pointer, :pointer, :int, :int, :int ], :int
  attach_function :av_resample_compensate, :av_resample_compensate, [ :pointer, :int, :int ], :void
  attach_function :av_resample_close, :av_resample_close, [ :pointer ], :void
  attach_function :avpicture_alloc, :avpicture_alloc, [ AVPicture.ptr, PixelFormat, :int, :int ], :int
  attach_function :avpicture_free, :avpicture_free, [ AVPicture.ptr ], :void
  attach_function :avpicture_fill, :avpicture_fill, [ AVPicture.ptr, :pointer, PixelFormat, :int, :int ], :int
  attach_function :avpicture_layout, :avpicture_layout, [ :pointer, PixelFormat, :int, :int, :pointer, :int ], :int
  attach_function :avpicture_get_size, :avpicture_get_size, [ PixelFormat, :int, :int ], :int
  attach_function :avcodec_get_chroma_sub_sample, :avcodec_get_chroma_sub_sample, [ PixelFormat, :pointer, :pointer ], :void
  attach_function :avcodec_get_pix_fmt_name, :avcodec_get_pix_fmt_name, [ PixelFormat ], :string
  attach_function :avcodec_set_dimensions, :avcodec_set_dimensions, [ AVCodecContext.ptr, :int, :int ], :void
  attach_function :avcodec_pix_fmt_to_codec_tag, :avcodec_pix_fmt_to_codec_tag, [ PixelFormat ], :uint
  attach_function :av_get_codec_tag_string, :av_get_codec_tag_string, [ :string, :uint, :uint ], :uint
  FF_LOSS_RESOLUTION = 0x0001
  FF_LOSS_DEPTH = 0x0002
  FF_LOSS_COLORSPACE = 0x0004
  FF_LOSS_ALPHA = 0x0008
  FF_LOSS_COLORQUANT = 0x0010
  FF_LOSS_CHROMA = 0x0020
  attach_function :avcodec_get_pix_fmt_loss, :avcodec_get_pix_fmt_loss, [ PixelFormat, PixelFormat, :int ], :int
  attach_function :avcodec_find_best_pix_fmt, :avcodec_find_best_pix_fmt, [ :int64, PixelFormat, :int, :pointer ], PixelFormat
  FF_ALPHA_TRANSP = 0x0001
  FF_ALPHA_SEMI_TRANSP = 0x0002
  attach_function :img_get_alpha_info, :img_get_alpha_info, [ :pointer, PixelFormat, :int, :int ], :int
  attach_function :avpicture_deinterlace, :avpicture_deinterlace, [ AVPicture.ptr, :pointer, PixelFormat, :int, :int ], :int
  attach_function :av_codec_next, :av_codec_next, [ AVCodec.ptr ], AVCodec.ptr
  attach_function :avcodec_version, :avcodec_version, [  ], :uint
  attach_function :avcodec_configuration, :avcodec_configuration, [  ], :string
  attach_function :avcodec_license, :avcodec_license, [  ], :string
  attach_function :avcodec_init, :avcodec_init, [  ], :void
  attach_function :avcodec_register, :avcodec_register, [ AVCodec.ptr ], :void
  attach_function :avcodec_find_encoder, :avcodec_find_encoder, [ CodecID ], AVCodec.ptr
  attach_function :avcodec_find_encoder_by_name, :avcodec_find_encoder_by_name, [ :string ], AVCodec.ptr
  attach_function :avcodec_find_decoder, :avcodec_find_decoder, [ CodecID ], AVCodec.ptr
  attach_function :avcodec_find_decoder_by_name, :avcodec_find_decoder_by_name, [ :string ], AVCodec.ptr
  attach_function :avcodec_string, :avcodec_string, [ :string, :int, AVCodecContext.ptr, :int ], :void
  attach_function :av_get_profile_name, :av_get_profile_name, [ :pointer, :int ], :string
  attach_function :avcodec_get_context_defaults, :avcodec_get_context_defaults, [ AVCodecContext.ptr ], :void
  attach_function :avcodec_get_context_defaults2, :avcodec_get_context_defaults2, [ AVCodecContext.ptr, AVMediaType ], :void
  attach_function :avcodec_get_context_defaults3, :avcodec_get_context_defaults3, [ AVCodecContext.ptr, AVCodec.ptr ], :int
  attach_function :avcodec_alloc_context, :avcodec_alloc_context, [  ], AVCodecContext.ptr
  attach_function :avcodec_alloc_context2, :avcodec_alloc_context2, [ AVMediaType ], AVCodecContext.ptr
  attach_function :avcodec_alloc_context3, :avcodec_alloc_context3, [ AVCodec.ptr ], AVCodecContext.ptr
  attach_function :avcodec_copy_context, :avcodec_copy_context, [ AVCodecContext.ptr, :pointer ], :int
  attach_function :avcodec_get_frame_defaults, :avcodec_get_frame_defaults, [ AVFrame.ptr ], :void
  attach_function :avcodec_alloc_frame, :avcodec_alloc_frame, [  ], AVFrame.ptr
  attach_function :avcodec_default_get_buffer, :avcodec_default_get_buffer, [ AVCodecContext.ptr, AVFrame.ptr ], :int
  attach_function :avcodec_default_release_buffer, :avcodec_default_release_buffer, [ AVCodecContext.ptr, AVFrame.ptr ], :void
  attach_function :avcodec_default_reget_buffer, :avcodec_default_reget_buffer, [ AVCodecContext.ptr, AVFrame.ptr ], :int
  attach_function :avcodec_get_edge_width, :avcodec_get_edge_width, [  ], :uint
  attach_function :avcodec_align_dimensions, :avcodec_align_dimensions, [ AVCodecContext.ptr, :pointer, :pointer ], :void
  attach_function :avcodec_align_dimensions2, :avcodec_align_dimensions2, [ AVCodecContext.ptr, :pointer, :pointer, :pointer ], :void
  attach_function :avcodec_default_get_format, :avcodec_default_get_format, [ AVCodecContext.ptr, :pointer ], PixelFormat
  attach_function :avcodec_thread_init, :avcodec_thread_init, [ AVCodecContext.ptr, :int ], :int
  attach_function :avcodec_default_execute, :avcodec_default_execute, [ AVCodecContext.ptr, callback([ AVCodecContext.ptr, :pointer ], :int), :pointer, :pointer, :int, :int ], :int
  attach_function :avcodec_default_execute2, :avcodec_default_execute2, [ AVCodecContext.ptr, callback([ AVCodecContext.ptr, :pointer, :int, :int ], :int), :pointer, :pointer, :int ], :int
  attach_function :avcodec_open, :avcodec_open, [ AVCodecContext.ptr, AVCodec.ptr ], :int
  attach_function :avcodec_open2, :avcodec_open2, [ AVCodecContext.ptr, AVCodec.ptr, :pointer ], :int
  attach_function :avcodec_decode_audio3, :avcodec_decode_audio3, [ AVCodecContext.ptr, :pointer, :pointer, AVPacket.ptr ], :int
  attach_function :avcodec_decode_audio4, :avcodec_decode_audio4, [ AVCodecContext.ptr, AVFrame.ptr, :pointer, AVPacket.ptr ], :int
  attach_function :avcodec_decode_video2, :avcodec_decode_video2, [ AVCodecContext.ptr, AVFrame.ptr, :pointer, AVPacket.ptr ], :int, { :blocking => true }
  attach_function :avcodec_decode_subtitle2, :avcodec_decode_subtitle2, [ AVCodecContext.ptr, AVSubtitle.ptr, :pointer, AVPacket.ptr ], :int
  attach_function :avsubtitle_free, :avsubtitle_free, [ AVSubtitle.ptr ], :void
  attach_function :avcodec_encode_audio, :avcodec_encode_audio, [ AVCodecContext.ptr, :pointer, :int, :pointer ], :int
  attach_function :avcodec_encode_audio2, :avcodec_encode_audio2, [ AVCodecContext.ptr, AVPacket.ptr, :pointer, :pointer ], :int
  attach_function :avcodec_fill_audio_frame, :avcodec_fill_audio_frame, [ AVFrame.ptr, :int, :int, :pointer, :int, :int ], :int
  attach_function :avcodec_encode_video, :avcodec_encode_video, [ AVCodecContext.ptr, :pointer, :int, :pointer ], :int
  attach_function :avcodec_encode_subtitle, :avcodec_encode_subtitle, [ AVCodecContext.ptr, :pointer, :int, :pointer ], :int
  attach_function :avcodec_close, :avcodec_close, [ AVCodecContext.ptr ], :int
  attach_function :avcodec_register_all, :avcodec_register_all, [  ], :void
  attach_function :avcodec_flush_buffers, :avcodec_flush_buffers, [ AVCodecContext.ptr ], :void
  attach_function :avcodec_default_free_buffers, :avcodec_default_free_buffers, [ AVCodecContext.ptr ], :void
  attach_function :av_get_pict_type_char, :av_get_pict_type_char, [ :int ], :char
  attach_function :av_get_bits_per_sample, :av_get_bits_per_sample, [ CodecID ], :int
  attach_function :av_get_bits_per_sample_format, :av_get_bits_per_sample_format, [ :int ], :int
  AV_PARSER_PTS_NB = 4
  PARSER_FLAG_COMPLETE_FRAMES = 0x0001
  PARSER_FLAG_ONCE = 0x0002
  PARSER_FLAG_FETCHED_OFFSET = 0x0004
  class AVCodecParserContext < FFI::Struct
    layout(
           :priv_data, :pointer,
           :parser, AVCodecParser.ptr,
           :frame_offset, :int64,
           :cur_offset, :int64,
           :next_frame_offset, :int64,
           :pict_type, :int,
           :repeat_pict, :int,
           :pts, :int64,
           :dts, :int64,
           :last_pts, :int64,
           :last_dts, :int64,
           :fetch_timestamp, :int,
           :cur_frame_start_index, :int,
           :cur_frame_offset, [:int64, 4],
           :cur_frame_pts, [:int64, 4],
           :cur_frame_dts, [:int64, 4],
           :flags, :int,
           :offset, :int64,
           :cur_frame_end, [:int64, 4],
           :key_frame, :int,
           :convergence_duration, :int64,
           :dts_sync_point, :int,
           :dts_ref_dts_delta, :int,
           :pts_dts_delta, :int,
           :cur_frame_pos, [:int64, 4],
           :pos, :int64,
           :last_pos, :int64
    )
  end
  class AVCodecParser < FFI::Struct
    layout(
           :codec_ids, [:int, 5],
           :priv_data_size, :int,
           :parser_init, callback([ AVCodecParserContext.ptr ], :int),
           :parser_parse, callback([ AVCodecParserContext.ptr, AVCodecContext.ptr, :pointer, :pointer, :pointer, :int ], :int),
           :parser_close, callback([ AVCodecParserContext.ptr ], :void),
           :split, callback([ AVCodecContext.ptr, :pointer, :int ], :int),
           :next, AVCodecParser.ptr
    )
    def parser_init=(cb)
      @parser_init = cb
      self[:parser_init] = @parser_init
    end
    def parser_init
      @parser_init
    end
    def parser_parse=(cb)
      @parser_parse = cb
      self[:parser_parse] = @parser_parse
    end
    def parser_parse
      @parser_parse
    end
    def parser_close=(cb)
      @parser_close = cb
      self[:parser_close] = @parser_close
    end
    def parser_close
      @parser_close
    end
    def split=(cb)
      @split = cb
      self[:split] = @split
    end
    def split
      @split
    end

  end
  attach_function :av_parser_next, :av_parser_next, [ AVCodecParser.ptr ], AVCodecParser.ptr
  attach_function :av_register_codec_parser, :av_register_codec_parser, [ AVCodecParser.ptr ], :void
  attach_function :av_parser_init, :av_parser_init, [ :int ], AVCodecParserContext.ptr
  attach_function :av_parser_parse2, :av_parser_parse2, [ AVCodecParserContext.ptr, AVCodecContext.ptr, :pointer, :pointer, :pointer, :int, :int64, :int64, :int64 ], :int
  attach_function :av_parser_change, :av_parser_change, [ AVCodecParserContext.ptr, AVCodecContext.ptr, :pointer, :pointer, :pointer, :int, :int ], :int
  attach_function :av_parser_close, :av_parser_close, [ AVCodecParserContext.ptr ], :void
  class AVBitStreamFilterContext < FFI::Struct
    layout(
           :priv_data, :pointer,
           :filter, AVBitStreamFilter.ptr,
           :parser, AVCodecParserContext.ptr,
           :next, AVBitStreamFilterContext.ptr
    )
  end
  class AVBitStreamFilter < FFI::Struct
    layout(
           :name, :pointer,
           :priv_data_size, :int,
           :filter, callback([ AVBitStreamFilterContext.ptr, AVCodecContext.ptr, :string, :pointer, :pointer, :pointer, :int, :int ], :int),
           :close, callback([ AVBitStreamFilterContext.ptr ], :void),
           :next, AVBitStreamFilter.ptr
    )
    def name=(str)
      @name = FFI::MemoryPointer.from_string(str)
      self[:name] = @name
    end
    def name
      @name.get_string(0)
    end
    def filter=(cb)
      @filter = cb
      self[:filter] = @filter
    end
    def filter
      @filter
    end
    def close=(cb)
      @close = cb
      self[:close] = @close
    end
    def close
      @close
    end

  end
  attach_function :av_register_bitstream_filter, :av_register_bitstream_filter, [ AVBitStreamFilter.ptr ], :void
  attach_function :av_bitstream_filter_init, :av_bitstream_filter_init, [ :string ], AVBitStreamFilterContext.ptr
  attach_function :av_bitstream_filter_filter, :av_bitstream_filter_filter, [ AVBitStreamFilterContext.ptr, AVCodecContext.ptr, :string, :pointer, :pointer, :pointer, :int, :int ], :int
  attach_function :av_bitstream_filter_close, :av_bitstream_filter_close, [ AVBitStreamFilterContext.ptr ], :void
  attach_function :av_bitstream_filter_next, :av_bitstream_filter_next, [ AVBitStreamFilter.ptr ], AVBitStreamFilter.ptr
  attach_function :av_fast_realloc, :av_fast_realloc, [ :pointer, :pointer, :uint ], :pointer
  attach_function :av_fast_malloc, :av_fast_malloc, [ :pointer, :pointer, :uint ], :void
  attach_function :av_picture_copy, :av_picture_copy, [ AVPicture.ptr, :pointer, PixelFormat, :int, :int ], :void
  attach_function :av_picture_crop, :av_picture_crop, [ AVPicture.ptr, :pointer, PixelFormat, :int, :int ], :int
  attach_function :av_picture_pad, :av_picture_pad, [ AVPicture.ptr, :pointer, :int, :int, PixelFormat, :int, :int, :int, :int, :pointer ], :int
  attach_function :av_xiphlacing, :av_xiphlacing, [ :pointer, :uint ], :uint
  attach_function :av_log_missing_feature, :av_log_missing_feature, [ :pointer, :string, :int ], :void
  attach_function :av_log_ask_for_sample, :av_log_ask_for_sample, [ :pointer, :string, :varargs ], :void
  attach_function :av_register_hwaccel, :av_register_hwaccel, [ AVHWAccel.ptr ], :void
  attach_function :av_hwaccel_next, :av_hwaccel_next, [ AVHWAccel.ptr ], AVHWAccel.ptr
  AV_LOCK_CREATE = 0
  AV_LOCK_OBTAIN = AV_LOCK_CREATE + 1
  AV_LOCK_RELEASE = AV_LOCK_OBTAIN + 1
  AV_LOCK_DESTROY = AV_LOCK_RELEASE + 1
  AVLockOp = enum :AVLockOp, [
    :create,
    :obtain,
    :release,
    :destroy,
  ]

  attach_function :av_lockmgr_register, :av_lockmgr_register, [ callback([ :pointer, AVLockOp ], :int) ], :int
  attach_function :avcodec_get_type, :avcodec_get_type, [ CodecID ], AVMediaType
  attach_function :avcodec_get_class, :avcodec_get_class, [  ], :pointer
  attach_function :avcodec_is_open, :avcodec_is_open, [ AVCodecContext.ptr ], :int


  ffi_lib [ "libavformat.so.53", "libavformat.53.dylib" ]

  class AVIOContext < FFI::Struct; end
  class AVFormatContext < FFI::Struct; end
  class AVPacket < FFI::Struct; end
  class AVFormatParameters < FFI::Struct; end
  class AVOutputFormat < FFI::Struct; end
  class AVProbeData < FFI::Struct; end
  class AVInputFormat < FFI::Struct; end
  class AVCodecContext < FFI::Struct; end
  class AVCodecParserContext < FFI::Struct; end
  class AVIndexEntry < FFI::Struct; end
  class AVPacketList < FFI::Struct; end
  class AVStreamInfo < FFI::Struct; end
  class AVStream < FFI::Struct; end
  class AVCodec < FFI::Struct; end
  class AVProgram < FFI::Struct; end
  AVIO_SEEKABLE_NORMAL = 0x0001
  class AVIOInterruptCB < FFI::Struct
    layout(
           :callback, callback([ :pointer ], :int),
           :opaque, :pointer
    )
    def callback=(cb)
      @callback = cb
      self[:callback] = @callback
    end
    def callback
      @callback
    end

  end
  class AVIOContext < FFI::Struct
    layout(
           :buffer, :pointer,
           :buffer_size, :int,
           :buf_ptr, :pointer,
           :buf_end, :pointer,
           :opaque, :pointer,
           :read_packet, callback([ :pointer, :pointer, :int ], :int),
           :write_packet, callback([ :pointer, :pointer, :int ], :int),
           :seek, callback([ :pointer, :int64, :int ], :int64),
           :pos, :int64,
           :must_flush, :int,
           :eof_reached, :int,
           :write_flag, :int,
           :max_packet_size, :int,
           :checksum, :ulong,
           :checksum_ptr, :pointer,
           :update_checksum, callback([ :ulong, :pointer, :uint ], :ulong),
           :error, :int,
           :read_pause, callback([ :pointer, :int ], :int),
           :read_seek, callback([ :pointer, :int, :int64, :int ], :int64),
           :seekable, :int
    )
    def read_packet=(cb)
      @read_packet = cb
      self[:read_packet] = @read_packet
    end
    def read_packet
      @read_packet
    end
    def write_packet=(cb)
      @write_packet = cb
      self[:write_packet] = @write_packet
    end
    def write_packet
      @write_packet
    end
    def seek=(cb)
      @seek = cb
      self[:seek] = @seek
    end
    def seek
      @seek
    end
    def update_checksum=(cb)
      @update_checksum = cb
      self[:update_checksum] = @update_checksum
    end
    def update_checksum
      @update_checksum
    end
    def read_pause=(cb)
      @read_pause = cb
      self[:read_pause] = @read_pause
    end
    def read_pause
      @read_pause
    end
    def read_seek=(cb)
      @read_seek = cb
      self[:read_seek] = @read_seek
    end
    def read_seek
      @read_seek
    end

  end
  attach_function :avio_check, :avio_check, [ :string, :int ], :int
  attach_function :avio_alloc_context, :avio_alloc_context, [ :pointer, :int, :int, :pointer, callback([ :pointer, :pointer, :int ], :int), callback([ :pointer, :pointer, :int ], :int), callback([ :pointer, :int64, :int ], :int64) ], AVIOContext.ptr
  attach_function :avio_w8, :avio_w8, [ AVIOContext.ptr, :int ], :void
  attach_function :avio_write, :avio_write, [ AVIOContext.ptr, :pointer, :int ], :void
  attach_function :avio_wl64, :avio_wl64, [ AVIOContext.ptr, :uint64 ], :void
  attach_function :avio_wb64, :avio_wb64, [ AVIOContext.ptr, :uint64 ], :void
  attach_function :avio_wl32, :avio_wl32, [ AVIOContext.ptr, :uint ], :void
  attach_function :avio_wb32, :avio_wb32, [ AVIOContext.ptr, :uint ], :void
  attach_function :avio_wl24, :avio_wl24, [ AVIOContext.ptr, :uint ], :void
  attach_function :avio_wb24, :avio_wb24, [ AVIOContext.ptr, :uint ], :void
  attach_function :avio_wl16, :avio_wl16, [ AVIOContext.ptr, :uint ], :void
  attach_function :avio_wb16, :avio_wb16, [ AVIOContext.ptr, :uint ], :void
  attach_function :avio_put_str, :avio_put_str, [ AVIOContext.ptr, :string ], :int
  attach_function :avio_put_str16le, :avio_put_str16le, [ AVIOContext.ptr, :string ], :int
  AVSEEK_SIZE = 0x10000
  AVSEEK_FORCE = 0x20000
  attach_function :avio_seek, :avio_seek, [ AVIOContext.ptr, :int64, :int ], :int64
  # inline function avio_skip
  # inline function avio_tell
  attach_function :avio_size, :avio_size, [ AVIOContext.ptr ], :int64
  attach_function :avio_printf, :avio_printf, [ AVIOContext.ptr, :string, :varargs ], :int
  attach_function :avio_flush, :avio_flush, [ AVIOContext.ptr ], :void
  attach_function :avio_read, :avio_read, [ AVIOContext.ptr, :pointer, :int ], :int
  attach_function :avio_r8, :avio_r8, [ AVIOContext.ptr ], :int
  attach_function :avio_rl16, :avio_rl16, [ AVIOContext.ptr ], :uint
  attach_function :avio_rl24, :avio_rl24, [ AVIOContext.ptr ], :uint
  attach_function :avio_rl32, :avio_rl32, [ AVIOContext.ptr ], :uint
  attach_function :avio_rl64, :avio_rl64, [ AVIOContext.ptr ], :uint64
  attach_function :avio_rb16, :avio_rb16, [ AVIOContext.ptr ], :uint
  attach_function :avio_rb24, :avio_rb24, [ AVIOContext.ptr ], :uint
  attach_function :avio_rb32, :avio_rb32, [ AVIOContext.ptr ], :uint
  attach_function :avio_rb64, :avio_rb64, [ AVIOContext.ptr ], :uint64
  attach_function :avio_get_str, :avio_get_str, [ AVIOContext.ptr, :int, :string, :int ], :int
  attach_function :avio_get_str16le, :avio_get_str16le, [ AVIOContext.ptr, :int, :string, :int ], :int
  attach_function :avio_get_str16be, :avio_get_str16be, [ AVIOContext.ptr, :int, :string, :int ], :int
  AVIO_FLAG_READ = 1
  AVIO_FLAG_WRITE = 2
  AVIO_FLAG_READ_WRITE = (1|2)
  AVIO_FLAG_NONBLOCK = 8
  attach_function :avio_open, :avio_open, [ :pointer, :string, :int ], :int
  attach_function :avio_open2, :avio_open2, [ :pointer, :string, :int, :pointer, :pointer ], :int
  attach_function :avio_close, :avio_close, [ AVIOContext.ptr ], :int
  attach_function :avio_open_dyn_buf, :avio_open_dyn_buf, [ :pointer ], :int
  attach_function :avio_close_dyn_buf, :avio_close_dyn_buf, [ AVIOContext.ptr, :pointer ], :int
  attach_function :avio_enum_protocols, :avio_enum_protocols, [ :pointer, :int ], :string
  attach_function :avio_pause, :avio_pause, [ AVIOContext.ptr, :int ], :int
  attach_function :avio_seek_time, :avio_seek_time, [ AVIOContext.ptr, :int, :int64, :int ], :int64
  LIBAVFORMAT_VERSION_MAJOR = 53
  LIBAVFORMAT_VERSION_MINOR = 21
  LIBAVFORMAT_VERSION_MICRO = 1
  LIBAVFORMAT_VERSION_INT = (53 << 16|21 << 8|1)
  LIBAVFORMAT_BUILD = (53 << 16|21 << 8|1)
  LIBAVFORMAT_IDENT = 'Lavf53.21.1'
  attach_function :av_metadata_get, :av_metadata_get, [ :pointer, :string, :pointer, :int ], :pointer
  attach_function :av_metadata_set2, :av_metadata_set2, [ :pointer, :string, :string, :int ], :int
  attach_function :av_metadata_conv, :av_metadata_conv, [ AVFormatContext.ptr, :pointer, :pointer ], :void
  attach_function :av_metadata_copy, :av_metadata_copy, [ :pointer, :pointer, :int ], :void
  attach_function :av_metadata_free, :av_metadata_free, [ :pointer ], :void
  attach_function :av_get_packet, :av_get_packet, [ AVIOContext.ptr, AVPacket.ptr, :int ], :int
  attach_function :av_append_packet, :av_append_packet, [ AVIOContext.ptr, AVPacket.ptr, :int ], :int
  class AVFrac < FFI::Struct
    layout(
           :val, :int64,
           :num, :int64,
           :den, :int64
    )
  end
  class AVProbeData < FFI::Struct
    layout(
           :filename, :pointer,
           :buf, :pointer,
           :buf_size, :int
    )
    def filename=(str)
      @filename = FFI::MemoryPointer.from_string(str)
      self[:filename] = @filename
    end
    def filename
      @filename.get_string(0)
    end

  end
  AVPROBE_SCORE_MAX = 100
  AVPROBE_PADDING_SIZE = 32
  class AVFormatParameters < FFI::Struct
    layout(
           :time_base, AVRational.by_value,
           :sample_rate, :int,
           :channels, :int,
           :width, :int,
           :height, :int,
           :pix_fmt, PixelFormat,
           :channel, :int,
           :standard, :pointer,
           :mpeg2ts_raw, :uint,
           :mpeg2ts_compute_pcr, :uint,
           :initial_pause, :uint,
           :prealloced_context, :uint
    )
    def standard=(str)
      @standard = FFI::MemoryPointer.from_string(str)
      self[:standard] = @standard
    end
    def standard
      @standard.get_string(0)
    end

  end
  AVFMT_NOFILE = 0x0001
  AVFMT_NEEDNUMBER = 0x0002
  AVFMT_SHOW_IDS = 0x0008
  AVFMT_RAWPICTURE = 0x0020
  AVFMT_GLOBALHEADER = 0x0040
  AVFMT_NOTIMESTAMPS = 0x0080
  AVFMT_GENERIC_INDEX = 0x0100
  AVFMT_TS_DISCONT = 0x0200
  AVFMT_VARIABLE_FPS = 0x0400
  AVFMT_NODIMENSIONS = 0x0800
  AVFMT_NOSTREAMS = 0x1000
  AVFMT_NOBINSEARCH = 0x2000
  AVFMT_NOGENSEARCH = 0x4000
  AVFMT_NO_BYTE_SEEK = 0x8000
  class AVOutputFormat < FFI::Struct
    layout(
           :name, :pointer,
           :long_name, :pointer,
           :mime_type, :pointer,
           :extensions, :pointer,
           :priv_data_size, :int,
           :audio_codec, CodecID,
           :video_codec, CodecID,
           :write_header, callback([ AVFormatContext.ptr ], :int),
           :write_packet, callback([ AVFormatContext.ptr, AVPacket.ptr ], :int),
           :write_trailer, callback([ AVFormatContext.ptr ], :int),
           :flags, :int,
           :set_parameters, callback([ AVFormatContext.ptr, AVFormatParameters.ptr ], :int),
           :interleave_packet, callback([ AVFormatContext.ptr, AVPacket.ptr, AVPacket.ptr, :int ], :int),
           :codec_tag, :pointer,
           :subtitle_codec, CodecID,
           :metadata_conv, :pointer,
           :priv_class, :pointer,
           :query_codec, callback([ CodecID, :int ], :int),
           :next, AVOutputFormat.ptr
    )
    def name=(str)
      @name = FFI::MemoryPointer.from_string(str)
      self[:name] = @name
    end
    def name
      @name.get_string(0)
    end
    def long_name=(str)
      @long_name = FFI::MemoryPointer.from_string(str)
      self[:long_name] = @long_name
    end
    def long_name
      @long_name.get_string(0)
    end
    def mime_type=(str)
      @mime_type = FFI::MemoryPointer.from_string(str)
      self[:mime_type] = @mime_type
    end
    def mime_type
      @mime_type.get_string(0)
    end
    def extensions=(str)
      @extensions = FFI::MemoryPointer.from_string(str)
      self[:extensions] = @extensions
    end
    def extensions
      @extensions.get_string(0)
    end
    def write_header=(cb)
      @write_header = cb
      self[:write_header] = @write_header
    end
    def write_header
      @write_header
    end
    def write_packet=(cb)
      @write_packet = cb
      self[:write_packet] = @write_packet
    end
    def write_packet
      @write_packet
    end
    def write_trailer=(cb)
      @write_trailer = cb
      self[:write_trailer] = @write_trailer
    end
    def write_trailer
      @write_trailer
    end
    def set_parameters=(cb)
      @set_parameters = cb
      self[:set_parameters] = @set_parameters
    end
    def set_parameters
      @set_parameters
    end
    def interleave_packet=(cb)
      @interleave_packet = cb
      self[:interleave_packet] = @interleave_packet
    end
    def interleave_packet
      @interleave_packet
    end
    def query_codec=(cb)
      @query_codec = cb
      self[:query_codec] = @query_codec
    end
    def query_codec
      @query_codec
    end

  end
  class AVInputFormat < FFI::Struct
    layout(
           :name, :pointer,
           :long_name, :pointer,
           :priv_data_size, :int,
           :read_probe, callback([ AVProbeData.ptr ], :int),
           :read_header, callback([ AVFormatContext.ptr, AVFormatParameters.ptr ], :int),
           :read_packet, callback([ AVFormatContext.ptr, AVPacket.ptr ], :int),
           :read_close, callback([ AVFormatContext.ptr ], :int),
           :read_seek, callback([ AVFormatContext.ptr, :int, :int64, :int ], :int),
           :read_timestamp, callback([ AVFormatContext.ptr, :int, :pointer, :int64 ], :int64),
           :flags, :int,
           :extensions, :pointer,
           :value, :int,
           :read_play, callback([ AVFormatContext.ptr ], :int),
           :read_pause, callback([ AVFormatContext.ptr ], :int),
           :codec_tag, :pointer,
           :read_seek2, callback([ AVFormatContext.ptr, :int, :int64, :int64, :int64, :int ], :int),
           :metadata_conv, :pointer,
           :priv_class, :pointer,
           :next, AVInputFormat.ptr
    )
    def name=(str)
      @name = FFI::MemoryPointer.from_string(str)
      self[:name] = @name
    end
    def name
      @name.get_string(0)
    end
    def long_name=(str)
      @long_name = FFI::MemoryPointer.from_string(str)
      self[:long_name] = @long_name
    end
    def long_name
      @long_name.get_string(0)
    end
    def read_probe=(cb)
      @read_probe = cb
      self[:read_probe] = @read_probe
    end
    def read_probe
      @read_probe
    end
    def read_header=(cb)
      @read_header = cb
      self[:read_header] = @read_header
    end
    def read_header
      @read_header
    end
    def read_packet=(cb)
      @read_packet = cb
      self[:read_packet] = @read_packet
    end
    def read_packet
      @read_packet
    end
    def read_close=(cb)
      @read_close = cb
      self[:read_close] = @read_close
    end
    def read_close
      @read_close
    end
    def read_seek=(cb)
      @read_seek = cb
      self[:read_seek] = @read_seek
    end
    def read_seek
      @read_seek
    end
    def read_timestamp=(cb)
      @read_timestamp = cb
      self[:read_timestamp] = @read_timestamp
    end
    def read_timestamp
      @read_timestamp
    end
    def extensions=(str)
      @extensions = FFI::MemoryPointer.from_string(str)
      self[:extensions] = @extensions
    end
    def extensions
      @extensions.get_string(0)
    end
    def read_play=(cb)
      @read_play = cb
      self[:read_play] = @read_play
    end
    def read_play
      @read_play
    end
    def read_pause=(cb)
      @read_pause = cb
      self[:read_pause] = @read_pause
    end
    def read_pause
      @read_pause
    end
    def read_seek2=(cb)
      @read_seek2 = cb
      self[:read_seek2] = @read_seek2
    end
    def read_seek2
      @read_seek2
    end

  end
  AVSTREAM_PARSE_NONE = 0
  AVSTREAM_PARSE_FULL = AVSTREAM_PARSE_NONE + 1
  AVSTREAM_PARSE_HEADERS = AVSTREAM_PARSE_FULL + 1
  AVSTREAM_PARSE_TIMESTAMPS = AVSTREAM_PARSE_HEADERS + 1
  AVSTREAM_PARSE_FULL_ONCE = AVSTREAM_PARSE_TIMESTAMPS + 1
  AVStreamParseType = enum :AVStreamParseType, [
    :none,
    :full,
    :headers,
    :timestamps,
    :full_once,
  ]

  AVINDEX_KEYFRAME = 0x0001
  class AVIndexEntry < FFI::Struct
    layout(
           :pos, :int64,
           :timestamp, :int64,
           :flags, :int,
           :size, :int,
           :min_distance, :int
    )
  end
  AV_DISPOSITION_DEFAULT = 0x0001
  AV_DISPOSITION_DUB = 0x0002
  AV_DISPOSITION_ORIGINAL = 0x0004
  AV_DISPOSITION_COMMENT = 0x0008
  AV_DISPOSITION_LYRICS = 0x0010
  AV_DISPOSITION_KARAOKE = 0x0020
  AV_DISPOSITION_FORCED = 0x0040
  AV_DISPOSITION_HEARING_IMPAIRED = 0x0080
  AV_DISPOSITION_VISUAL_IMPAIRED = 0x0100
  AV_DISPOSITION_CLEAN_EFFECTS = 0x0200
  MAX_REORDER_DELAY = 16
  MAX_PROBE_PACKETS = 2500
  MAX_STD_TIMEBASES = (60*12+5)
  class AVStreamInfo < FFI::Struct
    layout(
           :last_dts, :int64,
           :duration_gcd, :int64,
           :duration_count, :int,
           :duration_error, [:double, (60*12+5)],
           :codec_info_duration, :int64,
           :nb_decoded_frames, :int
    )
  end
  class AVStream < FFI::Struct
    layout(
           :index, :int,
           :id, :int,
           :codec, AVCodecContext.ptr,
           :r_frame_rate, AVRational.by_value,
           :priv_data, :pointer,
           :first_dts, :int64,
           :pts, AVFrac.by_value,
           :time_base, AVRational.by_value,
           :pts_wrap_bits, :int,
           :stream_copy, :int,
           :discard, AVDiscard,
           :quality, :float,
           :start_time, :int64,
           :duration, :int64,
           :need_parsing, AVStreamParseType,
           :parser, AVCodecParserContext.ptr,
           :cur_dts, :int64,
           :last_IP_duration, :int,
           :last_IP_pts, :int64,
           :index_entries, AVIndexEntry.ptr,
           :nb_index_entries, :int,
           :index_entries_allocated_size, :uint,
           :nb_frames, :int64,
           :disposition, :int,
           :probe_data, AVProbeData.by_value,
           :pts_buffer, [:int64, 16+1],
           :sample_aspect_ratio, AVRational.by_value,
           :metadata, :pointer,
           :info, AVStreamInfo.ptr,
           :cur_ptr, :pointer,
           :cur_len, :int,
           :cur_pkt, AVPacket.by_value,
           :reference_dts, :int64,
           :probe_packets, :int,
           :last_in_packet_buffer, AVPacketList.ptr,
           :avg_frame_rate, AVRational.by_value,
           :codec_info_nb_frames, :int,
    )
  end
  AV_PROGRAM_RUNNING = 1
  class AVProgram < FFI::Struct
    layout(
           :id, :int,
           :flags, :int,
           :discard, AVDiscard,
           :stream_index, :pointer,
           :nb_stream_indexes, :uint,
           :metadata, :pointer
    )
  end
  AVFMTCTX_NOHEADER = 0x0001
  class AVChapter < FFI::Struct
    layout(
           :id, :int,
           :time_base, AVRational.by_value,
           :start, :int64,
           :end, :int64,
           :metadata, :pointer
    )
  end
  AVFMT_NOOUTPUTLOOP = -1
  AVFMT_INFINITEOUTPUTLOOP = 0
  AVFMT_FLAG_GENPTS = 0x0001
  AVFMT_FLAG_IGNIDX = 0x0002
  AVFMT_FLAG_NONBLOCK = 0x0004
  AVFMT_FLAG_IGNDTS = 0x0008
  AVFMT_FLAG_NOFILLIN = 0x0010
  AVFMT_FLAG_NOPARSE = 0x0020
  AVFMT_FLAG_RTP_HINT = 0x0040
  AVFMT_FLAG_CUSTOM_IO = 0x0080
  AVFMT_FLAG_DISCARD_CORRUPT = 0x0100
  FF_FDEBUG_TS = 0x0001
  RAW_PACKET_BUFFER_SIZE = 2500000
  class AVFormatContext < FFI::Struct
    layout(
           :av_class, :pointer,
           :iformat, AVInputFormat.ptr,
           :oformat, AVOutputFormat.ptr,
           :priv_data, :pointer,
           :pb, AVIOContext.ptr,
           :nb_streams, :uint,
           :streams, :pointer,
           :filename, [:char, 1024],
           :timestamp, :int64,
           :ctx_flags, :int,
           :packet_buffer, AVPacketList.ptr,
           :start_time, :int64,
           :duration, :int64,
           :file_size, :int64,
           :bit_rate, :int,
           :cur_st, AVStream.ptr,
           :data_offset, :int64,
           :mux_rate, :int,
           :packet_size, :uint,
           :preload, :int,
           :max_delay, :int,
           :loop_output, :int,
           :flags, :int,
           :loop_input, :int,
           :probesize, :uint,
           :max_analyze_duration, :int,
           :key, :pointer,
           :keylen, :int,
           :nb_programs, :uint,
           :programs, :pointer,
           :video_codec_id, CodecID,
           :audio_codec_id, CodecID,
           :subtitle_codec_id, CodecID,
           :max_index_size, :uint,
           :max_picture_buffer, :uint,
           :nb_chapters, :uint,
           :chapters, :pointer,
           :debug, :int,
           :raw_packet_buffer, AVPacketList.ptr,
           :raw_packet_buffer_end, AVPacketList.ptr,
           :packet_buffer_end, AVPacketList.ptr,
           :metadata, :pointer,
           :raw_packet_buffer_remaining_size, :int,
           :start_time_realtime, :int64,
           :fps_probe_size, :int,
           :error_recognition, :int,
           :interrupt_callback, AVIOInterruptCB.by_value
    )
  end
  class AVPacketList < FFI::Struct
    layout(
           :pkt, AVPacket.by_value,
           :next, AVPacketList.ptr
    )
  end
  attach_function :avformat_version, :avformat_version, [  ], :uint
  attach_function :avformat_configuration, :avformat_configuration, [  ], :string
  attach_function :avformat_license, :avformat_license, [  ], :string
  attach_function :av_register_all, :av_register_all, [  ], :void
  attach_function :av_register_input_format, :av_register_input_format, [ AVInputFormat.ptr ], :void
  attach_function :av_register_output_format, :av_register_output_format, [ AVOutputFormat.ptr ], :void
  attach_function :avformat_network_init, :avformat_network_init, [  ], :int
  attach_function :avformat_network_deinit, :avformat_network_deinit, [  ], :int
  attach_function :av_iformat_next, :av_iformat_next, [ AVInputFormat.ptr ], AVInputFormat.ptr
  attach_function :av_oformat_next, :av_oformat_next, [ AVOutputFormat.ptr ], AVOutputFormat.ptr
  attach_function :avformat_alloc_context, :avformat_alloc_context, [  ], AVFormatContext.ptr
  attach_function :avformat_free_context, :avformat_free_context, [ AVFormatContext.ptr ], :void
  attach_function :avformat_get_class, :avformat_get_class, [  ], :pointer
  attach_function :avformat_new_stream, :avformat_new_stream, [ AVFormatContext.ptr, AVCodec.ptr ], AVStream.ptr
  attach_function :av_new_program, :av_new_program, [ AVFormatContext.ptr, :int ], AVProgram.ptr
  attach_function :av_guess_image2_codec, :av_guess_image2_codec, [ :string ], CodecID
  attach_function :av_pkt_dump, :av_pkt_dump, [ :pointer, AVPacket.ptr, :int ], :void
  attach_function :av_pkt_dump_log, :av_pkt_dump_log, [ :pointer, :int, AVPacket.ptr, :int ], :void
  attach_function :av_find_input_format, :av_find_input_format, [ :string ], AVInputFormat.ptr
  attach_function :av_probe_input_format, :av_probe_input_format, [ AVProbeData.ptr, :int ], AVInputFormat.ptr
  attach_function :av_probe_input_format2, :av_probe_input_format2, [ AVProbeData.ptr, :int, :pointer ], AVInputFormat.ptr
  attach_function :av_probe_input_buffer, :av_probe_input_buffer, [ AVIOContext.ptr, :pointer, :string, :pointer, :uint, :uint ], :int
  attach_function :av_open_input_stream, :av_open_input_stream, [ :pointer, AVIOContext.ptr, :string, AVInputFormat.ptr, AVFormatParameters.ptr ], :int
  attach_function :av_open_input_file, :av_open_input_file, [ :pointer, :string, AVInputFormat.ptr, :int, AVFormatParameters.ptr ], :int
  attach_function :avformat_open_input, :avformat_open_input, [ :pointer, :string, AVInputFormat.ptr, :pointer ], :int
  attach_function :av_find_stream_info, :av_find_stream_info, [ AVFormatContext.ptr ], :int
  attach_function :avformat_find_stream_info, :avformat_find_stream_info, [ AVFormatContext.ptr, :pointer ], :int
  attach_function :av_find_best_stream, :av_find_best_stream, [ AVFormatContext.ptr, AVMediaType, :int, :int, :pointer, :int ], :int
  attach_function :av_read_packet, :av_read_packet, [ AVFormatContext.ptr, AVPacket.ptr ], :int
  attach_function :av_read_frame, :av_read_frame, [ AVFormatContext.ptr, AVPacket.ptr ], :int
  attach_function :av_seek_frame, :av_seek_frame, [ AVFormatContext.ptr, :int, :int64, :int ], :int
  attach_function :avformat_seek_file, :avformat_seek_file, [ AVFormatContext.ptr, :int, :int64, :int64, :int64, :int ], :int
  attach_function :av_read_play, :av_read_play, [ AVFormatContext.ptr ], :int
  attach_function :av_read_pause, :av_read_pause, [ AVFormatContext.ptr ], :int
  attach_function :av_close_input_stream, :av_close_input_stream, [ AVFormatContext.ptr ], :void
  attach_function :av_close_input_file, :av_close_input_file, [ AVFormatContext.ptr ], :void
  attach_function :avformat_close_input, :avformat_close_input, [ :pointer ], :void
  attach_function :av_new_stream, :av_new_stream, [ AVFormatContext.ptr, :int ], AVStream.ptr
  attach_function :av_set_pts_info, :av_set_pts_info, [ AVStream.ptr, :int, :uint, :uint ], :void
  AVSEEK_FLAG_BACKWARD = 1
  AVSEEK_FLAG_BYTE = 2
  AVSEEK_FLAG_ANY = 4
  AVSEEK_FLAG_FRAME = 8
  attach_function :av_seek_frame_binary, :av_seek_frame_binary, [ AVFormatContext.ptr, :int, :int64, :int ], :int
  attach_function :av_update_cur_dts, :av_update_cur_dts, [ AVFormatContext.ptr, AVStream.ptr, :int64 ], :void
  attach_function :av_gen_search, :av_gen_search, [ AVFormatContext.ptr, :int, :int64, :int64, :int64, :int64, :int64, :int64, :int, :pointer, callback([ AVFormatContext.ptr, :int, :pointer, :int64 ], :int64) ], :int64
  attach_function :av_set_parameters, :av_set_parameters, [ AVFormatContext.ptr, AVFormatParameters.ptr ], :int
  attach_function :avformat_write_header, :avformat_write_header, [ AVFormatContext.ptr, :pointer ], :int
  attach_function :av_write_header, :av_write_header, [ AVFormatContext.ptr ], :int
  attach_function :av_write_frame, :av_write_frame, [ AVFormatContext.ptr, AVPacket.ptr ], :int
  attach_function :av_interleaved_write_frame, :av_interleaved_write_frame, [ AVFormatContext.ptr, AVPacket.ptr ], :int
  attach_function :av_interleave_packet_per_dts, :av_interleave_packet_per_dts, [ AVFormatContext.ptr, AVPacket.ptr, AVPacket.ptr, :int ], :int
  attach_function :av_write_trailer, :av_write_trailer, [ AVFormatContext.ptr ], :int
  attach_function :av_guess_format, :av_guess_format, [ :string, :string, :string ], AVOutputFormat.ptr
  attach_function :av_guess_codec, :av_guess_codec, [ AVOutputFormat.ptr, :string, :string, :string, AVMediaType ], CodecID
  attach_function :av_hex_dump, :av_hex_dump, [ :pointer, :pointer, :int ], :void
  attach_function :av_hex_dump_log, :av_hex_dump_log, [ :pointer, :int, :pointer, :int ], :void
  attach_function :av_pkt_dump2, :av_pkt_dump2, [ :pointer, AVPacket.ptr, :int, AVStream.ptr ], :void
  attach_function :av_pkt_dump_log2, :av_pkt_dump_log2, [ :pointer, :int, AVPacket.ptr, :int, AVStream.ptr ], :void
  attach_function :av_codec_get_id, :av_codec_get_id, [ :pointer, :uint ], :pointer
  attach_function :av_codec_get_tag, :av_codec_get_tag, [ :pointer, CodecID ], :pointer
  attach_function :av_find_default_stream_index, :av_find_default_stream_index, [ AVFormatContext.ptr ], :int
  attach_function :av_index_search_timestamp, :av_index_search_timestamp, [ AVStream.ptr, :int64, :int ], :int
  attach_function :av_add_index_entry, :av_add_index_entry, [ AVStream.ptr, :int64, :int64, :int, :int, :int ], :int
  attach_function :av_url_split, :av_url_split, [ :string, :int, :string, :int, :string, :int, :pointer, :string, :int, :string ], :void
  attach_function :dump_format, :dump_format, [ AVFormatContext.ptr, :int, :string, :int ], :void
  attach_function :av_dump_format, :av_dump_format, [ AVFormatContext.ptr, :int, :string, :int ], :void
  attach_function :parse_date, :parse_date, [ :string, :int ], :int64
  attach_function :av_gettime, :av_gettime, [  ], :int64
  attach_function :find_info_tag, :find_info_tag, [ :string, :int, :string, :string ], :int
  attach_function :av_get_frame_filename, :av_get_frame_filename, [ :string, :int, :string, :int ], :int
  attach_function :av_filename_number_test, :av_filename_number_test, [ :string ], :int
  attach_function :av_sdp_create, :av_sdp_create, [ :pointer, :int, :string, :int ], :pointer
  attach_function :avf_sdp_create, :avf_sdp_create, [ :pointer, :int, :string, :int ], :pointer
  attach_function :av_match_ext, :av_match_ext, [ :string, :string ], :int
  attach_function :avformat_query_codec, :avformat_query_codec, [ AVOutputFormat.ptr, CodecID, :int ], :int
  attach_function :avformat_get_riff_video_tags, :avformat_get_riff_video_tags, [  ], :pointer
  attach_function :avformat_get_riff_audio_tags, :avformat_get_riff_audio_tags, [  ], :pointer


  ffi_lib [ "libswscale.so.2", "libswscale.2.dylib" ]

  class SwsVector < FFI::Struct; end
  class SwsFilter < FFI::Struct; end
  LIBSWSCALE_VERSION_MAJOR = 2
  LIBSWSCALE_VERSION_MINOR = 1
  LIBSWSCALE_VERSION_MICRO = 0
  LIBSWSCALE_VERSION_INT = (2 << 16|1 << 8|0)
  LIBSWSCALE_BUILD = (2 << 16|1 << 8|0)
  LIBSWSCALE_IDENT = 'SwS2.1.0'
  attach_function :swscale_version, :swscale_version, [  ], :uint
  attach_function :swscale_configuration, :swscale_configuration, [  ], :string
  attach_function :swscale_license, :swscale_license, [  ], :string
  SWS_FAST_BILINEAR = 1
  SWS_BILINEAR = 2
  SWS_BICUBIC = 4
  SWS_X = 8
  SWS_POINT = 0x10
  SWS_AREA = 0x20
  SWS_BICUBLIN = 0x40
  SWS_GAUSS = 0x80
  SWS_SINC = 0x100
  SWS_LANCZOS = 0x200
  SWS_SPLINE = 0x400
  SWS_SRC_V_CHR_DROP_MASK = 0x30000
  SWS_SRC_V_CHR_DROP_SHIFT = 16
  SWS_PARAM_DEFAULT = 123456
  SWS_PRINT_INFO = 0x1000
  SWS_FULL_CHR_H_INT = 0x2000
  SWS_FULL_CHR_H_INP = 0x4000
  SWS_DIRECT_BGR = 0x8000
  SWS_ACCURATE_RND = 0x40000
  SWS_BITEXACT = 0x80000
  SWS_CPU_CAPS_MMX = 0x80000000
  SWS_CPU_CAPS_MMX2 = 0x20000000
  SWS_CPU_CAPS_3DNOW = 0x40000000
  SWS_CPU_CAPS_ALTIVEC = 0x10000000
  SWS_CPU_CAPS_BFIN = 0x01000000
  SWS_CPU_CAPS_SSE2 = 0x02000000
  SWS_MAX_REDUCE_CUTOFF = 0.002
  SWS_CS_ITU709 = 1
  SWS_CS_FCC = 4
  SWS_CS_ITU601 = 5
  SWS_CS_ITU624 = 5
  SWS_CS_SMPTE170M = 5
  SWS_CS_SMPTE240M = 7
  SWS_CS_DEFAULT = 5
  attach_function :sws_getCoefficients, :sws_getCoefficients, [ :int ], :pointer
  class SwsVector < FFI::Struct
    layout(
           :coeff, :pointer,
           :length, :int
    )
  end
  class SwsFilter < FFI::Struct
    layout(
           :lumH, SwsVector.ptr,
           :lumV, SwsVector.ptr,
           :chrH, SwsVector.ptr,
           :chrV, SwsVector.ptr
    )
  end
  attach_function :sws_isSupportedInput, :sws_isSupportedInput, [ PixelFormat ], :int
  attach_function :sws_isSupportedOutput, :sws_isSupportedOutput, [ PixelFormat ], :int
  attach_function :sws_alloc_context, :sws_alloc_context, [  ], :pointer
  attach_function :sws_init_context, :sws_init_context, [ :pointer, SwsFilter.ptr, SwsFilter.ptr ], :int
  attach_function :sws_freeContext, :sws_freeContext, [ :pointer ], :void
  attach_function :sws_getContext, :sws_getContext, [ :int, :int, PixelFormat, :int, :int, PixelFormat, :int, SwsFilter.ptr, SwsFilter.ptr, :pointer ], :pointer
  attach_function :sws_scale, :sws_scale, [ :pointer, :pointer, :pointer, :int, :int, :pointer, :pointer ], :pointer
  attach_function :sws_setColorspaceDetails, :sws_setColorspaceDetails, [ :pointer, :pointer, :int, :pointer, :int, :int, :int, :int ], :int
  attach_function :sws_getColorspaceDetails, :sws_getColorspaceDetails, [ :pointer, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer ], :int
  attach_function :sws_allocVec, :sws_allocVec, [ :int ], SwsVector.ptr
  attach_function :sws_getGaussianVec, :sws_getGaussianVec, [ :double, :double ], SwsVector.ptr
  attach_function :sws_getConstVec, :sws_getConstVec, [ :double, :int ], SwsVector.ptr
  attach_function :sws_getIdentityVec, :sws_getIdentityVec, [  ], SwsVector.ptr
  attach_function :sws_scaleVec, :sws_scaleVec, [ SwsVector.ptr, :double ], :void
  attach_function :sws_normalizeVec, :sws_normalizeVec, [ SwsVector.ptr, :double ], :void
  attach_function :sws_convVec, :sws_convVec, [ SwsVector.ptr, SwsVector.ptr ], :void
  attach_function :sws_addVec, :sws_addVec, [ SwsVector.ptr, SwsVector.ptr ], :void
  attach_function :sws_subVec, :sws_subVec, [ SwsVector.ptr, SwsVector.ptr ], :void
  attach_function :sws_shiftVec, :sws_shiftVec, [ SwsVector.ptr, :int ], :void
  attach_function :sws_cloneVec, :sws_cloneVec, [ SwsVector.ptr ], SwsVector.ptr
  attach_function :sws_printVec2, :sws_printVec2, [ SwsVector.ptr, :pointer, :int ], :void
  attach_function :sws_freeVec, :sws_freeVec, [ SwsVector.ptr ], :void
  attach_function :sws_getDefaultFilter, :sws_getDefaultFilter, [ :float, :float, :float, :float, :float, :float, :int ], SwsFilter.ptr
  attach_function :sws_freeFilter, :sws_freeFilter, [ SwsFilter.ptr ], :void
  attach_function :sws_getCachedContext, :sws_getCachedContext, [ :pointer, :int, :int, PixelFormat, :int, :int, PixelFormat, :int, SwsFilter.ptr, SwsFilter.ptr, :pointer ], :pointer
  attach_function :sws_convertPalette8ToPacked32, :sws_convertPalette8ToPacked32, [ :pointer, :pointer, :int, :pointer ], :void
  attach_function :sws_convertPalette8ToPacked24, :sws_convertPalette8ToPacked24, [ :pointer, :pointer, :int, :pointer ], :void
  attach_function :sws_get_class, :sws_get_class, [  ], :pointer

end
