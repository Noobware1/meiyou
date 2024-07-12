import 'package:flutter/material.dart';
import 'package:meiyou/domain/category/model/category.dart';
import 'package:meiyou/presentation/core/space.dart';

class CategoryListItem extends StatelessWidget {
  const CategoryListItem({
    super.key,
    required this.category,
    required this.moveUpEnabled,
    required this.onMoveup,
    required this.moveDownEnabled,
    required this.onMoveDown,
    required this.onToggleVisibility,
    required this.onEdit,
    required this.onDelete,
  });

  final Category category;
  final bool moveUpEnabled;
  final bool moveDownEnabled;
  final void Function(Category) onMoveup;
  final void Function(Category) onMoveDown;
  final void Function(Category) onToggleVisibility;
  final void Function(Category) onEdit;
  final void Function(Category) onDelete;

  @override
  Widget build(BuildContext context) {
    // final colors = context.theme.colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      // decoration: BoxDecoration(
      //   color: ElevationOverlay.applySurfaceTint(
      //       colors.surface, colors.surfaceTint, 3.0),
      //   // border: Border.all(color: context.theme.primaryColor),
      // ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            clipBehavior: Clip.hardEdge,
            type: MaterialType.transparency,
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                onEdit(category);
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                child: Row(
                  children: [
                    const Icon(Icons.label_outline),
                    const HorizontalSpace(18),
                    Expanded(child: Text(category.name))
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                  onPressed: !moveUpEnabled
                      ? null
                      : () {
                          onMoveup(category);
                        },
                  icon: const Icon(Icons.arrow_drop_up)),
              IconButton(
                  onPressed: !moveDownEnabled
                      ? null
                      : () {
                          onMoveDown(category);
                        },
                  icon: const Icon(Icons.arrow_drop_down)),
              const Spacer(),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        onEdit(category);
                      },
                      icon: const Icon(Icons.edit_outlined)),
                  IconButton(
                    onPressed: () {
                      onToggleVisibility(category);
                    },
                    icon: Icon(category.hidden
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                  ),
                  IconButton(
                      onPressed: () {
                        onDelete(category);
                      },
                      icon: const Icon(Icons.delete_outline)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
