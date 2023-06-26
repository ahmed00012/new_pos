import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/finince_out.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import '../../data_controller/cart_controller.dart';
import 'cash_out_widget.dart';

class UpperRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(dataFuture);
    final cartController = ref.watch(cartFuture);
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.15,
      width: double.infinity,
      color: Constants.scaffoldColor,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            SizedBox(
              width: 10,
            ),

             InkWell(
               onTap: () {
                 if (cartController.orderDetails.orderUpdatedId == null) {
                   showDialog(
                       context: context,
                       builder: (_) => AlertDialog(
                         titlePadding: EdgeInsets.zero,
                         title: Column(
                           children: [
                             Padding(
                               padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                               child: Align(
                                   alignment: Alignment.topRight,
                                   child: InkWell(
                                     onTap: (){
                                       Navigator.pop(context);
                                     },
                                     child: Container(
                                       height: size.height*0.05,
                                       width: size.height*0.05,
                                       decoration: BoxDecoration(
                                           color: Colors.red[400],
                                           borderRadius: BorderRadius.circular(10)),
                                       child: Center(
                                         child: Icon(
                                           Icons.clear,
                                           color: Colors.white,
                                         ),
                                       ),
                                     ),
                                   )),
                             ),
                                 Text(
                                   'partner'.tr(),
                                   style: TextStyle(fontSize: size.height * 0.025),
                                 ),
                               ],
                             ),
                             content: StatefulBuilder(builder:
                                 (BuildContext context, StateSetter setState) {
                               return Container(
                                 width: size.width * 0.4,
                                 height: size.height * 0.6,
                                 child: GridView.builder(
                                     itemCount:
                                         viewModel.paymentCustomers.length,
                                     gridDelegate:
                                         SliverGridDelegateWithFixedCrossAxisCount(
                                             crossAxisCount: 3,
                                             childAspectRatio: 1.5),
                                     itemBuilder: (context, i) {
                                       return InkWell(
                                         onTap: () {
                                           // viewModel.selectCustomer(i);
                                           Navigator.pop(context);
                                         },
                                         child: Padding(
                                           padding: const EdgeInsets.all(10.0),
                                           child: Container(
                                             decoration: BoxDecoration(
                                                 borderRadius:
                                                     BorderRadius.circular(10),
                                                 color: Colors.white,
                                                 border: Border.all(
                                                     color: cartController
                                                                     .orderDetails
                                                                     .customer !=
                                                                 null &&
                                                         cartController
                                                                     .orderDetails
                                                                     .customer!.id ==
                                                                 viewModel
                                                                     .paymentCustomers[
                                                                         i]
                                                                     .id
                                                         ? Constants.mainColor
                                                         : Constants
                                                             .scaffoldColor,
                                                     width: 2)),
                                             child: Column(
                                               mainAxisAlignment:
                                                   MainAxisAlignment.spaceEvenly,
                                               children: [
                                                 ClipRRect(
                                                   borderRadius:
                                                       BorderRadius.circular(
                                                           8),
                                                   child: Image.network(
                                                     viewModel
                                                         .paymentCustomers[i]
                                                         .image!,
                                                     height:
                                                         size.height * 0.06,
                                                     errorBuilder:
                                                         (BuildContext context,
                                                             Object exception,
                                                             StackTrace?
                                                                 stackTrace) {
                                                       return SizedBox();
                                                     },
                                                   ),
                                                 ),
                                                 Text(
                                                   viewModel.paymentCustomers[i]
                                                       .title!,
                                                   style: TextStyle(
                                                       color: cartController
                                                                       .orderDetails
                                                                       .customer !=
                                                                   null &&
                                                               cartController
                                                                       .orderDetails
                                                                       .customer ==
                                                                   viewModel
                                                                       .paymentCustomers[
                                                                           i]
                                                                       .id
                                                           ? Constants.mainColor
                                                           : Colors.black,
                                                       fontSize:
                                                           size.height * 0.02),
                                                 ),
                                               ],
                                             ),
                                           ),
                                         ),
                                       );
                                     }),
                               );
                             }),
                           ));
                 } else {
                   viewModel.displayToastMessage('canNotOpen'.tr(), true);
                 }
               },
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Container(
                   height: size.height * 0.15,
                   width: size.width * 0.08,
                   decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(10),
                       border: Border.all(color: Constants.mainColor)),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       cartController.orderDetails.customer == null
                           ? Icon(
                               Icons.delivery_dining,
                               size: size.height * 0.07,
                               color: Constants.mainColor,
                             )
                           : Container(
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10),
                               ),
                               child: ClipRRect(
                                 borderRadius: BorderRadius.circular(8),
                                 child: Image.network(
                                   cartController.orderDetails.customer!.image!,
                                   height: size.height * 0.05,
                                   errorBuilder: (BuildContext context,
                                       Object exception,
                                       StackTrace? stackTrace) {
                                     return SizedBox();
                                   },
                                 ),
                               ),
                             ),
                       cartController.orderDetails.customer == null
                           ? Text(
                               'partner'.tr(),
                               style: TextStyle(
                                   fontSize: size.height * 0.019,
                                   color: Constants.mainColor),
                             )
                           : Text(
                               cartController.orderDetails.customer!.title!,
                               textAlign: TextAlign.center,
                               style: TextStyle(
                                 color: Constants.mainColor,
                                 fontSize: size.height * 0.02,
                               ),
                             ),
                     ],
                   ),
                 ),
               ),
             ),

            // InkWell(
            //   onTap: () {
            //     if (cartController.orderDetails.cart!=null) {
            //       if(cartController.orderDetails.clientPhone==null) {
            //         viewModel.customerPhone.text = '';
            //         viewModel.customerName.text = '';
            //       }
            //       showDialog(
            //           context: context,
            //           builder: (_) => AlertDialog(
            //                 backgroundColor: Constants.scaffoldColor,
            //                 title: Center(
            //                   child: Text(
            //                     'addClient'.tr(),
            //                     style: TextStyle(fontSize: size.height * 0.025),
            //                   ),
            //                 ),
            //                 content: StatefulBuilder(builder:
            //                     (BuildContext context, StateSetter setState) {
            //                   return Container(
            //                     width: size.width * 0.4,
            //                     child: ListView(
            //                       shrinkWrap: true,
            //                       //   shrinkWrap: true,
            //                       children: [
            //                         Column(
            //                           mainAxisSize: MainAxisSize.min,
            //                           children: [
            //
            //                             Container(
            //                               height: size.height * 0.07,
            //                               decoration: BoxDecoration(
            //                                   color: Colors.white,
            //                                   border: Border.all(
            //                                       color: Colors.black12,
            //                                       width: 1.2),
            //                                   borderRadius:
            //                                   BorderRadius.circular(10)),
            //                               child: Padding(
            //                                 padding: const EdgeInsets.symmetric(
            //                                     horizontal: 10),
            //                                 child: TypeAheadField(
            //                                   textFieldConfiguration: TextFieldConfiguration(
            //                                     keyboardType: TextInputType.phone,
            //                                       controller: viewModel.customerPhone,
            //
            //                                       decoration: InputDecoration(
            //                                         contentPadding:
            //                                         EdgeInsets.all(10),
            //                                         label: Text(
            //                                            'clientPhone'.tr(),
            //                                           style: TextStyle(
            //                                             fontSize: size.height * 0.02,
            //                                             color: Colors.black45,
            //                                           ),
            //                                         ),
            //                                         border: InputBorder.none,
            //                                         icon: Icon(
            //                                           Icons.phone,
            //                                           color: Colors.black45,
            //                                         ),
            //                                       ),
            //                                   ),
            //                                   // suggestionsCallback: (pattern)  async{
            //                                   //   return   await  viewModel.suggestClient(pattern);
            //                                   // },
            //                                   itemBuilder: (context, suggestion) {
            //                                    return Column(
            //                                      children: [
            //                                        Text((suggestion as ClientModel).name!),
            //                                        Text((suggestion as ClientModel).phone!),
            //
            //                                      ],
            //                                    );
            //                                   },
            //                                   onSuggestionSelected: (suggestion) {
            //                                     viewModel.chooseClient(client: suggestion as ClientModel);
            //                                   },
            //                                 ),
            //                               ),
            //                             ),
            //
            //                             ///////////////customer name//////////////////////////////////////////
            //                             Padding(
            //                               padding: const EdgeInsets.symmetric(
            //                                   horizontal: 5, vertical: 10),
            //                               child: Container(
            //                                 height: size.height * 0.07,
            //                                 decoration: BoxDecoration(
            //                                     color: Colors.white,
            //                                     border: Border.all(
            //                                         color: Colors.black12,
            //                                         width: 1.2),
            //                                     borderRadius:
            //                                         BorderRadius.circular(10)),
            //                                 child: Padding(
            //                                   padding:
            //                                       const EdgeInsets.symmetric(
            //                                           horizontal: 10),
            //                                   child: TextField(
            //                                     controller: viewModel.customerName,
            //                                     decoration: InputDecoration(
            //                                       contentPadding:
            //                                           EdgeInsets.all(10),
            //                                       label: Text(
            //                                         'clientName'.tr(),
            //                                         style: TextStyle(
            //                                           fontSize:
            //                                               size.height * 0.02,
            //                                           color: Colors.black45,
            //                                         ),
            //                                       ),
            //                                       border: InputBorder.none,
            //                                       icon: Icon(
            //                                         Icons.person,
            //                                         color: Colors.black45,
            //                                       ),
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //
            //                             // if (viewModel.clients.isNotEmpty)
            //                             //   ConstrainedBox(
            //                             //     constraints: new BoxConstraints(
            //                             //       maxHeight: size.height * 0.2,
            //                             //     ),
            //                             //     child: Container(
            //                             //       color: Colors.white,
            //                             //       child: Padding(
            //                             //         padding:
            //                             //             const EdgeInsets.all(8.0),
            //                             //         child: ListView.separated(
            //                             //             shrinkWrap: true,
            //                             //             itemCount: viewModel
            //                             //                 .clients.length,
            //                             //             separatorBuilder:
            //                             //                 (context, i) {
            //                             //               return Divider();
            //                             //             },
            //                             //             itemBuilder: (context, i) {
            //                             //               return InkWell(
            //                             //                 onTap: () {
            //                             //                   // setState(() {
            //                             //                   //   cartController
            //                             //                   //           .customerPhone
            //                             //                   //           .text =
            //                             //                   //       viewModel
            //                             //                   //           .clients[i]
            //                             //                   //           .phone!;
            //                             //                   //   cartController
            //                             //                   //           .customerName
            //                             //                   //           .text =
            //                             //                   //       viewModel
            //                             //                   //           .clients[i]
            //                             //                   //           .name!;
            //                             //                   //   viewModel.clients =
            //                             //                   //       [];
            //                             //                   // });
            //                             //                   viewModel.chooseClient(index: i);
            //                             //                 },
            //                             //                 child: Column(
            //                             //                   children: [
            //                             //                     Text(viewModel
            //                             //                         .clients[i]
            //                             //                         .name!),
            //                             //                     Text(viewModel
            //                             //                         .clients[i]
            //                             //                         .phone!),
            //                             //                   ],
            //                             //                 ),
            //                             //               );
            //                             //             }),
            //                             //       ),
            //                             //     ),
            //                             //   ),
            //
            //                             //////////////////done button////////////////////////
            //                             SizedBox(
            //                               height: 30,
            //                             ),
            //                             InkWell(
            //                               onTap: () {
            //                                 Navigator.pop(context);
            //                                 viewModel.chooseClient();
            //                               },
            //                               child: Container(
            //                                 height: size.height * 0.07,
            //                                 width: size.width * 0.2,
            //                                 decoration: BoxDecoration(
            //                                     color: Constants.mainColor,
            //                                     borderRadius:
            //                                         BorderRadius.circular(10)),
            //                                 child: Center(
            //                                   child: Text(
            //                                     'save'.tr(),
            //                                     style: TextStyle(
            //                                         color: Colors.white,
            //                                         fontSize:
            //                                             size.height * 0.025),
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //                           ],
            //                         )
            //                       ],
            //                     ),
            //                   );
            //                 }),
            //               )).then((value) {
            //         viewModel.clients = [];
            //       });
            //     } else
            //       viewModel.displayToastMessage('noOrderFound'.tr(), true);
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Container(
            //       height: size.height * 0.15,
            //       width: size.width * 0.08,
            //       decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.circular(15),
            //           border: Border.all(color: Constants.mainColor)),
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //         children: [
            //           Icon(
            //             Icons.person,
            //             size: size.height * 0.07,
            //             color: Constants.mainColor,
            //           ),
            //           Text(
            //             'client'.tr(),
            //             style: TextStyle(
            //                 fontSize: size.height * 0.019,
            //                 color: Constants.mainColor),
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            InkWell(
              onTap: () {
                if (cartController.orderDetails.cart != null) {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        titlePadding: EdgeInsets.zero,
                        title: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: size.height*0.05,
                                      width: size.height*0.05,
                                      decoration: BoxDecoration(
                                          color: Colors.red[400],
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Center(
                                        child: Icon(
                                          Icons.clear,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                                Text(
                                  'notes'.tr(),
                                  style: TextStyle(fontSize: size.height * 0.025),
                                ),
                              ],
                            ),
                            content: Container(
                              width: size.width * 0.4,
                              height: size.height * 0.35,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: size.height * 0.22,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.black12, width: 1.2),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: TextField(
                                        // controller: cartController.notes,
                                        maxLines: 7,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          label: Text(
                                            'notes'.tr(),
                                            style: TextStyle(
                                              fontSize: size.height * 0.02,
                                              color: Colors.black45,
                                            ),
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (value) {
                                          cartController.orderDetails.notes =
                                              value;
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.04,
                                  ),
                                  //////////////////done button////////////////////////
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: size.height * 0.07,
                                      width: size.width * 0.2,
                                      decoration: BoxDecoration(
                                          color: Constants.mainColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          'save'.tr(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: size.height * 0.025),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ));
                } else
                  viewModel.displayToastMessage('noOrderFound'.tr(), true);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: size.height * 0.15,
                  width: size.width * 0.08,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Constants.mainColor)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.note_outlined,
                        size: size.height * 0.05,
                        color: Constants.mainColor,
                      ),
                      Text(
                        'notes'.tr(),
                        style: TextStyle(
                            fontSize: size.height * 0.019,
                            color: Constants.mainColor),
                      )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        titlePadding: EdgeInsets.zero,
                        contentPadding: EdgeInsets.zero,
                        title: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: size.height*0.05,
                                      width: size.height*0.05,
                                      decoration: BoxDecoration(
                                          color: Colors.red[400],
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Center(
                                        child: Icon(
                                          Icons.clear,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                             Text(
                               'expense'.tr(),
                               style: TextStyle(fontSize: size.height * 0.025),
                             ),
                           ],
                         ),
                        content: CashOutWidget(),
                      );
                    });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: size.height * 0.15,
                  width: size.width * 0.08,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Constants.mainColor)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.call_made_sharp,
                        size: size.height * 0.05,
                        color: Constants.mainColor,
                      ),
                      Text(
                        'expense'.tr(),
                        style: TextStyle(
                            fontSize: size.height * 0.019,
                            color: Constants.mainColor),
                      )
                    ],
                  ),
                ),
              ),
            ),

          PopupMenuButton<int>(
            position: PopupMenuPosition.under,
              tooltip: '',
              padding: EdgeInsets.only(right: 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),

              child:  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: size.height * 0.15,
                  width: size.width * 0.08,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Constants.mainColor)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // viewModel.lan == 'ar'
                      //     ? Image.asset('assets/images/saudi-arabia.png')
                      //     : Image.asset('assets/images/united-states.png'),
                      Icon(
                        Icons.language,
                        size: size.height * 0.05,
                        color: Constants.mainColor,
                      ),
                      Text(
                        'language'.tr(),
                        style: TextStyle(
                            fontSize: size.height * 0.019,
                            color: Constants.mainColor),
                      )
                    ],
                  ),
                ),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  onTap: (){
                    viewModel.changeLanguage(context,'en');
                  },
                  child: Text("English",style: TextStyle(
                      color:viewModel.lan=='en'? Constants.mainColor:Colors.black,
                    fontSize: size.height*0.02
                  ),),
                ),
                PopupMenuItem(
                  value: 2,
                  onTap: (){
                    viewModel.changeLanguage(context,'ar');
                  },
                  child: Text("Arabic",style: TextStyle(

                      color:viewModel.lan=='ar'? Constants.mainColor:Colors.black,
                      fontSize: size.height*0.02
                  ),),),

              ]),

            InkWell(
              onTap: () {
                viewModel.synchronize(context);
                viewModel.categories = [];
                viewModel.products = [];
                viewModel.optionsList = [];
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: size.height * 0.15,
                  width: size.width * 0.08,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Constants.mainColor)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.sync,
                        size: size.height * 0.05,
                        color: Constants.mainColor,
                      ),
                      Text(
                        'synchronize'.tr(),
                        style: TextStyle(
                            fontSize: size.height * 0.019,
                            color: Constants.mainColor),
                      )
                    ],
                  ),
                ),
              ),
            ),

            InkWell(
              onTap: () async{

                await launchUrl(Uri.parse('https://beta3.poss.app/'),mode: LaunchMode.externalApplication);

           // Navigator.push(context, MaterialPageRoute(builder: (context)=>VersionWebView()));
                },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: size.height * 0.15,
                  width: size.width * 0.08,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Constants.mainColor)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.vertical_align_bottom_sharp,
                        size: size.height * 0.05,
                        color: Constants.mainColor,
                      ),
                      Text(
                        'version 1.0.14'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: size.height * 0.019,
                            color: Constants.mainColor),
                      )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                //
                // viewModel.blue();
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        titlePadding: EdgeInsets.zero,
                        title: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: size.height*0.05,
                                      width: size.height*0.05,
                                      decoration: BoxDecoration(
                                          color: Colors.red[400],
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Center(
                                        child: Icon(
                                          Icons.clear,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                            SizedBox(height: 20,),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Are You Sure You Want To Logout ?',
                                style: TextStyle(
                                  color: Colors.red[500],
                                  fontSize: size.height * 0.03,
                                ),
                              ),
                            ),
                          ],
                        ),
                        content: Container(
                          height: size.height * 0.15,
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => FinanceOut()))
                                    .then((value) {
                                  viewModel.getNotes();
                                  viewModel.getCategories();
                                });
                              },
                              child: Container(
                                  height: size.height * 0.07,
                                  width: size.width * 0.15,
                                  decoration: BoxDecoration(
                                      color: Constants.mainColor,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.logout,
                                        color: Colors.white,
                                        size: size.height * 0.05,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'logout'.tr(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.height * 0.02),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                        ),
                      );
                    });

                // viewModel.getNotes();
                // viewModel.getCategories();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: size.height * 0.15,
                  width: size.width * 0.08,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Constants.mainColor)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.logout,
                        size: size.height * 0.05,
                        color: Constants.mainColor,
                      ),
                      Text(
                        'logout'.tr(),
                        style: TextStyle(
                            fontSize: size.height * 0.019,
                            color: Constants.mainColor),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
