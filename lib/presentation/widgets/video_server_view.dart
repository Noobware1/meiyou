// import 'package:flutter/material.dart';
// import 'package:streamify/helpers/data_classes.dart';
// import 'package:streamify/providers/base_parser.dart';
// import 'package:streamify/widgets/video_server_holder.dart';
// import 'package:streamify/providers/extractors/base_video_extractor.dart';

// class VideoServerHolderForAndroid extends StatefulWidget {
//   final List<VideoServer> servers;
//   // final EpisodeResponse? episodes;
//   // final BaseParser parser;
//   final String title;
//   // final void Function(List<VideoServerResponse> servers,
//   //     VideoServerResponse video, String title)? fun;
//   const VideoServerHolderForAndroid(
//       {super.key,
//       required this.servers,
//       // required this.parser,
//       required this.title});

//   @override
//   State<VideoServerHolderForAndroid> createState() =>
//       _VideoServerHolderForAndroidState();
// }

// class ServerWithExtractor {
//   final String server;
//   final VideoExtractor? extractor;

//   const ServerWithExtractor({required this.extractor, required this.server});
// }

// class _VideoServerHolderForAndroidState
//     extends State<VideoServerHolderForAndroid> {
//   final Set<VideoServerResponse> servers = {};

//   void _navigate(
//       List<VideoServerResponse> servers, VideoServerResponse server) {
//     Navigator.pop(context);
//     // Navigator.of(context).push(MaterialPageRoute(
//     //     builder: (context) => OkVideoPlayer(
//     //           title: widget.title,
//     //           selectedServer: server,
//     //           //videoFile: servers[index].video,
//     //           servers: servers,
//     //           episodes: widget.episodes,
//     //         )));
//     Future.delayed(const Duration(milliseconds: 700));
//   }

//   @override
//   void initState() {
//     super.initState();
//     //loadFirstServer = widget.loadFirstServer;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: List.generate(widget.servers.length, (i) {
//         return LazyLoadServer(
//             server: widget.servers[i],
//             servers: servers,
//             // episodes: widget.episodes,
//             callback: (server) {
//               // if (widget.fun != null) {
//               // widget.fun!(servers.toList(), server, widget.title);
//               Navigator.pop(context);
//               // } else {
//               //   _navigate(servers.toList(), server);
//               // }
//             },
//             provider: widget.parser);
//       })
//         ..add(const SizedBox(
//           height: 60,
//         )),
//     );
//   }
// }

// class LazyLoadServer extends StatefulWidget {
//   final VideoServer server;
//   final Set<VideoServerResponse> servers;
//   // final EpisodeResponse? episodes;
//   final BaseParser provider;
//   final void Function(VideoServerResponse selected) callback;
//   // final void Function(List<VideoServerResponse> servers,
//   //     VideoServerResponse video, String title)? fun;
//   const LazyLoadServer(
//       {super.key,
//       required this.callback,
//       // required this.episodes,
//       required this.server,
//       required this.servers,
//       //    this.fun,
//       required this.provider});

//   @override
//   State<LazyLoadServer> createState() => _LazyLoadServerState();
// }

// class _LazyLoadServerState extends State<LazyLoadServer> {
//   late final Future<VideoFile?>? video;

//   @override
//   void initState() {
//     super.initState();
//     video = widget.provider.loadVideoExtractor(widget.server)?.extractor();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: video,
//         builder: (context, snapshot) {
//           if (snapshot.data != null &&
//               snapshot.hasData &&
//               snapshot.connectionState == ConnectionState.done &&
//               snapshot.data!.data.isNotEmpty) {
//             final response = VideoServerResponse(
//                 name: widget.server.name, video: snapshot.data!);
//             widget.servers.add(response);
//             return Padding(
//               padding:
//                   const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 30),
//               child: VideoServerHolder(
//                   width: MediaQuery.of(context).size.width,
//                   onTap: () {
//                     widget.callback(response);
//                   },
//                   video: snapshot.data!,
//                   serverName: widget.server.name),
//             );
//           } else if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Padding(
//               padding: EdgeInsets.only(bottom: 30.0),
//               child: Center(
//                   child: SizedBox(
//                 height: 40,
//                 width: 40,
//                 child: CircularProgressIndicator(),
//               )),
//             );
//           } else {
//             return const SizedBox.shrink();
//           }
//         });
//   }
// }
