import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, String content) => showDialog(
    context: context,
    builder: (context) {
      Future.delayed(const Duration(seconds: 4), () {
        Navigator.of(context).pop(true);
      });
      return AlertDialog(
        content: Text(content),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('OK'))
        ],
      );
    });