import 'package:flutter/material.dart';
import 'package:mathdz/components/save_button.dart';



// ignore: must_be_immutable
class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow[300],
      // ignore: sized_box_for_whitespace
      content: Container(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "أضف مهمة جديدة",
              ),
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                SaveButton(text: "الحفظ", onPressed: onSave),

                const SizedBox(width: 8),


                SaveButton(text: "الإلغاء", onPressed: onCancel),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
