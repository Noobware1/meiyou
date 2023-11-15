class PluginEntity {
  final String name;

  final String source;
  final String version;
  final String? icon;
  final String? info;
  final bool lastUsed;
  final List<DependencyEntity>? dependencies;

  const PluginEntity({
    required this.name,
    required this.source,
    required this.version,
    required this.lastUsed,
    this.icon,
    this.info,
    this.dependencies,
  });

  static const none =
      PluginEntity(name: 'None', source: '', version: '', lastUsed: false);
}

class DependencyEntity {
  final String name;
  final String source;
  final String version;

  const DependencyEntity({
    required this.name,
    required this.source,
    required this.version,
  });
}
