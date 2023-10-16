import 'package:flutter_bloc/flutter_bloc.dart';

extension BlocUtils<Event, State> on Bloc<Event, State> {
  void addIf(bool condition, Event event) {
    if (condition) {
      add(event);
    }
  }
}
