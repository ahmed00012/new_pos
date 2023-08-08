
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/prefs_utils.dart';

import 'package:shormeh_pos_new_28_11_2022/ui/screens/order_method/widgets/order_method_item.dart';

import 'package:shormeh_pos_new_28_11_2022/ui/screens/payment/payment_screen.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/reciept/receipt_screen.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/order_method/widgets/delivery_order.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/bottom_nav_bar.dart';

import '../../../constants/printing_services/printing_service.dart';

import '../../../data_controller/cart_controller.dart';
import '../../../data_controller/order_method_controller.dart';
import '../../../models/order_method_model.dart';
import '../../widgets/back_btn.dart';
import '../tables/widgets/tables_dialog.dart';
import '../cart/cart_screen.dart';

class OrderMethod extends StatefulWidget {
  @override
  State<OrderMethod> createState() => _OrderMethodState();
}

class _OrderMethodState extends State<OrderMethod> {
// GlobalKey? imageKey;


  GlobalKey repaintBoundaryKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Consumer(builder: (context, ref, child) {
          final orderController = ref.watch(orderMethodFuture);
          final cartController = ref.watch(cartFuture);
          return Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(5),
                child: Cart(
                  navigate: false,
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, bottom: 10),
                                child: Text(
                                  'order'.tr(),
                                  style: TextStyle(
                                      fontSize: size.height * 0.03,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              // ),
                              Container(
                                width: size.width * 0.38,
                                child: GridView.builder(
                                    itemCount:
                                        orderController.orderMethods.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1.1,
                                    ),
                                    shrinkWrap: true,
                                    itemBuilder: (context, i) {
                                      OrderMethodModel orderMethod =
                                          orderController.orderMethods[i];
                                      return OrderMethodItem(
                                        index: i,
                                        orderMethods:
                                            orderController.orderMethods,
                                        onTap: () {
                                          cartController.setOrderMethod(
                                              orderController
                                                  .orderMethods[i]);
                                          if (orderMethod.id == 1) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        PaymentScreen(
                                                          order: cartController
                                                              .orderDetails,
                                                        )));
                                          }
                                          if (orderMethod.id == 2) {
                                            orderController.getTables();
                                            ConstantStyles.showPopup(
                                                    context: context,
                                                    height:
                                                        size.height * 0.8,
                                                    width: size.width * 0.8,
                                                    content: TablesDialog(),
                                                    title: 'tables'.tr())
                                                .then((value) async {
                                              if (value != null) {
                                                await orderController
                                                    .confirmOrder(
                                                        cartController
                                                            .orderDetails).then((uuid) {
                                                  PrintingService.captureImage(
                                                      order: cartController.orderDetails,
                                                      context: context,
                                                      globalKey: repaintBoundaryKey,
                                                      orderNo:uuid
                                                  );
                                                });


                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            BottomNavBar()),
                                                    (route) => false);
                                                cartController.closeOrder();
                                              }
                                            });
                                          }
                                          if (orderMethod.id == 3) {
                                            // imageProductsPrinter();
                                            orderController
                                                .confirmOrder(cartController
                                                    .orderDetails)
                                                .then((value) {

                                         PrintingService.captureImage(
                                                  order: cartController.orderDetails,
                                                  context: context,
                                                  globalKey: repaintBoundaryKey,
                                                  orderNo:value
                                              ).then((value) {

                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          BottomNavBar()),
                                                      (route) => false);
                                              cartController.closeOrder();
                                            });
                                            });


                                          }
                                          if (orderMethod.id == 4) {
                                            // orderController.getCoupons();
                                            // orderController.getClients();
                                            ConstantStyles.showPopup(
                                              context: context,
                                              content: DeliveryOrder(
                                                order: cartController
                                                    .orderDetails,
                                              ),
                                              title: 'orderDetails'.tr(),
                                            ).then((value) {
                                              if (value != null) {
                                                orderController
                                                    .confirmOrder(
                                                        cartController
                                                            .orderDetails)
                                                    .then((value) {
                                                  PrintingService.captureImage(
                                                      order: cartController.orderDetails,
                                                      context: context,
                                                      globalKey: repaintBoundaryKey,
                                                      orderNo:value
                                                  );

                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              BottomNavBar()),
                                                      (route) => false);
                                                  cartController
                                                      .closeOrder();
                                                });
                                              }
                                            });
                                          }
                                        },
                                      );
                                    }),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Receipt(
                              order: cartController.orderDetails,
                              scr: repaintBoundaryKey,
                            ),
                          ),
                          Align(
                            alignment: getLanguage() == 'en'
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: const BackBtn(),
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
          );
        }));
  }
}
