part of 'source_drop_down_bloc.dart';

sealed class SourceDropDownEvent extends Equatable {
  final BaseProvider provider;

  const SourceDropDownEvent({
    required this.provider,
  });

  @override
  List<Object> get props => [
        provider,
      ];
}

class SourceDropDownOnSelected extends SourceDropDownEvent {
  const SourceDropDownOnSelected({
    required super.provider,
  });
}
