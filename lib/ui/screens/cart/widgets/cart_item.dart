import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../constants/colors.dart';
import '../../../../data_controller/cart_controller.dart';
import '../../../../models/cart_model.dart';
import '../../home/home_screen.dart';

class CartItem extends ConsumerWidget {
  final int index;
  final bool closeEdit;

  const CartItem({Key? key,required this.closeEdit, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final cartController = ref.watch(cartFuture);
    CartModel item = cartController.orderDetails.cart![index];
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: (){
          if (!closeEdit) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const Home()),
                    (route) => false);
            // if (!viewModel.itemWidget ||
            //     index != viewModel.chosenItem) {
            //   viewModel.switchToCardItemWidget(true,
            //       i: index);
            //
            //   viewModel.getProductDetails(
            //     index: index,
            //     customerPrice: cartController
            //             .orderDetails.customer !=
            //         null,
            //   );
            // }
          }
        },
        child: Slidable(
          actionPane: const SlidableDrawerActionPane(),
          secondaryActions: [
            if (cartController.orderDetails.cart!.length > 1)
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
          child: Row(
            children: [
              Column(
                children: [
                  IconButton(
                      onPressed: () {
                        if (!closeEdit) {
                          cartController.plusController(index);
                        }
                      },
                      icon:const Icon(
                        Icons.add_box_outlined,
                        color: Constants.mainColor,
                      )),
                  IconButton(
                      onPressed: () {
                        if (!closeEdit) {
                          cartController.minusController(index);
                        }
                      },
                      icon: const Icon(
                        Icons.indeterminate_check_box_outlined,
                        color: Constants.mainColor,
                      ))
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5, left: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.black26),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item.count}X ${item.mainName!}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.height * 0.018,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              Text(
                                '${item.total} SAR',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.height * 0.017,
                                    fontWeight: FontWeight.bold),
                              ),
                             const SizedBox(
                                width: 10,
                              )
                            ],
                          ),
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
                                                    .allAttributesID!
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
                                                            '${value.realPrice} SAR',
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
                              item.allAttributesID!.isNotEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Divider(),
                            ),
                          if (item.extra!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:item.extra!
                                        .map((e) => Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  e.titleEn!,
                                                  textAlign: TextAlign.start,
                                                  style: const TextStyle(
                                                      color: Constants.mainColor,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  e.price.toString() + '  SAR',
                                                  textAlign: TextAlign.start,
                                                  style: const TextStyle(
                                                    color: Constants.mainColor,
                                                  ),
                                                )
                                              ],
                                            ))
                                        .toList(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
