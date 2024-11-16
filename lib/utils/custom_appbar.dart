import 'package:flutter/material.dart';
import 'package:traveltrails/utils/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: AppConstants.heading2Style),
      automaticallyImplyLeading: false,
      backgroundColor: AppConstants.appbarColor,
      elevation: 10.0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
