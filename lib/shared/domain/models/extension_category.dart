enum ExtensionCategory {
  video,
  manga,
  novel,
}

extension ExtensionCategoryWhen on ExtensionCategory {
  T when<T>({
    required T Function() video,
    required T Function() manga,
    required T Function() novel,
  }) {
    switch (this) {
      case ExtensionCategory.video:
        return video();
      case ExtensionCategory.manga:
        return manga();
      case ExtensionCategory.novel:
        return novel();
    }
  }
}
