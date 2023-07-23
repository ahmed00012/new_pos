// import 'package:easy_localization/src/public_ext.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shormeh_pos_new_28_11_2022/data_controller/mobile_order_controller.dart';
//
// import '../../constants/colors.dart';
// import 'custom_dropdown_with_title.dart';
//
// class FilterMobileWidget extends StatefulWidget {
//
//   @override
//   State<FilterMobileWidget> createState() => _FilterMobileWidgetState();
// }
//
// class _FilterMobileWidgetState extends State<FilterMobileWidget> {
//   bool openOrderMethod = false ;
//   int? orderMethod ;
//
//   bool openPaymentMethod = false ;
//   int? paymentMethod  ;
//
//   bool paid = false;
//   bool notPaid = false;
//
//   @override
//   Widget build(BuildContext context) {
//
//     Size size = MediaQuery.of(context).size;
//
//     return Consumer(
//         builder: (context, ref , child) {
//           final viewModel = ref.watch(mobileOrdersFuture(false));
//           return Container(
//             width: size.width *0.7,
//             height: size.height *0.5,
//             child: Stack(
//               children: [
//                 ListView(
//                   shrinkWrap: true,
//
//                   children: [
//                     // Center(
//                     //   child: Text('orderMethod'.tr(), style: TextStyle(
//                     //       color: Constants.mainColor,
//                     //       fontWeight: FontWeight.bold,
//                     //       fontSize: size.height * 0.02
//                     //   ),),
//                     // ),
//
//
//                     Text('paymentStatus'.tr(), style: TextStyle(
//                       fontSize: size.height*0.02,
//                       color: Constants.mainColor,
//                     ),),
//
//                     Row(
//
//                       children: [
//                         SizedBox(width: 10,),
//                         InkWell(
//                           onTap: (){
//                             setState(() {
//                               paid = !paid;
//                             });
//                           },
//                           child: SizedBox(
//                             width: size.width *0.1,
//                             height: size.height *0.06,
//                             child: Row(
//                               children: [
//                                 Container(
//                                   height: 22,
//                                   width: 22,
//                                   padding: EdgeInsets.all(4),
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     border: Border.all(
//                                       width: 1,
//                                       color: Constants.mainColor,
//                                     ),
//                                   ),
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: paid
//                                           ? Constants.mainColor
//                                           : Colors.transparent,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(width: 10,),
//                                 Text('paid'.tr(),style: TextStyle(
//                                     fontSize: size.height*0.02,
//                                     fontWeight: FontWeight.w500
//                                 ),),
//                               ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(width:30,),
//                         InkWell(
//                           onTap: (){
//                             setState(() {
//                               notPaid = !notPaid;
//                             });
//                           },
//                           child: SizedBox(
//                             width: size.width *0.1,
//                             height: size.height *0.06,
//                             child: Row(
//                               children: [
//                                 Container(
//                                   height: 22,
//                                   width: 22,
//                                   padding: EdgeInsets.all(4),
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     border: Border.all(
//                                       width: 1,
//                                       color: Constants.mainColor,
//                                     ),
//                                   ),
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: notPaid
//                                           ? Constants.mainColor
//                                           : Colors.transparent,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(width: 10,),
//                                 Text('notPaid'.tr(),style: TextStyle(
//                                     fontSize: size.height*0.02,
//                                     fontWeight: FontWeight.w500
//                                 ),),
//                               ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: size.width*0.2,),
//                       ],
//                     ),
//                     SizedBox(height:10,),
//                     CustomDropdownWithTitle(
//                       isExpanded: openOrderMethod,
//                       onSelectItem: (index) {
//                         setState(() {
//                           openOrderMethod = false;
//                           orderMethod = viewModel.orderMethods[index].id;
//                         });
//                       },
//                       title: 'chooseOrderMethod'.tr(),
//                       hint: 'orderMethod'.tr(),
//                       onTapExpand: () => setState(() {openOrderMethod = !openOrderMethod;}),
//                       items: viewModel.orderMethods.map((e) => e.title!.en!).toList(),
//                     ),
//
//                     // ListView.builder(
//                     //     itemCount: viewModel.orderMethods.length,
//                     //     physics: NeverScrollableScrollPhysics(),
//                     //     shrinkWrap: true,
//                     //     itemBuilder: (context, i) {
//                     //       return
//                     //         Padding(
//                     //           padding: const EdgeInsets.symmetric(
//                     //               horizontal: 10, vertical: 5),
//                     //           child: InkWell(
//                     //             onTap: () {
//                     //               viewModel.orderMethodFilter(
//                     //                   i, viewModel.orderMethods[i].id!);
//                     //               Navigator.pop(context);
//                     //             },
//                     //             child: Container(
//                     //               width: size.width * 0.08,
//                     //               height: 55,
//                     //               decoration: BoxDecoration(
//                     //                   color: Colors.white,
//                     //                   borderRadius: BorderRadius.circular(10),
//                     //                   border: Border.all(
//                     //                       color: viewModel.orderMethods[i].chosen!
//                     //                           ? Constants.mainColor
//                     //                           : Colors.black26)),
//                     //               child: Center(
//                     //                 child: Text(
//                     //                   viewModel.orderMethods[i].title!.en!,
//                     //
//                     //                   style: TextStyle(
//                     //                       color: Constants.mainColor,
//                     //                       fontSize: size.height * 0.02),
//                     //                 ),
//                     //               ),
//                     //             ),
//                     //           ),
//                     //         );
//                     //     }),
//                     SizedBox(height:30,),
//                     CustomDropdownWithTitle(
//                       isExpanded: openPaymentMethod,
//                       onSelectItem: (index) {
//                         setState(() {
//                           openPaymentMethod  = false;
//                           paymentMethod = viewModel.paymentMethods[index].id;
//                         });
//                       },
//                       title: 'choosePaymentMethod'.tr(),
//                       hint: 'paymentMethod'.tr(),
//                       onTapExpand: () => setState(() {openPaymentMethod = !openPaymentMethod;}),
//                       items: viewModel.paymentMethods.where((e) => e.id!=2).map((e) =>  e.title!.en!).toList(),
//                     ),
//
//
//
//
//                     // Center(
//                     //   child: Text(
//                     //     'paymentMethod'.tr(), style: TextStyle(
//                     //       color: Constants.mainColor,
//                     //       fontWeight: FontWeight.bold,
//                     //       fontSize: size.height * 0.02
//                     //   ),),
//                     // ),
//                     // ListView.builder(
//                     //     itemCount: viewModel.paymentMethods.length,
//                     //     physics: NeverScrollableScrollPhysics(),
//                     //     shrinkWrap: true,
//                     //     itemBuilder: (context, i) {
//                     //       return viewModel.paymentMethods[i].id == 2
//                     //           ? Padding(
//                     //         padding: const EdgeInsets.symmetric(
//                     //             horizontal: 10, vertical: 5),
//                     //         child: Container(
//                     //           decoration: BoxDecoration(
//                     //               color:  Colors.white,
//                     //               borderRadius:
//                     //               BorderRadius.circular(10),
//                     //             border: Border.all(  color: viewModel.paymentMethods[i].chosen!
//                     //             ? Constants.mainColor
//                     //               : Colors.white, )
//                     //              ),
//                     //           child: ClipRRect(
//                     //             borderRadius:
//                     //             BorderRadius.circular(10),
//                     //             child: Theme(
//                     //               data: Theme.of(context).copyWith(dividerColor: Constants.scaffoldColor),
//                     //               child: ExpansionTile(
//                     //
//                     //                 key: Key(
//                     //                     viewModel.key.toString()),
//                     //                 // backgroundColor: Constants.scaffoldColor,
//                     //                 collapsedIconColor:
//                     //                 Colors.lightGreen,
//                     //                 iconColor: Colors.lightGreen,
//                     //                 title: Center(
//                     //                   child: Text(
//                     //                     viewModel.paymentMethods[i]
//                     //                         .title!.en!,
//                     //                     style: TextStyle(
//                     //                       fontSize: size.height * 0.02,
//                     //                       color: Constants.mainColor,
//                     //                     ),
//                     //                   ),
//                     //                 ),
//                     //                 children: viewModel.paymentCustomer
//                     //                     .map((element) {
//                     //                   return InkWell(
//                     //                     onTap: () {
//                     //                       viewModel.paymentCustomerFilter(element.id!);
//                     //                       Navigator.pop(context);
//                     //                     },
//                     //                     child: Padding(
//                     //                       padding: const EdgeInsets.symmetric(vertical: 5),
//                     //                       child: Container(
//                     //                           height: 55,
//                     //                           decoration: BoxDecoration(
//                     //                               color: Colors.white,
//                     //                               borderRadius: BorderRadius.circular(10),
//                     //                               border: Border.all(
//                     //                                   color:
//                     //                                   element.id == viewModel.chosenCustomer
//                     //                                       ? Constants.mainColor
//                     //                                       : Colors.black26)),
//                     //                           child: Center(
//                     //                             child: Text(
//                     //                               element.title!,
//                     //                               style: TextStyle(
//                     //                                   fontSize:
//                     //                                   size.height *
//                     //                                       0.02,
//                     //                                   color: Constants.mainColor,
//                     //                                   fontWeight:
//                     //                                   FontWeight.w500),
//                     //                             ),
//                     //                           )
//                     //                       ),
//                     //                     ),
//                     //                   );
//                     //                 }).toList(),
//                     //               ),
//                     //             ),
//                     //           ),
//                     //         ),
//                     //       ) : Padding(
//                     //         padding: const EdgeInsets.symmetric(
//                     //             horizontal: 10, vertical: 5),
//                     //         child: InkWell(
//                     //           onTap: () {
//                     //             viewModel.paymentMethodFilter(
//                     //                 i, viewModel.paymentMethods[i].id!);
//                     //             Navigator.pop(context);
//                     //           },
//                     //           child: Container(
//                     //             width: size.width * 0.08,
//                     //             height: 55,
//                     //             decoration: BoxDecoration(
//                     //                 color: Colors.white,
//                     //                 borderRadius: BorderRadius.circular(10),
//                     //                 border: Border.all(
//                     //                     color:
//                     //                     viewModel.paymentMethods[i].chosen!
//                     //                         ? Constants.mainColor
//                     //                         : Colors.black26)),
//                     //             child: Center(
//                     //               child: Text(
//                     //                 viewModel.paymentMethods[i].title!.en!,
//                     //                 textAlign: TextAlign.center,
//                     //                 style: TextStyle(
//                     //                     color: Constants.mainColor,
//                     //                     fontSize: size.height * 0.02),
//                     //               ),
//                     //             ),
//                     //           ),
//                     //         ),
//                     //       );
//                     //     }),
//
//                     SizedBox(height: size.height*0.15,),
//                     // Center(
//                     //   child: Text(
//                     //     'owner'.tr(), style: TextStyle(
//                     //       color: Constants.mainColor,
//                     //       fontWeight: FontWeight.bold,
//                     //       fontSize: size.height * 0.02
//                     //   ),),
//                     // ),
//                     // ListView.builder(
//                     //     itemCount: viewModel.owners.length,
//                     //     physics: NeverScrollableScrollPhysics(),
//                     //     shrinkWrap: true,
//                     //     itemBuilder: (context, i) {
//                     //       return  Padding(
//                     //         padding: const EdgeInsets.symmetric(
//                     //             horizontal: 10, vertical: 5),
//                     //         child: InkWell(
//                     //           onTap: () {
//                     //             viewModel.ownerFilter(
//                     //                 i, viewModel.owners[i].id!);
//                     //             Navigator.pop(context);
//                     //           },
//                     //           child: Container(
//                     //             width: size.width * 0.08,
//                     //             height: 55,
//                     //             decoration: BoxDecoration(
//                     //                 color: Colors.white,
//                     //                 borderRadius: BorderRadius.circular(10),
//                     //                 border: Border.all(
//                     //                     color:
//                     //                     viewModel.owners[i].chosen!
//                     //                         ? Constants.mainColor
//                     //                         : Colors.black26)),
//                     //             child: Center(
//                     //               child: Text(
//                     //                 viewModel.owners[i].titleEn!,
//                     //                 textAlign: TextAlign.center,
//                     //                 style: TextStyle(
//                     //                     color: Constants.mainColor,
//                     //                     fontSize: size.height * 0.02),
//                     //               ),
//                     //             ),
//                     //           ),
//                     //         ),
//                     //       );
//                     //     }),
//
//                   ],
//                 ),
//
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: InkWell(
//                     onTap: (){
//                       viewModel.filterOrders(orderMethod: orderMethod
//                           ,paymentMethod: paymentMethod, paid: paid , notPaid: notPaid  );
//                       Navigator.pop(context);
//                     },
//                     child: Container(
//                       height: size.height *0.07,
//                       width: size.width,
//
//                       decoration: BoxDecoration(
//                           color: Constants.mainColor,
//                           borderRadius: BorderRadius.circular(15)
//                       ),
//                       child: Center(
//                         child: Text('done'.tr(),style: TextStyle(
//                             color: Colors.white,
//                             fontSize: size.height*0.025
//                         ),),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           );
//         }
//     );
//   }
// }