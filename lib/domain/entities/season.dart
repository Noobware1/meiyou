import 'package:equatable/equatable.dart';

class SeasonEntity extends Equatable {
  final num number;
  final int? id;
  final String? title;
  final String? url;
  final DateTime? airDate;
  final int? totalEpisode;

  final bool? isOnGoing;

  const SeasonEntity(
      {required this.number,
      this.id,
      this.title,
      this.url,
      this.totalEpisode,
      this.airDate,
      this.isOnGoing});

  @override
  List<Object?> get props => [number, id, title, url, airDate, isOnGoing];
}
