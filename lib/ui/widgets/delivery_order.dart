import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/order_method_controller.dart';
import '../../constants.dart';
import '../../data_controller/cart_controller.dart';
import '../../models/client_model.dart';

class DeliveryOrder extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderController =ref.watch(orderMethodFuture);
    final cartController = ref.watch(cartFuture);
    // final viewModel = ref.watch(dataFuture);
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child:Form(
        key: _formKey,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  TypeAheadFormField(
                       textFieldConfiguration: TextFieldConfiguration(
                         keyboardType: TextInputType.phone,
                         controller: orderController.customerPhone,
                         decoration: InputDecoration(
                           contentPadding:
                           EdgeInsets.all(10),
                         hintText: '050*******',
                           border: OutlineInputBorder(
                             borderSide: BorderSide(
                                 width: 1, color: Colors.black12),
                           ),
                           focusedBorder: OutlineInputBorder(
                             borderSide: BorderSide(
                                 width: 1, color: Colors.black45),
                           ),
                           icon: Icon(
                             Icons.phone,
                             color: Colors.black45,
                           ),
                         ),
                       ),
                       suggestionsCallback: (pattern)  {
                         return  orderController.suggestClient(pattern);
                       },
                       itemBuilder: (context, suggestion) {
                         return Column(
                           children: [
                             Text((suggestion as ClientModel).name!),
                             Text((suggestion as ClientModel).phone!),


                             Divider()

                           ],
                         );
                       },
                       onSuggestionSelected: (suggestion) {
                         orderController.chooseClient(client: suggestion as ClientModel);
                       },
                   ),

                  SizedBox(
                    height: 10,
                  ),
                ///////////////customer name//////////////////////////////////////////
                TextFormField(
                  controller: orderController.customerName,
                  decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.all(10),
                 hintText:  'clientName'.tr(),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.black45),
                    ),
                    icon: Icon(
                      Icons.person,
                      color: Colors.black45,
                    ),
                  ),
                  onChanged: (value){
                    cartController.orderDetails.clientName = value;
                  },
                  validator: (value){
                    if(value!.isEmpty){
                      return 'pleaseEnterClientName'.tr();
                    }
                  },

                ),
                  SizedBox(
                    height: 10,
                  ),

                  TextFormField(
                    controller: orderController.deliveryFee,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.all(10),
                      hintText:  'deliveryFee'.tr(),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: Colors.black12),
                      ),
                      focusedBorder:const OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: Colors.black45),
                      ),
                      icon: Icon(
                        Icons.motorcycle,
                        color: Colors.black45,
                      ),
                    ),

                    validator: (value){
                      if(value!.isEmpty){
                        return 'pleaseEnterDeliveryFee'.tr();
                      }
                      if(double.tryParse(value) == null){
                        return 'pleasePutValidNumber'.tr();
                      }
                    },
                    onChanged: (value) {
                      cartController.orderDetails.deliveryFee = double.parse(value);
                      orderController.notifyListeners();

                    },

                  ),

              SizedBox(
                height: 20,
              ),

              TextFormField(
                controller: orderController.notes,
                maxLines: 7,
                decoration:  InputDecoration(
                  contentPadding:
                  EdgeInsets.all(10),
                  hintText:   'address'.tr(),

                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: Colors.black12),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: Colors.black45),
                  ),
                  icon: Icon(
                    Icons.location_on_rounded,
                    color: Colors.black45,
                  ),
                ),
                onChanged: (value){
                  cartController.orderDetails.notes = value;
                },
                validator: (value){
                  if(value!.isEmpty){
                    return 'pleaseEnterAddress'.tr();
                  }
                },
              ),

              SizedBox(
                height: 20,
              ),
              if(cartController.orderDetails.discount==null)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 5),
                child: Container(
                  width: size.width * 0.35,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: TextField(
                          controller:
                          orderController.coupon,
                          decoration: InputDecoration(
                            contentPadding:
                            EdgeInsets.all(10),
                            hintText:   'coupon'.tr(),

                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black45),
                            ),
                            icon: Image.asset(
                              'assets/images/discount.png',
                              color: Colors.black45,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              FocusManager.instance.primaryFocus
                                  ?.unfocus();
                              orderController.checkCoupon();
                            },
                            child: Container(
                              height: size.height * 0.07,
                              // width: size.width*0.2,
                              decoration: BoxDecoration(
                                  color: Constants.mainColor,
                                  borderRadius:
                                  BorderRadius.circular(
                                      10)),
                              child: Center(
                                child: Text(
                                  'add'.tr(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                      size.height * 0.02),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
                  if(cartController.orderDetails.discount!=null)
                    Container(
                      height: size.height*0.1,
                      width: size.width*0.4,

                      decoration: BoxDecoration(
                        // color: Constants.mainColor,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Constants.mainColor)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/discount.png',
                                color: Constants.mainColor,
                                height: 30,
                                width: 30,
                              ),
                              SizedBox(width: 20,),
                              Text('Coupon Discount',style: TextStyle(
                                color: Constants.mainColor,
                                fontSize: size.height*0.02
                              ),)
                            ],
                          ),
                          Text(cartController.orderDetails.discount!,style: TextStyle(
                              color: Constants.mainColor,
                              fontSize: size.height*0.02
                          ),)
                        ],
                      ),
                    ),
              SizedBox(
                height: 50,
              ),

              InkWell(
                onTap: () {
                  if(_formKey.currentState!.validate()) {
                        Navigator.pop(context, true);
                        orderController.chooseClient();
                      }
                    },
                child:
                Container(
                  height: size
                      .height *
                      0.08,
                  width:
                  size.width *
                      0.2,
                  decoration: BoxDecoration(
                      color: Constants
                          .mainColor,
                      borderRadius:
                      BorderRadius.circular(10)),
                  child:
                  Center(
                    child:
                    Text(
                      'done'.tr(),
                      style: TextStyle(
                          color:
                          Colors.white,
                          fontSize: size.height * 0.025),
                    ),
                  ),
                ),
              ),
                  SizedBox(height: 20,)
                ],
              ),
            ),
            // if(orderController.loading)
            //   Container(
            //     height: size.height,
            //
            //     color: Colors.white.withOpacity(0.5),
            //     child: Center(
            //       child: CircularProgressIndicator(
            //         color: Constants.mainColor,
            //       ),
            //     ),
            //   )
          ],
        ),
      ),
    );
  }
}
