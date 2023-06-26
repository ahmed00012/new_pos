

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:screenshot/screenshot.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/new_order_controller.dart';

import '../../data_controller/cart_controller.dart';






class Receipt extends ConsumerWidget{
  final scr = GlobalKey();
  ScreenshotController screenshotController;
  final  VoidCallback onScreenShot;

  Receipt({required this.screenshotController, required this.onScreenShot });

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = ref.watch(dataFuture);
    final orderController = ref.watch(newOrderFuture);
    final cartController = ref.watch(cartFuture);

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
                      child: Card(
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
                  if(cartController.orderDetails.branchName!=null)
                    Text(
                      cartController.orderDetails.branchName!,
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
                  if (cartController.orderDetails.payment1 != null)
                    Text(
                      cartController.orderDetails.payment1!.title!.en!,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  if (cartController.orderDetails.customer != null)
                    Text(
                      cartController.orderDetails.customer!.title!,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  // orderController.chosenOrderMethod != null||
                  //     cartController.cardItems[0].orderMethod != null
                  if (cartController.orderDetails.cart != null)
                    Container(
                      width: 150,
                      decoration: BoxDecoration(border: Border.all(width: 2)),
                      child: Center(
                        child: Text(
                          cartController.orderDetails.orderMethod ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  RepaintBoundary(
                    key: scr,
                    child: Screenshot(
                      controller: screenshotController,
                      child: Column(
                        children: [
                          Table(
                            border: TableBorder.all(),
                            columnWidths: const <int, TableColumnWidth>{
                              0: FixedColumnWidth(45),
                              1: FlexColumnWidth(),
                              2: FixedColumnWidth(90),
                              3: FixedColumnWidth(70),
                            },
                            children: [
                              TableRow(children: [
                                TableCell(
                                    verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Center(
                                        child: Text(
                                          'qty'.tr(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    )),
                                TableCell(
                                    verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                        child: Text(
                                          'item'.tr(),
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    )),
                                TableCell(
                                    verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                        child: Text(
                                          'price'.tr(),
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    )),
                                TableCell(
                                    verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                        child: Text(
                                          'total'.tr(),
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    )),
                              ])
                            ],
                          ),
                          if (cartController.orderDetails.cart != null)
                            Table(
                              border: TableBorder.all(),
                              columnWidths: const <int, TableColumnWidth>{
                                0: FixedColumnWidth(45),
                                1: FlexColumnWidth(),
                                // 2: FixedColumnWidth(90),
                                2: FixedColumnWidth(70),
                              },
                              children:
                              cartController.orderDetails.cart!.map((e) {
                                return TableRow(children: [
                                  TableCell(
                                    verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Center(
                                        child: Text(
                                          e.count.toString(),
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  // width: size.width*0.25,
                                                  child: Text(
                                                    e.title!,
                                                    style: TextStyle(
                                                        fontSize: size.height*0.02,
                                                        height: 1,
                                                        fontWeight:
                                                        FontWeight.w500),
                                                  ),
                                                ),
                                                SizedBox(width: 5,),
                                                // Spacer(),
                                                Text(
                                                  e.price.toString() + ' SAR',
                                                  style: TextStyle(
                                                      fontSize: size.height*0.018,
                                                      fontWeight:
                                                      FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5,),
                                            ListView.builder(
                                              itemCount: e.attributes!.length,
                                              shrinkWrap: true,
                                              physics:
                                              NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, j) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Container(
                                                    width: size.width*0.12,
                                                    child: Row(
                                                      children: [
                                                        if (cartController.inList(
                                                          attribute:
                                                            e.attributes![j],
                                                            productIndex:
                                                            cartController
                                                                .orderDetails
                                                                .cart!
                                                                .indexOf(e)))
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                        Expanded(
                                                          child: Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                              children: e
                                                                  .attributes![j]
                                                                  .values!
                                                                  .map((value) => e
                                                                  .allAttributesID!
                                                                  .contains(
                                                                  value.id)
                                                                  ? Row(
                                                                children: [
                                                                  Expanded(

                                                                    child: Text(
                                                                        value.attributeValue!.en!,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(color: Colors.black,
                                                                            fontSize: size.height*0.02,
                                                                            fontWeight: FontWeight.w500)),
                                                                  ),
                                                                  SizedBox(width: 5,),

                                                                  if(value.realPrice!=null)
                                                                    Text(
                                                                        value.realPrice.toString() + ' SAR',
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(color: Colors.black,
                                                                            fontSize: size.height*0.018,
                                                                            fontWeight: FontWeight.w500))
                                                                ],
                                                              )
                                                                  : Container())
                                                                  .toList()),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            if (e.extra != null)
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: e.extra!.map((extra) {
                                                  return Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        2.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            extra.titleEn!,

                                                            style: TextStyle(
                                                                fontSize: size.height*0.02,
                                                                overflow: TextOverflow.ellipsis,
                                                                fontWeight:
                                                                FontWeight.w500),
                                                          ),
                                                        ),

                                                        SizedBox(width: 5,),
                                                        Text(
                                                          extra.price.toString() + ' SAR',
                                                          style: TextStyle(
                                                              fontSize: size.height*0.018,
                                                              fontWeight:
                                                              FontWeight.w500),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            if (e.extraNotes != null)
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(2.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        e.extraNotes!,
                                                        style: TextStyle(
                                                            fontSize: size.height*0.02,
                                                            fontWeight:
                                                            FontWeight.w500),
                                                      ),
                                                    ),

                                                    // Spacer(),
                                                    SizedBox(width: 5,),
                                                    Text(
                                                      '0.0 SAR',
                                                      style: TextStyle(
                                                          fontSize: size.height*0.018,
                                                          fontWeight:
                                                          FontWeight.w500),
                                                    )
                                                  ],
                                                ),
                                              )
                                          ],
                                        )),
                                  ),

                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 5),
                                      child: Center(
                                        child: Text(
                                          e.total.toString() + ' SAR',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]);
                              }).toList(),
                            ),
                          SizedBox(
                            height: 40,
                          ),
                          Table(
                            border: TableBorder.all(),
                            children: [
                              if (cartController.orderDetails.amount1 != null)
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                      child: Text(
                                        'paid'.tr(),
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                      child: Text(
                                        cartController.orderDetails
                                            .getTotalAmount()
                                            .toStringAsFixed(2) +
                                            ' SAR ',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ]),
                              if (cartController.orderDetails.amount1 != null)
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                      child: Text(
                                        'remaining'.tr(),
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                      child: Text(
                                        (cartController.orderDetails
                                            .getTotalAmount() -
                                            cartController.orderDetails
                                                .getTotal())
                                            .toStringAsFixed(2) +
                                            ' SAR ',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ]),
                              if(cartController.orderDetails.tax!=null)
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                      child: Text(
                                        'tax'.tr(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                      child: Text(
                                        cartController.orderDetails.tax!
                                            .toStringAsFixed(2) +
                                            ' SAR ',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ]),
                              if (cartController.orderDetails.deliveryFee != null)
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                      child: Text(
                                        'delivery'.tr(),
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                      child: Text(
                                        cartController.orderDetails.deliveryFee.toString()+  ' SAR',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ]),

                              if (cartController.orderDetails.delivery != null)
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                      child: Text(
                                        'delivery'.tr(),
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                      child: Text(
                                        cartController.orderDetails.delivery.toString()+  ' SAR',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ]),
                              if (cartController.orderDetails.discount != null)
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                      child: Text(
                                        'discount'.tr(),
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                      child:
                                      cartController.orderDetails.discount!.contains('%')?
                                      Text(
                                        cartController.orderDetails.discount!,
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ):
                                      Text(
                                        cartController.orderDetails.discount!+  ' SAR',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ]),
                              if(cartController.orderDetails.cart!=null)
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Center(
                                      child: Text(
                                        'total'.tr(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Center(
                                      child: Text(
                                        cartController.orderDetails
                                            .getTotal()
                                            .toStringAsFixed(2) +
                                            ' SAR ',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ]),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),



                          SizedBox(
                            height: 20,
                          ),

                          Text(
                            'contactUs'.tr(),
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/twitter.png',
                                  width: 35,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  orderController.twitter,
                                  style: TextStyle(fontSize: size.height*0.022),
                                ),
                                Spacer(),
                                Image.asset(
                                  'assets/images/instagram.png',
                                  width: 35,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  orderController.instagram,
                                  style: TextStyle(fontSize: size.height*0.022),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/call.png',
                                width: 35,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                orderController.phone,
                                style: TextStyle(fontSize: size.height*0.022),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
