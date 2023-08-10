import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/printing_services/printing_service.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/prefs_utils.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/cart_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/tables_controller.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';
import '../../../../models/cart_model.dart';
import '../../../../models/tables_model.dart';
import '../../../widgets/bottom_nav_bar.dart';
import '../../orders/widgets/cancel_widget.dart';
import '../../reciept/widgets/products_table.dart';

class TableOrder extends StatelessWidget {

  final CurrentOrder order;
  final Department department;
  final Tables table;
  final Function(OrderDetails) onScreenshot;


  TableOrder({super.key, required this.order,required this.department, required this.table,
  required this.onScreenshot});

  @override
  Widget build(BuildContext context) {
    // final viewModel = ref.watch(ordersFuture);
    // final cartController = ref.watch(cartFuture);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer(builder: (context, ref, child) {
        final cartController = ref.watch(cartFuture);
        // final ordersController = ref.watch(tablesFuture);
        return Stack(
          children: [
            Container(
              color: Colors.white,
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () {
                    OrderDetails orderDetails =
                    cartController.editOrderTable(order: order , department: department , table: table );
                    onScreenshot(orderDetails);
                      // PrintingService.printInvoice(
                      //     order: orderDetails,
                      //     table: ProductsTable(cart: orderDetails.cart));
                    },
                    child: Icon(
                      Icons.print,
                      color: Constants.mainColor,
                      size: 30,
                    )),
              ),
            ),
            Column(
              children: [

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Column(
                      children: [
                        Text(
                          '${'orderNumber'.tr()}:  ${order.uuid}',
                          style: TextStyle(
                              fontSize: size.height * 0.028,
                              fontWeight: FontWeight.bold,
                              color: Constants.mainColor,
                              fontStyle: FontStyle.italic),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          order.createdAt!,
                          style: TextStyle(
                              fontSize: size.height * 0.02,
                              fontWeight: FontWeight.bold,
                              color: Constants.mainColor),
                        ),

                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          order.orderStatus!.title!.en!,
                          style: TextStyle(
                              fontSize: size.height * 0.02,
                              fontWeight: FontWeight.bold,
                              color: Constants.mainColor),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        Expanded(
                            child: ListView.builder(
                                itemCount: order.details!.length,
                                itemBuilder: (context, i) {
                                  List<DetailsTables> details = order.details!;

                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.grey, width: 0.5)),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              details[i].quantity.toString() +
                                                  'X  ' +
                                                  details[i].product!.title!.en!,
                                              style: TextStyle(
                                                  fontSize: size.height * 0.022,
                                                  color: Constants.mainColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          ListView.separated(
                                            itemCount:
                                            details[i].attributes!.length,
                                            physics:
                                            NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, j) {
                                              return Padding(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 2),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        details[i]
                                                            .attributes![j]
                                                            .attribute!.title!.en!,
                                                        style: TextStyle(
                                                            fontSize:
                                                            size.height *
                                                                0.018,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            letterSpacing: 0.1,
                                                            color: Constants
                                                                .lightBlue,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: size.width * 0.12,
                                                      alignment:
                                                      Alignment.centerRight,
                                                      child: Text(
                                                        details[i]
                                                            .attributes![j].attributeValue!.
                                                        attributeValueTitle!.en!,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            fontSize:
                                                            size.height *
                                                                0.018,
                                                            letterSpacing: 0.1,
                                                            color: Constants
                                                                .lightBlue),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            separatorBuilder:
                                                (BuildContext context,
                                                int index) {
                                              return Divider();
                                            },
                                          ),
                                          if (details[i].notes!.isNotEmpty &&
                                              details[i].attributes!.isNotEmpty)
                                            Divider(),
                                          ListView.separated(
                                            itemCount: details[i].notes!.length,
                                            physics:
                                            NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, j) {
                                              return Padding(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 2),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  textDirection:
                                                  getLanguage() == 'en'
                                                      ? TextDirection.ltr
                                                      : TextDirection.rtl,
                                                  children: [
                                                    Text(
                                                      details[i].notes![j].title!,
                                                      style: TextStyle(
                                                          fontSize:
                                                          size.height * 0.018,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          letterSpacing: 0.1,
                                                          color:
                                                          Constants.lightBlue,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '${details[i].notes![j].price} SAR',
                                                      style: TextStyle(
                                                        fontSize:
                                                        size.height * 0.018,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                        letterSpacing: 0.1,
                                                        color:
                                                        Constants.lightBlue,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            separatorBuilder:
                                                (BuildContext context,
                                                int index) {
                                              return Divider();
                                            },
                                          ),
                                          if ((details[i].notes!.isNotEmpty ||
                                              details[i]
                                                  .attributes!
                                                  .isNotEmpty) &&
                                              details[i].note != null)
                                            Divider(),
                                          if (details[i].note != null)
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                    'notes'.tr(),
                                                    style: TextStyle(
                                                        fontSize:
                                                        size.height * 0.02,
                                                        color: Colors.red),
                                                  ),
                                                  Text(
                                                    details[i].note!,
                                                    style: TextStyle(
                                                        fontSize:
                                                        size.height * 0.02,
                                                        color: Colors.red),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          SizedBox(
                                            height: 5,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                })),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            SizedBox(
                              height: 5,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  department.title!,
                                  style: TextStyle(
                                      fontSize: size.height * 0.02,
                                      fontWeight: FontWeight.bold,
                                      color: Constants.mainColor),
                                ),

                                Text(
                                  table.title!,
                                  style: TextStyle(
                                      fontSize: size.height * 0.02,
                                      fontWeight: FontWeight.bold,
                                      color: Constants.mainColor),
                                ),

                              ],
                            ),

                            if (order.discount != 0)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'discount'.tr(),
                                    style: TextStyle(
                                        fontSize: size.height * 0.02,
                                        fontWeight: FontWeight.bold,
                                        color: Constants.mainColor),
                                  ),
                                  Text(
                                    '- ${order.discount} SAR',
                                    style: TextStyle(
                                        fontSize: size.height * 0.02,
                                        fontWeight: FontWeight.bold,
                                        color: Constants.mainColor),
                                  ),
                                ],
                              ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'total'.tr(),
                                  style: TextStyle(
                                      fontSize: size.height * 0.02,
                                      fontWeight: FontWeight.bold,
                                      color: Constants.mainColor),
                                ),
                                Text(
                                  '${order.total} SAR ',
                                  style: TextStyle(
                                      fontSize: size.height * 0.02,
                                      fontWeight: FontWeight.bold,
                                      color: Constants.mainColor),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                if (order.orderStatusId != 5 &&
                    order.orderStatusId != 8 &&
                    order.orderStatusId != 10
                    )
                  Container(
                    height: 50,
                    child: Row(
                      children: [
                        Flexible(
                          child: InkWell(
                            onTap: () {
                              ConstantStyles.showPopup(context: context,
                                content: CancelWidget(orderId: order.id!,
                                  mobileOrders: false,
                                ),
                                title:  'cancelOrder'.tr(),);
                            },
                            child: Container(
                              color: Constants.secondryColor,
                              child: Center(
                                child: Text(
                                  'cancelOrder'.tr(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height * 0.025,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: InkWell(
                            onTap: () {

                              cartController.orderDetails =  cartController.editOrderTable(
                                order: order,
                                department: department,
                                table: table
                              );
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BottomNavBar()),
                                      (route) => false);

                            },
                            child: Container(
                              color: Constants.mainColor,
                              child: Center(
                                child: Text(
                                  'editOrder'.tr(),
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
                    ),
                  ),

                // if (order.orderStatusId == 1)
                //   Container(
                //     height: 50,
                //     child: Row(
                //       children: [
                //         Flexible(
                //           child: InkWell(
                //             onTap: () {
                //               // viewModel.complain( size, context,false, orderId: viewModel
                //               //     .orders[viewModel.chosenOrder!].id!);
                //             },
                //             child: Container(
                //               color: Constants.secondryColor,
                //               child: Center(
                //                 child: Text(
                //                   'cancelOrder'.tr(),
                //                   style: TextStyle(
                //                     color: Colors.white,
                //                     fontSize: size.height * 0.025,
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ),
                //         Flexible(
                //           child: InkWell(
                //             onTap: () {
                //               // viewModel.acceptOrder();
                //             },
                //             child: Container(
                //               color: Constants.mainColor,
                //               child: Center(
                //                 child: Text(
                //                   'acceptOrder'.tr(),
                //                   style: TextStyle(
                //                     color: Colors.white,
                //                     fontSize: size.height * 0.025,
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                //
                // if (order.orderStatusId !=1 &&
                //     order.orderStatusId != 8 &&
                //     order.orderStatusId != 9 &&
                //     order.orderStatusId != 5 &&
                //     order.paymentStatus == 0 &&
                //     order.orderStatusId != 10 )
                //   Container(
                //     height: 50,
                //     child: InkWell(
                //       onTap: () {
                //       cartController.editOrderTable(order: order, table: table, department: department);
                //       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>
                //       BottomNavBar()), (route) => false);
                //
                //       },
                //       child: Container(
                //         color: Constants.mainColor,
                //         child: Center(
                //           child: Text(
                //             'editOrder'.tr(),
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontSize: size.height * 0.025,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),


              ],
            )
            // if (viewModel.loading)
            //   Container(
            //     height: size.height,
            //     width: size.width,
            //     color: Colors.white.withOpacity(0.5),
            //   )
          ],
        );
      }
      ),
    );
  }
}
