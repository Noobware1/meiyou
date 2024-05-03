// ignore_for_file: constant_identifier_names

enum ExtensionType {
  Video,
  Manga,
  Novel;

  @override
  String toString() {
    switch (this) {
      case ExtensionType.Video:
        return 'video';
      case ExtensionType.Manga:
        return 'manga';
      case ExtensionType.Novel:
        return 'novel';
    }
  }

  T when<T>({
    required T Function() video,
    required T Function() manga,
    required T Function() novel,
  }) {
    switch (this) {
      case ExtensionType.Video:
        return video();
      case ExtensionType.Manga:
        return manga();
      case ExtensionType.Novel:
        return novel();
      default:
        throw invailedTypeError();
    }
  }

  ArgumentError invailedTypeError() =>
      ArgumentError.value(this, "type", "Invalid Extension Type");
}
