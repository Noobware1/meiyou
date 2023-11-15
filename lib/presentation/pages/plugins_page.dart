import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extenstions/async_snapshot.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/domain/entities/plugin.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';
import 'package:meiyou/domain/usecases/plugin_repository/get_installed_plugins_usecase.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';

class PluginsPage extends StatefulWidget {
  const PluginsPage({super.key});

  @override
  State<PluginsPage> createState() => _PluginsPageState();
}

class _PluginsPageState extends State<PluginsPage> {
  bool isSame(PluginEntity p, PluginEntity p1) {
    if ((p.name.hashCode + p.version.hashCode) ==
        (p1.name.hashCode + p1.version.hashCode)) {
      return true;
    }
    return false;
  }

  static const _textStyle =
      TextStyle(fontWeight: FontWeight.w600, fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: context.repository<PluginRepository>().getAllPlugins(),
          builder: (context, snapshot) {
            return snapshot.when(
                data: (data) {
                  return SizedBox(
                    height: context.screenHeight,
                    child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Column(
                              children: [
                                Text(data[index].type.toUpperCase()),
                                addVerticalSpace(10),
                                ..._buildListView(data[index].plugins)
                              ],
                            ),
                          );
                        },
                        itemCount: data.length),
                  );
                },
                error: (e) => Center(child: Text(e.toString())),
                loading: () => Center(child: CircularProgressIndicator()));
          }),
    );
  }

  List<Widget> _buildListView(List<PluginEntity> data) {
    return List.generate(data.length, (index) {
      return Row(
        children: [
          CachedNetworkImage(
              imageUrl: data[index].icon ?? '',
              height: 50,
              width: 50,
              fit: BoxFit.fill,
              errorWidget: (context, e, s) {
                return Image.asset(
                  'assets/images/default-poster.jpg',
                  height: 50,
                  width: 50,
                  fit: BoxFit.fill,
                );
              }),
          addHorizontalSpace(20),
          Text(
            data[index].name,
            style: _textStyle,
          )
        ],
      );
    });
  }
}
