

import 'package:flutter/material.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/colors.dart';

class SingleItemUpperRow extends StatelessWidget {
  final VoidCallback onTap;
  final Color ?color;
  final String ?title;
  final IconData icon;
  const SingleItemUpperRow({Key? key , required this.onTap ,this.title,
    required this.icon, this.color = Constants.mainColor,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: size.height * 0.15,
          width: size.width * 0.1,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Icon(
                  icon,
                  size: size.height * 0.05,
                  color: Colors.white,
                )),


                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    title ?? '',
                    style: TextStyle(
                        fontSize: size.height * 0.019,
                        color: Colors.white),
                  )

            ],
          ),
        ),
      ),
    );
  }
}
