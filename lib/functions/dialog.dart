import 'package:flutter/material.dart';

Future<String?> showConfirmDialog(BuildContext context, String dispMessage) async{
  AlertDialog alertDialog = AlertDialog(
    title: const Text("Confirm"),
    content: Text(dispMessage),
    actions: [
      ElevatedButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop("cancel"),
          child: const Text("Cancel")),
      ElevatedButton(onPressed: () => Navigator.of(context, rootNavigator: true).pop("ok"),
          child: const Text("Delete")),
    ],
  );
  String? res = await showDialog<String?>(
      barrierDismissible: false,
      context: context,
      builder: (context) => alertDialog);
  return res;
}

void showSnackBar(BuildContext context, String message, int second){
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: second))
  );
}

bool isNumeric(String value) {
  final numericValue = num.tryParse(value);
  return numericValue != null;
}
