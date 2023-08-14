

import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';

class ChooseDriverWidget extends StatelessWidget {
  final String title;
  final double distance;
  final VoidCallback onTap;
  const ChooseDriverWidget({Key? key,required this.title,required this.distance,
  required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon(Icons.person,color: Constants.mainColor,
                  // size: size.height*0.022,),
                  // SizedBox(width: 5,),
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: size.height*0.022,
                        color: Constants.mainColor,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 15,),

                  // Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on_outlined,color: Constants.mainColor,
                        size: size.height*0.022,),
                      SizedBox(width: 5,),
                      Text(
                        '$distance  KM',
                        style: TextStyle(
                          fontSize: size.height*0.022,
                          color: Constants.mainColor,
                        ),
                      ),
                    ],
                  ),

                ],
              )
          ),
        ),
      ),
    );
  }
}
