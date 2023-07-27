
import 'dart:typed_data';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/prefs_utils.dart';

import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/new_order_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/payment/widgets/payment_item.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/custom_button.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/custom_text_field.dart';

import 'package:shormeh_pos_new_28_11_2022/ui/screens/reciept/receipt_screen.dart';


import '../../../constants/colors.dart';
import '../../../data_controller/cart_controller.dart';
import '../../../local_storage.dart';
import '../../../models/cart_model.dart';
import 'widgets/amount_widget.dart';
import '../cart/cart_screen.dart';

import 'package:image/image.dart' as img;

import '../home/home_screen.dart';



class PaymentScreen extends StatefulWidget {
// bool? selectCustomer;
// bool? fromHome;
//   this.selectCustomer,this.fromHome,
final OrderDetails order ;
PaymentScreen({ required this.order});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController coupon = TextEditingController();
  img.Image? productsScreenshot;
  Uint8List? productsScreenshotUint8List;

  @override
  void initState() {
    // TODO: implement initState
    // imageProductsPrinter();
    super.initState();
  }

  imageProductsPrinter() async {
    screenshotController.capture().then((Uint8List? image2) {
      productsScreenshot = img.decodePng(image2!);
      productsScreenshot!.setPixelRgba(0, 0, 255,255,255);
      productsScreenshot= img.copyResize(productsScreenshot!, width: 550);
      productsScreenshotUint8List = image2;
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      body: Consumer(
        builder: (context , ref , child) {
          final orderController = ref.watch(newOrderFuture);
          final cartController = ref.watch(cartFuture);
          return Row(
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
                          SingleChildScrollView(
                            child: SizedBox(
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
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:
                                            orderController.paymentMethods.length,
                                        itemBuilder: (context, i) {
                                          return orderController.paymentMethods[i].id == 2 ||
                                              orderController.paymentMethods[i].id == 7
                                              ? Container()
                                              : PaymentItem(
                                                index: i,
                                                title: orderController.paymentMethods[i].title!.en!,
                                                color: orderController.paymentMethods[i].chosen? Constants.mainColor :Colors.white,
                                                textColor: orderController.paymentMethods[i].chosen? Colors.white:Colors.black,
                                                onTap: (){

                                                  setState(() {
                                                    orderController.paymentMethods[i].chosen = !orderController.paymentMethods[i].chosen ;
                                                  });

                                                  if(orderController.paymentMethods[i].chosen ) {
                                                    orderController.selectPayment(cartController.orderDetails,
                                                        i,cartController.getTotal());

                                                    if(orderController.paymentMethods[i].id == 1) {
                                                      ConstantStyles.showPopup(context: context,
                                                        content: AmountWidget(
                                                          predict1: orderController.predict1 !=
                                                              orderController.predict2
                                                              ? orderController.predict1.toString()
                                                              : null,
                                                          predict2: orderController.predict2.toString(),
                                                          predict3: orderController.predict3.toString(),
                                                          predict4: orderController.predict4.toString(),
                                                          showTextField: true,
                                                        ),
                                                        title:  'amount'.tr(),).then((value) {
                                                          if(value!=null) {
                                                          cartController.setPayment(
                                                              orderController
                                                                  .paymentMethods[i],
                                                              value);
                                                          setState(() {});
                                                        } else{
                                                            setState(() {
                                                              orderController.paymentMethods[i].chosen = false ;
                                                            });
                                                          }

                                                      });
                                                    }
                                                    else{
                                                      ConstantStyles.showPopup(context: context,
                                                        content: AmountWidget(
                                                          predict1: cartController.getTotal().toString(),
                                                          showTextField: true,
                                                        ),
                                                        title:  'amount'.tr(),).then((value) {
                                                        if(value!=null) {
                                                          cartController.setPayment(
                                                              orderController
                                                                  .paymentMethods[i],
                                                              value);
                                                          setState(() {});
                                                        } else
                                                         setState(() {
                                                           orderController.paymentMethods[i].chosen = false;
                                                         });
                                                      });

                                                    }
                                                  }
                                                  else{
                                                  cartController.removePayment(paymentModel: orderController.paymentMethods[i],clear: false);
                                                  }


                                                },

                                              );
                                        }),
                                  ),

                                  if(cartController.orderDetails.customer==null &&
                                      cartController.orderDetails.orderStatusID !=4 &&
                                      cartController.orderDetails.paymentStatus !=0)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: cartController.orderDetails.owner == null
                                              ? Colors.white
                                              : Constants.mainColor,
                                          borderRadius: BorderRadius.circular(10),
                                          border:
                                              Border.all(color: Colors.black12)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: ExpansionTile(
                                          key: Key(orderController.collapseKey.toString()),
                                          collapsedIconColor: Colors.lightGreen,
                                          iconColor: Colors.lightGreen,
                                          title: Center(
                                            child: Text(
                                              cartController.orderDetails.owner == null
                                                  ? 'others'.tr()
                                                  : cartController.orderDetails.owner!.title!,
                                              style: TextStyle(
                                                  fontSize: size.height * 0.02,
                                                  color:cartController.orderDetails.owner == null
                                                          ? Colors.black
                                                          : Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          children:
                                              orderController.owners.map((element) {
                                            return InkWell(
                                              onTap: () {
                                                cartController.removePayment(clear: true);
                                                orderController.selectOwner(cartController.orderDetails,element);
                                              },
                                              child: Container(
                                                width: size.width * 0.35,
                                                height: size.height * 0.06,
                                                color: element.chosen
                                                    ? Colors.lightGreen
                                                    : Colors.white,
                                                child: Center(
                                                  child: Text(
                                                    element.title!,
                                                    style: TextStyle(
                                                        fontSize:
                                                            size.height * 0.02,
                                                        color: element.chosen
                                                            ? Colors.white
                                                            : Colors.black,
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


                                  if (
                                 ( cartController.orderDetails.updateWithCoupon == false ||
                                     cartController.orderDetails.updateWithCoupon == null)
                                      && cartController.orderDetails.customer == null&&
                                     cartController.orderDetails.discount == 0 &&
                                     cartController.orderDetails.orderStatusID !=4
                                  )
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical:  10),
                                      child: SizedBox(
                                        width: size.width * 0.35,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 7,
                                              child: CustomTextField(
                                                controller: coupon,
                                                label: 'coupon'.tr(),
                                                hint: 'coupon'.tr(),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: CustomButton(
                                                title: 'add'.tr(),
                                                onTap: (){
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  cartController.checkCoupon(coupon.text);
                                                },
                                              )
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  if(cartController.orderDetails.discount != 0)
                                    Container(
                                      height: size.height*0.1,
                                      width: size.width*0.4,

                                      decoration: BoxDecoration(
                                         color: Colors.white,
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(color: Constants.mainColor)
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,

                                        children: [

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/images/discount.png',
                                                color: Constants.mainColor,
                                                height: 30,
                                                width: 30,
                                              ),
                                              SizedBox(width: 20,),
                                              Text('couponDiscount'.tr(),style: TextStyle(
                                                  color: Constants.mainColor,
                                                  fontSize: size.height*0.02
                                              ),)
                                            ],
                                          ),
                                          Text(
                                            '${cartController.orderDetails.discount} SAR',
                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),

                                  SizedBox(
                                    height: size.height * 0.06,
                                  ),
                                ],
                              ),
                            ),
                          ),
                              Padding(
                                padding:
                              getLanguage()=='en'?
                                const  EdgeInsets.fromLTRB(0, 0, 60, 0):
                               const EdgeInsets.fromLTRB(60, 0, 0, 0)  ,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: SizedBox(
                                    width: size.width * 0.3,
                                    height: size.height*0.9,
                                    child: Receipt(screenshotController: screenshotController,
                                        order: cartController.orderDetails,
                                        onScreenShot: (){
                                        orderController.testPrint(
                                          orderDetails: cartController.orderDetails,
                                          productsScreenshot: productsScreenshot!,
                                          productsImage: productsScreenshotUint8List!

                                        );
                                    }),
                                  ),
                                ),
                              ),
                            ],
                          ),

                    ),

                    ////////////////////////////// x button ///////////////////////////////
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment:getLanguage()=='en'?
                        Alignment.topRight:Alignment.topLeft,
                        child: InkWell(
                          onTap: () {
                            if(cartController.orderDetails.orderUpdatedId != null &&
                            cartController.orderDetails.paymentStatus == 0){

                              ConstantStyles.showPopup(context: context,
                                  content:  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context).size.height*0.07,
                                            width: MediaQuery.of(context).size.width*0.1,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10),
                                                color: Constants.mainColor),
                                            child: InkWell(
                                              onTap: () {
                                                // viewModel.emptyCardList();
                                                orderController.cancelPayment();
                                                Navigator.pushAndRemoveUntil(context,
                                                    MaterialPageRoute(builder: (_)=>Home()), (route) => false);

                                              },
                                              child: Center(
                                                child: Text(
                                                  'yes'.tr(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:24),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 40,),
                                          Container(
                                            height: MediaQuery.of(context).size.height*0.07,
                                            width: MediaQuery.of(context).size.width*0.1,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10),
                                                color: Constants.mainColor),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pop(context);

                                              },
                                              child: Center(
                                                child: Text(
                                                  'no'.tr(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:24),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                title:   'cancelEditing'.tr(),);
                            }
                           else{
                              orderController.cancelPayment();
                              Navigator.pop(context);
                            }

                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Colors.red[400],
                                borderRadius: BorderRadius.circular(10)),
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
                    ///////////////////////////////////////////////////////////////////done button//////////////////////
                    Align(
                      alignment: Alignment.bottomCenter,
                       child: Row(
                         children: [
                           Expanded(
                             child: Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: CustomButton(
                                 title:  '${'pay'.tr()}/${'send'.tr()}',
                                 onTap: (){
                                   orderController.confirmOrder(cartController.orderDetails,
                                       0,
                                       coupon.text,
                                       productsScreenshot!,
                                     productsScreenshotUint8List!,
                                   );
                                 },

                               ),
                             ),
                           ),
                           if (cartController.orderDetails.orderUpdatedId==null &&
                               cartController.orderDetails.customer==null)
                             Expanded(
                               child: Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: CustomButton(
                                   title:'hold'.tr(),
                                   onTap: (){
                                     orderController.confirmOrder(cartController.orderDetails,
                                       1,
                                       coupon.text,
                                       productsScreenshot!,
                                       productsScreenshotUint8List!,
                                     );
                                   },
                                 )
                               ),
                             ),

                             if( cartController.orderDetails.customer!=null)
                             Expanded(
                               child: Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: CustomButton(
                                   title: 'payLater'.tr(),
                                   onTap: (){
                                     orderController.confirmOrder(cartController.orderDetails,
                                       0,
                                       coupon.text,
                                       productsScreenshot!,
                                       productsScreenshotUint8List!,
                                     );
                                   },
                                 ),
                               ),
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
          );
        }
      ),
    );
  }
}
