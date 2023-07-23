

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:screenshot/screenshot.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/prefs_utils.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/new_order_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/models/cart_model.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/reciept/widgets/payment_summary_table.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/reciept/widgets/products_table.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/reciept/widgets/table_header.dart';

import '../../../constants/printing_services/invoice_widget.dart';
import '../../../data_controller/cart_controller.dart';


class Receipt extends ConsumerWidget{
  final scr = GlobalKey();
  final ScreenshotController screenshotController;
  final  VoidCallback onScreenShot;
  final OrderDetails order;

  Receipt({required this.screenshotController, required this.onScreenShot , required this.order });

  @override
  Widget build(BuildContext context, ref) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [

                  Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: onScreenShot,
                      child:const Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(Icons.print,color: Colors.black,size: 25,),
                        ),
                      ),
                    ),
                  ),
                  
                  Image.asset(
                    'assets/images/logo.png',
                    height: 120,
                  ),
                    Text(
                      getBranchName(),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  Text(
                    DateTime.now().toString().substring(0, 16),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  Column(
                    children: List.generate(order.payMethods.length,
                            (index) =>  Text(
                              order.payMethods[index].title!,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            )),
                  ),

                 const SizedBox(
                    height: 10,
                  ),
                    Container(
                      width: 150,
                      decoration: BoxDecoration(border: Border.all(width: 2)),
                      child: Center(
                        child: Text(
                          order.orderMethod ?? '',
                          textAlign: TextAlign.center,
                          style:const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  const  SizedBox(
                    height: 20,
                  ),
                  InvoiceWidget.invoiceProducts(order),
                  // RepaintBoundary(
                  //   key: scr,
                  //   child: Screenshot(
                  //     controller: screenshotController,
                  //     child: InvoiceWidget().invoiceProducts(order),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
