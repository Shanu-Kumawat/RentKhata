import 'package:flutter/material.dart';

/// Shows a non-dismissible loading overlay while executing an async action.
/// Useful for preventing rapid double-taps on buttons that generate PDFs or perform network requests.
Future<T> withLoadingOverlay<T>({
  required BuildContext context,
  required Future<T> Function() action,
}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );

  try {
    return await action();
  } finally {
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
