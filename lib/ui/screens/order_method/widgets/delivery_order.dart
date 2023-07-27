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

class DeliveryOrder extends StatefulWidget {
  final OrderDetails order;

   DeliveryOrder({super.key, required this.order});

  @override
  State<DeliveryOrder> createState() => _DeliveryOrderState();
}

class _DeliveryOrderState extends State<DeliveryOrder> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController customerPhone = TextEditingController();

  final TextEditingController customerName = TextEditingController();

  final TextEditingController deliveryFee = TextEditingController();

  final TextEditingController notes = TextEditingController();

  final TextEditingController coupon = TextEditingController();

  @override
  void initState() {

    customerName.text = widget.order.clientName ?? '';
    customerPhone.text = widget.order.clientPhone ?? '';
    deliveryFee.text = widget.order.deliveryFee.toString() ?? '';
    notes.text = widget.order.notes ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Consumer(
      builder: (context , ref , child) {
        final cartController = ref.watch(cartFuture);
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
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
                      decoration:  InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        label: Text(
                          'phone'.tr(),
                          style: TextStyle(
                            fontSize: size.height * 0.02,
                            color: Colors.black45,
                          ),
                        ),

                        focusedBorder:const OutlineInputBorder(
                          borderSide:  BorderSide(color: Colors.black26),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        focusedErrorBorder:  const OutlineInputBorder(
                          borderSide:  BorderSide(color: Colors.black26),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:  BorderSide(color: Colors.black26),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),

                      ),
                    ),
                    suggestionsCallback: (pattern) async {
                      return await cartController.onSearchClientTextChanged(pattern);
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
                      customerPhone.text = (suggestion as ClientModel).phone!;
                      customerName.text = (suggestion as ClientModel).name!;
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
                    onChange: (value){
                      cartController.orderDetails.deliveryFee = double.parse(deliveryFee.text);
                    },
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
                    maxLines: 4,
                    onChange: (value){
                      cartController.orderDetails.notes = notes.text;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'pleaseEnterAddress'.tr();
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (cartController.orderDetails.discount == 0)
                    Row(
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
                  if (cartController.orderDetails.discount != 0)
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
          ),
        );
      }
    );
  }
}
