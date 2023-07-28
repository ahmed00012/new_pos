import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:shormeh_pos_new_28_11_2022/models/order_method_model.dart';
import '../../../../constants/colors.dart';
import '../../../../models/customer_model.dart';
import '../../../../models/orders_model.dart';
import '../../../../models/owner_model.dart';
import '../../../../models/payment_model.dart';
import '../../../widgets/custom_dropdown_with_title.dart';

class FilterWidget extends StatefulWidget {
  final List<OwnerModel> owners;
  final List<OrderMethodModel> orderMethods;
  final List<PaymentModel> paymentMethods;
  final List<CustomerModel> paymentCustomers;

  const FilterWidget({super.key , required this.paymentMethods, required this.orderMethods,
  required this.owners , required this.paymentCustomers});



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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
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
                            padding: const EdgeInsets.all(4),
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
                          const SizedBox(width: 10,),
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
                    orderMethod = widget.orderMethods[index].id;
                  });
                },
                title: 'chooseOrderMethod'.tr(),
                hint: 'orderMethod'.tr(),
                onTapExpand: () => setState(() {openOrderMethod = !openOrderMethod;}),
                items: widget.orderMethods.map((e) => e.title!.en!).toList(),
              ),

              SizedBox(height:30,),
              CustomDropdownWithTitle(
                isExpanded: openPaymentMethod,
                onSelectItem: (index) {
                  setState(() {
                    openPaymentMethod  = false;
                    paymentMethod = widget.paymentMethods[index].id;
                  });
                },
                title: 'choosePaymentMethod'.tr(),
                hint: 'paymentMethod'.tr(),
                onTapExpand: () => setState(() {openPaymentMethod = !openPaymentMethod;}),
                items: widget.paymentMethods.where((e) => e.id!=2).map((e) =>  e.title!.en!).toList(),
              ),


              const SizedBox(height:30,),
              CustomDropdownWithTitle(
                isExpanded: openCustomer,
                onSelectItem: (index) {
                  setState(() {
                    openCustomer  = false;
                    customer = widget.paymentCustomers[index].id;
                  });
                },
                title: 'choosePartner'.tr(),
                hint: 'partner'.tr(),
                onTapExpand: () => setState(() {openCustomer = !openCustomer;}),
                items: widget.paymentCustomers.map((e) => e.title!).toList(),
              ),

              SizedBox(height: 30,),
              CustomDropdownWithTitle(
                isExpanded: openOwner,
                onSelectItem: (index) {
                  setState(() {
                    openOwner  = false;
                    owner = widget.owners[index].id;
                  });
                },
                title: 'chooseOwner'.tr(),
                hint: 'owner'.tr(),
                onTapExpand: () => setState(() {openOwner = !openOwner;}),
                items: widget.owners.map((e) => e.title!).toList(),
              ),
              SizedBox(height: size.height*0.15,),
            ],
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: (){
                if(customer!= null || paymentMethod != null ||  orderMethod != null || owner!= null || paid
                    || notPaid)
                {
                  OrdersModel customizedOrder = OrdersModel(
                    paymentCustomerId: customer,
                    paymentMethodId: paymentMethod,
                    orderMethodId: orderMethod,
                    ownerId: owner,
                    paymentStatus: paid
                        ? 1
                        : notPaid
                        ? 0
                        : null,
                  );
                  Navigator.pop(context,customizedOrder);
                }
                // viewModel.getOrders(page : 1 ,customer: customer ,orderMethod: orderMethod,
                //     ownerId:  owner ,paymentMethod: paymentMethod, paid: paid , notPaid: notPaid  );

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
}