
require 'ffi'

module FFI::Libav
  extend FFI::Library

  ffi_lib [ "libavutil.so.52", "libavutil.52.dylib" ]

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

  attach_function :av_get_picture_type_char, :av_get_picture_type_char, [ :int ], :char
  AV_PIX_FMT_NONE = -1
  AV_PIX_FMT_YUV420P = AV_PIX_FMT_NONE + 1
  AV_PIX_FMT_YUYV422 = AV_PIX_FMT_YUV420P + 1
  AV_PIX_FMT_RGB24 = AV_PIX_FMT_YUYV422 + 1
  AV_PIX_FMT_BGR24 = AV_PIX_FMT_RGB24 + 1
  AV_PIX_FMT_YUV422P = AV_PIX_FMT_BGR24 + 1
  AV_PIX_FMT_YUV444P = AV_PIX_FMT_YUV422P + 1
  AV_PIX_FMT_YUV410P = AV_PIX_FMT_YUV444P + 1
  AV_PIX_FMT_YUV411P = AV_PIX_FMT_YUV410P + 1
  AV_PIX_FMT_GRAY8 = AV_PIX_FMT_YUV411P + 1
  AV_PIX_FMT_MONOWHITE = AV_PIX_FMT_GRAY8 + 1
  AV_PIX_FMT_MONOBLACK = AV_PIX_FMT_MONOWHITE + 1
  AV_PIX_FMT_PAL8 = AV_PIX_FMT_MONOBLACK + 1
  AV_PIX_FMT_YUVJ420P = AV_PIX_FMT_PAL8 + 1
  AV_PIX_FMT_YUVJ422P = AV_PIX_FMT_YUVJ420P + 1
  AV_PIX_FMT_YUVJ444P = AV_PIX_FMT_YUVJ422P + 1
  AV_PIX_FMT_XVMC_MPEG2_MC = AV_PIX_FMT_YUVJ444P + 1
  AV_PIX_FMT_XVMC_MPEG2_IDCT = AV_PIX_FMT_XVMC_MPEG2_MC + 1
  AV_PIX_FMT_UYVY422 = AV_PIX_FMT_XVMC_MPEG2_IDCT + 1
  AV_PIX_FMT_UYYVYY411 = AV_PIX_FMT_UYVY422 + 1
  AV_PIX_FMT_BGR8 = AV_PIX_FMT_UYYVYY411 + 1
  AV_PIX_FMT_BGR4 = AV_PIX_FMT_BGR8 + 1
  AV_PIX_FMT_BGR4_BYTE = AV_PIX_FMT_BGR4 + 1
  AV_PIX_FMT_RGB8 = AV_PIX_FMT_BGR4_BYTE + 1
  AV_PIX_FMT_RGB4 = AV_PIX_FMT_RGB8 + 1
  AV_PIX_FMT_RGB4_BYTE = AV_PIX_FMT_RGB4 + 1
  AV_PIX_FMT_NV12 = AV_PIX_FMT_RGB4_BYTE + 1
  AV_PIX_FMT_NV21 = AV_PIX_FMT_NV12 + 1
  AV_PIX_FMT_ARGB = AV_PIX_FMT_NV21 + 1
  AV_PIX_FMT_RGBA = AV_PIX_FMT_ARGB + 1
  AV_PIX_FMT_ABGR = AV_PIX_FMT_RGBA + 1
  AV_PIX_FMT_BGRA = AV_PIX_FMT_ABGR + 1
  AV_PIX_FMT_GRAY16BE = AV_PIX_FMT_BGRA + 1
  AV_PIX_FMT_GRAY16LE = AV_PIX_FMT_GRAY16BE + 1
  AV_PIX_FMT_YUV440P = AV_PIX_FMT_GRAY16LE + 1
  AV_PIX_FMT_YUVJ440P = AV_PIX_FMT_YUV440P + 1
  AV_PIX_FMT_YUVA420P = AV_PIX_FMT_YUVJ440P + 1
  AV_PIX_FMT_VDPAU_H264 = AV_PIX_FMT_YUVA420P + 1
  AV_PIX_FMT_VDPAU_MPEG1 = AV_PIX_FMT_VDPAU_H264 + 1
  AV_PIX_FMT_VDPAU_MPEG2 = AV_PIX_FMT_VDPAU_MPEG1 + 1
  AV_PIX_FMT_VDPAU_WMV3 = AV_PIX_FMT_VDPAU_MPEG2 + 1
  AV_PIX_FMT_VDPAU_VC1 = AV_PIX_FMT_VDPAU_WMV3 + 1
  AV_PIX_FMT_RGB48BE = AV_PIX_FMT_VDPAU_VC1 + 1
  AV_PIX_FMT_RGB48LE = AV_PIX_FMT_RGB48BE + 1
  AV_PIX_FMT_RGB565BE = AV_PIX_FMT_RGB48LE + 1
  AV_PIX_FMT_RGB565LE = AV_PIX_FMT_RGB565BE + 1
  AV_PIX_FMT_RGB555BE = AV_PIX_FMT_RGB565LE + 1
  AV_PIX_FMT_RGB555LE = AV_PIX_FMT_RGB555BE + 1
  AV_PIX_FMT_BGR565BE = AV_PIX_FMT_RGB555LE + 1
  AV_PIX_FMT_BGR565LE = AV_PIX_FMT_BGR565BE + 1
  AV_PIX_FMT_BGR555BE = AV_PIX_FMT_BGR565LE + 1
  AV_PIX_FMT_BGR555LE = AV_PIX_FMT_BGR555BE + 1
  AV_PIX_FMT_VAAPI_MOCO = AV_PIX_FMT_BGR555LE + 1
  AV_PIX_FMT_VAAPI_IDCT = AV_PIX_FMT_VAAPI_MOCO + 1
  AV_PIX_FMT_VAAPI_VLD = AV_PIX_FMT_VAAPI_IDCT + 1
  AV_PIX_FMT_YUV420P16LE = AV_PIX_FMT_VAAPI_VLD + 1
  AV_PIX_FMT_YUV420P16BE = AV_PIX_FMT_YUV420P16LE + 1
  AV_PIX_FMT_YUV422P16LE = AV_PIX_FMT_YUV420P16BE + 1
  AV_PIX_FMT_YUV422P16BE = AV_PIX_FMT_YUV422P16LE + 1
  AV_PIX_FMT_YUV444P16LE = AV_PIX_FMT_YUV422P16BE + 1
  AV_PIX_FMT_YUV444P16BE = AV_PIX_FMT_YUV444P16LE + 1
  AV_PIX_FMT_VDPAU_MPEG4 = AV_PIX_FMT_YUV444P16BE + 1
  AV_PIX_FMT_DXVA2_VLD = AV_PIX_FMT_VDPAU_MPEG4 + 1
  AV_PIX_FMT_RGB444LE = AV_PIX_FMT_DXVA2_VLD + 1
  AV_PIX_FMT_RGB444BE = AV_PIX_FMT_RGB444LE + 1
  AV_PIX_FMT_BGR444LE = AV_PIX_FMT_RGB444BE + 1
  AV_PIX_FMT_BGR444BE = AV_PIX_FMT_BGR444LE + 1
  AV_PIX_FMT_Y400A = AV_PIX_FMT_BGR444BE + 1
  AV_PIX_FMT_BGR48BE = AV_PIX_FMT_Y400A + 1
  AV_PIX_FMT_BGR48LE = AV_PIX_FMT_BGR48BE + 1
  AV_PIX_FMT_YUV420P9BE = AV_PIX_FMT_BGR48LE + 1
  AV_PIX_FMT_YUV420P9LE = AV_PIX_FMT_YUV420P9BE + 1
  AV_PIX_FMT_YUV420P10BE = AV_PIX_FMT_YUV420P9LE + 1
  AV_PIX_FMT_YUV420P10LE = AV_PIX_FMT_YUV420P10BE + 1
  AV_PIX_FMT_YUV422P10BE = AV_PIX_FMT_YUV420P10LE + 1
  AV_PIX_FMT_YUV422P10LE = AV_PIX_FMT_YUV422P10BE + 1
  AV_PIX_FMT_YUV444P9BE = AV_PIX_FMT_YUV422P10LE + 1
  AV_PIX_FMT_YUV444P9LE = AV_PIX_FMT_YUV444P9BE + 1
  AV_PIX_FMT_YUV444P10BE = AV_PIX_FMT_YUV444P9LE + 1
  AV_PIX_FMT_YUV444P10LE = AV_PIX_FMT_YUV444P10BE + 1
  AV_PIX_FMT_YUV422P9BE = AV_PIX_FMT_YUV444P10LE + 1
  AV_PIX_FMT_YUV422P9LE = AV_PIX_FMT_YUV422P9BE + 1
  AV_PIX_FMT_VDA_VLD = AV_PIX_FMT_YUV422P9LE + 1
  AV_PIX_FMT_GBRP = AV_PIX_FMT_VDA_VLD + 1
  AV_PIX_FMT_GBRP9BE = AV_PIX_FMT_GBRP + 1
  AV_PIX_FMT_GBRP9LE = AV_PIX_FMT_GBRP9BE + 1
  AV_PIX_FMT_GBRP10BE = AV_PIX_FMT_GBRP9LE + 1
  AV_PIX_FMT_GBRP10LE = AV_PIX_FMT_GBRP10BE + 1
  AV_PIX_FMT_GBRP16BE = AV_PIX_FMT_GBRP10LE + 1
  AV_PIX_FMT_GBRP16LE = AV_PIX_FMT_GBRP16BE + 1
  AV_PIX_FMT_YUVA422P = AV_PIX_FMT_GBRP16LE + 1
  AV_PIX_FMT_YUVA444P = AV_PIX_FMT_YUVA422P + 1
  AV_PIX_FMT_YUVA420P9BE = AV_PIX_FMT_YUVA444P + 1
  AV_PIX_FMT_YUVA420P9LE = AV_PIX_FMT_YUVA420P9BE + 1
  AV_PIX_FMT_YUVA422P9BE = AV_PIX_FMT_YUVA420P9LE + 1
  AV_PIX_FMT_YUVA422P9LE = AV_PIX_FMT_YUVA422P9BE + 1
  AV_PIX_FMT_YUVA444P9BE = AV_PIX_FMT_YUVA422P9LE + 1
  AV_PIX_FMT_YUVA444P9LE = AV_PIX_FMT_YUVA444P9BE + 1
  AV_PIX_FMT_YUVA420P10BE = AV_PIX_FMT_YUVA444P9LE + 1
  AV_PIX_FMT_YUVA420P10LE = AV_PIX_FMT_YUVA420P10BE + 1
  AV_PIX_FMT_YUVA422P10BE = AV_PIX_FMT_YUVA420P10LE + 1
  AV_PIX_FMT_YUVA422P10LE = AV_PIX_FMT_YUVA422P10BE + 1
  AV_PIX_FMT_YUVA444P10BE = AV_PIX_FMT_YUVA422P10LE + 1
  AV_PIX_FMT_YUVA444P10LE = AV_PIX_FMT_YUVA444P10BE + 1
  AV_PIX_FMT_YUVA420P16BE = AV_PIX_FMT_YUVA444P10LE + 1
  AV_PIX_FMT_YUVA420P16LE = AV_PIX_FMT_YUVA420P16BE + 1
  AV_PIX_FMT_YUVA422P16BE = AV_PIX_FMT_YUVA420P16LE + 1
  AV_PIX_FMT_YUVA422P16LE = AV_PIX_FMT_YUVA422P16BE + 1
  AV_PIX_FMT_YUVA444P16BE = AV_PIX_FMT_YUVA422P16LE + 1
  AV_PIX_FMT_YUVA444P16LE = AV_PIX_FMT_YUVA444P16BE + 1
  AV_PIX_FMT_NB = AV_PIX_FMT_YUVA444P16LE + 1
  AVPixelFormat = enum :AVPixelFormat, [
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
    :yuva422p,
    :yuva444p,
    :yuva420p9be,
    :yuva420p9le,
    :yuva422p9be,
    :yuva422p9le,
    :yuva444p9be,
    :yuva444p9le,
    :yuva420p10be,
    :yuva420p10le,
    :yuva422p10be,
    :yuva422p10le,
    :yuva444p10be,
    :yuva444p10le,
    :yuva420p16be,
    :yuva420p16le,
    :yuva422p16be,
    :yuva422p16le,
    :yuva444p16be,
    :yuva444p16le,
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
  # inline function av_cmp_q
  # inline function av_q2d
  attach_function :av_reduce, :av_reduce, [ :pointer, :pointer, :int64, :int64, :int64 ], :int
  attach_function :av_mul_q, :av_mul_q, [ AVRational.by_value, AVRational.by_value ], AVRational.by_value
  attach_function :av_div_q, :av_div_q, [ AVRational.by_value, AVRational.by_value ], AVRational.by_value
  attach_function :av_add_q, :av_add_q, [ AVRational.by_value, AVRational.by_value ], AVRational.by_value
  attach_function :av_sub_q, :av_sub_q, [ AVRational.by_value, AVRational.by_value ], AVRational.by_value
  # inline function av_inv_q
  attach_function :av_d2q, :av_d2q, [ :double, :int ], AVRational.by_value
  attach_function :av_nearer_q, :av_nearer_q, [ AVRational.by_value, AVRational.by_value, AVRational.by_value ], :int
  attach_function :av_find_nearest_q_idx, :av_find_nearest_q_idx, [ AVRational.by_value, :pointer ], :int
  attach_function :av_malloc, :av_malloc, [ :uint ], :pointer
  # inline function av_malloc_array
  attach_function :av_realloc, :av_realloc, [ :pointer, :uint ], :pointer
  attach_function :av_free, :av_free, [ :pointer ], :void
  attach_function :av_mallocz, :av_mallocz, [ :uint ], :pointer
  # inline function av_mallocz_array
  attach_function :av_strdup, :av_strdup, [ :string ], :string
  attach_function :av_freep, :av_freep, [ :pointer ], :void
  attach_function :av_memcpy_backptr, :av_memcpy_backptr, [ :pointer, :int, :int ], :void
  M_LOG2_10 = 3.32192809488736234787
  M_PHI = 1.61803398874989484820
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
  attach_function :av_rescale_rnd, :av_rescale_rnd, [ :int64, :int64, :int64, :int ], :int64
  attach_function :av_rescale_q, :av_rescale_q, [ :int64, AVRational.by_value, AVRational.by_value ], :int64
  attach_function :av_rescale_q_rnd, :av_rescale_q_rnd, [ :int64, AVRational.by_value, AVRational.by_value, :int ], :int64
  attach_function :av_compare_ts, :av_compare_ts, [ :int64, AVRational.by_value, :int64, AVRational.by_value ], :int
  attach_function :av_compare_mod, :av_compare_mod, [ :uint64, :uint64, :uint64 ], :int64

  AV_LOG_QUIET = -8
  AV_LOG_PANIC = 0
  AV_LOG_FATAL = 8
  AV_LOG_ERROR = 16
  AV_LOG_WARNING = 24
  AV_LOG_INFO = 32
  AV_LOG_VERBOSE = 40
  AV_LOG_DEBUG = 48
  AVLogLevel = enum :AVLogLevel, [
    :quiet, -8,
    :panic, 0,
    :fatal, 8,
    :error, 16,
    :warning, 24,
    :info, 32,
    :debug, 48,
  ]
  attach_function :av_log, :av_log, [ :pointer, :int, :string, :varargs ], :void
  attach_function :av_log_get_level, :av_log_get_level, [  ], :AVLogLevel
  attach_function :av_log_set_level, :av_log_set_level, [ :AVLogLevel ], :void
  attach_function :av_default_item_name, :av_default_item_name, [ :pointer ], :string
  AV_LOG_SKIP_REPEATED = 1
  attach_function :av_log_set_flags, :av_log_set_flags, [ :int ], :void

  ffi_lib [ "libavcodec.so.54", "libavcodec.54.dylib" ]

  class AVPacket < FFI::Struct; end
  class AVPacketSideData < FFI::Struct; end
  class AVPanScan < FFI::Struct; end
  class AVCodecContext < FFI::Struct; end
  class AVFrame < FFI::Struct; end
  class RcOverride < FFI::Struct; end
  class AVHWAccel < FFI::Struct; end
  class AVCodec < FFI::Struct; end
  class AVSubtitle < FFI::Struct; end
  class AVCodecParser < FFI::Struct; end
  class AVCodecParserContext < FFI::Struct; end
  class AVPicture < FFI::Struct; end
  class AVBitStreamFilter < FFI::Struct; end
  class AVBitStreamFilterContext < FFI::Struct; end
  LIBAVCODEC_VERSION_MAJOR = 54
  LIBAVCODEC_VERSION_MINOR = 35
  LIBAVCODEC_VERSION_MICRO = 0
  LIBAVCODEC_VERSION_INT = (54 << 16|35 << 8|0)
  LIBAVCODEC_BUILD = (54 << 16|35 << 8|0)
  LIBAVCODEC_IDENT = 'Lavc54.35.0'
  AV_CODEC_ID_NONE = 0
  AV_CODEC_ID_MPEG1VIDEO = AV_CODEC_ID_NONE + 1
  AV_CODEC_ID_MPEG2VIDEO = AV_CODEC_ID_MPEG1VIDEO + 1
  AV_CODEC_ID_MPEG2VIDEO_XVMC = AV_CODEC_ID_MPEG2VIDEO + 1
  AV_CODEC_ID_H261 = AV_CODEC_ID_MPEG2VIDEO_XVMC + 1
  AV_CODEC_ID_H263 = AV_CODEC_ID_H261 + 1
  AV_CODEC_ID_RV10 = AV_CODEC_ID_H263 + 1
  AV_CODEC_ID_RV20 = AV_CODEC_ID_RV10 + 1
  AV_CODEC_ID_MJPEG = AV_CODEC_ID_RV20 + 1
  AV_CODEC_ID_MJPEGB = AV_CODEC_ID_MJPEG + 1
  AV_CODEC_ID_LJPEG = AV_CODEC_ID_MJPEGB + 1
  AV_CODEC_ID_SP5X = AV_CODEC_ID_LJPEG + 1
  AV_CODEC_ID_JPEGLS = AV_CODEC_ID_SP5X + 1
  AV_CODEC_ID_MPEG4 = AV_CODEC_ID_JPEGLS + 1
  AV_CODEC_ID_RAWVIDEO = AV_CODEC_ID_MPEG4 + 1
  AV_CODEC_ID_MSMPEG4V1 = AV_CODEC_ID_RAWVIDEO + 1
  AV_CODEC_ID_MSMPEG4V2 = AV_CODEC_ID_MSMPEG4V1 + 1
  AV_CODEC_ID_MSMPEG4V3 = AV_CODEC_ID_MSMPEG4V2 + 1
  AV_CODEC_ID_WMV1 = AV_CODEC_ID_MSMPEG4V3 + 1
  AV_CODEC_ID_WMV2 = AV_CODEC_ID_WMV1 + 1
  AV_CODEC_ID_H263P = AV_CODEC_ID_WMV2 + 1
  AV_CODEC_ID_H263I = AV_CODEC_ID_H263P + 1
  AV_CODEC_ID_FLV1 = AV_CODEC_ID_H263I + 1
  AV_CODEC_ID_SVQ1 = AV_CODEC_ID_FLV1 + 1
  AV_CODEC_ID_SVQ3 = AV_CODEC_ID_SVQ1 + 1
  AV_CODEC_ID_DVVIDEO = AV_CODEC_ID_SVQ3 + 1
  AV_CODEC_ID_HUFFYUV = AV_CODEC_ID_DVVIDEO + 1
  AV_CODEC_ID_CYUV = AV_CODEC_ID_HUFFYUV + 1
  AV_CODEC_ID_H264 = AV_CODEC_ID_CYUV + 1
  AV_CODEC_ID_INDEO3 = AV_CODEC_ID_H264 + 1
  AV_CODEC_ID_VP3 = AV_CODEC_ID_INDEO3 + 1
  AV_CODEC_ID_THEORA = AV_CODEC_ID_VP3 + 1
  AV_CODEC_ID_ASV1 = AV_CODEC_ID_THEORA + 1
  AV_CODEC_ID_ASV2 = AV_CODEC_ID_ASV1 + 1
  AV_CODEC_ID_FFV1 = AV_CODEC_ID_ASV2 + 1
  AV_CODEC_ID_4XM = AV_CODEC_ID_FFV1 + 1
  AV_CODEC_ID_VCR1 = AV_CODEC_ID_4XM + 1
  AV_CODEC_ID_CLJR = AV_CODEC_ID_VCR1 + 1
  AV_CODEC_ID_MDEC = AV_CODEC_ID_CLJR + 1
  AV_CODEC_ID_ROQ = AV_CODEC_ID_MDEC + 1
  AV_CODEC_ID_INTERPLAY_VIDEO = AV_CODEC_ID_ROQ + 1
  AV_CODEC_ID_XAN_WC3 = AV_CODEC_ID_INTERPLAY_VIDEO + 1
  AV_CODEC_ID_XAN_WC4 = AV_CODEC_ID_XAN_WC3 + 1
  AV_CODEC_ID_RPZA = AV_CODEC_ID_XAN_WC4 + 1
  AV_CODEC_ID_CINEPAK = AV_CODEC_ID_RPZA + 1
  AV_CODEC_ID_WS_VQA = AV_CODEC_ID_CINEPAK + 1
  AV_CODEC_ID_MSRLE = AV_CODEC_ID_WS_VQA + 1
  AV_CODEC_ID_MSVIDEO1 = AV_CODEC_ID_MSRLE + 1
  AV_CODEC_ID_IDCIN = AV_CODEC_ID_MSVIDEO1 + 1
  AV_CODEC_ID_8BPS = AV_CODEC_ID_IDCIN + 1
  AV_CODEC_ID_SMC = AV_CODEC_ID_8BPS + 1
  AV_CODEC_ID_FLIC = AV_CODEC_ID_SMC + 1
  AV_CODEC_ID_TRUEMOTION1 = AV_CODEC_ID_FLIC + 1
  AV_CODEC_ID_VMDVIDEO = AV_CODEC_ID_TRUEMOTION1 + 1
  AV_CODEC_ID_MSZH = AV_CODEC_ID_VMDVIDEO + 1
  AV_CODEC_ID_ZLIB = AV_CODEC_ID_MSZH + 1
  AV_CODEC_ID_QTRLE = AV_CODEC_ID_ZLIB + 1
  AV_CODEC_ID_SNOW = AV_CODEC_ID_QTRLE + 1
  AV_CODEC_ID_TSCC = AV_CODEC_ID_SNOW + 1
  AV_CODEC_ID_ULTI = AV_CODEC_ID_TSCC + 1
  AV_CODEC_ID_QDRAW = AV_CODEC_ID_ULTI + 1
  AV_CODEC_ID_VIXL = AV_CODEC_ID_QDRAW + 1
  AV_CODEC_ID_QPEG = AV_CODEC_ID_VIXL + 1
  AV_CODEC_ID_PNG = AV_CODEC_ID_QPEG + 1
  AV_CODEC_ID_PPM = AV_CODEC_ID_PNG + 1
  AV_CODEC_ID_PBM = AV_CODEC_ID_PPM + 1
  AV_CODEC_ID_PGM = AV_CODEC_ID_PBM + 1
  AV_CODEC_ID_PGMYUV = AV_CODEC_ID_PGM + 1
  AV_CODEC_ID_PAM = AV_CODEC_ID_PGMYUV + 1
  AV_CODEC_ID_FFVHUFF = AV_CODEC_ID_PAM + 1
  AV_CODEC_ID_RV30 = AV_CODEC_ID_FFVHUFF + 1
  AV_CODEC_ID_RV40 = AV_CODEC_ID_RV30 + 1
  AV_CODEC_ID_VC1 = AV_CODEC_ID_RV40 + 1
  AV_CODEC_ID_WMV3 = AV_CODEC_ID_VC1 + 1
  AV_CODEC_ID_LOCO = AV_CODEC_ID_WMV3 + 1
  AV_CODEC_ID_WNV1 = AV_CODEC_ID_LOCO + 1
  AV_CODEC_ID_AASC = AV_CODEC_ID_WNV1 + 1
  AV_CODEC_ID_INDEO2 = AV_CODEC_ID_AASC + 1
  AV_CODEC_ID_FRAPS = AV_CODEC_ID_INDEO2 + 1
  AV_CODEC_ID_TRUEMOTION2 = AV_CODEC_ID_FRAPS + 1
  AV_CODEC_ID_BMP = AV_CODEC_ID_TRUEMOTION2 + 1
  AV_CODEC_ID_CSCD = AV_CODEC_ID_BMP + 1
  AV_CODEC_ID_MMVIDEO = AV_CODEC_ID_CSCD + 1
  AV_CODEC_ID_ZMBV = AV_CODEC_ID_MMVIDEO + 1
  AV_CODEC_ID_AVS = AV_CODEC_ID_ZMBV + 1
  AV_CODEC_ID_SMACKVIDEO = AV_CODEC_ID_AVS + 1
  AV_CODEC_ID_NUV = AV_CODEC_ID_SMACKVIDEO + 1
  AV_CODEC_ID_KMVC = AV_CODEC_ID_NUV + 1
  AV_CODEC_ID_FLASHSV = AV_CODEC_ID_KMVC + 1
  AV_CODEC_ID_CAVS = AV_CODEC_ID_FLASHSV + 1
  AV_CODEC_ID_JPEG2000 = AV_CODEC_ID_CAVS + 1
  AV_CODEC_ID_VMNC = AV_CODEC_ID_JPEG2000 + 1
  AV_CODEC_ID_VP5 = AV_CODEC_ID_VMNC + 1
  AV_CODEC_ID_VP6 = AV_CODEC_ID_VP5 + 1
  AV_CODEC_ID_VP6F = AV_CODEC_ID_VP6 + 1
  AV_CODEC_ID_TARGA = AV_CODEC_ID_VP6F + 1
  AV_CODEC_ID_DSICINVIDEO = AV_CODEC_ID_TARGA + 1
  AV_CODEC_ID_TIERTEXSEQVIDEO = AV_CODEC_ID_DSICINVIDEO + 1
  AV_CODEC_ID_TIFF = AV_CODEC_ID_TIERTEXSEQVIDEO + 1
  AV_CODEC_ID_GIF = AV_CODEC_ID_TIFF + 1
  AV_CODEC_ID_DXA = AV_CODEC_ID_GIF + 1
  AV_CODEC_ID_DNXHD = AV_CODEC_ID_DXA + 1
  AV_CODEC_ID_THP = AV_CODEC_ID_DNXHD + 1
  AV_CODEC_ID_SGI = AV_CODEC_ID_THP + 1
  AV_CODEC_ID_C93 = AV_CODEC_ID_SGI + 1
  AV_CODEC_ID_BETHSOFTVID = AV_CODEC_ID_C93 + 1
  AV_CODEC_ID_PTX = AV_CODEC_ID_BETHSOFTVID + 1
  AV_CODEC_ID_TXD = AV_CODEC_ID_PTX + 1
  AV_CODEC_ID_VP6A = AV_CODEC_ID_TXD + 1
  AV_CODEC_ID_AMV = AV_CODEC_ID_VP6A + 1
  AV_CODEC_ID_VB = AV_CODEC_ID_AMV + 1
  AV_CODEC_ID_PCX = AV_CODEC_ID_VB + 1
  AV_CODEC_ID_SUNRAST = AV_CODEC_ID_PCX + 1
  AV_CODEC_ID_INDEO4 = AV_CODEC_ID_SUNRAST + 1
  AV_CODEC_ID_INDEO5 = AV_CODEC_ID_INDEO4 + 1
  AV_CODEC_ID_MIMIC = AV_CODEC_ID_INDEO5 + 1
  AV_CODEC_ID_RL2 = AV_CODEC_ID_MIMIC + 1
  AV_CODEC_ID_ESCAPE124 = AV_CODEC_ID_RL2 + 1
  AV_CODEC_ID_DIRAC = AV_CODEC_ID_ESCAPE124 + 1
  AV_CODEC_ID_BFI = AV_CODEC_ID_DIRAC + 1
  AV_CODEC_ID_CMV = AV_CODEC_ID_BFI + 1
  AV_CODEC_ID_MOTIONPIXELS = AV_CODEC_ID_CMV + 1
  AV_CODEC_ID_TGV = AV_CODEC_ID_MOTIONPIXELS + 1
  AV_CODEC_ID_TGQ = AV_CODEC_ID_TGV + 1
  AV_CODEC_ID_TQI = AV_CODEC_ID_TGQ + 1
  AV_CODEC_ID_AURA = AV_CODEC_ID_TQI + 1
  AV_CODEC_ID_AURA2 = AV_CODEC_ID_AURA + 1
  AV_CODEC_ID_V210X = AV_CODEC_ID_AURA2 + 1
  AV_CODEC_ID_TMV = AV_CODEC_ID_V210X + 1
  AV_CODEC_ID_V210 = AV_CODEC_ID_TMV + 1
  AV_CODEC_ID_DPX = AV_CODEC_ID_V210 + 1
  AV_CODEC_ID_MAD = AV_CODEC_ID_DPX + 1
  AV_CODEC_ID_FRWU = AV_CODEC_ID_MAD + 1
  AV_CODEC_ID_FLASHSV2 = AV_CODEC_ID_FRWU + 1
  AV_CODEC_ID_CDGRAPHICS = AV_CODEC_ID_FLASHSV2 + 1
  AV_CODEC_ID_R210 = AV_CODEC_ID_CDGRAPHICS + 1
  AV_CODEC_ID_ANM = AV_CODEC_ID_R210 + 1
  AV_CODEC_ID_BINKVIDEO = AV_CODEC_ID_ANM + 1
  AV_CODEC_ID_IFF_ILBM = AV_CODEC_ID_BINKVIDEO + 1
  AV_CODEC_ID_IFF_BYTERUN1 = AV_CODEC_ID_IFF_ILBM + 1
  AV_CODEC_ID_KGV1 = AV_CODEC_ID_IFF_BYTERUN1 + 1
  AV_CODEC_ID_YOP = AV_CODEC_ID_KGV1 + 1
  AV_CODEC_ID_VP8 = AV_CODEC_ID_YOP + 1
  AV_CODEC_ID_PICTOR = AV_CODEC_ID_VP8 + 1
  AV_CODEC_ID_ANSI = AV_CODEC_ID_PICTOR + 1
  AV_CODEC_ID_A64_MULTI = AV_CODEC_ID_ANSI + 1
  AV_CODEC_ID_A64_MULTI5 = AV_CODEC_ID_A64_MULTI + 1
  AV_CODEC_ID_R10K = AV_CODEC_ID_A64_MULTI5 + 1
  AV_CODEC_ID_MXPEG = AV_CODEC_ID_R10K + 1
  AV_CODEC_ID_LAGARITH = AV_CODEC_ID_MXPEG + 1
  AV_CODEC_ID_PRORES = AV_CODEC_ID_LAGARITH + 1
  AV_CODEC_ID_JV = AV_CODEC_ID_PRORES + 1
  AV_CODEC_ID_DFA = AV_CODEC_ID_JV + 1
  AV_CODEC_ID_WMV3IMAGE = AV_CODEC_ID_DFA + 1
  AV_CODEC_ID_VC1IMAGE = AV_CODEC_ID_WMV3IMAGE + 1
  AV_CODEC_ID_UTVIDEO = AV_CODEC_ID_VC1IMAGE + 1
  AV_CODEC_ID_BMV_VIDEO = AV_CODEC_ID_UTVIDEO + 1
  AV_CODEC_ID_VBLE = AV_CODEC_ID_BMV_VIDEO + 1
  AV_CODEC_ID_DXTORY = AV_CODEC_ID_VBLE + 1
  AV_CODEC_ID_V410 = AV_CODEC_ID_DXTORY + 1
  AV_CODEC_ID_XWD = AV_CODEC_ID_V410 + 1
  AV_CODEC_ID_CDXL = AV_CODEC_ID_XWD + 1
  AV_CODEC_ID_XBM = AV_CODEC_ID_CDXL + 1
  AV_CODEC_ID_ZEROCODEC = AV_CODEC_ID_XBM + 1
  AV_CODEC_ID_MSS1 = AV_CODEC_ID_ZEROCODEC + 1
  AV_CODEC_ID_MSA1 = AV_CODEC_ID_MSS1 + 1
  AV_CODEC_ID_TSCC2 = AV_CODEC_ID_MSA1 + 1
  AV_CODEC_ID_MTS2 = AV_CODEC_ID_TSCC2 + 1
  AV_CODEC_ID_CLLC = AV_CODEC_ID_MTS2 + 1
  AV_CODEC_ID_MSS2 = AV_CODEC_ID_CLLC + 1
  AV_CODEC_ID_FIRST_AUDIO = 0x10000
  AV_CODEC_ID_PCM_S16LE = 0x10000
  AV_CODEC_ID_PCM_S16BE = AV_CODEC_ID_PCM_S16LE + 1
  AV_CODEC_ID_PCM_U16LE = AV_CODEC_ID_PCM_S16BE + 1
  AV_CODEC_ID_PCM_U16BE = AV_CODEC_ID_PCM_U16LE + 1
  AV_CODEC_ID_PCM_S8 = AV_CODEC_ID_PCM_U16BE + 1
  AV_CODEC_ID_PCM_U8 = AV_CODEC_ID_PCM_S8 + 1
  AV_CODEC_ID_PCM_MULAW = AV_CODEC_ID_PCM_U8 + 1
  AV_CODEC_ID_PCM_ALAW = AV_CODEC_ID_PCM_MULAW + 1
  AV_CODEC_ID_PCM_S32LE = AV_CODEC_ID_PCM_ALAW + 1
  AV_CODEC_ID_PCM_S32BE = AV_CODEC_ID_PCM_S32LE + 1
  AV_CODEC_ID_PCM_U32LE = AV_CODEC_ID_PCM_S32BE + 1
  AV_CODEC_ID_PCM_U32BE = AV_CODEC_ID_PCM_U32LE + 1
  AV_CODEC_ID_PCM_S24LE = AV_CODEC_ID_PCM_U32BE + 1
  AV_CODEC_ID_PCM_S24BE = AV_CODEC_ID_PCM_S24LE + 1
  AV_CODEC_ID_PCM_U24LE = AV_CODEC_ID_PCM_S24BE + 1
  AV_CODEC_ID_PCM_U24BE = AV_CODEC_ID_PCM_U24LE + 1
  AV_CODEC_ID_PCM_S24DAUD = AV_CODEC_ID_PCM_U24BE + 1
  AV_CODEC_ID_PCM_ZORK = AV_CODEC_ID_PCM_S24DAUD + 1
  AV_CODEC_ID_PCM_S16LE_PLANAR = AV_CODEC_ID_PCM_ZORK + 1
  AV_CODEC_ID_PCM_DVD = AV_CODEC_ID_PCM_S16LE_PLANAR + 1
  AV_CODEC_ID_PCM_F32BE = AV_CODEC_ID_PCM_DVD + 1
  AV_CODEC_ID_PCM_F32LE = AV_CODEC_ID_PCM_F32BE + 1
  AV_CODEC_ID_PCM_F64BE = AV_CODEC_ID_PCM_F32LE + 1
  AV_CODEC_ID_PCM_F64LE = AV_CODEC_ID_PCM_F64BE + 1
  AV_CODEC_ID_PCM_BLURAY = AV_CODEC_ID_PCM_F64LE + 1
  AV_CODEC_ID_PCM_LXF = AV_CODEC_ID_PCM_BLURAY + 1
  AV_CODEC_ID_S302M = AV_CODEC_ID_PCM_LXF + 1
  AV_CODEC_ID_PCM_S8_PLANAR = AV_CODEC_ID_S302M + 1
  AV_CODEC_ID_ADPCM_IMA_QT = 0x11000
  AV_CODEC_ID_ADPCM_IMA_WAV = AV_CODEC_ID_ADPCM_IMA_QT + 1
  AV_CODEC_ID_ADPCM_IMA_DK3 = AV_CODEC_ID_ADPCM_IMA_WAV + 1
  AV_CODEC_ID_ADPCM_IMA_DK4 = AV_CODEC_ID_ADPCM_IMA_DK3 + 1
  AV_CODEC_ID_ADPCM_IMA_WS = AV_CODEC_ID_ADPCM_IMA_DK4 + 1
  AV_CODEC_ID_ADPCM_IMA_SMJPEG = AV_CODEC_ID_ADPCM_IMA_WS + 1
  AV_CODEC_ID_ADPCM_MS = AV_CODEC_ID_ADPCM_IMA_SMJPEG + 1
  AV_CODEC_ID_ADPCM_4XM = AV_CODEC_ID_ADPCM_MS + 1
  AV_CODEC_ID_ADPCM_XA = AV_CODEC_ID_ADPCM_4XM + 1
  AV_CODEC_ID_ADPCM_ADX = AV_CODEC_ID_ADPCM_XA + 1
  AV_CODEC_ID_ADPCM_EA = AV_CODEC_ID_ADPCM_ADX + 1
  AV_CODEC_ID_ADPCM_G726 = AV_CODEC_ID_ADPCM_EA + 1
  AV_CODEC_ID_ADPCM_CT = AV_CODEC_ID_ADPCM_G726 + 1
  AV_CODEC_ID_ADPCM_SWF = AV_CODEC_ID_ADPCM_CT + 1
  AV_CODEC_ID_ADPCM_YAMAHA = AV_CODEC_ID_ADPCM_SWF + 1
  AV_CODEC_ID_ADPCM_SBPRO_4 = AV_CODEC_ID_ADPCM_YAMAHA + 1
  AV_CODEC_ID_ADPCM_SBPRO_3 = AV_CODEC_ID_ADPCM_SBPRO_4 + 1
  AV_CODEC_ID_ADPCM_SBPRO_2 = AV_CODEC_ID_ADPCM_SBPRO_3 + 1
  AV_CODEC_ID_ADPCM_THP = AV_CODEC_ID_ADPCM_SBPRO_2 + 1
  AV_CODEC_ID_ADPCM_IMA_AMV = AV_CODEC_ID_ADPCM_THP + 1
  AV_CODEC_ID_ADPCM_EA_R1 = AV_CODEC_ID_ADPCM_IMA_AMV + 1
  AV_CODEC_ID_ADPCM_EA_R3 = AV_CODEC_ID_ADPCM_EA_R1 + 1
  AV_CODEC_ID_ADPCM_EA_R2 = AV_CODEC_ID_ADPCM_EA_R3 + 1
  AV_CODEC_ID_ADPCM_IMA_EA_SEAD = AV_CODEC_ID_ADPCM_EA_R2 + 1
  AV_CODEC_ID_ADPCM_IMA_EA_EACS = AV_CODEC_ID_ADPCM_IMA_EA_SEAD + 1
  AV_CODEC_ID_ADPCM_EA_XAS = AV_CODEC_ID_ADPCM_IMA_EA_EACS + 1
  AV_CODEC_ID_ADPCM_EA_MAXIS_XA = AV_CODEC_ID_ADPCM_EA_XAS + 1
  AV_CODEC_ID_ADPCM_IMA_ISS = AV_CODEC_ID_ADPCM_EA_MAXIS_XA + 1
  AV_CODEC_ID_ADPCM_G722 = AV_CODEC_ID_ADPCM_IMA_ISS + 1
  AV_CODEC_ID_ADPCM_IMA_APC = AV_CODEC_ID_ADPCM_G722 + 1
  AV_CODEC_ID_AMR_NB = 0x12000
  AV_CODEC_ID_AMR_WB = AV_CODEC_ID_AMR_NB + 1
  AV_CODEC_ID_RA_144 = 0x13000
  AV_CODEC_ID_RA_288 = AV_CODEC_ID_RA_144 + 1
  AV_CODEC_ID_ROQ_DPCM = 0x14000
  AV_CODEC_ID_INTERPLAY_DPCM = AV_CODEC_ID_ROQ_DPCM + 1
  AV_CODEC_ID_XAN_DPCM = AV_CODEC_ID_INTERPLAY_DPCM + 1
  AV_CODEC_ID_SOL_DPCM = AV_CODEC_ID_XAN_DPCM + 1
  AV_CODEC_ID_MP2 = 0x15000
  AV_CODEC_ID_MP3 = AV_CODEC_ID_MP2 + 1
  AV_CODEC_ID_AAC = AV_CODEC_ID_MP3 + 1
  AV_CODEC_ID_AC3 = AV_CODEC_ID_AAC + 1
  AV_CODEC_ID_DTS = AV_CODEC_ID_AC3 + 1
  AV_CODEC_ID_VORBIS = AV_CODEC_ID_DTS + 1
  AV_CODEC_ID_DVAUDIO = AV_CODEC_ID_VORBIS + 1
  AV_CODEC_ID_WMAV1 = AV_CODEC_ID_DVAUDIO + 1
  AV_CODEC_ID_WMAV2 = AV_CODEC_ID_WMAV1 + 1
  AV_CODEC_ID_MACE3 = AV_CODEC_ID_WMAV2 + 1
  AV_CODEC_ID_MACE6 = AV_CODEC_ID_MACE3 + 1
  AV_CODEC_ID_VMDAUDIO = AV_CODEC_ID_MACE6 + 1
  AV_CODEC_ID_FLAC = AV_CODEC_ID_VMDAUDIO + 1
  AV_CODEC_ID_MP3ADU = AV_CODEC_ID_FLAC + 1
  AV_CODEC_ID_MP3ON4 = AV_CODEC_ID_MP3ADU + 1
  AV_CODEC_ID_SHORTEN = AV_CODEC_ID_MP3ON4 + 1
  AV_CODEC_ID_ALAC = AV_CODEC_ID_SHORTEN + 1
  AV_CODEC_ID_WESTWOOD_SND1 = AV_CODEC_ID_ALAC + 1
  AV_CODEC_ID_GSM = AV_CODEC_ID_WESTWOOD_SND1 + 1
  AV_CODEC_ID_QDM2 = AV_CODEC_ID_GSM + 1
  AV_CODEC_ID_COOK = AV_CODEC_ID_QDM2 + 1
  AV_CODEC_ID_TRUESPEECH = AV_CODEC_ID_COOK + 1
  AV_CODEC_ID_TTA = AV_CODEC_ID_TRUESPEECH + 1
  AV_CODEC_ID_SMACKAUDIO = AV_CODEC_ID_TTA + 1
  AV_CODEC_ID_QCELP = AV_CODEC_ID_SMACKAUDIO + 1
  AV_CODEC_ID_WAVPACK = AV_CODEC_ID_QCELP + 1
  AV_CODEC_ID_DSICINAUDIO = AV_CODEC_ID_WAVPACK + 1
  AV_CODEC_ID_IMC = AV_CODEC_ID_DSICINAUDIO + 1
  AV_CODEC_ID_MUSEPACK7 = AV_CODEC_ID_IMC + 1
  AV_CODEC_ID_MLP = AV_CODEC_ID_MUSEPACK7 + 1
  AV_CODEC_ID_GSM_MS = AV_CODEC_ID_MLP + 1
  AV_CODEC_ID_ATRAC3 = AV_CODEC_ID_GSM_MS + 1
  AV_CODEC_ID_VOXWARE = AV_CODEC_ID_ATRAC3 + 1
  AV_CODEC_ID_APE = AV_CODEC_ID_VOXWARE + 1
  AV_CODEC_ID_NELLYMOSER = AV_CODEC_ID_APE + 1
  AV_CODEC_ID_MUSEPACK8 = AV_CODEC_ID_NELLYMOSER + 1
  AV_CODEC_ID_SPEEX = AV_CODEC_ID_MUSEPACK8 + 1
  AV_CODEC_ID_WMAVOICE = AV_CODEC_ID_SPEEX + 1
  AV_CODEC_ID_WMAPRO = AV_CODEC_ID_WMAVOICE + 1
  AV_CODEC_ID_WMALOSSLESS = AV_CODEC_ID_WMAPRO + 1
  AV_CODEC_ID_ATRAC3P = AV_CODEC_ID_WMALOSSLESS + 1
  AV_CODEC_ID_EAC3 = AV_CODEC_ID_ATRAC3P + 1
  AV_CODEC_ID_SIPR = AV_CODEC_ID_EAC3 + 1
  AV_CODEC_ID_MP1 = AV_CODEC_ID_SIPR + 1
  AV_CODEC_ID_TWINVQ = AV_CODEC_ID_MP1 + 1
  AV_CODEC_ID_TRUEHD = AV_CODEC_ID_TWINVQ + 1
  AV_CODEC_ID_MP4ALS = AV_CODEC_ID_TRUEHD + 1
  AV_CODEC_ID_ATRAC1 = AV_CODEC_ID_MP4ALS + 1
  AV_CODEC_ID_BINKAUDIO_RDFT = AV_CODEC_ID_ATRAC1 + 1
  AV_CODEC_ID_BINKAUDIO_DCT = AV_CODEC_ID_BINKAUDIO_RDFT + 1
  AV_CODEC_ID_AAC_LATM = AV_CODEC_ID_BINKAUDIO_DCT + 1
  AV_CODEC_ID_QDMC = AV_CODEC_ID_AAC_LATM + 1
  AV_CODEC_ID_CELT = AV_CODEC_ID_QDMC + 1
  AV_CODEC_ID_G723_1 = AV_CODEC_ID_CELT + 1
  AV_CODEC_ID_G729 = AV_CODEC_ID_G723_1 + 1
  AV_CODEC_ID_8SVX_EXP = AV_CODEC_ID_G729 + 1
  AV_CODEC_ID_8SVX_FIB = AV_CODEC_ID_8SVX_EXP + 1
  AV_CODEC_ID_BMV_AUDIO = AV_CODEC_ID_8SVX_FIB + 1
  AV_CODEC_ID_RALF = AV_CODEC_ID_BMV_AUDIO + 1
  AV_CODEC_ID_IAC = AV_CODEC_ID_RALF + 1
  AV_CODEC_ID_ILBC = AV_CODEC_ID_IAC + 1
  AV_CODEC_ID_OPUS = AV_CODEC_ID_ILBC + 1
  AV_CODEC_ID_COMFORT_NOISE = AV_CODEC_ID_OPUS + 1
  AV_CODEC_ID_TAK = AV_CODEC_ID_COMFORT_NOISE + 1
  AV_CODEC_ID_FIRST_SUBTITLE = 0x17000
  AV_CODEC_ID_DVD_SUBTITLE = 0x17000
  AV_CODEC_ID_DVB_SUBTITLE = AV_CODEC_ID_DVD_SUBTITLE + 1
  AV_CODEC_ID_TEXT = AV_CODEC_ID_DVB_SUBTITLE + 1
  AV_CODEC_ID_XSUB = AV_CODEC_ID_TEXT + 1
  AV_CODEC_ID_SSA = AV_CODEC_ID_XSUB + 1
  AV_CODEC_ID_MOV_TEXT = AV_CODEC_ID_SSA + 1
  AV_CODEC_ID_HDMV_PGS_SUBTITLE = AV_CODEC_ID_MOV_TEXT + 1
  AV_CODEC_ID_DVB_TELETEXT = AV_CODEC_ID_HDMV_PGS_SUBTITLE + 1
  AV_CODEC_ID_SRT = AV_CODEC_ID_DVB_TELETEXT + 1
  AV_CODEC_ID_FIRST_UNKNOWN = 0x18000
  AV_CODEC_ID_TTF = 0x18000
  AV_CODEC_ID_PROBE = 0x19000
  AV_CODEC_ID_MPEG2TS = 0x20000
  AV_CODEC_ID_MPEG4SYSTEMS = 0x20001
  AV_CODEC_ID_FFMETADATA = 0x21000
  AVCodecID = enum :AVCodecID, [
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
    :utvideo,
    :bmv_video,
    :vble,
    :dxtory,
    :v410,
    :xwd,
    :cdxl,
    :xbm,
    :zerocodec,
    :mss1,
    :msa1,
    :tscc2,
    :mts2,
    :cllc,
    :mss2,
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
    :adpcm_ima_apc,
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
    :g723_1,
    :g729,
    :'8svx_exp',
    :'8svx_fib',
    :bmv_audio,
    :ralf,
    :iac,
    :ilbc,
    :opus,
    :comfort_noise,
    :tak,
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

  class AVCodecDescriptor < FFI::Struct
    layout(
           :id, :int,
           :type, :int,
           :name, :pointer,
           :long_name, :pointer,
           :props, :int
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

  end
  AV_CODEC_PROP_INTRA_ONLY = (1 << 0)
  AV_CODEC_PROP_LOSSY = (1 << 1)
  AV_CODEC_PROP_LOSSLESS = (1 << 2)
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
  AVCOL_TRC_SMPTE240M = 7
  AVCOL_TRC_NB = AVCOL_TRC_SMPTE240M + 1
  AVColorTransferCharacteristic = enum :AVColorTransferCharacteristic, [
    :bt709, 1,
    :unspecified, 2,
    :gamma22, 4,
    :gamma28, 5,
    :smpte240m, 7,
    :nb,
  ]

  AVCOL_SPC_RGB = 0
  AVCOL_SPC_BT709 = 1
  AVCOL_SPC_UNSPECIFIED = 2
  AVCOL_SPC_FCC = 4
  AVCOL_SPC_BT470BG = 5
  AVCOL_SPC_SMPTE170M = 6
  AVCOL_SPC_SMPTE240M = 7
  AVCOL_SPC_YCOCG = 8
  AVCOL_SPC_NB = AVCOL_SPC_YCOCG + 1
  AVColorSpace = enum :AVColorSpace, [
    :rgb, 0,
    :bt709, 1,
    :unspecified, 2,
    :fcc, 4,
    :bt470bg, 5,
    :smpte170m, 6,
    :smpte240m, 7,
    :ycocg, 8,
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
  CODEC_FLAG_LOOP_FILTER = 0x00000800
  CODEC_FLAG_INTERLACED_ME = 0x20000000
  CODEC_FLAG_CLOSED_GOP = 0x80000000
  CODEC_FLAG2_FAST = 0x00000001
  CODEC_FLAG2_NO_OUTPUT = 0x00000004
  CODEC_FLAG2_LOCAL_HEADER = 0x00000008
  CODEC_FLAG_CBP_RD = 0x04000000
  CODEC_FLAG_QP_RD = 0x08000000
  CODEC_FLAG2_STRICT_GOP = 0x00000002
  CODEC_FLAG2_SKIP_RD = 0x00004000
  CODEC_FLAG2_CHUNKS = 0x00008000
  CODEC_CAP_DRAW_HORIZ_BAND = 0x0001
  CODEC_CAP_DR1 = 0x0002
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
  AV_PKT_DATA_H263_MB_INFO = AV_PKT_DATA_PARAM_CHANGE + 1
  AVPacketSideDataType = enum :AVPacketSideDataType, [
    :palette,
    :new_extradata,
    :param_change,
    :h263_mb_info,
  ]

  class AVPacketSideData < FFI::Struct
    layout(
           :data, :pointer,
           :size, :int,
           :type, :int
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

  AV_NUM_DATA_POINTERS = 8
  class AVFrame < FFI::Struct
    layout(
           :data, [:pointer, 8],
           :linesize, [:int, 8],
           :extended_data, :pointer,
           :width, :int,
           :height, :int,
           :nb_samples, :int,
           :format, AVPixelFormat,
           :key_frame, :int,
           :pict_type, :int,
           :base, [:pointer, 8],
           :sample_aspect_ratio, AVRational.by_value,
           :pts, :int64,
           :pkt_pts, :int64,
           :pkt_dts, :int64,
           :coded_picture_number, :int,
           :display_picture_number, :int,
           :quality, :int,
           :reference, :int,
           :qscale_table, :pointer,
           :qstride, :int,
           :qscale_type, :int,
           :mbskip_table, :pointer,
           :motion_val, [:pointer, 2],
           :mb_type, :pointer,
           :dct_coeff, :pointer,
           :ref_index, [:pointer, 2],
           :opaque, :pointer,
           :error, [:uint64, 8],
           :type, :int,
           :repeat_pict, :int,
           :interlaced_frame, :int,
           :top_field_first, :int,
           :palette_has_changed, :int,
           :buffer_hints, :int,
           :pan_scan, AVPanScan.ptr,
           :reordered_opaque, :int64,
           :hwaccel_picture_private, :pointer,
           :owner, AVCodecContext.ptr,
           :thread_opaque, :pointer,
           :motion_subsample_log2, :uint8,
           :sample_rate, :int,
           :channel_layout, :uint64
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

  FF_COMPRESSION_DEFAULT = -1
  FF_ASPECT_EXTENDED = 15
  FF_RC_STRATEGY_XVID = 1
  FF_PRED_LEFT = 0
  FF_PRED_PLANE = 1
  FF_PRED_MEDIAN = 2
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
  SLICE_FLAG_CODED_ORDER = 0x0001
  SLICE_FLAG_ALLOW_FIELD = 0x0002
  SLICE_FLAG_ALLOW_PLANE = 0x0004
  FF_MB_DECISION_SIMPLE = 0
  FF_MB_DECISION_BITS = 1
  FF_MB_DECISION_RD = 2
  FF_CODER_TYPE_VLC = 0
  FF_CODER_TYPE_AC = 1
  FF_CODER_TYPE_RAW = 2
  FF_CODER_TYPE_RLE = 3
  FF_CODER_TYPE_DEFLATE = 4
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
  FF_EC_GUESS_MVS = 1
  FF_EC_DEBLOCK = 2
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
  AV_EF_CRCCHECK = (1 << 0)
  AV_EF_BITSTREAM = (1 << 1)
  AV_EF_BUFFER = (1 << 2)
  AV_EF_EXPLODE = (1 << 3)
  FF_DCT_AUTO = 0
  FF_DCT_FASTINT = 1
  FF_DCT_INT = 2
  FF_DCT_MMX = 3
  FF_DCT_ALTIVEC = 5
  FF_DCT_FAAN = 6
  FF_IDCT_AUTO = 0
  FF_IDCT_INT = 1
  FF_IDCT_SIMPLE = 2
  FF_IDCT_SIMPLEMMX = 3
  FF_IDCT_LIBMPEG2MMX = 4
  FF_IDCT_MMI = 5
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
  FF_THREAD_FRAME = 1
  FF_THREAD_SLICE = 2
  FF_PROFILE_UNKNOWN = -99
  FF_PROFILE_RESERVED = -100
  FF_PROFILE_AAC_MAIN = 0
  FF_PROFILE_AAC_LOW = 1
  FF_PROFILE_AAC_SSR = 2
  FF_PROFILE_AAC_LTP = 3
  FF_PROFILE_AAC_HE = 4
  FF_PROFILE_AAC_HE_V2 = 28
  FF_PROFILE_AAC_LD = 22
  FF_PROFILE_AAC_ELD = 38
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
  class AVCodecContext < FFI::Struct
    layout(
           :av_class, :pointer,
           :log_level_offset, :int,
           :codec_type, AVMediaType,
           :codec, :pointer,
           :codec_name, [:char, 32],
           :codec_id, :int,
           :codec_tag, :uint,
           :stream_codec_tag, :uint,
           :sub_id, :int,
           :priv_data, :pointer,
           :internal, :pointer,
           :opaque, :pointer,
           :bit_rate, :int,
           :bit_rate_tolerance, :int,
           :global_quality, :int,
           :compression_level, :int,
           :flags, :int,
           :flags2, :int,
           :extradata, :pointer,
           :extradata_size, :int,
           :time_base, AVRational.by_value,
           :ticks_per_frame, :int,
           :delay, :int,
           :width, :int,
           :height, :int,
           :coded_width, :int,
           :coded_height, :int,
           :gop_size, :int,
           :pix_fmt, AVPixelFormat,
           :me_method, :int,
           :draw_horiz_band, callback([ AVCodecContext.ptr, :pointer, :pointer, :int, :int, :int ], :void),
           :get_format, callback([ AVCodecContext.ptr, :pointer ], :int),
           :max_b_frames, :int,
           :b_quant_factor, :float,
           :rc_strategy, :int,
           :b_frame_strategy, :int,
           :luma_elim_threshold, :int,
           :chroma_elim_threshold, :int,
           :b_quant_offset, :float,
           :has_b_frames, :int,
           :mpeg_quant, :int,
           :i_quant_factor, :float,
           :i_quant_offset, :float,
           :lumi_masking, :float,
           :temporal_cplx_masking, :float,
           :spatial_cplx_masking, :float,
           :p_masking, :float,
           :dark_masking, :float,
           :slice_count, :int,
           :prediction_method, :int,
           :slice_offset, :pointer,
           :sample_aspect_ratio, AVRational.by_value,
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
           :dtg_active_format, :int,
           :me_range, :int,
           :intra_quant_bias, :int,
           :inter_quant_bias, :int,
           :color_table_id, :int,
           :slice_flags, :int,
           :xvmc_acceleration, :int,
           :mb_decision, :int,
           :intra_matrix, :pointer,
           :inter_matrix, :pointer,
           :scenechange_threshold, :int,
           :noise_reduction, :int,
           :inter_threshold, :int,
           :quantizer_noise_shaping, :int,
           :me_threshold, :int,
           :mb_threshold, :int,
           :intra_dc_precision, :int,
           :skip_top, :int,
           :skip_bottom, :int,
           :border_masking, :float,
           :mb_lmin, :int,
           :mb_lmax, :int,
           :me_penalty_compensation, :int,
           :bidir_refine, :int,
           :brd_scale, :int,
           :keyint_min, :int,
           :refs, :int,
           :chromaoffset, :int,
           :scenechange_factor, :int,
           :mv0_threshold, :int,
           :b_sensitivity, :int,
           :color_primaries, :int,
           :color_trc, :int,
           :colorspace, :int,
           :color_range, :int,
           :chroma_sample_location, :int,
           :slices, :int,
           :field_order, :int,
           :sample_rate, :int,
           :channels, :int,
           :sample_fmt, :int,
           :frame_size, :int,
           :frame_number, :int,
           :block_align, :int,
           :cutoff, :int,
           :request_channels, :int,
           :channel_layout, :uint64,
           :request_channel_layout, :uint64,
           :audio_service_type, :int,
           :request_sample_fmt, :int,
           :get_buffer, callback([ AVCodecContext.ptr, AVFrame.ptr ], :int),
           :release_buffer, callback([ AVCodecContext.ptr, AVFrame.ptr ], :void),
           :reget_buffer, callback([ AVCodecContext.ptr, AVFrame.ptr ], :int),
           :qcompress, :float,
           :qblur, :float,
           :qmin, :int,
           :qmax, :int,
           :max_qdiff, :int,
           :rc_qsquish, :float,
           :rc_qmod_amp, :float,
           :rc_qmod_freq, :int,
           :rc_buffer_size, :int,
           :rc_override_count, :int,
           :rc_override, RcOverride.ptr,
           :rc_eq, :pointer,
           :rc_max_rate, :int,
           :rc_min_rate, :int,
           :rc_buffer_aggressivity, :float,
           :rc_initial_cplx, :float,
           :rc_max_available_vbv_use, :float,
           :rc_min_vbv_overflow_use, :float,
           :rc_initial_buffer_occupancy, :int,
           :coder_type, :int,
           :context_model, :int,
           :lmin, :int,
           :lmax, :int,
           :frame_skip_threshold, :int,
           :frame_skip_factor, :int,
           :frame_skip_exp, :int,
           :frame_skip_cmp, :int,
           :trellis, :int,
           :min_prediction_order, :int,
           :max_prediction_order, :int,
           :timecode_frame_start, :int64,
           :rtp_callback, callback([ AVCodecContext.ptr, :pointer, :int, :int ], :void),
           :rtp_payload_size, :int,
           :mv_bits, :int,
           :header_bits, :int,
           :i_tex_bits, :int,
           :p_tex_bits, :int,
           :i_count, :int,
           :p_count, :int,
           :skip_count, :int,
           :misc_bits, :int,
           :frame_bits, :int,
           :stats_out, :pointer,
           :stats_in, :pointer,
           :workaround_bugs, :int,
           :strict_std_compliance, :int,
           :error_concealment, :int,
           :debug, :int,
           :debug_mv, :int,
           :err_recognition, :int,
           :reordered_opaque, :int64,
           :hwaccel, AVHWAccel.ptr,
           :hwaccel_context, :pointer,
           :error, [:uint64, 8],
           :dct_algo, :int,
           :idct_algo, :int,
           :dsp_mask, :uint,
           :bits_per_coded_sample, :int,
           :bits_per_raw_sample, :int,
           :lowres, :int,
           :coded_frame, AVFrame.ptr,
           :thread_count, :int,
           :thread_type, :int,
           :active_thread_type, :int,
           :thread_safe_callbacks, :int,
           :execute, callback([ AVCodecContext.ptr, callback([ AVCodecContext.ptr, :pointer ], :int), :pointer, :pointer, :int, :int ], :int),
           :execute2, callback([ AVCodecContext.ptr, callback([ AVCodecContext.ptr, :pointer, :int, :int ], :int), :pointer, :pointer, :int ], :int),
           :thread_opaque, :pointer,
           :nsse_weight, :int,
           :profile, :int,
           :level, :int,
           :skip_loop_filter, :int,
           :skip_idct, :int,
           :skip_frame, :int,
           :subtitle_header, :pointer,
           :subtitle_header_size, :int,
           :error_rate, :int,
           :pkt, AVPacket.ptr,
           :vbv_delay, :uint64
    )
    def draw_horiz_band=(cb)
      @draw_horiz_band = cb
      self[:draw_horiz_band] = @draw_horiz_band
    end
    def draw_horiz_band
      @draw_horiz_band
    end
    def get_format=(cb)
      @get_format = cb
      self[:get_format] = @get_format
    end
    def get_format
      @get_format
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
    def reget_buffer=(cb)
      @reget_buffer = cb
      self[:reget_buffer] = @reget_buffer
    end
    def reget_buffer
      @reget_buffer
    end
    def rc_eq=(str)
      @rc_eq = FFI::MemoryPointer.from_string(str)
      self[:rc_eq] = @rc_eq
    end
    def rc_eq
      @rc_eq.get_string(0)
    end
    def rtp_callback=(cb)
      @rtp_callback = cb
      self[:rtp_callback] = @rtp_callback
    end
    def rtp_callback
      @rtp_callback
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
           :long_name, :pointer,
           :type, AVMediaType,
           :id, :int,
           :capabilities, :int,
           :supported_framerates, :pointer,
           :pix_fmts, :pointer,
           :supported_samplerates, :pointer,
           :sample_fmts, :pointer,
           :channel_layouts, :pointer,
           :max_lowres, :uint8,
           :priv_class, :pointer,
           :profiles, :pointer,
           :priv_data_size, :int,
           :next, AVCodec.ptr,
           :init_thread_copy, callback([ AVCodecContext.ptr ], :int),
           :update_thread_context, callback([ AVCodecContext.ptr, :pointer ], :int),
           :defaults, :pointer,
           :init_static_data, callback([ AVCodec.ptr ], :void),
           :init, callback([ AVCodecContext.ptr ], :int),
           :encode_sub, callback([ AVCodecContext.ptr, :pointer, :int, :pointer ], :int),
           :encode2, callback([ AVCodecContext.ptr, AVPacket.ptr, :pointer, :pointer ], :int),
           :decode, callback([ AVCodecContext.ptr, :pointer, :pointer, AVPacket.ptr ], :int),
           :close, callback([ AVCodecContext.ptr ], :int),
           :flush, callback([ AVCodecContext.ptr ], :void)
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
    def init=(cb)
      @init = cb
      self[:init] = @init
    end
    def init
      @init
    end
    def encode_sub=(cb)
      @encode_sub = cb
      self[:encode_sub] = @encode_sub
    end
    def encode_sub
      @encode_sub
    end
    def encode2=(cb)
      @encode2 = cb
      self[:encode2] = @encode2
    end
    def encode2
      @encode2
    end
    def decode=(cb)
      @decode = cb
      self[:decode] = @decode
    end
    def decode
      @decode
    end
    def close=(cb)
      @close = cb
      self[:close] = @close
    end
    def close
      @close
    end
    def flush=(cb)
      @flush = cb
      self[:flush] = @flush
    end
    def flush
      @flush
    end

  end
  class AVHWAccel < FFI::Struct
    layout(
           :name, :pointer,
           :type, :int,
           :id, :int,
           :pix_fmt, :int,
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
           :data, [:pointer, 8],
           :linesize, [:int, 8]
    )
  end
  AVPALETTE_SIZE = 1024
  AVPALETTE_COUNT = 256
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

  AV_SUBTITLE_FLAG_FORCED = 0x00000001
  class AVSubtitleRect < FFI::Struct
    layout(
           :x, :int,
           :y, :int,
           :w, :int,
           :h, :int,
           :nb_colors, :int,
           :pict, AVPicture.by_value,
           :type, :int,
           :text, :pointer,
           :ass, :pointer,
           :flags, :int
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
  attach_function :av_codec_next, :av_codec_next, [ :pointer ], AVCodec.ptr
  attach_function :avcodec_version, :avcodec_version, [  ], :uint
  attach_function :avcodec_configuration, :avcodec_configuration, [  ], :string
  attach_function :avcodec_license, :avcodec_license, [  ], :string
  attach_function :avcodec_register, :avcodec_register, [ AVCodec.ptr ], :void
  attach_function :avcodec_register_all, :avcodec_register_all, [  ], :void
  attach_function :avcodec_alloc_context3, :avcodec_alloc_context3, [ :pointer ], AVCodecContext.ptr
  attach_function :avcodec_get_context_defaults3, :avcodec_get_context_defaults3, [ AVCodecContext.ptr, :pointer ], :int
  attach_function :avcodec_get_class, :avcodec_get_class, [  ], :pointer
  attach_function :avcodec_copy_context, :avcodec_copy_context, [ AVCodecContext.ptr, :pointer ], :int
  attach_function :avcodec_alloc_frame, :avcodec_alloc_frame, [  ], AVFrame.ptr
  attach_function :avcodec_get_frame_defaults, :avcodec_get_frame_defaults, [ AVFrame.ptr ], :void
  attach_function :avcodec_free_frame, :avcodec_free_frame, [ :pointer ], :void
  attach_function :avcodec_open2, :avcodec_open2, [ AVCodecContext.ptr, :pointer, :pointer ], :int
  attach_function :avcodec_close, :avcodec_close, [ AVCodecContext.ptr ], :int
  attach_function :avsubtitle_free, :avsubtitle_free, [ AVSubtitle.ptr ], :void
  attach_function :av_destruct_packet, :av_destruct_packet, [ AVPacket.ptr ], :void
  attach_function :av_init_packet, :av_init_packet, [ AVPacket.ptr ], :void
  attach_function :av_new_packet, :av_new_packet, [ AVPacket.ptr, :int ], :int
  attach_function :av_shrink_packet, :av_shrink_packet, [ AVPacket.ptr, :int ], :void
  attach_function :av_grow_packet, :av_grow_packet, [ AVPacket.ptr, :int ], :int
  attach_function :av_dup_packet, :av_dup_packet, [ AVPacket.ptr ], :int
  attach_function :av_free_packet, :av_free_packet, [ AVPacket.ptr ], :void
  attach_function :av_packet_new_side_data, :av_packet_new_side_data, [ AVPacket.ptr, :int, :int ], :pointer
  attach_function :av_packet_shrink_side_data, :av_packet_shrink_side_data, [ AVPacket.ptr, :int, :int ], :int
  attach_function :av_packet_get_side_data, :av_packet_get_side_data, [ AVPacket.ptr, :int, :pointer ], :pointer
  attach_function :avcodec_find_decoder, :avcodec_find_decoder, [ :int ], AVCodec.ptr
  attach_function :avcodec_find_decoder_by_name, :avcodec_find_decoder_by_name, [ :string ], AVCodec.ptr
  attach_function :avcodec_default_get_buffer, :avcodec_default_get_buffer, [ AVCodecContext.ptr, AVFrame.ptr ], :int
  attach_function :avcodec_default_release_buffer, :avcodec_default_release_buffer, [ AVCodecContext.ptr, AVFrame.ptr ], :void
  attach_function :avcodec_default_reget_buffer, :avcodec_default_reget_buffer, [ AVCodecContext.ptr, AVFrame.ptr ], :int
  attach_function :avcodec_get_edge_width, :avcodec_get_edge_width, [  ], :uint
  attach_function :avcodec_align_dimensions, :avcodec_align_dimensions, [ AVCodecContext.ptr, :pointer, :pointer ], :void
  attach_function :avcodec_align_dimensions2, :avcodec_align_dimensions2, [ AVCodecContext.ptr, :pointer, :pointer, :pointer ], :void
  attach_function :avcodec_decode_audio3, :avcodec_decode_audio3, [ AVCodecContext.ptr, :pointer, :pointer, AVPacket.ptr ], :int
  attach_function :avcodec_decode_audio4, :avcodec_decode_audio4, [ AVCodecContext.ptr, AVFrame.ptr, :pointer, AVPacket.ptr ], :int
  attach_function :avcodec_decode_video2, :avcodec_decode_video2, [ AVCodecContext.ptr, AVFrame.ptr, :pointer, AVPacket.ptr ], :int
  attach_function :avcodec_decode_subtitle2, :avcodec_decode_subtitle2, [ AVCodecContext.ptr, AVSubtitle.ptr, :pointer, AVPacket.ptr ], :int
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
           :last_pos, :int64,
           :duration, :int
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
  attach_function :avcodec_find_encoder, :avcodec_find_encoder, [ :int ], AVCodec.ptr
  attach_function :avcodec_find_encoder_by_name, :avcodec_find_encoder_by_name, [ :string ], AVCodec.ptr
  attach_function :avcodec_encode_audio, :avcodec_encode_audio, [ AVCodecContext.ptr, :pointer, :int, :pointer ], :int
  attach_function :avcodec_encode_audio2, :avcodec_encode_audio2, [ AVCodecContext.ptr, AVPacket.ptr, :pointer, :pointer ], :int
  attach_function :avcodec_encode_video, :avcodec_encode_video, [ AVCodecContext.ptr, :pointer, :int, :pointer ], :int
  attach_function :avcodec_encode_video2, :avcodec_encode_video2, [ AVCodecContext.ptr, AVPacket.ptr, :pointer, :pointer ], :int
  attach_function :avcodec_encode_subtitle, :avcodec_encode_subtitle, [ AVCodecContext.ptr, :pointer, :int, :pointer ], :int
  attach_function :av_audio_resample_init, :av_audio_resample_init, [ :int, :int, :int, :int, :int, :int, :int, :int, :int, :double ], :pointer
  attach_function :audio_resample, :audio_resample, [ :pointer, :pointer, :pointer, :int ], :int
  attach_function :audio_resample_close, :audio_resample_close, [ :pointer ], :void
  attach_function :av_resample_init, :av_resample_init, [ :int, :int, :int, :int, :int, :double ], :pointer
  attach_function :av_resample, :av_resample, [ :pointer, :pointer, :pointer, :pointer, :int, :int, :int ], :int
  attach_function :av_resample_compensate, :av_resample_compensate, [ :pointer, :int, :int ], :void
  attach_function :av_resample_close, :av_resample_close, [ :pointer ], :void
  attach_function :avpicture_alloc, :avpicture_alloc, [ AVPicture.ptr, :int, :int, :int ], :int
  attach_function :avpicture_free, :avpicture_free, [ AVPicture.ptr ], :void
  attach_function :avpicture_fill, :avpicture_fill, [ AVPicture.ptr, :pointer, :int, :int, :int ], :int
  attach_function :avpicture_layout, :avpicture_layout, [ :pointer, :int, :int, :int, :pointer, :int ], :int
  attach_function :avpicture_get_size, :avpicture_get_size, [ :int, :int, :int ], :int
  attach_function :avpicture_deinterlace, :avpicture_deinterlace, [ AVPicture.ptr, :pointer, :int, :int, :int ], :int
  attach_function :av_picture_copy, :av_picture_copy, [ AVPicture.ptr, :pointer, :int, :int, :int ], :void
  attach_function :av_picture_crop, :av_picture_crop, [ AVPicture.ptr, :pointer, :int, :int, :int ], :int
  attach_function :av_picture_pad, :av_picture_pad, [ AVPicture.ptr, :pointer, :int, :int, :int, :int, :int, :int, :int, :pointer ], :int
  attach_function :avcodec_get_chroma_sub_sample, :avcodec_get_chroma_sub_sample, [ :int, :pointer, :pointer ], :void
  attach_function :avcodec_pix_fmt_to_codec_tag, :avcodec_pix_fmt_to_codec_tag, [ :int ], :uint
  FF_LOSS_RESOLUTION = 0x0001
  FF_LOSS_DEPTH = 0x0002
  FF_LOSS_COLORSPACE = 0x0004
  FF_LOSS_ALPHA = 0x0008
  FF_LOSS_COLORQUANT = 0x0010
  FF_LOSS_CHROMA = 0x0020
  attach_function :avcodec_get_pix_fmt_loss, :avcodec_get_pix_fmt_loss, [ :int, :int, :int ], :int
  attach_function :avcodec_find_best_pix_fmt, :avcodec_find_best_pix_fmt, [ :int64, :int, :int, :pointer ], :int
  attach_function :avcodec_find_best_pix_fmt2, :avcodec_find_best_pix_fmt2, [ :pointer, :int, :int, :pointer ], :int
  attach_function :avcodec_default_get_format, :avcodec_default_get_format, [ AVCodecContext.ptr, :pointer ], :int
  attach_function :avcodec_set_dimensions, :avcodec_set_dimensions, [ AVCodecContext.ptr, :int, :int ], :void
  attach_function :av_get_codec_tag_string, :av_get_codec_tag_string, [ :string, :uint, :uint ], :uint
  attach_function :avcodec_string, :avcodec_string, [ :string, :int, AVCodecContext.ptr, :int ], :void
  attach_function :av_get_profile_name, :av_get_profile_name, [ :pointer, :int ], :string
  attach_function :avcodec_default_execute, :avcodec_default_execute, [ AVCodecContext.ptr, callback([ AVCodecContext.ptr, :pointer ], :int), :pointer, :pointer, :int, :int ], :int
  attach_function :avcodec_default_execute2, :avcodec_default_execute2, [ AVCodecContext.ptr, callback([ AVCodecContext.ptr, :pointer, :int, :int ], :int), :pointer, :pointer, :int ], :int
  attach_function :avcodec_fill_audio_frame, :avcodec_fill_audio_frame, [ AVFrame.ptr, :int, :int, :pointer, :int, :int ], :int
  attach_function :avcodec_flush_buffers, :avcodec_flush_buffers, [ AVCodecContext.ptr ], :void
  attach_function :avcodec_default_free_buffers, :avcodec_default_free_buffers, [ AVCodecContext.ptr ], :void
  attach_function :av_get_bits_per_sample, :av_get_bits_per_sample, [ :int ], :int
  attach_function :av_get_exact_bits_per_sample, :av_get_exact_bits_per_sample, [ :int ], :int
  attach_function :av_get_audio_frame_duration, :av_get_audio_frame_duration, [ AVCodecContext.ptr, :int ], :int
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
  attach_function :av_fast_padded_malloc, :av_fast_padded_malloc, [ :pointer, :pointer, :uint ], :void
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

  attach_function :av_lockmgr_register, :av_lockmgr_register, [ callback([ :pointer, :int ], :int) ], :int
  attach_function :avcodec_get_type, :avcodec_get_type, [ :int ], :int
  attach_function :avcodec_is_open, :avcodec_is_open, [ AVCodecContext.ptr ], :int
  attach_function :av_codec_is_encoder, :av_codec_is_encoder, [ :pointer ], :int
  attach_function :av_codec_is_decoder, :av_codec_is_decoder, [ :pointer ], :int
  attach_function :avcodec_descriptor_get, :avcodec_descriptor_get, [ :int ], :pointer
  attach_function :avcodec_descriptor_next, :avcodec_descriptor_next, [ :pointer ], :pointer
  attach_function :avcodec_descriptor_get_by_name, :avcodec_descriptor_get_by_name, [ :string ], :pointer


  ffi_lib [ "libavformat.so.54", "libavformat.54.dylib" ]

  class AVIOContext < FFI::Struct; end
  class AVPacket < FFI::Struct; end
  class AVOutputFormat < FFI::Struct; end
  class AVFormatContext < FFI::Struct; end
  class AVInputFormat < FFI::Struct; end
  class AVProbeData < FFI::Struct; end
  class AVCodecContext < FFI::Struct; end
  class AVCodecParserContext < FFI::Struct; end
  class AVPacketList < FFI::Struct; end
  class AVIndexEntry < FFI::Struct; end
  class AVStreamInfo < FFI::Struct; end
  class AVCodec < FFI::Struct; end
  class AVStream < FFI::Struct; end
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
           :av_class, :pointer,
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
  attach_function :avio_closep, :avio_closep, [ :pointer ], :int
  attach_function :avio_open_dyn_buf, :avio_open_dyn_buf, [ :pointer ], :int
  attach_function :avio_close_dyn_buf, :avio_close_dyn_buf, [ AVIOContext.ptr, :pointer ], :int
  attach_function :avio_enum_protocols, :avio_enum_protocols, [ :pointer, :int ], :string
  attach_function :avio_pause, :avio_pause, [ AVIOContext.ptr, :int ], :int
  attach_function :avio_seek_time, :avio_seek_time, [ AVIOContext.ptr, :int, :int64, :int ], :int64
  LIBAVFORMAT_VERSION_MAJOR = 54
  LIBAVFORMAT_VERSION_MINOR = 20
  LIBAVFORMAT_VERSION_MICRO = 4
  LIBAVFORMAT_VERSION_INT = (54 << 16|20 << 8|4)
  LIBAVFORMAT_BUILD = (54 << 16|20 << 8|4)
  LIBAVFORMAT_IDENT = 'Lavf54.20.4'
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
  AVFMT_ALLOW_FLUSH = 0x10000
  AVFMT_TS_NONSTRICT = 0x20000
  class AVOutputFormat < FFI::Struct
    layout(
           :name, :pointer,
           :long_name, :pointer,
           :mime_type, :pointer,
           :extensions, :pointer,
           :audio_codec, :int,
           :video_codec, :int,
           :subtitle_codec, :int,
           :flags, :int,
           :codec_tag, :pointer,
           :priv_class, :pointer,
           :next, AVOutputFormat.ptr,
           :priv_data_size, :int,
           :write_header, callback([ AVFormatContext.ptr ], :int),
           :write_packet, callback([ AVFormatContext.ptr, AVPacket.ptr ], :int),
           :write_trailer, callback([ AVFormatContext.ptr ], :int),
           :interleave_packet, callback([ AVFormatContext.ptr, AVPacket.ptr, AVPacket.ptr, :int ], :int),
           :query_codec, callback([ :int, :int ], :int)
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
           :flags, :int,
           :extensions, :pointer,
           :codec_tag, :pointer,
           :priv_class, :pointer,
           :next, AVInputFormat.ptr,
           :raw_codec_id, :int,
           :priv_data_size, :int,
           :read_probe, callback([ AVProbeData.ptr ], :int),
           :read_header, callback([ AVFormatContext.ptr ], :int),
           :read_packet, callback([ AVFormatContext.ptr, AVPacket.ptr ], :int),
           :read_close, callback([ AVFormatContext.ptr ], :int),
           :read_seek, callback([ AVFormatContext.ptr, :int, :int64, :int ], :int),
           :read_timestamp, callback([ AVFormatContext.ptr, :int, :pointer, :int64 ], :int64),
           :read_play, callback([ AVFormatContext.ptr ], :int),
           :read_pause, callback([ AVFormatContext.ptr ], :int),
           :read_seek2, callback([ AVFormatContext.ptr, :int, :int64, :int64, :int64, :int ], :int)
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
    def extensions=(str)
      @extensions = FFI::MemoryPointer.from_string(str)
      self[:extensions] = @extensions
    end
    def extensions
      @extensions.get_string(0)
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
  AV_DISPOSITION_ATTACHED_PIC = 0x0400
  MAX_STD_TIMEBASES = (60*12+5)
  MAX_PROBE_PACKETS = 2500
  MAX_REORDER_DELAY = 16
  class AVStreamInfo < FFI::Struct
    layout(
           :last_dts, :int64,
           :duration_gcd, :int64,
           :duration_count, :int,
           :duration_error, [:double, (60*12+5)],
           :nb_decoded_frames, :int,
           :found_decoder, :int,
           :fps_first_dts, :int64,
           :fps_first_dts_idx, :int,
           :fps_last_dts, :int64,
           :fps_last_dts_idx, :int
    )
  end

  class AVStream < FFI::Struct
    layout(
           :index, :int,
           :id, :int,
           :codec, AVCodecContext.ptr,
           :r_frame_rate, AVRational.by_value,
           :priv_data, :pointer,
           :pts, AVFrac.by_value,
           :time_base, AVRational.by_value,
           :start_time, :int64,
           :duration, :int64,
           :nb_frames, :int64,
           :disposition, :int,
           :discard, AVDiscard,
           :sample_aspect_ratio, AVRational.by_value,
           :metadata, :pointer,
           :avg_frame_rate, AVRational.by_value,
           :attached_pic, AVPacket.by_value,
           :info, AVStreamInfo.ptr,
           :pts_wrap_bits, :int,
           :reference_dts, :int64,
           :first_dts, :int64,
           :cur_dts, :int64,
           :last_IP_pts, :int64,
           :last_IP_duration, :int,
           :probe_packets, :int,
           :codec_info_nb_frames, :int,
           :need_parsing, :int,
           :parser, AVCodecParserContext.ptr,
           :last_in_packet_buffer, AVPacketList.ptr,
           :probe_data, AVProbeData.by_value,
           :pts_buffer, [:int64, 16+1],
           :index_entries, AVIndexEntry.ptr,
           :nb_index_entries, :int,
           :index_entries_allocated_size, :uint,
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
  AVFMT_FLAG_GENPTS = 0x0001
  AVFMT_FLAG_IGNIDX = 0x0002
  AVFMT_FLAG_NONBLOCK = 0x0004
  AVFMT_FLAG_IGNDTS = 0x0008
  AVFMT_FLAG_NOFILLIN = 0x0010
  AVFMT_FLAG_NOPARSE = 0x0020
  AVFMT_FLAG_NOBUFFER = 0x0040
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
           :ctx_flags, :int,
           :nb_streams, :uint,
           :streams, :pointer,
           :filename, [:char, 1024],
           :start_time, :int64,
           :duration, :int64,
           :bit_rate, :int,
           :packet_size, :uint,
           :max_delay, :int,
           :flags, :int,
           :probesize, :uint,
           :max_analyze_duration, :int,
           :key, :pointer,
           :keylen, :int,
           :nb_programs, :uint,
           :programs, :pointer,
           :video_codec_id, :int,
           :audio_codec_id, :int,
           :subtitle_codec_id, :int,
           :max_index_size, :uint,
           :max_picture_buffer, :uint,
           :nb_chapters, :uint,
           :chapters, :pointer,
           :metadata, :pointer,
           :start_time_realtime, :int64,
           :fps_probe_size, :int,
           :error_recognition, :int,
           :interrupt_callback, AVIOInterruptCB.by_value,
           :debug, :int,
           :packet_buffer, AVPacketList.ptr,
           :packet_buffer_end, AVPacketList.ptr,
           :data_offset, :int64,
           :raw_packet_buffer, AVPacketList.ptr,
           :raw_packet_buffer_end, AVPacketList.ptr,
           :parse_queue, AVPacketList.ptr,
           :parse_queue_end, AVPacketList.ptr,
           :raw_packet_buffer_remaining_size, :int
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
  attach_function :av_find_input_format, :av_find_input_format, [ :string ], AVInputFormat.ptr
  attach_function :av_probe_input_format, :av_probe_input_format, [ AVProbeData.ptr, :int ], AVInputFormat.ptr
  attach_function :av_probe_input_format2, :av_probe_input_format2, [ AVProbeData.ptr, :int, :pointer ], AVInputFormat.ptr
  attach_function :av_probe_input_buffer, :av_probe_input_buffer, [ AVIOContext.ptr, :pointer, :string, :pointer, :uint, :uint ], :int
  attach_function :avformat_open_input, :avformat_open_input, [ :pointer, :string, AVInputFormat.ptr, :pointer ], :int
  attach_function :avformat_find_stream_info, :avformat_find_stream_info, [ AVFormatContext.ptr, :pointer ], :int
  attach_function :av_find_best_stream, :av_find_best_stream, [ AVFormatContext.ptr, :int, :int, :int, :pointer, :int ], :int
  attach_function :av_read_packet, :av_read_packet, [ AVFormatContext.ptr, AVPacket.ptr ], :int
  attach_function :av_read_frame, :av_read_frame, [ AVFormatContext.ptr, AVPacket.ptr ], :int
  attach_function :av_seek_frame, :av_seek_frame, [ AVFormatContext.ptr, :int, :int64, :int ], :int
  attach_function :avformat_seek_file, :avformat_seek_file, [ AVFormatContext.ptr, :int, :int64, :int64, :int64, :int ], :int
  attach_function :av_read_play, :av_read_play, [ AVFormatContext.ptr ], :int
  attach_function :av_read_pause, :av_read_pause, [ AVFormatContext.ptr ], :int
  attach_function :av_close_input_file, :av_close_input_file, [ AVFormatContext.ptr ], :void
  attach_function :avformat_close_input, :avformat_close_input, [ :pointer ], :void
  AVSEEK_FLAG_BACKWARD = 1
  AVSEEK_FLAG_BYTE = 2
  AVSEEK_FLAG_ANY = 4
  AVSEEK_FLAG_FRAME = 8
  attach_function :avformat_write_header, :avformat_write_header, [ AVFormatContext.ptr, :pointer ], :int
  attach_function :av_write_frame, :av_write_frame, [ AVFormatContext.ptr, AVPacket.ptr ], :int
  attach_function :av_interleaved_write_frame, :av_interleaved_write_frame, [ AVFormatContext.ptr, AVPacket.ptr ], :int
  attach_function :av_interleave_packet_per_dts, :av_interleave_packet_per_dts, [ AVFormatContext.ptr, AVPacket.ptr, AVPacket.ptr, :int ], :int
  attach_function :av_write_trailer, :av_write_trailer, [ AVFormatContext.ptr ], :int
  attach_function :av_guess_format, :av_guess_format, [ :string, :string, :string ], AVOutputFormat.ptr
  attach_function :av_guess_codec, :av_guess_codec, [ AVOutputFormat.ptr, :string, :string, :string, :int ], :int
  attach_function :av_hex_dump, :av_hex_dump, [ :pointer, :pointer, :int ], :void
  attach_function :av_hex_dump_log, :av_hex_dump_log, [ :pointer, :int, :pointer, :int ], :void
  attach_function :av_pkt_dump2, :av_pkt_dump2, [ :pointer, AVPacket.ptr, :int, AVStream.ptr ], :void
  attach_function :av_pkt_dump_log2, :av_pkt_dump_log2, [ :pointer, :int, AVPacket.ptr, :int, AVStream.ptr ], :void
  attach_function :av_codec_get_id, :av_codec_get_id, [ :pointer, :uint ], :pointer
  attach_function :av_codec_get_tag, :av_codec_get_tag, [ :pointer, :int ], :pointer
  attach_function :av_find_default_stream_index, :av_find_default_stream_index, [ AVFormatContext.ptr ], :int
  attach_function :av_index_search_timestamp, :av_index_search_timestamp, [ AVStream.ptr, :int64, :int ], :int
  attach_function :av_add_index_entry, :av_add_index_entry, [ AVStream.ptr, :int64, :int64, :int, :int, :int ], :int
  attach_function :av_url_split, :av_url_split, [ :string, :int, :string, :int, :string, :int, :pointer, :string, :int, :string ], :void
  attach_function :av_dump_format, :av_dump_format, [ AVFormatContext.ptr, :int, :string, :int ], :void
  attach_function :av_get_frame_filename, :av_get_frame_filename, [ :string, :int, :string, :int ], :int
  attach_function :av_filename_number_test, :av_filename_number_test, [ :string ], :int
  attach_function :av_sdp_create, :av_sdp_create, [ :pointer, :int, :string, :int ], :pointer
  attach_function :av_match_ext, :av_match_ext, [ :string, :string ], :int
  attach_function :avformat_query_codec, :avformat_query_codec, [ AVOutputFormat.ptr, :int, :int ], :int
  attach_function :avformat_get_riff_video_tags, :avformat_get_riff_video_tags, [  ], :pointer
  attach_function :avformat_get_riff_audio_tags, :avformat_get_riff_audio_tags, [  ], :pointer


  ffi_lib [ "libswscale.so.2", "libswscale.2.dylib" ]

  class SwsVector < FFI::Struct; end
  class SwsFilter < FFI::Struct; end
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
  attach_function :sws_isSupportedInput, :sws_isSupportedInput, [ :int ], :int
  attach_function :sws_isSupportedOutput, :sws_isSupportedOutput, [ :int ], :int
  attach_function :sws_alloc_context, :sws_alloc_context, [  ], :pointer
  attach_function :sws_init_context, :sws_init_context, [ :pointer, SwsFilter.ptr, SwsFilter.ptr ], :int
  attach_function :sws_freeContext, :sws_freeContext, [ :pointer ], :void
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
  attach_function :sws_getCachedContext, :sws_getCachedContext, [ :pointer, :int, :int, :int, :int, :int, :int, :int, SwsFilter.ptr, SwsFilter.ptr, :pointer ], :pointer
  attach_function :sws_convertPalette8ToPacked32, :sws_convertPalette8ToPacked32, [ :pointer, :pointer, :int, :pointer ], :void
  attach_function :sws_convertPalette8ToPacked24, :sws_convertPalette8ToPacked24, [ :pointer, :pointer, :int, :pointer ], :void
  attach_function :sws_get_class, :sws_get_class, [  ], :pointer

end
