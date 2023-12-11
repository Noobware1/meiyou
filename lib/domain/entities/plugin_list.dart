import 'package:meiyou_extenstions/models.dart';

class PluginListEntity {
  final int id;
  final String name;
  final List<OnlinePlugin> plugins;

  PluginListEntity(
      {required this.id, required this.name, required this.plugins});
}
