

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PaymentSummaryTable extends StatelessWidget {
 final double ?paidAmount;
 final double ?remainingAmount;
 final double tax;
 final double ?deliveryFee;
 final double? discount;
 final double total;

  const PaymentSummaryTable({Key? key,  this.deliveryFee,required this.total,
     this.discount,required this.tax,  this.paidAmount,
     this.remainingAmount,  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  Size size =  MediaQuery.of(context).size;
    return  Table(
      border: TableBorder.all(),
      children: [
        if(paidAmount!=0)
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
              child: Text(
                'paid'.tr(),
                style: TextStyle(
                    fontSize: size.height*0.022,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2),
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
              child: Text(
                '${paidAmount} SAR ',
                style: TextStyle(
                    fontSize: size.height*0.022,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ]),
        if(remainingAmount!=0)
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
              child: Text(
                'remaining'.tr(),
                style: TextStyle(
                    fontSize: size.height*0.022,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
              child: Text(
                '$remainingAmount SAR ',
                style: TextStyle(
                    fontSize: size.height*0.022,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
              child: Text(
                'tax'.tr(),
                style: TextStyle(
                    fontSize: size.height*0.022,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
              child: Text(
                '${tax.toStringAsFixed(2)} SAR ',
                style: TextStyle(
                    fontSize: size.height*0.022,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ]),
        if (deliveryFee != 0)
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: Text(
                  'delivery'.tr(),
                  style: TextStyle(
                      fontSize: size.height*0.022,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: Text('$deliveryFee SAR',
                  style: TextStyle(
                      fontSize: size.height*0.022,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ]),

        if (discount != 0)
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: Text(
                  'discount'.tr(),
                  style: TextStyle(
                      fontSize: size.height*0.022,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: Text(
                  '$discount SAR',
                  style: TextStyle(
                      fontSize: size.height*0.022,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Text(
                'total'.tr(),
                style: TextStyle(
                    fontSize: size.height*0.025,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Text(
                '${total.toStringAsFixed(2)} SAR ',
                style: TextStyle(
                    fontSize: size.height*0.025,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ]),
      ],
    );
  }
}
