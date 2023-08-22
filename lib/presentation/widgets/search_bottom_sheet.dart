import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:streamify/helpers/data_classes.dart';
// import 'package:streamify/notifers/search_response_notifer.dart';
// import 'package:streamify/notifers/watch_notifer.dart';
import 'package:streamify/providers/base_parser.dart';
// import 'package:streamify/providers/meta_providers/models/main_api_models.dart';
import 'package:streamify/utils/check_connection_state.dart';
import 'package:streamify/widgets/add_space.dart';
import 'package:streamify/widgets/image_view/image_button_wrapper.dart';
import 'package:streamify/widgets/image_view/image_holder.dart';
import 'package:streamify/widgets/perfect_loading_indicator.dart';
import 'package:streamify/widgets/search_bar.dart';

class SearchBottomSheet extends StatefulWidget {
  final Future<List<SearchResponse>?> future;
  final SearchResponse? selected;
  final void Function(Future<List<SearchResponse>?> future) onFutureChanged;
  final void Function(SearchResponse searchResponse) onSelected;
  final BaseParser parser;
  final String? text;

  const SearchBottomSheet({
    super.key,
    this.text,
    required this.parser,
    this.selected,
    required this.future,
    required this.onFutureChanged,
    required this.onSelected,
  });

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  late Future<List<SearchResponse>?> future;

  @override
  void initState() {
    future = widget.future;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        addVerticalSpace(10),
        MyCoolSearchBar(
          callback: (String query) {
            setState(() {
              future = widget.parser.search(query);
            });
            widget.onFutureChanged.call(future);
          },
          initialText: widget.text,
        ),
        addVerticalSpace(50),
        FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (waiting(snapshot)) {
                return const SizedBox(
                    height: 200,
                    child: Center(child: PerfectLoadingIndicator()));
              } else if (done(snapshot)) {
                return Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                        runSpacing: 40,
                        spacing: 20,
                        children: _generateList(snapshot.data!, context)),
                  ),
                );
              } else {
                return addVerticalSpace(50);
              }
            }),
        addVerticalSpace(50)
      ],
    );
  }

  List<Widget> _generateList(
      List<SearchResponse> responses, BuildContext context) {
    return List.generate(responses.length, (index) {
      final response = responses[index];
      return ImageButtonWrapper(
          onTap: () {
            if (widget.selected != responses[index]) {
              widget.onSelected(responses[index]);
            }
            Navigator.pop(context);
          },
          child: ImageHolder.withText(
              imageUrl: response.cover, text: response.title));
    });
  }
}
