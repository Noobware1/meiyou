import 'package:meiyou_extensions_lib/models.dart';

class ExtensionList {
  final List<InstalledExtension> updates;
  final List<InstalledExtension> installed;
  final List<AvailableExtension> available;

  ExtensionList({
    required this.updates,
    required this.installed,
    required this.available,
  });

  bool get isEmpty => updates.isEmpty && installed.isEmpty && available.isEmpty;
}
