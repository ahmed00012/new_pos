import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/orders_controller.dart';

import '../../../../constants/colors.dart';
import '../../../widgets/custom_dropdown_with_title.dart';

class FilterWidget extends StatefulWidget {

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  bool openOrderMethod = false ;
  int? orderMethod ;

  bool openPaymentMethod = false ;
  int? paymentMethod  ;

  bool openOwner = false ;
  int? owner  ;

  bool openCustomer = false ;
  int? customer;

  bool paid = false;
  bool notPaid = false;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Consumer(
      builder: (context, ref , child) {
        final viewModel = ref.watch(ordersFuture);
        return Container(
          width: size.width *0.7,
          height: size.height *0.6,
          child: Stack(
            children: [
              ListView(
                shrinkWrap: true,

                children: [
                  Text('paymentStatus'.tr(), style: TextStyle(
                    fontSize: size.height*0.02,
                    color: Constants.mainColor,
                  ),),

                  Row(

                    children: [
                      SizedBox(width: 10,),
                      InkWell(
                        onTap: (){
                          setState(() {
                            paid = !paid;
                          });
                        },
                        child: SizedBox(
                          width: size.width *0.1,
                          height: size.height *0.06,
                          child: Row(
                            children: [
                              Container(
                                height: 22,
                                width: 22,
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 1,
                                    color: Constants.mainColor,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: paid
                                        ? Constants.mainColor
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Text('paid'.tr(),style: TextStyle(
                                  fontSize: size.height*0.02,
                                  fontWeight: FontWeight.w500
                              ),),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width:30,),
                      InkWell(
                        onTap: (){
                          setState(() {
                            notPaid = !notPaid;
                          });
                        },
                        child: SizedBox(
                          width: size.width *0.1,
                          height: size.height *0.06,
                          child: Row(
                            children: [
                              Container(
                                height: 22,
                                width: 22,
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 1,
                                    color: Constants.mainColor,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: notPaid
                                        ? Constants.mainColor
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Text('notPaid'.tr(),style: TextStyle(
                                  fontSize: size.height*0.02,
                                  fontWeight: FontWeight.w500
                              ),),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: size.width*0.2,),
                    ],
                  ),
                  SizedBox(height:10,),
                  CustomDropdownWithTitle(
                    isExpanded: openOrderMethod,
                    onSelectItem: (index) {
                      setState(() {
                        openOrderMethod = false;
                        orderMethod = viewModel.orderMethods[index].id;
                      });
                    },
                    title: 'chooseOrderMethod'.tr(),
                    hint: 'orderMethod'.tr(),
                    onTapExpand: () => setState(() {openOrderMethod = !openOrderMethod;}),
                    items: viewModel.orderMethods.map((e) => e.title!.en!).toList(),
                  ),

                  SizedBox(height:30,),
                  CustomDropdownWithTitle(
                    isExpanded: openPaymentMethod,
                    onSelectItem: (index) {
                      setState(() {
                        openPaymentMethod  = false;
                        paymentMethod = viewModel.paymentMethods[index].id;
                      });
                    },
                    title: 'choosePaymentMethod'.tr(),
                    hint: 'paymentMethod'.tr(),
                    onTapExpand: () => setState(() {openPaymentMethod = !openPaymentMethod;}),
                    items: viewModel.paymentMethods.where((e) => e.id!=2).map((e) =>  e.title!.en!).toList(),
                  ),


                  SizedBox(height:30,),
                  CustomDropdownWithTitle(
                    isExpanded: openCustomer,
                    onSelectItem: (index) {
                      setState(() {
                        openCustomer  = false;
                        customer = viewModel.paymentCustomer[index].id;
                      });
                    },
                    title: 'choosePartner'.tr(),
                    hint: 'partner'.tr(),
                    onTapExpand: () => setState(() {openCustomer = !openCustomer;}),
                    items: viewModel.paymentCustomer.map((e) => e.title!).toList(),
                  ),

                  SizedBox(height: 30,),
                  CustomDropdownWithTitle(
                    isExpanded: openOwner,
                    onSelectItem: (index) {
                      setState(() {
                        openOwner  = false;
                        owner = viewModel.owners[index].id;
                      });
                    },
                    title: 'chooseOwner'.tr(),
                    hint: 'owner'.tr(),
                    onTapExpand: () => setState(() {openOwner = !openOwner;}),
                    items: viewModel.owners.map((e) => e.title!).toList(),
                  ),
                  SizedBox(height: size.height*0.15,),
                ],
              ),

              Align(
                alignment: Alignment.bottomCenter,
                 child: InkWell(
                   onTap: (){
                     viewModel.getOrders(page : 1 ,customer: customer ,orderMethod: orderMethod ,
                         ownerId:  owner ,paymentMethod: paymentMethod, paid: paid , notPaid: notPaid  );
                     Navigator.pop(context);
                   },
                   child: Container(
                    height: size.height *0.07,
                    width: size.width,

                    decoration: BoxDecoration(
                      color: Constants.mainColor,
                      borderRadius: BorderRadius.circular(15)
                    ),
                     child: Center(
                       child: Text('done'.tr(),style: TextStyle(
                         color: Colors.white,
                         fontSize: size.height*0.025
                       ),),
                     ),
                ),
                 ),
              )
            ],
          ),
        );
      }
    );
  }
}