part of 'source_drop_down_bloc.dart';

sealed class SourceDropDownState extends Equatable {
  final BaseProvider provider;
  const SourceDropDownState(
    this.provider,
  );

  @override
  List<Object> get props => [
        provider,
        // searchResponses!
      ];
}

class SourceDropDownSelected extends SourceDropDownState {
  const SourceDropDownSelected(super.provider);
}
