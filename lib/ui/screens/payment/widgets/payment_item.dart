


import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';

class PaymentItem extends StatefulWidget {
  final String title;
  final int index;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;

 const PaymentItem({Key? key , required this.title,required this.onTap, required this.index,
 required this.color, required this.textColor}) : super(key: key);

  @override
  _PaymentItemState createState() => _PaymentItemState();
}

class _PaymentItemState extends State<PaymentItem> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding:
      const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          width: size.width * 0.3,
          height: size.height * 0.06,
          decoration: BoxDecoration(
              color: widget.color,
              borderRadius:
              BorderRadius.circular(
                  10),
              border: Border.all(
                  color:
                  Colors.black12)),
          child: Center(
            child: Text(
             widget.title,
              style: TextStyle(
                  fontSize:
                  size.height *
                      0.02,
                  color:  widget.textColor,
                  fontWeight:
                  FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
