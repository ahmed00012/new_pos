

import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: Constants.mainColor,
      strokeWidth: 4,
    );
  }
}
