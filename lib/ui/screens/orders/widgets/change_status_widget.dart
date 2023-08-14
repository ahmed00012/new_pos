

import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';
import 'order_status_widget.dart';

class ChangeStatusWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String title;

  const ChangeStatusWidget({Key? key,required this.onTap,required this.title,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
              border: Border.all(
                  color: Constants.mainColor
              ),
              borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],


          ),
          child: Center(
            child: Text(
                title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.height*0.022,
                color: Constants.mainColor
              ),
            ),
          )
        ),
      ),
    );
  }
}
