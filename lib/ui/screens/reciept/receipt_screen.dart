
import 'dart:typed_data';
import 'package:davinci/core/davinci_capture.dart';
import 'package:davinci/core/davinci_core.dart';
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
  final String? orderNo;
  Receipt({required this.order,this.orderNo});

  GlobalKey? imageKey;
  final scr = GlobalKey();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: SingleChildScrollView(
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
                        onTap: () async {
                          Uint8List uints = await DavinciCapture.click(
                            returnImageUint8List: true,
                            imageKey!,
                            context: context,
                          );
                          PrintingService.printInvoice(order: order, pic: uints);
                        },
                        child: Container(

                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child:const Padding(
                            padding:  EdgeInsets.all(7.0),
                            child: Icon(
                              Icons.print,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/logo.png',
                      height: 140,
                    ),


                    Davinci(builder: (key) {
                      imageKey = key;
                      return RepaintBoundary(
                        key: scr,
                        child: Column(
                          children: [
                            if(orderNo!=null)
                              Text(
                                orderNo!,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            Text(
                              getBranchName(),
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Tax No. : ${getTaxNumber()}',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              DateTime.now().toString().substring(0, 16),
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '${'employee'.tr()} : ${getUserName()}',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            if (order.clientName != null)
                              Text(
                                '${'client'.tr()} : ${order.clientName}',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            Column(
                              children: List.generate(
                                  order.payMethods.length,
                                      (index) => Text(
                                    order.payMethods[index].title ?? '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  )),
                            ),
                            const SizedBox(
                              height: 10,
                            ),


                            if (order.customer != null && order.payLater)
                              Text("${order.customer!.title!}  -  ${'payLater'.tr()}",
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),

                            if (order.customer != null && !order.payLater)
                              Text(order.customer!.title!,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),

                            if (order.owner != null)
                              const SizedBox(
                                height: 10,
                              ),
                            if (order.owner != null)
                              Text(  '${'owner'.tr()} : ${order.owner!.title!}',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),

                            if (order.department != null)
                              const SizedBox(
                                height: 10,
                              ),
                            if (order.department != null)
                              Text( order.department!,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),

                            if (order.tableId != null)
                              const SizedBox(
                                height: 10,
                              ),
                            if (order.tableId != null)
                              Text(order.tableTitle!,
                                style: const TextStyle(
                                  fontSize: 18,
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
                                    style: const TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.w500),
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
                                Text(getPhone()),
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
                                Text(getInstagram()),
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
                                Text(getInstagram()),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      );
                    }
                    )

                  ],
                ),
              ),
            ),
          )

      ),
    );
  }
}
