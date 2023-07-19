


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BranchClosed extends StatelessWidget {
  const BranchClosed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/images/closed.png', height: size.height * 0.6),
        SizedBox(
          height: 20,
        ),
        Text(
          'closed'.tr(),
          style: TextStyle(
              color: Colors.red,
              fontSize: size.height * 0.025,
              fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
