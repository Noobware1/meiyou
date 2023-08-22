import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamify/helpers/color_from_theme.dart';
import 'package:streamify/notifers/search_response_notifer.dart';
import 'package:streamify/providers/meta_providers/models/main_api_models.dart';
import 'package:streamify/providers/providers.dart';

class MyCoolSearchBar extends StatefulWidget {
  final void Function(String value) callback;
  final String? initialText;
  // final MediaDetails? mediaDetails;
  const MyCoolSearchBar({super.key, this.initialText, required this.callback});

  @override
  State<MyCoolSearchBar> createState() => _MyCoolSearchBarState();
}

class _MyCoolSearchBarState extends State<MyCoolSearchBar> {
  Color color = Colors.grey;

  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.initialText ?? 'Search...');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Container(
        height: 60,
        padding: const EdgeInsets.only(left: 30, right: 10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: getPrimaryColor(context), width: 2)),
        child: TextField(
          controller: controller,
          onSubmitted: (value) => widget.callback.call(value),
          style: const TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: GestureDetector(
                onTap: () => widget.callback.call(controller.value.text),
                child: const Icon(
                  Icons.search,
                  size: 32,
                  color: Colors.white,
                ),
              )),
        ),
      ),
    );
  }

  void _changeColor(BuildContext context) {
    setState(() {
      color = getPrimaryColor(context);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
