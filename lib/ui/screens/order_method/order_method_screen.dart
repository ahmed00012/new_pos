import 'dart:typed_data';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/utils.dart';
import 'package:shormeh_pos_new_28_11_2022/local_storage.dart';
import 'package:shormeh_pos_new_28_11_2022/models/cart_model.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/order_method/widgets/order_method_item.dart';

import 'package:shormeh_pos_new_28_11_2022/ui/screens/payment/payment_screen.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/reciept/receipt_screen.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/order_method/widgets/delivery_order.dart';
import 'package:image/image.dart' as img;
import '../../../constants/colors.dart';
import '../../../data_controller/cart_controller.dart';
import '../../../data_controller/order_method_controller.dart';
import '../../../models/order_method_model.dart';
import '../../widgets/back_btn.dart';
import '../../widgets/tables_dialog.dart';
import '../cart/cart_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class OrderMethod extends ConsumerStatefulWidget {
  const OrderMethod({Key? key , required this.order}) : super(key: key);
  final OrderDetails order;


  @override
  OrderMethodState createState() => OrderMethodState();
}

class OrderMethodState extends ConsumerState<OrderMethod> {

ScreenshotController screenshotController = ScreenshotController();
Uint8List? productsImage;
img.Image? productsScreenshot;

imageProductsPrinter() async {
  final controller = ref.watch(orderMethodFuture(widget.order));
  screenshotController.capture().then((Uint8List? image2) {
    setState((){   productsScreenshot = img.decodePng(image2!);
    productsScreenshot!.setPixelRgba(0, 0, 255,255,255);
    productsScreenshot= img.copyResize(productsScreenshot!, width: 550);
    productsImage = image2;
    controller.setImageScreenshot(image2,productsScreenshot);

    });
  });
}

  @override
  Widget build(BuildContext context) {
  final orderController = ref.watch(orderMethodFuture(widget.order));
  final cartController = ref.watch(cartFuture);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
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
                  child: ListView(
                    children: [

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Padding(
                                padding: const EdgeInsets.only(left: 10,bottom: 10),
                                child: Text(
                                  'order'.tr(),
                                  style: TextStyle(
                                      fontSize: size.height * 0.03,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              // ),
                              Container(
                                width: size.width*0.38,
                                child: GridView.builder(
                                    itemCount: orderController.orderMethods.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1.1,
                                    ),
                                    shrinkWrap: true,
                                    itemBuilder: (context, i) {
                                      OrderMethodModel orderMethod = orderController.orderMethods[i];
                                      return OrderMethodItem( index: i,
                                        orderMethods: orderController.orderMethods,
                                        onTap: (){
                                                orderController.setOrderMethod(
                                                    orderController.orderMethods[i]);
                                                if (orderMethod.id == 1) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) => PaymentScreen(
                                                            order: cartController.orderDetails,)));
                                                }
                                                if(orderMethod.id == 2){
                                                  ConstantStyles.showPopup(context: context,
                                                      content: TablesDialog(),
                                                      title: 'tables'.tr());
                                                }
                                                if (orderMethod.id == 3) {
                                                  imageProductsPrinter();
                                                  orderController.confirmOrder(context);
                                                }
                                                if(orderMethod.id == 4 ){
                                                  orderController.getCoupons();
                                                  orderController.getClients();
                                                  ConstantStyles.showPopup(context: context,
                                                      content:  DeliveryOrder(order: widget.order),
                                                      title:   'orderDetails'.tr(),).
                                                  then((value) {
                                                   imageProductsPrinter();
                                                   orderController.confirmOrder(context);
                                                  });
                                                }

                                        },


                                      );
                                    }),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: SizedBox(
                                height: size.height,
                                child: Receipt(screenshotController: screenshotController,
                                    order: cartController.orderDetails,
                                    onScreenShot: (){
                                      imageProductsPrinter();
                                      Future.delayed(Duration(milliseconds: 500),(){
                                        orderController.testPrint();

                                      });
                                    }),
                              ),
                            ),
                          ),
                          Align(
                            alignment: getLanguage()=='en'?
                            Alignment.topRight:Alignment.topLeft,
                            child: const BackBtn(),
                          ),

                        ],
                      ),

                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),




                if (orderController.loading)
                  Container(
                    height: size.height,
                    width: size.width,
                    color: Colors.white.withOpacity(0.8),
                    child: Center(
                      child:
                      LoadingAnimationWidget.inkDrop(
                        color: Constants.mainColor,
                        size: size.height*0.2,
                      ),
                    ),
                  )
              ],
            ),
          )
        ],
      )

    );
  }
}
