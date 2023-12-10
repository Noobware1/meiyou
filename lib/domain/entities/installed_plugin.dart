class InstalledPluginEntity {
  const InstalledPluginEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.author,
    required this.description,
    required this.lang,
    required this.baseUrl,
    required this.version,
    required this.updateurl,
    required this.savedPath,
    required this.sourceCodePath,
    required this.iconPath,
    required this.lastUsed,
  });

  final int id;
  final String name;
  final String type;
  final String author;
  final String description;
  final String lang;
  final String baseUrl;
  final String version;
  final String updateurl;
  final String savedPath;
  final String sourceCodePath;
  final String iconPath;
  final bool lastUsed;

  static const none = InstalledPluginEntity(
    id: 0,
    name: 'None',
    type: '',
    author: '',
    description: '',
    lang: '',
    baseUrl: '',
    version: '',
    updateurl: '',
    savedPath: '',
    sourceCodePath: '',
    iconPath: '',
    lastUsed: false,
  );
}
