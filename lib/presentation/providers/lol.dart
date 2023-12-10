
import 'package:meiyou/presentation/blocs/player/server_and_video_cubit.dart';
import 'package:meiyou_extenstions/models.dart';

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
            quality: VideoQuality.hlsMaster,
            title: null,
            isBackup: false,
          ),
          VideoSource(
            url:
                "https://www030.anifastcdn.info/videos/hls/upfeT_TNQu_DDdRquTwJiA/1701538434/103379/4b23f9372a28e885ad8f314c143399e4/ep.1.1677680964.m3u8",
            format: VideoFormat.hls,
            quality: VideoQuality.hlsMaster,
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

            quality: VideoQuality.hlsMaster,
            // quality: Instance of 'VideoQuality',
            title: null,
            isBackup: false,
          ),
          VideoSource(
            url:
                "https://www030.anifastcdn.info/videos/hls/M_eBro4xHgxtjEL7FEUxFw/1701538435/103379/4b23f9372a28e885ad8f314c143399e4/ep.1.1677680964.m3u8",
            format: VideoFormat.hls,

            quality: VideoQuality.hlsMaster,
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
