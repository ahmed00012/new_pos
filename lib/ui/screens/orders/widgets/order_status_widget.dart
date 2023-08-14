

import 'package:flutter/material.dart';

class OrderStatusWidget extends StatelessWidget {
  const OrderStatusWidget({Key? key ,required this.color ,required this.title ,
    required this.image, this.imgColor = Colors.white, this.textColor = Colors.white}) : super(key: key);
  final Color color;
  final String image;
  final String title;
  final Color imgColor;
  final Color textColor;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Container(
        width: size.width * 0.13,
        decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.white,)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 5,),
            Image.asset(
              image,
              color:  imgColor,
              width: size.width*0.05,
              height: size.height*0.05,
            ),
            Spacer(),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: textColor,
                  fontSize: size.height * 0.019,
                  height: 1,
                  letterSpacing: 0.1
              ),
            ),
            SizedBox(height: 5,),
          ],
        ));
  }
}
