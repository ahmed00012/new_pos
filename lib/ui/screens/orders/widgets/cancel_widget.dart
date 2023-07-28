import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/orders_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/custom_text_field.dart';

import '../../../../constants/colors.dart';
import '../../../../models/complain_reasons.dart';

class CancelWidget extends StatefulWidget {
  final int orderId;
  final bool mobileOrders;


  const CancelWidget(
      {super.key,
        required this.orderId,
        required this.mobileOrders,

        });

  @override
  State<CancelWidget> createState() => _CancelWidgetState();
}

class _CancelWidgetState extends State<CancelWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController secretId = TextEditingController();
  TextEditingController secretCode = TextEditingController();
  TextEditingController reason = TextEditingController();
  bool visible = false;


  @override
  Widget build(BuildContext context) {
    // final viewModel = ref.watch(ordersFuture(widget.mobileOrders));
    Size size = MediaQuery.of(context).size;
    return Container(
      // height:widget.complain!? size.height * 0.7:size.height * 0.5,
      // width: size.width * 0.4,
      child: Form(
        key: _formKey,
        child: ListView(
          children: [

            CustomTextField(
              controller: reason,
              label:  'reason'.tr(),
            ),
            SizedBox(height: 20,),

            CustomTextField(
              controller: secretId,
              numerical: true,
              label: 'id'.tr(),
              validator: (e) {
                if (e!.isEmpty) return 'IdEmpty'.tr();
                return null;
              },
            ),
            SizedBox(height: 20,),
            CustomTextField(
              controller: secretCode,
              numerical: true,
              label:    'password'.tr(),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    visible = !visible;
                  });
                },
                child: Icon(
                  visible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
              ),
              validator: (e) {
                if (e!.isEmpty) return 'passwordRequired'.tr();
                return null;
              },
            ),

            SizedBox(
              height: 50,
            ),

            Consumer(builder: (context, ref, child) {
              final orderController =
              ref.watch(ordersFuture(widget.mobileOrders));
              return InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    widget.mobileOrders?
                    orderController.cancelMobileOrder(
                        id: widget.orderId,
                        secretId: secretId.text,
                        secretCode: secretCode.text,
                        reason: reason.text,
                    ):
                    orderController.cancelOrder(
                        id: widget.orderId,
                        secretId: secretId.text,
                        secretCode: secretCode.text,
                        reason: reason.text,);
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  height: size.height * 0.07,
                  width: size.width * 0.2,
                  decoration: BoxDecoration(
                      color: Constants.mainColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      'done'.tr(),
                      style: TextStyle(
                          color: Colors.white, fontSize: size.height * 0.025),
                    ),
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
