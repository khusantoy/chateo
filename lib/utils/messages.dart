import 'package:flutter/material.dart';

class Messages {
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      },
    );
  }
}
