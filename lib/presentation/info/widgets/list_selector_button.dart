part of 'package:meiyou/presentation/info/content_widget/content_widget.dart';

class ListSelector extends StatefulWidget {
  const ListSelector({
    super.key,
    required this.onSelected,
    required this.keys,
    required this.selected,
  });
  final int selected;
  final void Function(int index) onSelected;
  final List<String> keys;

  @override
  State<ListSelector> createState() => _ListSelectorState();
}

class _ListSelectorState extends State<ListSelector> {
  late final ScrollController? _controller;

  static const animationDuration = Duration(milliseconds: 200);

  @override
  void initState() {
    if (!isMobile) {
      _controller = ScrollController();
    } else {
      _controller = null;
    }
    super.initState();
  }

  Widget _buildSrollBar({required Widget child}) {
    if (isMobile) return child;
    return ScrollbarTheme(
      data: const ScrollbarThemeData(
        thumbColor: MaterialStatePropertyAll(Colors.grey),
      ),
      child: Scrollbar(
        controller: _controller,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40,
        width: context.width,
        child: _buildSrollBar(
          child: ListView.separated(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, i) => const HorizontalSpace(10),
            itemCount: widget.keys.length,
            itemBuilder: (context, index) {
              final isNotSelected = widget.selected != index;
              return Material(
                color: isNotSelected
                    ? context.theme.colorScheme.background
                    : context.theme.colorScheme.primary,
                animationDuration: animationDuration,
                borderRadius: BorderRadius.circular(15),
                child: InkWell(
                  splashColor: context.theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    if (isNotSelected) {
                      widget.onSelected(index);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: isNotSelected
                              ? Colors.grey
                              : context.theme.colorScheme.primary,
                          width: 2),
                    ),
                    child: Text(widget.keys[index],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
