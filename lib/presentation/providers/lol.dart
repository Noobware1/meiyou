import 'package:meiyou/data/models/extractor_link.dart';
import 'package:meiyou/data/models/media/video/video.dart';
import 'package:meiyou/data/models/media/video/video_format.dart';
import 'package:meiyou/data/models/media/video/video_quailty.dart';
import 'package:meiyou/data/models/media/video/video_source.dart';
import 'package:meiyou/domain/entities/media_type.dart';
import 'package:meiyou/presentation/blocs/player/server_and_video_cubit.dart';

final videos = [
  ExtractedVideoData(
      link: ExtractorLink(
        name: 'VidStreaming',
        url:
            'https://goone.pro/streaming.php?id=MTAzMzc5&title=Darling+in+the+FranXX+Episode+1',
        headers: null,
        referer: null,
        extra: null,
      ),
      video: Video(
        videoSources: [
          VideoSource(
            url:
                "https://www030.vipanicdn.net/streamhls/4b23f9372a28e885ad8f314c143399e4/ep.1.1677680964.m3u8",
            format: VideoFormat.hls,
            quality: VideoQuality.hls,
            title: null,
            isBackup: false,
          ),
          VideoSource(
            url:
                "https://www030.anifastcdn.info/videos/hls/upfeT_TNQu_DDdRquTwJiA/1701538434/103379/4b23f9372a28e885ad8f314c143399e4/ep.1.1677680964.m3u8",
            format: VideoFormat.hls,
            quality: VideoQuality.hls,
            title: null,
            isBackup: false,
          )
        ],
        subtitles: null,
        extra: null,
        headers: {"referer": "https://goone.pro"},
      )),
  ExtractedVideoData(
      link: ExtractorLink(
        name: "Gogo server",
        url:
            "https://goone.pro/embedplus?id=MTAzMzc5&token=UJw1L8vtNyUcQ8qD4KewHw&expires=1701531233",
        headers: null,
        referer: null,
        extra: null,
      ),
      video: Video(
        videoSources: [
          VideoSource(
            url:
                "https://www030.vipanicdn.net/streamhls/4b23f9372a28e885ad8f314c143399e4/ep.1.1677680964.m3u8",
            format: VideoFormat.other,

            quality: VideoQuality.hls,
            // quality: Instance of 'VideoQuality',
            title: null,
            isBackup: false,
          ),
          VideoSource(
            url:
                "https://www030.anifastcdn.info/videos/hls/M_eBro4xHgxtjEL7FEUxFw/1701538435/103379/4b23f9372a28e885ad8f314c143399e4/ep.1.1677680964.m3u8",
            format: VideoFormat.hls,

            quality: VideoQuality.hls,
            // quality: Instance of 'VideoQuality',
            title: null,
            isBackup: false,
          )
        ],
        subtitles: null,
        extra: null,
        headers: {"referer": "https://goone.pro"},
      ))
];
