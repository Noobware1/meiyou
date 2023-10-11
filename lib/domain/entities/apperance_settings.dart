import 'package:equatable/equatable.dart';

class ApperanceSettingsEntity extends Equatable {
  final int theme;
  final int themeMode;
  final bool isAmoledEnabled;

  const ApperanceSettingsEntity(
      {required this.theme,
      required this.themeMode,
      required this.isAmoledEnabled});

  @override
  List<Object?> get props => [theme, themeMode, isAmoledEnabled];
}
