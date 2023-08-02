
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/colors.dart';
import '../../../../data_controller/cart_controller.dart';
import '../../../../data_controller/home_controller.dart';
import '../../../../models/product_details_model.dart';


class AttributesWidget extends ConsumerWidget {

 final int productIndex;
 final List<Attributes> attributes ;
  AttributesWidget({required this.productIndex , required this.attributes});
  @override
  Widget build(BuildContext context,ref) {
    // final viewModel = ref.watch(dataFuture);
    final cartController = ref.watch(cartFuture);
    Size size = MediaQuery.of(context).size;
    return StatefulBuilder(
        builder: (context,setState) {
          return ListView.builder(
              itemCount: attributes.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(attributes[i].title!.en! ,
                        style: TextStyle(
                            color: Constants.mainColor,
                            fontSize: size.height*0.032,
                            fontWeight: FontWeight.bold
                        ),),
                      const SizedBox(height: 10,),
                      Wrap(
                        runSpacing: 3,
                        spacing: 1,
                        alignment: WrapAlignment.center,
                        children: attributes[i].values!.map((element){
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: InkWell(
                              onTap: (){

                                cartController.editAttributes(
                                    attribute: attributes[i],
                                    attributeValue: element,
                                    productIndex: productIndex,
                                    attributeIndex: i,);

                              },
                              child: Container(
                                height: size.height*0.12,
                                  width: size.width*0.16,

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 1,
                                          offset: Offset(0, 2), // changes position of shadow
                                        ),
                                      ],
                                    color: Colors.white,
                                    border: Border.all(color: cartController.orderDetails.cart[productIndex]
                                        .allAttributesValuesID!.contains(element.id)?Constants.mainColor:Colors.white,

                                    )
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 5,),
                                      Text(element.attributeValue!.en!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(

                                          fontSize: size.height*0.02,

                                      ),),
                                      const SizedBox(height: 10,),
                                      Text('${element.price} SAR',style: TextStyle(
                                          color: Constants.secondryColor,
                                          fontSize: size.height*0.02,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ],
                                  )
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                    ],
                  ),
                );
              });
        }
    );
  }
}
