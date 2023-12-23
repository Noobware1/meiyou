import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/assets.dart';
import 'package:meiyou/core/resources/platform_check.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/domain/entities/installed_plugin.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou_extensions_lib/extenstions.dart';
import 'package:meiyou_extensions_lib/models.dart';


const _defaultPadding = EdgeInsets.fromLTRB(20, 10, 20, 15);


class PluginWidget<P> extends StatefulWidget {
  final P plugin;
  final AsyncCallback onTap;
  final String? version;
  final String buttonText;
  final bool showChanges;
  final AsyncCallback? onCancel;
  const PluginWidget(
      {super.key,
      required this.plugin,
      required this.onTap,
      required this.buttonText,
      this.version,
      this.showChanges = true,
      this.onCancel});

  static const _textStyle =
      TextStyle(fontWeight: FontWeight.w600, fontSize: 18);

  static const _textStyleMobile =
      TextStyle(fontWeight: FontWeight.w600, fontSize: 15);

  @override
  State<PluginWidget> createState() => _PluginWidgetState();
}

class _PluginWidgetState extends State<PluginWidget> {
  static const _iconSize = 35.0;

  Widget _defaultAssestImage() {
    return Image.asset(
      defaultposterImage,
      height: _iconSize,
      width: _iconSize,
      fit: BoxFit.fill,
    );
  }

  Widget _buildImage(String? icon) {
    if (icon == null) return _defaultAssestImage();
    if (icon.startsWith('http')) {
      return CachedNetworkImage(
          imageUrl: icon,
          height: _iconSize,
          width: _iconSize,
          fit: BoxFit.fill,
          errorWidget: (context, e, s) {
            print('$e\n$s');
            return _defaultAssestImage();
          });
    } else {
      return Image.file(
        File(icon),
        height: _iconSize,
        width: _iconSize,
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) => _defaultAssestImage(),
      );
    }
  }

  bool showChanges = false;

  @override
  Widget build(BuildContext context) {
    final textStyle =
        isMobile ? PluginWidget._textStyleMobile : PluginWidget._textStyle;
    return Padding(
      padding: _defaultPadding,
      child: Row(
        children: [
          _buildImage(widget.plugin is OnlinePlugin
              ? (widget.plugin as OnlinePlugin).iconUrl
              : (widget.plugin as InstalledPluginEntity).iconPath),
          addHorizontalSpace(20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.plugin.name,
                style: textStyle,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    (widget.plugin is OnlinePlugin
                            ? (widget.plugin as OnlinePlugin).lang
                            : (widget.plugin as InstalledPluginEntity).lang)
                        .toUpperCaseFirst(),
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  addHorizontalSpace(5),
                  Text(
                    widget.version ??
                        'v${widget.plugin is OnlinePlugin ? (widget.plugin as OnlinePlugin).version : (widget.plugin as InstalledPluginEntity).version}',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: widget.showChanges && showChanges
                      ? const Stack(alignment: Alignment.center, children: [
                          Icon(Icons.arrow_downward_rounded),
                          SizedBox(
                              height: _iconSize,
                              width: _iconSize,
                              child: CircularProgressIndicator()),
                        ])
                      : InkWell(
                          borderRadius: BorderRadius.circular(15),
                          splashColor: context.theme.colorScheme.primary,
                          onTap: () {
                            if (widget.showChanges) {
                              setState(() => showChanges = true);
                              widget.onTap().then((value) =>
                                  setState(() => showChanges = false));
                            } else {
                              widget.onTap();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(widget.buttonText,
                                style: textStyle.copyWith(
                                  color: context.theme.colorScheme.primary,
                                )),
                          ),
                        ))),
        ],
      ),
    );
  }
}
