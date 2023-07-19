import 'package:flutter/material.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/colors.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';

class CustomButton extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  final String title;
  final VoidCallback onTap;
  const CustomButton({
    Key? key,
    required this.title,
     this.height,
     this.width,
    required this.onTap,
     this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height ?? ConstantStyles.contextHeight(context)*0.07,
        width: width ?? ConstantStyles.contextWidth(context)*0.1,
        decoration: BoxDecoration(
            color: color ?? Constants.mainColor, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: ConstantStyles.contextHeight(context) * 0.025),
          ),
        ),
      ),
    );
  }
}
