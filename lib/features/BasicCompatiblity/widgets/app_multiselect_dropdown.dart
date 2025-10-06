import 'package:MilanMandap/core/const/app_colors.dart';
import 'package:flutter/material.dart';

class MultiSelectDropdown extends FormField<List<String>> {
  MultiSelectDropdown({
    super.key,
    required List<String> items,
    required List<String> selectedItems,
    required ValueChanged<List<String>> onChanged,
    String hintText = "Select options",
    bool isRequired = false,
  }) : super(
         initialValue: selectedItems,
         validator: isRequired
             ? (value) {
                 if (value == null || value.isEmpty) {
                   return "This field is required";
                 }
                 return null;
               }
             : null,
         builder: (FormFieldState<List<String>> state) {
           void openMultiSelectDialog(BuildContext context) async {
             List<String> tempSelected = List.from(state.value ?? []);

             final List<String>? results = await showDialog(
               context: context,
               builder: (context) {
                 return StatefulBuilder(
                   builder: (context, setStateDialog) {
                     return AlertDialog(
                       title: Text(hintText),
                       content: SingleChildScrollView(
                         child: Column(
                           children: items.map((item) {
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
                           onPressed: () =>
                               Navigator.pop(context, tempSelected),
                           child: Text(
                             "OK",
                             style: TextStyle(color: AppColors.white),
                           ),
                         ),
                       ],
                     );
                   },
                 );
               },
             );

             if (results != null) {
               state.didChange(results);
               onChanged(results);
             }
           }

           return InkWell(
             onTap: () => openMultiSelectDialog(state.context),
             child: InputDecorator(
               decoration: InputDecoration(
                 labelText: hintText,
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(12),
                 ),
                 errorText: state.errorText,
               ),
               child: Wrap(
                 spacing: 8,
                 runSpacing: 4,
                 children: [
                   if (state.value == null || state.value!.isEmpty)
                     Chip(
                       label: const Text("Select"),
                       backgroundColor: AppColors.primaryOpacity,
                     )
                   else ...[
                     ...state.value!.map((e) {
                       return Chip(
                         label: Text(e),
                         backgroundColor: AppColors.primaryOpacity,
                         deleteIcon: const Icon(Icons.close, size: 18),
                         onDeleted: () {
                           final newList = List<String>.from(state.value!)
                             ..remove(e);
                           state.didChange(newList);
                           onChanged(newList);
                         },
                       );
                     }),

                     /// ✅ Make "Select More +" clickable
                     ActionChip(
                       label: const Text("Select More +"),
                       backgroundColor: AppColors.primaryOpacity,
                       onPressed: () => openMultiSelectDialog(state.context),
                     ),
                   ],
                 ],
               ),
             ),
           );
         },
       );
}
