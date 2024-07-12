import 'package:meiyou/shared/domain/models/extension_category.dart';

class NoExtensionFoundException implements Exception {
  NoExtensionFoundException(this.category);

  final ExtensionCategory category;

  @override
  String toString() {
    return 'NoExtensionFoundException: No extension found for $category';
  }
}
