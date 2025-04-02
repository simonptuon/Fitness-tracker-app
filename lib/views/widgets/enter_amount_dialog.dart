import 'package:flutter/material.dart';

class EnterAmountDialog extends StatelessWidget {
  final Function(int) onConfirm;

  const EnterAmountDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Image.asset(
              'assets/cup.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Enter mL",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final int? enteredAmount = int.tryParse(controller.text);
                  if (enteredAmount != null && enteredAmount > 0) {
                    onConfirm(enteredAmount); // Pass the entered amount back
                    Navigator.of(context).pop(); // Close the dialog
                  }
                },
                child: const Text("OK"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
