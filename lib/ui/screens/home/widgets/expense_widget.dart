import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/custom_button.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/custom_text_field.dart';

import '../../../../constants/colors.dart';

class ExpenseDialog extends StatelessWidget {
  ExpenseDialog({super.key , required this.onTap});

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final GlobalKey<FormState> addExpenseFormKey = GlobalKey();
  final Function(String,String) onTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.4,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: addExpenseFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: descriptionController,
                  label: 'description'.tr(),
                  maxLines: 5,
                  validator: (value) {
                    if (value!.isEmpty) return 'required'.tr();
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: priceController,
                  label: 'amount'.tr(),
                  numerical: true,
                  validator: (value) {
                    if (value!.isEmpty) return 'required'.tr();
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                    title: 'ok'.tr(),
                    onTap: () {
                      if (addExpenseFormKey.currentState!.validate()) {
                        Navigator.pop(context);
                        onTap(descriptionController.text,priceController.text);
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
