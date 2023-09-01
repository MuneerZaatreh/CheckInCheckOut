// ignore_for_file: file_names

import 'package:flutter/material.dart';

class AppBarWithArrowBack extends StatelessWidget with PreferredSizeWidget {
  const AppBarWithArrowBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 207, 177, 43),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
