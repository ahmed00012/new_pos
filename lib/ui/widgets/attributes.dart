
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';
import '../../data_controller/cart_controller.dart';
import '../../data_controller/home_controller.dart';


class AttributesWidget extends ConsumerWidget {

  int? productIndex;
  AttributesWidget({this.productIndex});
  @override
  Widget build(BuildContext context,ref) {
    final viewModel = ref.watch(dataFuture);
    final cartController = ref.watch(cartFuture);
    Size size = MediaQuery.of(context).size;
    return StatefulBuilder(
        builder: (context,setState) {
          return ListView.builder(
              itemCount: viewModel.attributes.length,
              shrinkWrap: true,

              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(viewModel.attributes[i].title!.en! ,
                        style: TextStyle(
                            color: Constants.mainColor,
                            fontSize: size.height*0.032,
                            fontWeight: FontWeight.bold
                        ),),
                      SizedBox(height: 10,),
                      Wrap(
                        runSpacing: 3,
                        spacing: 1,
                        alignment: WrapAlignment.center,
                        children: viewModel.attributes[i].values!.map((element){
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: InkWell(
                              onTap: (){
                                print(element.id);

                                if(cartController.orderDetails.updateID != null){
                                  viewModel.updateAttributes(orderDetails: cartController.orderDetails,
                                      attributeIndex: viewModel.attributes[i].values!.indexOf(element));
                                }

                                if(!attributes[attributeIndex].values![valueIndex].chosen!) {


                                  cartController.orderDetails.addAttributes(attributes[attributeIndex],
                                      productIndex, attributes[attributeIndex].values![valueIndex]);
                                }

                                else if(attributes[attributeIndex].values![valueIndex].chosen!){
                                  // int attributeIndexInsideCart = orderDetails.cart![productIndex].attributes!.indexOf(attributes[attributeIndex]);
                                  orderDetails.removeAttributes(attributes[attributeIndex], productIndex,
                                      attributes[attributeIndex].values![valueIndex],attributeIndex);

                                }




                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  height: size.height*0.12,
                                    width: size.width*0.16,

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      border: Border.all(color: cartController.orderDetails.cart![viewModel.chosenItem!]
                                          .allAttributesID!.contains(element.id)?Constants.mainColor:Colors.white,

                                      )
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 5,),
                                        Text(element.attributeValue!.en!,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(

                                            fontSize: size.height*0.02,

                                        ),),
                                        SizedBox(height: 10,),
                                        if(element.realPrice!=0)
                                        Text(element.realPrice.toString()+' SAR',style: TextStyle(
                                            color: Constants.secondryColor,
                                            fontSize: size.height*0.02,
                                            fontWeight: FontWeight.bold
                                        ),)
                                      ],
                                    )
                                ),
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
