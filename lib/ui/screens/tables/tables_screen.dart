
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/tables_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/tables/widgets/table_order.dart';
import '../../../constants/colors.dart';
import '../../../constants/printing_services/printing_service.dart';
import '../../../data_controller/cart_controller.dart';
import '../../../models/tables_model.dart';
import '../reciept/receipt_screen.dart';
import 'widgets/num_of_guests.dart';

class TablesScreen extends StatefulWidget {
  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  // ScreenshotController screenshotController = ScreenshotController();
  CurrentOrder? chosenOrder;
  Tables? chosenTable;
  Department? chosenDepartment;
  GlobalKey repaintBoundaryKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Consumer(
            builder: (context,ref , child) {
              final tablesController = ref.watch(tablesFuture);
              final cartController = ref.watch(cartFuture);
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    height: size.height,
                    width: size.width * 0.28,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if(chosenOrder!=null)
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child:  Receipt(order: cartController.editOrderTable(
                                order: chosenOrder!,
                                table: chosenTable!,
                                department: chosenDepartment!
                            ),
                              repaintRenderKey: repaintBoundaryKey,),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Card(
                              elevation: 5,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: chosenOrder != null
                                  ? _buildOrderInvoiceScreen(
                                order: chosenOrder!,
                                department: chosenDepartment!,
                                table: chosenTable!,

                              )
                                  : Container()),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child:Stack(
                      fit: StackFit.expand,
                      children: [
                          //

                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 20),
                        //   child: Container(
                        //     width: size.width ,
                        //     height: size.height,
                        //     color: Constants.scaffoldColor,
                        //   ),
                        // ),
                        Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: tablesController.departments.length,
                                  itemBuilder: (context, index) {
                                    return ListView(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: [
                                        SizedBox(
                                          height: 35,
                                        ),
                                        Center(
                                          child: Text(
                                            tablesController.departments[index].title!,
                                            style: TextStyle(
                                                fontSize: size.height * 0.03,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold,
                                                color: Constants.lightBlue),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        GridView.builder(
                                          itemCount:
                                          tablesController.departments[index].tables!.length,
                                          physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 6,
                                            childAspectRatio: 1.5,
                                          ),
                                          itemBuilder: (context, i) {
                                            return Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              elevation: 2,
                                              child: InkWell(
                                                onTap: () {
                                                  // if(tablesController.departments[index].tables![i].currentOrder==null) {
                                                  //   showDialog(
                                                  //       context: context,
                                                  //       builder: (context) {
                                                  //         return AlertDialog(
                                                  //             backgroundColor:
                                                  //             Constants
                                                  //                 .scaffoldColor,
                                                  //             title: Center(
                                                  //               child: Text(
                                                  //                 'Count Of Guests',
                                                  //                 style: TextStyle(
                                                  //                   fontSize:
                                                  //                   size.height *
                                                  //                       0.03,
                                                  //                 ),
                                                  //               ),
                                                  //             ),
                                                  //             content: CountOfGuests());
                                                  //       }).then((value) {
                                                  //     if (value != null) {
                                                  //
                                                  //       // tablesController
                                                  //       //     .reserveTable(
                                                  //       //         index,
                                                  //       //         tablesController
                                                  //       //             .departments[
                                                  //       //                 index]
                                                  //       //             .tables![i],
                                                  //       //         value,
                                                  //       //         context,false,
                                                  //       //     cartController.orderDetails)
                                                  //       //     .then((value) {
                                                  //       //   // homeController.selectedTab =
                                                  //       //   //     SelectedTab.home;
                                                  //       // });
                                                  //     }
                                                  //   });
                                                  // }
                                                  // else
                                                    if(tablesController.departments[index].tables![i].currentOrder!=null){
                                                    setState(() {
                                                      chosenOrder = tablesController.departments[index].tables![i].currentOrder;
                                                      chosenDepartment = tablesController.departments[index];
                                                      chosenTable = tablesController.departments[index].tables![i];
                                                    });
                                                    tablesController.getCurrentOrder( index, i);
                                                  }

                                                  else{

                                                    ConstantStyles.displayToastMessage('No order found', true);
                                                  }
                                                  // tablesController.confirmOrderPrinter(index, i, context, size, cartController, printerController);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: tablesController
                                                          .departments[index]
                                                          .tables![i]
                                                          .currentOrder !=
                                                          null ||
                                                          tablesController.departments[index]
                                                              .tables![i].chosen!
                                                          ? Constants.mainColor
                                                          : Colors.white,
                                                      borderRadius:
                                                      BorderRadius.circular(10.0),
                                                      border: Border.all(
                                                        color: Constants.mainColor,)),
                                                  child: Center(
                                                    child: Text(
                                                      tablesController
                                                          .departments[index].tables![i].title!.toString(),
                                                      style: TextStyle(
                                                          color: tablesController
                                                              .departments[index]
                                                              .tables![i]
                                                              .currentOrder !=
                                                              null ||
                                                              tablesController
                                                                  .departments[index]
                                                                  .tables![i]
                                                                  .chosen!
                                                              ? Colors.white
                                                              : Constants.mainColor,
                                                          fontSize: size.height * 0.03),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                            SizedBox(
                              height: 100,
                            ),
                          ],
                        ),
                        if(tablesController.loading)
                          Container(
                            height: size.height,
                            width: size.width,
                            color: Colors.white.withOpacity(0.5),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Constants.mainColor,
                              ),
                            ),
                          )
                      ],
                    )
                  )
                ],
              );
            }
          ),

        ],
      ),
    );
  }

  Widget _buildOrderInvoiceScreen({required CurrentOrder order,required Tables table , required Department department}) {
    return TableOrder(
      order: order,
      table: table,
        department: department,
      onScreenshot: (order){
        PrintingService.captureImage(
            order: order,
            context: context,
            globalKey: repaintBoundaryKey,
            orderNo:order.orderNumber
        );

        // PrintingService.receiptToImage(
        //     orderDetails: order,
        //     imageKey: imageKey!,
        //     context: context,
        //     orderNo: order.orderNumber
        // );
      },
    );
  }
}
