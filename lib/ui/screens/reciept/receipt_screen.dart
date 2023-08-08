
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

import 'package:shormeh_pos_new_28_11_2022/constants/prefs_utils.dart';
import 'package:shormeh_pos_new_28_11_2022/models/cart_model.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/reciept/widgets/payment_summary_table.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/reciept/widgets/products_table.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/reciept/widgets/table_header.dart';
import '../../../constants/printing_services/printing_service.dart';


class Receipt extends StatelessWidget {

  final OrderDetails order;

  Receipt({required this.order,this.scr});

  // final GlobalKey? imageKey;
  final GlobalKey ?scr;
  // final  ScreenshotController? screenshotController;

  // this.screenshotController,


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: RepaintBoundary(
          key: scr,
          child: Container(

                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        // Align(
                        //   alignment: Alignment.topLeft,
                        //   child: InkWell(
                        //     onTap:  (){
                        //         // screenshotController2.capture(
                        //         //     delay: Duration(milliseconds: 100)
                        //         // ).then((Uint8List? image) {
                        //         //   PrintingService.printInvoice(order: order, pic: image!);
                        //         // });
                        //     },
                        //     child: Container(
                        //       decoration: BoxDecoration(
                        //           color: Colors.green,
                        //           borderRadius: BorderRadius.circular(10)
                        //       ),
                        //       child:const Padding(
                        //         padding:  EdgeInsets.all(7.0),
                        //         child: Icon(
                        //           Icons.print,
                        //           color: Colors.white,
                        //           size: 25,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Image.asset(
                          'assets/images/logo.png',
                          width: size.width*0.1,
                        ),
                      Text(
                        getBranchName(),
                        style: TextStyle(
                          fontSize: size.height*0.025,
                        ),
                      ),
                      Text(
                        'Tax No. : ${getTaxNumber()}',
                        style: TextStyle(
                          fontSize: size.height*0.025,
                        ),
                      ),
                      Text(
                       order.orderTime?? DateTime.now().toString().substring(0, 16),
                        style: TextStyle(
                          fontSize: size.height*0.025,
                        ),
                      ),
                      Text(
                        '${'employee'.tr()} : ${getUserName()}',
                        style:  TextStyle(
                          fontSize: size.height*0.025,
                        ),
                      ),
                      if (order.clientName != null)
                        Text(
                          '${'client'.tr()} : ${order.clientName}',
                          style:  TextStyle(
                            fontSize: size.height*0.025,

                          ),
                        ),
                      Column(
                        children: List.generate(
                            order.payMethods.length,
                                (index) => Text(
                              order.payMethods[index].title ?? '',
                              style:  TextStyle(
                                fontSize: size.height*0.025,
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),


                      if (order.customer != null && order.payLater)
                        Text("${order.customer!.title!}  -  ${'payLater'.tr()}",
                          style:  TextStyle(
                            fontSize: size.height*0.025,
                          ),
                        ),

                      if (order.customer != null && !order.payLater)
                        Text(order.customer!.title!,
                          style:  TextStyle(
                            fontSize: size.height*0.025,
                          ),
                        ),

                      if (order.owner != null)
                        const SizedBox(
                          height: 10,
                        ),
                      if (order.owner != null)
                        Text(  '${'owner'.tr()} : ${order.owner!.title!}',
                          style:  TextStyle(
                            fontSize: size.height*0.025,
                          ),
                        ),

                      if (order.department != null)
                        const SizedBox(
                          height: 10,
                        ),
                      if (order.department != null)
                        Text( order.department!,
                          style:  TextStyle(
                            fontSize: size.height*0.025,
                          ),
                        ),

                      if (order.tableId != null)
                        const SizedBox(
                          height: 10,
                        ),
                      if (order.tableId != null)
                        Text(order.tableTitle!,
                          style:  TextStyle(
                            fontSize: size.height*0.025,
                          ),
                        ),
                      if (order.tableId != null)
                        const SizedBox(
                          height: 10,
                        ),
                      if (order.orderMethod != null)
                        Container(
                          width: 300,
                          decoration: BoxDecoration(border: Border.all(width: 2)),
                          padding: EdgeInsets.all(5),
                          child: Center(
                            child: Text(
                              order.orderMethod!,
                              textAlign: TextAlign.center,
                              style:  TextStyle(
                                  fontSize: size.height*0.025,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),


                      const SizedBox(
                        height: 20,
                      ),
                      const TableHeader(),
                      ProductsTable(cart: order.cart),
                      const SizedBox(
                        height: 20,
                      ),
                      PaymentSummaryTable(
                        total: order.total,
                        tax: order.tax,
                        remainingAmount: order.remaining,
                        paidAmount: order.paid,
                        discount: order.discount,
                        deliveryFee: order.deliveryFee,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone,
                            size: 25,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(getPhone(),style: TextStyle(fontSize: size.height*0.025),),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/instagram.png',
                            height: 25,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(getInstagram(),style: TextStyle(fontSize: size.height*0.025),),
                          SizedBox(
                            width: 30,
                          ),
                          Image.asset(
                            'assets/images/twitter.png',
                            height: 25,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(getInstagram(),style: TextStyle(fontSize: size.height*0.025),),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      )

                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
