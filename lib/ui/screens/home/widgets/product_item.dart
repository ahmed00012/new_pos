

import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';

class ProductItemWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String ?price;
  final String ?image;
  final bool addButton;
  const ProductItemWidget({Key? key, required this.onTap ,required this.title,
    this.addButton = false , this.price , this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:
        const EdgeInsets.fromLTRB(
            5, 0, 5, 10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10),
          ),
          child: Container(
              height: 20,
              width: 20,
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,),
              child: Column(
                mainAxisAlignment: MainAxisAlignment
                    .center,
                children: [
                  Text(
                    title,
                    textAlign:
                    TextAlign.center,
                    style: TextStyle(
                        fontSize:
                        size.height *
                            0.02,
                        color: Constants
                            .mainColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  if (image != null)
                    Image.network(image!,
                      height:size.height *0.095,
                    ),

                  if(addButton)
                  Icon(
                    Icons.add,
                    color: Constants
                        .mainColor,
                    size: size.height *
                        0.04,
                  ),

                  if (price != null)
                  Text(
                    '${price!} SAR',
                    style: TextStyle(
                        fontSize: size.height * 0.022,
                        color: Constants.secondryColor,
                        fontWeight:
                        FontWeight.bold),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
