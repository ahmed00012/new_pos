import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/printing_services/payment_summary_table.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/printing_services/products_table.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/printing_services/table_header.dart';

import '../../models/cart_model.dart';
import '../prefs_utils.dart';

class InvoiceWidget{

 static Widget invoiceProducts(OrderDetails order){
    return Column(
      children: [
        const TableHeader(),
        ProductsTable(cart: order.cart),
        const  SizedBox(
          height: 40,
        ),
        PaymentSummaryTable(
          tax: order.tax,
          total: order.total,
          deliveryFee: order.deliveryFee,
          discount: order.discount,
          paidAmount: order.paid,
          remainingAmount: order.remaining,
        ),

        const SizedBox(
          height: 20,
        ),

        Text(
          'contactUs'.tr(),
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/twitter.png',
                width: 35,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                getTwitter(),
                style: TextStyle(fontSize: 16),
              ),
              Spacer(),
              Image.asset(
                'assets/images/instagram.png',
                width: 35,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                getInstagram(),
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/call.png',
              width: 35,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              getPhone(),
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

}