import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/printing_services/printing_service.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/prefs_utils.dart';

import 'package:shormeh_pos_new_28_11_2022/data_controller/new_order_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/payment/widgets/payment_item.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/bottom_nav_bar.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/custom_button.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/custom_text_field.dart';

import 'package:shormeh_pos_new_28_11_2022/ui/screens/reciept/receipt_screen.dart';

import '../../../constants/colors.dart';

import '../../../data_controller/cart_controller.dart';

import '../../../models/cart_model.dart';
import 'widgets/amount_widget.dart';
import '../cart/cart_screen.dart';

class PaymentScreen extends StatefulWidget {
  final OrderDetails order;
  PaymentScreen({required this.order});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // GlobalKey? imageKey;
  GlobalKey repaintBoundaryKey = GlobalKey();
  TextEditingController coupon = TextEditingController();
  ScreenshotController? screenshotController = ScreenshotController();

  // Future<CaptureResult> captureImage(GlobalKey globalKey) async {
  //   final pixelRatio = MediaQuery.of(context).devicePixelRatio;
  //   final boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  //   final image = await boundary.toImage(pixelRatio: pixelRatio);
  //   final data = await image.toByteData(format: ui.ImageByteFormat.png);
  //   return CaptureResult(data!.buffer.asUint8List(), image.width, image.height);
  // }

  // Function()

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer(builder: (context, ref, child) {
        final orderController = ref.watch(newOrderFuture);
        final cartController = ref.watch(cartFuture);
        return SingleChildScrollView(
          child: Container(
            height: size.height,
            width: size.width,
            child: Row(
              children: [
                const Cart(
                  navigate: false,
                  closeEdit: true,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: size.width * 0.35,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //////////////payment////////////////////////////////////////

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            '${'payment'.tr()} : ',
                                            style: TextStyle(
                                                fontSize: size.height * 0.03,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: size.width * 0.35,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: orderController
                                            .paymentMethods.length,
                                        itemBuilder: (context, i) {
                                          return orderController
                                                          .paymentMethods[i]
                                                          .id ==
                                                      2 ||
                                                  orderController
                                                          .paymentMethods[i]
                                                          .id ==
                                                      7
                                              ? Container()
                                              : PaymentItem(
                                                  index: i,
                                                  title: orderController
                                                      .paymentMethods[i]
                                                      .title!
                                                      .en!,
                                                  color: orderController
                                                          .paymentMethods[i]
                                                          .chosen
                                                      ? Constants.mainColor
                                                      : Colors.white,
                                                  textColor: orderController
                                                          .paymentMethods[i]
                                                          .chosen
                                                      ? Colors.white
                                                      : Colors.black,
                                                  onTap: () {
                                                    setState(() {
                                                      orderController
                                                              .paymentMethods[i]
                                                              .chosen =
                                                          !orderController
                                                              .paymentMethods[i]
                                                              .chosen;
                                                    });

                                                    if (orderController
                                                        .paymentMethods[i]
                                                        .chosen &&
                                                        cartController.orderDetails.paid == 0 ||
                                                        cartController.orderDetails.paid <
                                                            cartController.orderDetails.total) {
                                                      orderController
                                                          .selectPayment(
                                                              cartController
                                                                  .orderDetails,
                                                              i,
                                                              cartController
                                                                  .getTotal());

                                                      if (orderController
                                                              .paymentMethods[i]
                                                              .id ==
                                                          1) {
                                                        ConstantStyles
                                                            .showPopup(
                                                          context: context,
                                                          width:
                                                              size.width * 0.3,
                                                          content: AmountWidget(
                                                            predict1: orderController
                                                                        .predict1 !=
                                                                    orderController
                                                                        .predict2
                                                                ? orderController
                                                                    .predict1
                                                                    .toString()
                                                                : null,
                                                            predict2:
                                                                orderController
                                                                    .predict2
                                                                    .toString(),
                                                            predict3:
                                                                orderController
                                                                    .predict3
                                                                    .toString(),
                                                            predict4:
                                                                orderController
                                                                    .predict4
                                                                    .toString(),
                                                            showTextField: true,
                                                          ),
                                                          title: 'amount'.tr(),
                                                        ).then((value) {
                                                          if (value != null &&
                                                              double.parse(
                                                                      value) !=
                                                                  0) {
                                                            cartController.setPayment(
                                                                orderController
                                                                    .paymentMethods[i],
                                                                value);
                                                            setState(() {});
                                                          } else {
                                                            setState(() {
                                                              orderController
                                                                  .paymentMethods[
                                                                      i]
                                                                  .chosen = false;
                                                            });
                                                          }
                                                        });
                                                      } else {
                                                        ConstantStyles
                                                            .showPopup(
                                                          context: context,
                                                          height:
                                                              size.height * .45,
                                                          width:
                                                              size.width * 0.3,
                                                          content: AmountWidget(
                                                            predict1: (cartController
                                                                        .getTotal() -
                                                                    cartController
                                                                        .orderDetails
                                                                        .paid)
                                                                .toString(),
                                                            showTextField: true,
                                                          ),
                                                          title: 'amount'.tr(),
                                                        ).then((value) {
                                                          if (value != null &&
                                                              double.parse(
                                                                      value) !=
                                                                  0) {
                                                            cartController.setPayment(
                                                                orderController
                                                                    .paymentMethods[i],
                                                                value);
                                                            setState(() {});
                                                          } else
                                                            setState(() {
                                                              orderController
                                                                  .paymentMethods[
                                                                      i]
                                                                  .chosen = false;
                                                            });
                                                        });
                                                      }
                                                    }
                                                    else if(orderController
                                                        .paymentMethods[i]
                                                        .chosen &&
                                                        cartController.orderDetails.paid >=
                                                            cartController.orderDetails.total){
                                                      setState(() {
                                                        orderController
                                                            .paymentMethods[i]
                                                            .chosen = false;
                                                      });
                                                    }

                                                    else {
                                                      cartController.removePayment(
                                                          paymentModel:
                                                              orderController
                                                                  .paymentMethods[i],
                                                          clear: false);
                                                    }
                                                  },
                                                );
                                        }),
                                  ),

                                  if (cartController
                                              .orderDetails.customer ==
                                          null &&
                                      cartController
                                              .orderDetails.orderStatusID !=
                                          4 &&
                                      cartController
                                              .orderDetails.paymentStatus !=
                                          0)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: cartController
                                                        .orderDetails.owner ==
                                                    null
                                                ? Colors.white
                                                : Constants.mainColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.black12)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: ExpansionTile(
                                            key: Key(orderController.collapseKey
                                                .toString()),
                                            collapsedIconColor: cartController
                                                        .orderDetails.owner !=
                                                    null
                                                ? Colors.white
                                                : Colors.black,
                                            iconColor: cartController
                                                        .orderDetails.owner !=
                                                    null
                                                ? Colors.white
                                                : Colors.black,
                                            title: Center(
                                              child: Text(
                                                cartController.orderDetails
                                                            .owner ==
                                                        null
                                                    ? 'others'.tr()
                                                    : cartController
                                                        .orderDetails
                                                        .owner!
                                                        .title!,
                                                style: TextStyle(
                                                    fontSize:
                                                        size.height * 0.02,
                                                    color: cartController
                                                                .orderDetails
                                                                .owner ==
                                                            null
                                                        ? Colors.black
                                                        : Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            children: orderController.owners
                                                .map((element) {
                                              return InkWell(
                                                onTap: () {
                                                  cartController.removePayment(
                                                      clear: true);
                                                  orderController.selectOwner(
                                                      cartController
                                                          .orderDetails,
                                                      element);
                                                },
                                                child: Container(
                                                  width: size.width * 0.35,
                                                  height: size.height * 0.06,
                                                  color: element.chosen
                                                      ? Constants.scaffoldColor
                                                      : Colors.white,
                                                  child: Center(
                                                    child: Text(
                                                      element.title!,
                                                      style: TextStyle(
                                                          fontSize:
                                                              size.height *
                                                                  0.02,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),

                                  SizedBox(
                                    height: 30,
                                    width: size.width,
                                  ),
                                  // ),

                                  ////////////////////////////coupon/////////////////////////////////////////////////////

                                  if ((cartController.orderDetails
                                                  .updateWithCoupon ==
                                              false ||
                                          cartController.orderDetails
                                                  .updateWithCoupon ==
                                              null) &&
                                      cartController.orderDetails.customer ==
                                          null &&
                                      cartController.orderDetails.discount ==
                                          0 &&
                                      cartController
                                              .orderDetails.orderStatusID !=
                                          4)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: SizedBox(
                                        width: size.width * 0.35,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 7,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white,
                                                ),
                                                child: CustomTextField(
                                                  controller: coupon,
                                                  label: 'coupon'.tr(),
                                                  hint: 'coupon'.tr(),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                flex: 3,
                                                child: CustomButton(
                                                  title: 'add'.tr(),
                                                  onTap: () {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                    cartController.checkCoupon(
                                                        coupon.text);
                                                    print(cartController
                                                        .orderDetails
                                                        .toJson());
                                                  },
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (cartController.orderDetails.discount != 0)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Container(
                                        height: size.height * 0.08,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: Constants.mainColor)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/discount.png',
                                              color: Constants.mainColor,
                                              height: 30,
                                              width: 30,
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              '${'couponDiscount'.tr()}   ${cartController.orderDetails.discount} SAR',
                                              style: TextStyle(
                                                  color: Constants.mainColor,
                                                  fontSize:
                                                      size.height * 0.024),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                  SizedBox(
                                    height: size.height * 0.06,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: size.height * 0.9,
                                child: Receipt(
                                    order: cartController.orderDetails,
                                    repaintRenderKey: repaintBoundaryKey),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: getLanguage() == 'en'
                                    ? Alignment.topRight
                                    : Alignment.topLeft,
                                child: InkWell(
                                  onTap: () {
                                    if (cartController
                                                .orderDetails.orderUpdatedId !=
                                            null &&
                                        cartController
                                                .orderDetails.paymentStatus ==
                                            0) {
                                      ConstantStyles.showPopup(
                                        context: context,
                                        height: size.height * 0.3,
                                        width: size.width * 0.3,
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CustomButton(
                                              title: 'yes'.tr(),
                                              onTap: () {
                                                cartController.closeOrder();
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            BottomNavBar()),
                                                    (route) => false);
                                              },
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            CustomButton(
                                              title: 'no'.tr(),
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                        title: 'cancelEditing'.tr(),
                                      );
                                    } else {
                                      cartController.removePayment(clear: true);
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.red[400],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Center(
                                      child: Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      ////////////////////////////// x button ///////////////////////////////

                      ///////////////////////////////////////////////////////////////////done button//////////////////////
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomButton(
                                  title: '${'pay'.tr()}/${'send'.tr()}',
                                  onTap: () {
                                    if(cartController.orderDetails.paid == 0 &&
                                        cartController.orderDetails.total > 0 &&
                                    cartController.orderDetails.owner == null &&
                                    cartController.orderDetails.customer == null)
                                      ConstantStyles.displayToastMessage('paymentMethodRequired'.tr(), true);

                                    else if(cartController.orderDetails.paid <
                                        cartController.orderDetails.total &&
                                        cartController.orderDetails.owner == null &&
                                        cartController.orderDetails.customer == null)
                                      ConstantStyles.displayToastMessage('paymentNotValid'.tr(), true);

                                   else {
                                      if (cartController
                                              .orderDetails.remaining !=
                                          0) {
                                        ConstantStyles.showPopup(
                                            context: context,
                                            height: size.height * 0.3,
                                            width: size.width * 0.3,
                                            content: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  '${cartController.orderDetails.remaining} SAR',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          size.height * 0.04),
                                                ),
                                                CustomButton(
                                                    title: 'ok'.tr(),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      orderController
                                                          .confirmOrder(
                                                              orderDetails:
                                                                  cartController
                                                                      .orderDetails)
                                                          .then((value) {
                                                        if (value != null) {
                                                          PrintingService.captureImage(
                                                              order: cartController
                                                                  .orderDetails,
                                                              context: context,
                                                              globalKey:
                                                                  repaintBoundaryKey,
                                                              orderNo: value);

                                                          Navigator.pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          BottomNavBar()),
                                                              (route) => false);
                                                          cartController
                                                              .closeOrder();
                                                        }
                                                      });
                                                    })
                                              ],
                                            ),
                                            title: 'remaining'.tr());
                                      } else {
                                        orderController
                                            .confirmOrder(
                                                orderDetails:
                                                    cartController.orderDetails)
                                            .then((value) async {
                                          if (value != null) {
                                            PrintingService.captureImage(
                                                order:
                                                    cartController.orderDetails,
                                                context: context,
                                                globalKey: repaintBoundaryKey,
                                                orderNo: value);

                                            cartController.closeOrder();
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BottomNavBar()),
                                                (route) => false);
                                          }
                                        });
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                            if (cartController.orderDetails.orderUpdatedId ==
                                    null &&
                                cartController.orderDetails.customer == null)
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomButton(
                                      title: 'hold'.tr(),
                                      color: Constants.secondryColor,
                                      onTap: () {
                                        cartController.orderDetails.hold = 1;
                                        orderController
                                            .confirmOrder(
                                                orderDetails:
                                                    cartController.orderDetails)
                                            .then((value) async {
                                          if (value != null) {
                                            PrintingService.captureImage(
                                                order:
                                                    cartController.orderDetails,
                                                context: context,
                                                globalKey: repaintBoundaryKey,
                                                orderNo: value);

                                            cartController.closeOrder();
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BottomNavBar()),
                                                (route) => false);
                                          }
                                        });
                                      },
                                    )),
                              ),
                            if (cartController.orderDetails.customer != null)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomButton(
                                    title: 'payLater'.tr(),
                                    color: Constants.secondryColor,
                                    onTap: () {
                                      cartController.orderDetails.payLater =
                                          true;
                                      cartController.removePayment(clear: true);
                                      orderController
                                          .confirmOrder(
                                              orderDetails:
                                                  cartController.orderDetails)
                                          .then((value) {
                                        if (value != null) {
                                          PrintingService.captureImage(
                                              order:
                                                  cartController.orderDetails,
                                              context: context,
                                              globalKey: repaintBoundaryKey,
                                              orderNo: value);

                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BottomNavBar()),
                                              (route) => false);
                                          cartController.closeOrder();
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      if (orderController.loading)
                        ConstantStyles.circularLoading()
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
