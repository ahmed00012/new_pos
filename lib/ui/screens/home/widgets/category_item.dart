

import 'package:flutter/material.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';

class CategoryItem extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final String title;
  const CategoryItem({Key? key, required this.onTap, required this.color ,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        color: color,
        child: Center(
          child: Text(title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: ConstantStyles.contextHeight(context) * 0.02,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
