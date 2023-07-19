import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/order_method_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/models/cart_model.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/custom_text_field.dart';
import '../../../../constants/colors.dart';
import '../../../../data_controller/cart_controller.dart';
import '../../../../models/client_model.dart';

class DeliveryOrder extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final OrderDetails order;
  final TextEditingController customerPhone = TextEditingController();
  final TextEditingController customerName = TextEditingController();
  final TextEditingController deliveryFee = TextEditingController();
  final TextEditingController notes = TextEditingController();
  final TextEditingController coupon = TextEditingController();
   DeliveryOrder({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartController = ref.watch(cartFuture);
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                 const SizedBox(
                    height: 30,
                  ),
                  TypeAheadFormField(
                    textFieldConfiguration: TextFieldConfiguration(
                      keyboardType: TextInputType.phone,
                      controller: customerPhone,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: '050*******',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.black45),
                        ),
                        icon: Icon(
                          Icons.phone,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                    suggestionsCallback: (pattern) {
                      return cartController.onSearchClientTextChanged(pattern);
                    },
                    itemBuilder: (context, suggestion) {
                      return Column(
                        children: [
                          Text((suggestion as ClientModel).name!),
                          Text((suggestion as ClientModel).phone!),
                          const Divider()
                        ],
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      cartController.chooseClient(
                          name: (suggestion as ClientModel).name!,
                          phone: (suggestion as ClientModel).phone!);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: customerName,
                    label: 'clientName'.tr(),
                    hint: 'clientName'.tr(),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'pleaseEnterClientName'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: deliveryFee,
                    label: 'deliveryFee'.tr(),
                    hint: 'deliveryFee'.tr(),
                    numerical: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'pleaseEnterDeliveryFee'.tr();
                      }
                      if (double.tryParse(value) == null) {
                        return 'pleasePutValidNumber'.tr();
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  CustomTextField(
                    controller:  notes,
                    label: 'address'.tr(),
                    hint: 'address'.tr(),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'pleaseEnterAddress'.tr();
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (cartController.orderDetails.discount == null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        width: size.width * 0.35,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 7,
                              child: CustomTextField(
                                controller:  coupon,
                                label: 'coupon'.tr(),
                                hint: 'coupon'.tr(),
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
                                    cartController.checkCoupon(coupon.text);
                                  },
                                  child: Container(
                                    height: size.height * 0.07,
                                    // width: size.width*0.2,
                                    decoration: BoxDecoration(
                                        color: Constants.mainColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        'add'.tr(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.height * 0.02),
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
                  if (cartController.orderDetails.discount != null)
                    Container(
                      height: size.height * 0.1,
                      width: size.width * 0.4,
                      decoration: BoxDecoration(
                          // color: Constants.mainColor,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Constants.mainColor)),
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
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Coupon Discount',
                                style: TextStyle(
                                    color: Constants.mainColor,
                                    fontSize: size.height * 0.02),
                              )
                            ],
                          ),
                          Text(
                            cartController.orderDetails.discount.toString(),
                            style: TextStyle(
                                color: Constants.mainColor,
                                fontSize: size.height * 0.02),
                          )
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(context, true);
                        cartController.chooseClient(
                            name: customerName.text, phone: customerPhone.text);
                      }
                    },
                    child: Container(
                      height: size.height * 0.08,
                      width: size.width * 0.2,
                      decoration: BoxDecoration(
                          color: Constants.mainColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          'done'.tr(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.025),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
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
