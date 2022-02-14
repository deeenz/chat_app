import 'package:chat_app/ui/shared/colors.dart';
import 'package:flutter/material.dart';


showSnackbar(BuildContext context, String title, {Duration? duration}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    
    SnackBar(
      backgroundColor: mainColor,
      content: Text(
        title,
        style:const TextStyle(color: white),
      ),
      behavior: SnackBarBehavior.floating,
      duration: duration?? const Duration(seconds: 2),
    ),
  );
}
