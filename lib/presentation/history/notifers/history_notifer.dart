import 'dart:async';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:meiyou/domain/models/history.dart';
import 'package:meiyou/notifers/async_notifer.dart';

class HistoryNotifer extends AsyncStateNotifier<Map<String, List<History>>> {
  late final StreamSubscription<List<History>> _subscription;

  HistoryNotifer(Stream<List<History>> stream) : super.loading() {
    _subscription = stream.listen((history) {
      setData(groupBy(history, (e) => _formatRelativeTime(e.lastSeen)));
    });
  }

  @override
  FutureOr<void> onDispose() async {
    await _subscription.cancel();
    await super.onDispose();
  }

  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays > 1 && difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      // For dates older than 7 days, format as MM/dd/yyyy
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(dateTime);
    }
  }
}
