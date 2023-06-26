import 'dart:async';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/local_storage.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/home.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/payment_screen.dart';

import '../../constants.dart';
import '../../data_controller/cart_controller.dart';
import '../../models/cart_model.dart';
import '../widgets/choose_client_widget.dart';
import '../widgets/tables_dialog.dart';
import 'order_method.dart';

class Cart extends ConsumerStatefulWidget {
  bool? navigate;
  String? page;
  bool? closeEdit;
  Cart({this.navigate, this.page, this.closeEdit = false});

  @override
  CartState createState() => CartState();
}

class CartState extends ConsumerState<Cart> {

  SelectedTab ?selectedTab ;

  void cartNavigation({required OrderDetails orderDetails,}) {
    // switchToCardItemWidget(false);

    if (widget.navigate! && orderDetails.cart!=null) {
      selectedTab = SelectedTab.home;
      if (orderDetails.customer != null || orderDetails.tableTitle!=null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PaymentScreen(
                  selectCustomer: true,
                  fromHome: true,
                )));
      } else if (orderDetails.orderUpdatedId!=null && orderDetails.customer == null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PaymentScreen(fromHome: true,)));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OrderMethod()));

      }
    }

  }


  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(dataFuture);
    final cartController = ref.watch(cartFuture);
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Image.asset(
                  'assets/images/ahmed-01.png',
                  width: size.width * 0.28,
                ),
                Column(
                  children: [
                    Container(
                      width: size.width * 0.28,
                      decoration: const BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  color: Constants.secondryColor, width: 5),
                              left: BorderSide(
                                  color: Constants.secondryColor, width: 5))),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              'branch'.tr() +
                                  ' \n' +
                                  LocalStorage.getData(key: 'branchName'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height * 0.02,
                                  color: Constants.mainColor),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              'employee'.tr() +
                                  ' \n' +
                                  LocalStorage.getData(key: 'username'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height * 0.02,
                                  color: Constants.mainColor),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5, left: 3),
                      child: InkWell(
                        onTap: () {
                        cartNavigation(orderDetails: cartController.orderDetails);
                        },
                        child: Container(
                          height: size.height * 0.09,
                          width: size.height * 0.09,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Constants.mainColor),
                          child: Center(
                            child: Text(
                              'send'.tr(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.025,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                textDirection: TextDirection.ltr,
                children: [
                  InkWell(
                    onTap: () {
                      if (cartController.orderDetails.cart != null && !widget.closeEdit!) {
                        // viewModel.getClients();
                        showDialog(
                            context: context,
                            builder: (_) => ChooseClientWidget(
                                  currentContext: context,
                                ));
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/images/ahmed-03.png',
                          width: size.width * 0.132,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                color: Constants.mainColor,
                                size: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              if (cartController.orderDetails.clientName ==
                                  null)
                                Text(
                                  'customer'.tr(),
                                  style: TextStyle(
                                      color: Constants.mainColor,
                                      fontSize: size.height * 0.02),
                                ),
                              if (cartController.orderDetails.clientName !=
                                  null)
                                Container(
                                  width: size.width * 0.08,
                                  child: Text(
                                    cartController.orderDetails.clientName!,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Constants.mainColor,
                                        fontSize: size.height * 0.02),
                                  ),
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  InkWell(
                    onTap: () {
                      if (!widget.closeEdit!) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  titlePadding: EdgeInsets.zero,
                                  contentPadding: EdgeInsets.zero,
                                  title: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 10, 0),
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                height: size.height * 0.05,
                                                width: size.height * 0.05,
                                                decoration: BoxDecoration(
                                                    color: Colors.red[400],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.clear,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                  content: Container(
                                      height: size.height * 0.7,
                                      width: size.width * 0.7,
                                      child: TablesDialog()));
                            });
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/images/ahmed-02.png',
                          width: size.width * 0.132,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/chair(2).png',
                                width: size.width * 0.03,
                                color: Constants.mainColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              if (cartController.orderDetails.tableTitle ==
                                      null &&
                                  cartController.orderDetails.tableTitle ==
                                      'null')
                                Text(
                                  'Tables',
                                  style: TextStyle(
                                      color: Constants.mainColor,
                                      fontSize: size.height * 0.02),
                                ),
                              if (cartController.orderDetails.tableTitle !=
                                      null &&
                                  cartController.orderDetails.tableTitle !=
                                      'null')
                                Text(
                                  cartController.orderDetails.tableTitle!,
                                  style: TextStyle(
                                      color: Constants.mainColor,
                                      fontSize: size.height * 0.02),
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Expanded(
          child: Container(
            width: size.width * 0.28,
            child: Card(
              elevation: 1,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                // alignment: Alignment.center,
                // fit: StackFit.expand,
                children: [
                  //////////////////cnacel order button////////////////////////
                  if (cartController.orderDetails.cart != null)
                    InkWell(
                      onTap: () {
                        cartController.emptyCardList();
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>Home()),
                                (route) => false);
                      },
                      child: Container(
                        height: size.height * 0.07,
                        width: double.infinity,
                        color: Colors.red[500],
                        child: Center(
                          child: Text(
                            // viewModel.updateOrder
                            cartController.orderDetails.orderUpdatedId != null
                                ? 'cancelEditing'.tr()
                                : 'cancelOrder'.tr(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.025),
                          ),
                        ),
                      ),
                    ),

/////////////////////card products/////////////////////////////////
                  if (cartController.orderDetails.cart != null)
                    Expanded(
                      // height: size.height * 0.55,

                      child: ListView.builder(
                        itemCount: cartController.orderDetails.cart!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: InkWell(
                              onTap: () {
                                if (!widget.closeEdit!) {
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>Home()),
                                          (route) => false);
                                  if (!viewModel.itemWidget || index != viewModel.chosenItem) {
                                    viewModel.switchToCardItemWidget(true, i: index);

                                    viewModel.getProductDetails(
                                    index: index,
                                    customerPrice: cartController.orderDetails.customer!=null,
                                    );
                                  }
                                }
                              },
                              child: Slidable(
                                actionPane: const SlidableDrawerActionPane(),
                                secondaryActions: [
                                  if (cartController.orderDetails.cart!.length >
                                      1)
                                    IconSlideAction(
                                      color: Colors.red[400],
                                      iconWidget: const Icon(
                                          Icons.delete_forever,
                                          color: Colors.white),
                                      onTap: () {
                                        if (!widget.closeEdit!) {
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
                                              //  viewModel.plusController(i);
                                              if (!widget.closeEdit!) {
                                                cartController.orderDetails
                                                    .plusController(index);
                                                viewModel.refreshList();
                                              }
                                            },
                                            icon: Icon(
                                              Icons.add_box_outlined,
                                              color: Constants.mainColor,
                                            )),
                                        IconButton(
                                            onPressed: () {
                                              // viewModel.minusController(i);
                                              if (!widget.closeEdit!) {
                                                cartController.orderDetails
                                                    .minusController(index);
                                                viewModel.refreshList();
                                              }
                                            },
                                            icon: Icon(
                                              Icons
                                                  .indeterminate_check_box_outlined,
                                              color: Constants.mainColor,
                                            ))
                                      ],
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 5, left: 5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 0.5,
                                                  color: Colors.black26),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      cartController
                                                              .orderDetails
                                                              .cart![index]
                                                              .count
                                                              .toString() +
                                                          'X ' +
                                                          cartController
                                                              .orderDetails
                                                              .cart![index]
                                                              .mainName!,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize:
                                                              size.height *
                                                                  0.018,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      cartController
                                                              .orderDetails
                                                              .cart![index]
                                                              .total
                                                              .toString() +
                                                          ' SAR',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize:
                                                              size.height *
                                                                  0.017,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    )
                                                  ],
                                                ),
                                                if (cartController.orderDetails
                                                        .cart![index].extraNotes !=
                                                    null)
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          width:
                                                              size.width * 0.15,
                                                          child: Text(
                                                            cartController
                                                                .orderDetails
                                                                .cart![index]
                                                                .extraNotes!,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black45,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ),
                                                        ),
                                                        Text(
                                                          '0.0  SAR',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black45),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Column(
                                                    // crossAxisAlignment:
                                                    // CrossAxisAlignment.start,
                                                    // children: HomeController
                                                    //     .orderDetails.cart![i].attributes!
                                                    //     .map((e) =>
                                                    // ).toList(),
                                                    //
                                                    children: [
                                                      ListView.separated(
                                                        itemCount:
                                                        cartController
                                                                .orderDetails
                                                                .cart![index]
                                                                .attributes!
                                                                .length,
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (context, j) {
                                                          return Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: cartController
                                                                  .orderDetails
                                                                  .cart![index]
                                                                  .attributes![
                                                                      j]
                                                                  .values!
                                                                  .map((value) => cartController
                                                                          .orderDetails
                                                                          .cart![
                                                                              index]
                                                                          .allAttributesID!
                                                                          .contains(
                                                                              value.id)
                                                                      ? Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(value.attributeValue!.en!,
                                                                                style: TextStyle(
                                                                                  color: Colors.black45,
                                                                                )),
                                                                            if (value.price !=
                                                                                null)
                                                                              Text(value.realPrice.toString() + ' SAR',
                                                                                  style: TextStyle(
                                                                                    color: Colors.black45,
                                                                                  )),
                                                                          ],
                                                                        )
                                                                      : Container())
                                                                  .toList());
                                                        },
                                                        separatorBuilder:
                                                            (context, i) {
                                                          return Divider();
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                if (cartController
                                                        .orderDetails
                                                        .cart![index]
                                                        .extra!
                                                        .isNotEmpty &&
                                                    cartController
                                                        .orderDetails
                                                        .cart![index]
                                                        .allAttributesID!
                                                        .isNotEmpty)
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: Divider(),
                                                  ),
                                                if (cartController.orderDetails
                                                    .cart![index].extra!.isNotEmpty)
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children:
                                                      cartController
                                                              .orderDetails
                                                              .cart![index]
                                                              .extra!
                                                              .map((e) => Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        e.titleEn!,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Constants.mainColor,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                      Text(
                                                                        e.price.toString() +
                                                                            '  SAR',
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Constants.mainColor,
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
                        },
                      ),
                    ),
                  // Spacer(),

                  ////////////////////////////////////summary////////////////////////////////////////
                  if (cartController.orderDetails.cart != null) Divider(),
                  if (cartController.orderDetails.cart != null)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: size.width,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'tax'.tr() + ': ',
                                style: TextStyle(
                                    fontSize: size.height * 0.018,
                                    color: Colors.black45),
                              ),
                              Spacer(),
                              Text(
                                cartController.orderDetails.tax!
                                        .toStringAsFixed(2) +
                                    ' SAR',
                                style: TextStyle(
                                    fontSize: size.height * 0.018,
                                    color: Colors.black45),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),

                        if (cartController.orderDetails.delivery != null &&
                            cartController.orderDetails.delivery != 0)
                          Container(
                            width: size.width,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'delivery'.tr() + ' : ',
                                  style: TextStyle(
                                      fontSize: size.height * 0.018,
                                      color: Colors.black45),
                                ),
                                Spacer(),
                                Text(
                                  cartController.orderDetails.delivery!
                                          .toStringAsFixed(2) +
                                      ' SAR',
                                  style: TextStyle(
                                      fontSize: size.height * 0.018,
                                      color: Colors.black45),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),

                        if (cartController.orderDetails.discount != null &&
                            !cartController.orderDetails.discount!
                                .startsWith('0'))
                          Container(
                            width: size.width,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'discount'.tr() + ': ',
                                  style: TextStyle(
                                      fontSize: size.height * 0.018,
                                      color: Colors.black45),
                                ),
                                Spacer(),
                                Text(
                                  cartController.orderDetails.discount! +
                                      ' SAR',
                                  style: TextStyle(
                                      fontSize: size.height * 0.018,
                                      color: Colors.black45),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(
                          height: 5,
                        )
                      ],
                    ),

////////////////////////////////////////////checkout button////////////////////////////////
                  if (cartController.orderDetails.cart != null)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: () {
                         cartNavigation(orderDetails: cartController.orderDetails);
                        },
                        child: Container(
                          height: size.height * 0.07,
                          width: size.width,
                          color: Constants.mainColor,
                          alignment: Alignment.center,
                          child: Container(
                            width: size.width * 0.24,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: size.width * 0.085,
                                  child: Text(
                                    'pay'.tr(),
                                    style: TextStyle(
                                        fontSize: size.height * 0.025,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  width: 2,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'total'.tr() + ': ',
                                  style: TextStyle(
                                      fontSize: size.height * 0.025,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                                Spacer(),
                                Text(
                                  cartController.orderDetails.total!
                                          .toStringAsFixed(2) +
                                      ' SAR',
                                  style: TextStyle(
                                      fontSize: size.height * 0.025,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  // if (viewModel.loading)
                  //   Container(
                  //     height: size.height,
                  //     width: size.width,
                  //     color: Colors.white.withOpacity(0.5),
                  //   )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
