import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:injecktor/injecktor.dart';

import 'package:meiyou_extensions_lib/preference.dart';
import 'package:meiyou/core/utils/resources/storage/storage_preferences.dart';
import 'package:meiyou/presentation/onboard/steps/onboarding_step.dart';
import 'package:meiyou/presentation/core/button.dart';
import 'package:meiyou/presentation/core/space.dart';

class StorageStep implements OnBoardingStep {
  StorageStep(this.listener);

  bool _isCompleted = false;

  @override
  bool get isCompleted => _isCompleted;

  void _onComplete(bool isCompleted) {
    _isCompleted = isCompleted;
    listener();
  }

  @override
  final VoidCallback listener;

  @override
  StorageStepWidget build(BuildContext context) =>
      StorageStepWidget(onCompleted: _onComplete);
}

class StorageStepWidget extends OnBoardingStepWidget {
  const StorageStepWidget({super.key, required super.onCompleted});

  @override
  State<StorageStepWidget> createState() => _StorageStepState();
}

class _StorageStepState extends State<StorageStepWidget> {
  late Preference<String> storagePref;

  @override
  void initState() {
    storagePref = InjectKtor.get<StoragePreferences>().baseStorageDirectory();
    super.initState();
  }

  void onSelected(BuildContext context) {
    FilePicker.platform.getDirectoryPath().then((path) {
      if (path != null) {
        storagePref.set(path);
        widget.onCompleted!(storagePref.isSet());
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var selectedPath = storagePref.get();
    if (selectedPath == StoragePreferences.NOTSET) {
      selectedPath = "No storage location selected";
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select a folder where Meiyou will store your library, downloads, backups and more.\n\nA dedicated folder is recommended.\n\nSelected folder: $selectedPath',
        ),
        const VerticalSpace(10),
        Button(
          text: 'Select a folder',
          onPressed: () => onSelected(context),
        )
      ],
    );
  }
}
