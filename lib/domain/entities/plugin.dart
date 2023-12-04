

class PluginEntity {
  final int id;
  final String name;

  final String source;
  final String version;
  final String? icon;
  final String? info;
  final bool lastUsed;
  final bool installed;
  final List<DependencyEntity>? dependencies;

  const PluginEntity({
    required this.id,
    required this.name,
    required this.source,
    required this.version,
    required this.lastUsed,
    required this.installed,
    this.icon,
    this.info,
    this.dependencies,
  });

  static const none = PluginEntity(
      id: -1,
      name: 'None',
      source: '',
      version: '',
      lastUsed: false,
      installed: true);
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
