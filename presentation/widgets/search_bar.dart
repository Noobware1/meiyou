import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';

class CustomSearchBar extends StatefulWidget {
  final void Function(String query) onSearch;
  final String? hint;
  const CustomSearchBar({super.key, required this.onSearch, this.hint});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.hint);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 8),
      child: Card(
        elevation: 5,
        shape: const StadiumBorder(),
        child: TextField(
          controller: _controller,
          onSubmitted: widget.onSearch,
          decoration: InputDecoration(
            // prefixIconColor: Colors.blue,
            filled: true,
            fillColor: context.theme.colorScheme.background,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            // enabledBorder: ,
            constraints: BoxConstraints(
              maxWidth: width / 1.2,
            ),
            prefixIcon: IconButton(
                disabledColor: Colors.grey,
                icon: const Icon(Icons.search),
                onPressed: () => widget.onSearch(_controller.text)),
            // hintText: _controller.text,
            suffixIcon: IconButton(
              onPressed: () {
                _controller.clear();
              },
              icon: const Icon(Icons.clear),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
