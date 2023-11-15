// import 'package:meiyou/data/models/episode.dart';
// import 'package:meiyou/data/models/media_details.dart';

// extension EpisodeUtils on List<Episode> {
//   bool isInRange(int index) {
//     if ((length - 1) <= index) return true;
//     return false;
//   }

//   void fill(int len, MediaDetails media) {
//     if (isEmpty) {
//       add(Episode(
//           number: 1,
//           thumbnail: media.bannerImage ?? media.poster,
//           title: 'Episode 1'));
//     }
//     var lastEpisodeNumber = last.number;
//     while (length < len) {
//       lastEpisodeNumber++;
//       add(Episode(
//           number: lastEpisodeNumber,
//           title: 'Episode $lastEpisodeNumber',
//           thumbnail: media.bannerImage ?? media.poster));
//       if (length == len) break;
//       continue;
//     }
//   }

//   List<Episode> fillMissingEpisode(MediaDetails media) {
//     sort((a, b) => a.number.compareTo(b.number));
//     final len = length;

//     final newData = <Episode>[first]; //stores new data

//     for (var i = 1; i < len; i++) {
//       var diff = this[i].number.toInt() - this[i - 1].number.toInt();

//       if (diff > 1) {
//         //there is gap here
//         var val = 0;
//         diff--;

//         for (var j = 0; j < diff; j++) {
//           val = this[i - 1].number.toInt() + j + 1;

//           newData.add(Episode(
//               number: val,
//               title: 'Episode $val',
//               thumbnail: media.bannerImage ?? media.poster));
//           // new_data.push('y')
//         }
//       }

//       //put current info after missing data was inserted
//       // new_number.push(numbers[i])
//       newData.add(this[i]);
//     }

//     return newData;
//   }
// }
