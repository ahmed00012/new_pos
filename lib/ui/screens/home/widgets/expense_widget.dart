import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/custom_button.dart';

import '../../../../constants/colors.dart';


class ExpenseDialog extends StatelessWidget {
  ExpenseDialog({super.key});

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.4,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black12, width: 1.2),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      label: Text(
                        'description'.tr(),
                        style: TextStyle(
                          fontSize: size.height * 0.02,
                          color: Colors.black45,
                        ),
                      ),
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return 'required'.tr();
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: size.height * 0.07,
                child: Row(
                  children: [
                    Container(
                      width: size.width * 0.3,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black12, width: 1.2),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: priceController,
                          keyboardType: TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            label: Text(
                              'amount'.tr(),
                              style: TextStyle(
                                fontSize: size.height * 0.02,
                                color: Colors.black45,
                              ),
                            ),
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) return 'required'.tr();
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'SAR',
                      style: TextStyle(
                          fontSize: size.height * 0.03,
                          color: Constants.mainColor),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Consumer(builder:
                  (BuildContext context, WidgetRef ref, Widget? child) {
                final controller = ref.watch(dataFuture);
                return CustomButton(
                    title: 'ok'.tr(),
                    onTap: () {
                      Navigator.pop(context);
                      controller.expense(
                          descriptionController.text, priceController.text);
                    });
              }),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
