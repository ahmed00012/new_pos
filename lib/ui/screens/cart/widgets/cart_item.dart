import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';
import '../../../../data_controller/cart_controller.dart';
import '../../../../data_controller/home_controller.dart';
import '../../../../models/cart_model.dart';
import '../../home/home_screen.dart';
import '../../home/widgets/single_item.dart';

class CartItem extends ConsumerWidget {
  final int index;
  final bool closeEdit;

  const CartItem({Key? key,required this.closeEdit, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final cartController = ref.watch(cartFuture);
    final viewModel = ref.watch(dataFuture);
    CartModel item = cartController.orderDetails.cart[index];
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: (){
          viewModel
              .getProductDetails(
              productID: item.id!,
              customerPrice: cartController.orderDetails.customer != null)
              .then((value) {
            if(!cartController.orderDetails.cart[index].updated) {
              cartController.orderDetails.cart[index].attributes!.forEach((element) {
                viewModel.attributes.forEach((element2) {
                  if(element.title!.en == element2.title!.en){
                    element.id = element2.id;
                  }
                });
              });
            }
            ConstantStyles.showPopup(
                context: context,
                height: size.height*0.9,
                width: size.width*0.8,
                content: SingleItem(
                  index: index, optionList: viewModel.optionsList,
                  attributes: viewModel.attributes,
                ),
                title: '');
          });
          // if (!closeEdit) {
          //   Navigator.pushAndRemoveUntil(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => const Home()),
          //           (route) => false);
          //   // if (!viewModel.itemWidget ||
          //   //     index != viewModel.chosenItem) {
          //   //   viewModel.switchToCardItemWidget(true,
          //   //       i: index);
          //   //
          //   //   viewModel.getProductDetails(
          //   //     index: index,
          //   //     customerPrice: cartController
          //   //             .orderDetails.customer !=
          //   //         null,
          //   //   );
          //   // }
          // }
        },
        child: Slidable(
          actionPane: const SlidableDrawerActionPane(),
          secondaryActions: [
            if (cartController.orderDetails.cart.length > 1)
              IconSlideAction(
                color: Colors.red[400],
                iconWidget: const Icon(Icons.delete_forever, color: Colors.white),
                onTap: () {
                  if (!closeEdit) {
                    cartController.removeCartItem(index: index);
                  }
                },
              ),
          ],
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Constants.mainColor),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: Colors.black26),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: size.width*0.08,
                            child: Text(
                              item.mainName!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.height * 0.018,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),

                          InkWell(
                              onTap: (){
                                if (!closeEdit) {
                                  cartController.minusController(index);
                                }

                              },
                              child: Image.asset('assets/images/minus-button.png',height: size.height*0.04,color: Colors.green,)),
                          Text(
                            '${item.count}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: size.height * 0.018,
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                              onTap: (){
                                if (!closeEdit) {
                                  viewModel.getProductDetails(productID: cartController.orderDetails.cart[index].id!,
                                      customerPrice: cartController.orderDetails.customer!=null).then((value){
                                    cartController.plusController(index,
                                      viewModel.attributes);

                                  });

                                }
                              },
                              child: Image.asset('assets/images/plus(1).png',height: size.height*0.05,color: Colors.green,)),


                          Text(
                            '${item.total} SAR',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: size.height * 0.017,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5,),

                    if (item.extraNotes != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: size.width * 0.15,
                              child: Text(
                                item.extraNotes!,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.black45,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            const Text(
                              '0.0  SAR',
                              textAlign: TextAlign.start,
                              style: TextStyle(color: Colors.black45),
                            )
                          ],
                        ),
                      ),
                    if (item.extraNotes != null)
                      Divider(),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          ListView.separated(
                            itemCount: item.attributes!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, j) {
                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: item.attributes![j].values!
                                      .map((value) => item
                                      .allAttributesValuesID!
                                      .contains(value.id)
                                      ? Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Text(
                                          value.attributeValue!.en!,
                                          style: const TextStyle(
                                            color: Colors.black45,
                                          )),
                                      if (value.price != null)
                                        Text(
                                            '${value.price} SAR',
                                            style: const TextStyle(
                                              color: Colors.black45,
                                            )),
                                    ],
                                  )
                                      : Container())
                                      .toList());
                            },
                            separatorBuilder: (context, i) {
                              return Divider();
                            },
                          )
                        ],
                      ),
                    ),
                    if (item.extra!.isNotEmpty &&
                        item.allAttributesValuesID!.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(),
                      ),


                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          ListView.separated(
                            itemCount: item.extra!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, i) {
                              return Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.extra![i].titleEn!,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        color: Colors.black45,
                                    ),
                                  ),
                                  Text(
                                    item.extra![i].price.toString() + '  SAR',
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      color: Colors.black45,
                                    ),
                                  )
                                ],
                              );
                            },
                            separatorBuilder: (context, i) {
                              return Divider();
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
