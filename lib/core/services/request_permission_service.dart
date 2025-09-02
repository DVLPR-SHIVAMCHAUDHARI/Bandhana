import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestPermission {
  Future<void> showPermissionDialog(BuildContext context, String title) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("$title Permission Required"),
        content: Text(
          "Please enable $title permission from settings to continue.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings(); // Opens system Settings
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }
}
