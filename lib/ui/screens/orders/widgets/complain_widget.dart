import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/orders_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/custom_text_field.dart';

import '../../../../constants/colors.dart';
import '../../../../models/complain_reasons.dart';

class ComplainWidget extends StatefulWidget {
  final int orderId;
  final bool mobileOrders;
  final List<ComplainReasons> reasons;

  const ComplainWidget(
      {super.key,
      required this.orderId,
      required this.mobileOrders,
      required this.reasons});

  @override
  State<ComplainWidget> createState() => _ComplainWidgetState();
}

class _ComplainWidgetState extends State<ComplainWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController secretId = TextEditingController();
  TextEditingController secretCode = TextEditingController();
  TextEditingController mobile = TextEditingController();
  bool visible = false;
  int? reasonId;
  String? reasonTitle;

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
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                '${'reason'.tr()} : ',
                style: TextStyle(
                    fontSize: size.height * 0.025, fontWeight: FontWeight.bold),
              ),
            ),

            ListView.builder(
                itemCount: widget.reasons.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InkWell(
                      onTap: () {
                        // viewModel.selectReason(i);
                        setState(() {
                          reasonId = widget.reasons[i].id;
                          reasonTitle = widget.reasons[i].title;
                          widget.reasons.forEach((element) {
                            element.chosen = false;
                          });
                          widget.reasons[i].chosen = !widget.reasons[i].chosen;
                        });
                      },
                      child: Container(
                        height: size.height * 0.07,
                        width: size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: widget.reasons[i].chosen
                                  ? Constants.mainColor
                                  : Colors.black38,
                              width: widget.reasons[i].chosen ? 1.2 : 1,
                            )),
                        child: Center(
                          child: Text(
                            widget.reasons[i].title!,
                            style: TextStyle(
                                color: widget.reasons[i].chosen
                                    ? Constants.mainColor
                                    : Colors.black,
                                fontSize: size.height * 0.02),
                          ),
                        ),
                      ),
                    ),
                  );
                }),

            CustomTextField(
              controller: secretId,
              numerical: true,
              label: 'id'.tr(),
              validator: (e) {
                if (e!.isEmpty) return 'IdEmpty'.tr();
                return null;
              },
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: secretCode,
                keyboardType: TextInputType.phone,
                obscureText: visible,
                decoration: InputDecoration(
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
                  contentPadding: EdgeInsets.all(10),
                  label: Text(
                    'password'.tr(),
                    style: TextStyle(
                      fontSize: size.height * 0.02,
                      color: Colors.black45,
                    ),
                  ),
                  border: InputBorder.none,
                ),
                validator: (e) {
                  if (e!.isEmpty) return 'passwordRequired'.tr();
                  return null;
                },
              ),
            ),

            CustomTextField(
              controller: mobile,
              numerical: true,
              label: 'clientPhone'.tr(),
              validator: (e) {
                if (e!.isEmpty) return 'mobileRequired'.tr();
                return null;
              },
            ),

            //
            // if(!widget.complain!)
            //   SizedBox(
            //     height: 10,
            //   ),

            // if(!widget.complain!)
            //   Container(
            //     height: size.height * 0.12,
            //     width: size.width * 0.4,
            //     decoration: BoxDecoration(
            //         color: Colors.white,
            //         border: Border.all(
            //             color: Colors.black12,
            //             width: 1.2),
            //         borderRadius:
            //         BorderRadius.circular(
            //             10)),
            //     child: Padding(
            //       padding: const EdgeInsets
            //           .symmetric(
            //           horizontal: 10),
            //       child: TextField(
            //         controller:
            //         viewModel.reason,
            //         decoration:
            //         InputDecoration(
            //           contentPadding:
            //           const EdgeInsets
            //               .all(8.0),
            //           label: Padding(
            //             padding:
            //             const EdgeInsets
            //                 .all(8.0),
            //             child: Text(
            //               'reason'.tr(),
            //               style: TextStyle(
            //                 fontSize:
            //                 size.height *
            //                     0.02,
            //                 color: Colors
            //                     .black45,
            //               ),
            //             ),
            //           ),
            //           border:
            //           InputBorder.none,
            //         ),
            //       ),
            //     ),
            //   ),

            SizedBox(
              height: 50,
            ),
//////////////////done button////////////////////////
            Consumer(builder: (context, ref, child) {
              final orderController =
                  ref.watch(ordersFuture(widget.mobileOrders));
              return InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    orderController.complainOrder(
                        id: widget.orderId,
                        secretId: secretId.text,
                        secretCode: secretCode.text,
                        reasonId: reasonId!,
                        mobile: mobile.text,
                        reason: reasonTitle);
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
