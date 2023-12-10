import 'package:meiyou/data/models/extracted_video_data.dart';
import 'package:meiyou/presentation/blocs/player/server_and_video_cubit.dart';
import 'package:meiyou_extenstions/models.dart';

final videos = [
  ExtractedVideoData(
      link: ExtractorLink(
          url:
              'https://goone.pro/streaming.php?id=MjE2ODE2&title=One+Piece+Episode+1087',
          name: 'Vidstreaming'),
      video: Video(
        videoSources: [
          VideoSource(
              url:
                  'https://www047.vipanicdn.net/streamhls/0b594d900f47daabc194844092384914/ep.1087.1702175315.m3u8',
              format: VideoFormat.hls,
              quality: VideoQuality.hlsMaster,
              isBackup: false,
              title: null),
          VideoSource(
              url:
                  'https://www047.anifastcdn.info/videos/hls/FrhjCNixVr3O7Nj-2WfbBw/1702237032/216816/0b594d900f47daabc194844092384914/ep.1087.1702175315.m3u8',
              format: VideoFormat.hls,
              quality: VideoQuality.hlsMaster,
              isBackup: true,
              title: null)
        ],
        subtitles: null,
        extra: null,
        headers: {'referer': 'https://goone.pro'},
      )),
  ExtractedVideoData(
      link: ExtractorLink(
          url:
              'https://goone.pro/embedplus?id=MjE2ODQw&token=0zN2p1u-aaZfg3p-uMHyew&expires=1702230000',
          name: 'Gogo Server'),
      video: Video(
          videoSources: [
            VideoSource(
                url:
                    'https://vipanicdn.net/093997b0a3046470bdf294d6575e93edce3d94d2464fe331996d922afcbf78cfaa396492cd2dfd0741f728c712d6dfcfb63865f2ee1e595ae5dec89220318e9ebbb21f28b43e8501b34d4c43eb425ae571d46130b114835e51fe4a3eb7a4231f4b120ab9aa197424f070a151b0305906ea84924b139a4654ddcc9c9cb165f569/8ef9b82f08b01fe2c3728600ddee8b7c/boushoku-no-berserk-episode-11-1702222143.original.m3u8',
                format: VideoFormat.hls,
                quality: VideoQuality.hlsMaster,
                isBackup: false,
                title: null),
            VideoSource(
                url:
                    'https://vipanicdn.net/stream/8ef9b82f08b01fe2c3728600ddee8b7c/boushoku-no-berserk-episode-11-1702222143.original.m3u8',
                format: VideoFormat.hls,
                quality: VideoQuality.hlsMaster,
                isBackup: true,
                title: null)
          ],
          subtitles: null,
          extra: null,
          headers: {'referer': 'https://goone.pro'}))
];
