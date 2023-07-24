import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/tables_controller.dart';

import '../../constants/colors.dart';
import '../../local_storage.dart';
import '../../models/tables_model.dart';




class TableOrder extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final tablesController = ref.watch(tablesFuture);
     final homeController = ref.watch(dataFuture);
    Size size = MediaQuery.of(context).size;

    return Container(
      child: tablesController.chosenOrder != null
          ? Column(
        children: [
          // if(viewModel.orders[viewModel.chosenOrder!].orderStatusId!=7)
          //   InkWell(
          //     onTap: (){
          //       viewModel.complain(size, context);
          //     },
          //     child: Container(
          //         height: 35,
          //         color: Colors.red[500],
          //         child:Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Icon(Icons.warning_amber_outlined,color: Colors.white,),
          //             SizedBox(width: 10,),
          //             Text(
          //               'complainOrder'.tr(),
          //               style: TextStyle(
          //                 color: Colors.white,
          //                 fontSize: size.height*0.02,
          //               ),
          //             ),
          //
          //           ],
          //         )
          //     ),
          //   ),

          Expanded(
            child: Column(
              children: [
               Container(
                 height: size.height*0.08,
                 width: size.width,

                 decoration: BoxDecoration(
                     color: Constants.mainColor,
                   borderRadius: BorderRadius.only(
                     topLeft: Radius.circular(10),
                     topRight: Radius.circular(10),
                   )
                 ),
                 child:  Center(
                   child: Text(
                     'orderNumber'.tr()+ ':  ${tablesController.chosenOrderNum!}',
                     style: TextStyle(
                         fontSize: size.height * 0.028,
                         fontWeight: FontWeight.bold,
                         color: Colors.white,
                         fontStyle: FontStyle.italic),
                   ),
                 ),
               ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  tablesController.currentOrder!.createdAt!,
                  style: TextStyle(
                      fontSize: size.height * 0.02,
                      fontWeight: FontWeight.bold,
                      color: Constants.mainColor),
                ),

                SizedBox(
                  height: 5,
                ),
                Text(
                  tablesController.currentOrder!.currentOrder!.orderStatus!.title!.en!,
                  style: TextStyle(
                      fontSize: size.height * 0.02,
                      fontWeight: FontWeight.bold,
                      color: Constants.mainColor),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Divider(),
                ),
                // Expanded(
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 10),
                //       child: ListView.builder(
                //           itemCount: tablesController.currentOrder!.currentOrder!
                //               .details!.length,
                //           itemBuilder: (context, i) {
                //             List<DetailsTables> details =  tablesController.currentOrder!
                //                 .currentOrder!.details!;
                //
                //             return Card(
                //               elevation: 2,
                //               child: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Padding(
                //                     padding: const EdgeInsets.all(10.0),
                //                     child: Text(
                //                       details[i].quantity.toString() +
                //                           'X  ' +
                //                           details[i].product!.title!.en!,
                //                       style: TextStyle(
                //                           fontSize: size.height * 0.022,
                //                           color: Constants.mainColor,
                //                           fontWeight: FontWeight.bold),
                //                     ),
                //                   ),
                //
                //                   ListView.separated(
                //                     itemCount: details[i].notes!.length,
                //                     physics: NeverScrollableScrollPhysics(),
                //                     shrinkWrap: true,
                //                     itemBuilder: (context,j){
                //                       return Padding(
                //                         padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                //                         child: Row(
                //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                           children: [
                //                             Text(details[i].notes![j].title!,style: TextStyle(
                //                                 fontSize: size.height*0.02,
                //                                 color: Constants.lightBlue
                //                             ),),
                //
                //                             Text(details[i].notes![j].price.toString()+' SAR',style: TextStyle(
                //                                 fontSize: size.height*0.02,
                //                                 color: Constants.lightBlue
                //                             ),),
                //                           ],
                //                         ),
                //                       );
                //
                //                     }, separatorBuilder: (BuildContext context, int index) { return Divider(); },),
                //                   if(details[i].note!=null)
                //                     Divider(),
                //                   if(details[i].note!=null)
                //                     Row(
                //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                       children: [
                //                         Text(details[i].note!,style: TextStyle(
                //                             fontSize: size.height*0.02,
                //                             color: Constants.lightBlue
                //                         ),),
                //
                //                         Text('0,0'+' SAR',style: TextStyle(
                //                             fontSize: size.height*0.02,
                //                             color: Constants.lightBlue
                //                         ),),
                //                       ],
                //                     )
                //                 ],
                //               ),
                //             );
                //           }),
                //     )),
                Expanded(
                    child: ListView.builder(
                          itemCount: tablesController.currentOrder!.currentOrder!
                              .details!.length,
                          itemBuilder: (context, i) {
                            List<DetailsTables> details =  tablesController.currentOrder!
                                .currentOrder!.details!;


                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey,width: 0.5)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    itemCount: details[i].attributes!.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context,j){
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(details[i].attributes![j].attribute!.title!.en!,style: TextStyle(
                                                fontSize: size.height*0.02,
                                                color: Constants.lightBlue
                                            ),),

                                            Text(details[i].attributes![j].attributeValue!.attributeValueTitle!.en!.toString(),style: TextStyle(
                                                fontSize: size.height*0.02,
                                                color: Constants.lightBlue
                                            ),),
                                          ],
                                        ),
                                      );

                                    }, separatorBuilder: (BuildContext context, int index) { return Divider(); },),

                                  if(details[i].notes!.isNotEmpty && details[i].attributes!.isNotEmpty)
                                    Divider(),
                                  ListView.separated(
                                    itemCount: details[i].notes!.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context,j){
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          textDirection:
                                          LocalStorage.getData(key: 'language')=='en'?
                                          TextDirection.ltr:TextDirection.rtl,
                                          children: [
                                            Text(details[i].notes![j].title!,style: TextStyle(
                                                fontSize: size.height*0.02,
                                                color: Constants.lightBlue
                                            ),),

                                            Text(details[i].notes![j].price.toString()+' SAR',style: TextStyle(
                                                fontSize: size.height*0.02,
                                                color: Constants.lightBlue
                                            ),),
                                          ],
                                        ),
                                      );

                                    }, separatorBuilder: (BuildContext context, int index) { return Divider(); },),
                                  if((details[i].notes!.isNotEmpty || details[i].attributes!.isNotEmpty)
                                      && details[i].note!=null)
                                    Divider(),
                                  if(details[i].note!=null)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('notes'.tr(),style: TextStyle(
                                              fontSize: size.height*0.02,
                                              color: Colors.red
                                          ),),
                                          Text(details[i].note!,style: TextStyle(
                                              fontSize: size.height*0.02,
                                              color: Colors.red
                                          ),),


                                        ],
                                      ),
                                    ),
                                  SizedBox(height: 5,)
                                ],
                              ),
                            ),
                          );
                        })),
                // Container(
                //   height: size.height*0.47,
                //   child: SingleChildScrollView(
                //     child: Table(
                //       border:
                //       TableBorder.all(color: Constants.mainColor),
                //       columnWidths: const <int, TableColumnWidth>{
                //         0: FlexColumnWidth(),
                //         1: FixedColumnWidth(120),
                //       },
                //       children: tablesController.currentOrder!.currentOrder!.details!.map((e) {
                //
                //         return TableRow(children: [
                //           TableCell(
                //             child: Padding(
                //                 padding: const EdgeInsets.all(8.0),
                //                 child: Column(
                //                   crossAxisAlignment:
                //                   CrossAxisAlignment.start,
                //                   children: [
                //                     Text(
                //                       e.quantity.toString() +
                //                           'X  ' +
                //                           e.title!,
                //                       style: TextStyle(
                //                         color: Constants.mainColor,
                //                         fontSize: size.height * 0.022,
                //                       ),
                //                     ),
                //                     if (e.notes!.isNotEmpty)
                //                       Column(
                //                         crossAxisAlignment:
                //                         CrossAxisAlignment.start,
                //                         children: e.notes!.map((extra) {
                //                           return Padding(
                //                             padding:
                //                             const EdgeInsets.all(
                //                                 2.0),
                //                             child: Text(
                //                               '         ' + extra,
                //                               style: TextStyle(
                //                                   fontSize:
                //                                   size.height *
                //                                       0.018,
                //                                   fontWeight:
                //                                   FontWeight.w500),
                //                             ),
                //                           );
                //                         }).toList(),
                //                       ),
                //                     if (e.note != null)
                //                       Text(
                //                         '           ' + e.note!,
                //                         style: TextStyle(
                //                           fontSize: size.height * 0.018,
                //                         ),
                //                       ),
                //
                //                     // if (e.extraNotes!=null)
                //                     //   Padding(
                //                     //     padding:
                //                     //     const EdgeInsets.all(2.0),
                //                     //     child: Text(
                //                     //       e.extraNotes!,
                //                     //       style: TextStyle(
                //                     //           fontSize: 14,
                //                     //           fontWeight:
                //                     //           FontWeight.w500),
                //                     //     ),
                //                     //   )
                //                   ],
                //                 )),
                //           ),
                //           TableCell(
                //             child: Padding(
                //                 padding: const EdgeInsets.all(8.0),
                //                 child: Column(
                //                   children: [
                //                     Text(
                //                       e.total.toString() + ' SAR',
                //                       style: TextStyle(
                //                           fontSize: size.height * 0.022,
                //                           color: Constants.mainColor,
                //                           fontWeight: FontWeight.bold),
                //                     ),
                //                     if (e.notes!.isNotEmpty)
                //
                //                       Column(
                //                         children:
                //                         e.notes!.map((extra) {
                //                           int index = e.notes!.indexOf(extra);
                //                           return Padding(
                //                             padding:
                //                             const EdgeInsets.all(
                //                                 2.0),
                //                             child: Text(
                //                               e.notePrice![index].toString() +
                //                                   ' SAR',
                //                               textAlign:
                //                               TextAlign.center,
                //                               style: TextStyle(
                //                                   fontSize:
                //                                   size.height *
                //                                       0.018,
                //                                   fontWeight:
                //                                   FontWeight.w500),
                //                             ),
                //                           );
                //                         }).toList(),
                //                       ),
                //                     if (e.note != null)
                //                       Text(
                //                         '0.0 SAR',
                //                         style: TextStyle(
                //                           fontSize: size.height * 0.018,
                //                         ),
                //                       ),
                //                   ],
                //                 )),
                //           ),
                //         ]);
                //       }).toList(),
                //     ),
                //   ),
                // ),

                SizedBox(
                  height: 20,
                ),

              ],
            ),
          ),
          // if (tablesController.orders[tablesController.chosenOrder!].orderStatusId !=
          //     5 &&
          //     tablesController.orders[tablesController.chosenOrder!].paymentMethod ==
          //         null)
          //   Container(
          //     height: 50,
          //     child: Row(
          //       children: [
          //         Flexible(
          //           child: InkWell(
          //             onTap: () {
          //               tablesController.cancelOrder(
          //                   tablesController.orders[tablesController.chosenOrder!].id!);
          //               tablesController.orders[tablesController.chosenOrder!]
          //                   .orderStatusId = 5;
          //               tablesController.orders[tablesController.chosenOrder!]
          //                   .orderStatus = 'Order Cancelled';
          //             },
          //             child: Container(
          //               color: Colors.redAccent,
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

          //       ],
          //     ),
          //   ),

          Container(
            height: size.height * 0.14,
            width: size.width * 0.28,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                // if(tablesController.currentOrder!.notes != null)
                //   Divider(color: Colors.grey,),
                // if(viewModel.orders[viewModel.chosenOrder!]
                //     .notes != null)
                //   Text('notes'.tr()+' \n'+viewModel.orders[viewModel.chosenOrder!]
                //       .notes!,
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //         color: Constants.secondryColor,
                //         fontSize: size.height*0.02
                //     ),),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Divider(),
                ),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'table'.tr(),
                      style: TextStyle(
                          fontSize: size.height * 0.02,
                          fontWeight: FontWeight.bold,
                          color: Constants.mainColor),
                    ),
                    Text(
                      tablesController.currentOrder!.title!.toString(),
                      style: TextStyle(
                          fontSize: size.height * 0.02,
                          fontWeight: FontWeight.bold,
                          color: Constants.mainColor),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'total'.tr(),
                      style: TextStyle(
                          fontSize: size.height * 0.02,
                          fontWeight: FontWeight.bold,
                          color: Constants.mainColor),
                    ),
                    Text(
                      tablesController.currentOrder!.currentOrder!
                          .total
                          .toString() +
                          ' SAR ',
                      style: TextStyle(
                          fontSize: size.height * 0.02,
                          fontWeight: FontWeight.bold,
                          color: Constants.mainColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          InkWell(
            onTap: () {
              // homeController.editOrder(tablesController.currentOrder!.currentOrder!,
              //     department:tablesController.departments[tablesController.chosenDepartment!].title,
              // table: tablesController.chosenTable!.title);
              // tablesController.editOrder();
              // homeController.selectedTab = SelectedTab.home;
              // homeController.notifyListeners();


            },
            child: Container(
              color: Constants.mainColor,
              width: size.width,
              height: size.height*0.07,
              child: Center(
                child: Text(
                  'editOrder'.tr(),
                  style: TextStyle(
                    fontSize: size.height * 0.025,
                    color: Colors.white
                  ),
                ),
              ),
            ),
          ),
        ],
      )
          : Container(),
    );
  }
}
