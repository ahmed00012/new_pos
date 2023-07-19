
import 'package:flutter/material.dart';

class SummaryRow extends StatelessWidget {
  const SummaryRow({Key? key , required this.title , required this.value}) : super(key: key);
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Container(
      width: size.width,
      child: Row(
        children: [
          const  SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: size.height * 0.018,
                color: Colors.black45),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
                fontSize: size.height * 0.018,
                color: Colors.black45),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
