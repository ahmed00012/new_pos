

import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';

class UpperRowCard extends StatelessWidget {
  final VoidCallback ?onTap;
  final String title;
  final IconData? icon;
  final String? image;
   const UpperRowCard({Key? key,  this.onTap , required this.title ,this.icon , this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = ConstantStyles.contextSize(context);
    return InkWell(
      onTap:onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: size.height * 0.15,
          width: size.width * 0.08,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Constants.mainColor)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if(image==null)
              Icon(
                icon,
                size: size.height * 0.05,
                color: Constants.mainColor,
              ),
              if(image != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(image!,
                      height: size.height * 0.05,
                    ),
                  ),
                ),

              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: size.height * 0.019,
                    color: Constants.mainColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
