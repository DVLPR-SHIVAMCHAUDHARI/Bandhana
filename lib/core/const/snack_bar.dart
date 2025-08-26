import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'globals.dart';

import 'package:flutter/material.dart';

snackbar({color, title, message, ContentType type = ContentType.failure}) {
  return ScaffoldMessenger.of(appContext).showSnackBar(
    SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        color: color,
        title: title ?? 'Oops!',
        message:
            message ??
            'This is an example error message that will be shown in the body of snackbar!',

        contentType: type,
      ),
    ),
  );
}
