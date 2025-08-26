import 'package:bandhana/core/const/app_colors.dart';
import 'package:flutter/material.dart';

class MultiSelectDropdown extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;
  final String hintText;
  final ValueChanged<List<String>> onChanged;

  const MultiSelectDropdown({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    this.hintText = "Select options",
  });

  @override
  State<MultiSelectDropdown> createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  void _openMultiSelectDialog() async {
    // create a temporary selection copy
    List<String> tempSelected = List.from(widget.selectedItems);

    final List<String>? results = await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(widget.hintText),
              content: SingleChildScrollView(
                child: Column(
                  children: widget.items.map((item) {
                    final isSelected = tempSelected.contains(item);
                    return CheckboxListTile(
                      checkColor: Colors.white,
                      activeColor: AppColors.primary,
                      value: isSelected,
                      title: Text(item),
                      onChanged: (checked) {
                        setStateDialog(() {
                          if (checked == true) {
                            tempSelected.add(item);
                          } else {
                            tempSelected.remove(item);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, tempSelected),
                  child: Text("OK", style: TextStyle(color: AppColors.white)),
                ),
              ],
            );
          },
        );
      },
    );

    if (results != null) {
      widget.onChanged(results);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openMultiSelectDialog,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            ...widget.selectedItems.isEmpty
                ? [
                    Chip(
                      color: WidgetStatePropertyAll(AppColors.primaryOpacity),

                      label: Text('Select'),
                    ),
                  ]
                : widget.selectedItems.map((e) {
                    return Chip(
                      color: WidgetStatePropertyAll(AppColors.primaryOpacity),
                      label: Text(e),

                      deleteIcon: Icon(Icons.close, size: 18),
                      onDeleted: () {
                        final newList = List<String>.from(widget.selectedItems)
                          ..remove(e);
                        widget.onChanged(newList);
                      },
                    );
                  }).toList(),
            widget.selectedItems.isNotEmpty
                ? Chip(
                    color: WidgetStatePropertyAll(AppColors.primaryOpacity),

                    label: Text('Select More +'),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
