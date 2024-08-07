import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/features/home/presentation/screens/sources/sources_screen_view_model.dart';
import 'package:meiyou/features/home/presentation/widgets/base_browse_item.dart';
import 'package:meiyou/features/home/presentation/widgets/base_browse_list_view.dart';
import 'package:meiyou/shared/domain/models/source.dart';
import 'package:meiyou/shared/presentation/widgets/empty_screen.dart';
import 'package:meiyou/shared/presentation/widgets/image_holder.dart';
import 'package:meiyou/shared/presentation/widgets/state_listenable_builder.dart';

class SourcesScreen extends StatelessWidget {
  final SourcesScreenViewModel viewModel;

  const SourcesScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return StateListenableBuilder(
        stateListenable: viewModel.stateListenable,
        builder: (context, state, _) {
          if (state.sources.isEmpty) {
            return const EmptyScreen(
              text: 'No sources found',
            );
          }
          return BaseBrowseListView(
              group: state.sources,
              itemBuilder: (context, source) {
                return BaseBrowseItem(
                  actions: _actions(context, source),
                  name: source.name,
                  icon: _icon(source.icon),
                  onPressed: () {
                    viewModel.selectedSource(source);
                  },
                  onLongPress: () {},
                  subtitle: Text(source.version),
                );
              });
        });
  }

  Widget _icon(Uint8List? icon) {
    return ImageHolder.memory(
      height: 24,
      width: 24,
      bytes: icon,
    );
  }

  List<Widget> _actions(BuildContext context, InstalledSource source) {
    final (IconData icon, Color color) = source.pin == Pin.pinned
        ? (Icons.push_pin, context.theme.colorScheme.primary)
        : (Icons.push_pin_outlined, context.theme.colorScheme.onSurfaceVariant);

    return [
      IconButton(
        onPressed: () {
          viewModel.togglePin(source);
        },
        style: ButtonStyle(
          iconColor: WidgetStateProperty.all(color),
        ),
        icon: Icon(icon),
      ),
    ];
  }
}
