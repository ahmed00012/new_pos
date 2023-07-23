import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shormeh_pos_new_28_11_2022/models/orders_model.dart';

import '../../../../constants/colors.dart';

class OrderWidget extends StatelessWidget {
  const OrderWidget({super.key, required this.order});

  final OrdersModel order;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        if (order.paymentCustomerImage != null)
          AspectRatio(
            aspectRatio: 6,
            child: Align(
              alignment: Alignment.topRight,
              child: Image.network(
                order.paymentCustomerImage!,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: order.ownerName != null
                      ? Constants.secondryColor
                      : order.paymentStatus == 0 && order.orderStatusId != 5
                          // && viewModel.orders[i].orderStatusId != 4
                          ? Colors.red
                          : Colors.white)),
          child: Center(
            child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${"order".tr()} ${order.uuid}',
                      style: TextStyle(
                          color: Constants.mainColor,
                          fontWeight: FontWeight.bold,
                          fontSize: size.height * 0.02),
                    ),
                    if (order.orderMethodId != 2)
                      Text(
                        order.orderMethod.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: size.height * 0.02,
                            color: Constants.lightBlue),
                      ),
                    if (order.orderMethodId == 2)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            order.department.toString(),
                            style: TextStyle(
                                fontSize: size.height * 0.02,
                                color: Constants.mainColor),
                          ),
                        const  SizedBox(
                            height: 2,
                          ),
                          Container(
                            height: size.height * 0.032,
                            width: size.width * 0.05,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Constants.mainColor)),
                            child: Center(
                              child: Text(
                                order.table!,
                                style: TextStyle(
                                    fontSize: size.height * 0.015,
                                    color: Constants.lightBlue),
                              ),
                            ),
                          )
                        ],
                      ),
                    if (order.clientPhone != null)
                      Text(
                        order.clientPhone!,
                        style: TextStyle(
                            fontSize: size.height * 0.02,
                            color: Constants.lightBlue),
                      ),
                    if (order.ownerName != null)
                      Text(
                        order.ownerName!,
                        style: TextStyle(
                            fontSize: size.height * 0.02,
                            color: Constants.lightBlue),
                      ),
                    if (order.orderStatusId == 7)
                      Icon(
                        Icons.warning_amber_outlined,
                        color: Colors.red[500],
                        size: 25,
                      ),
                  ],
                )),
          ),
        ),
        if (order.orderStatusId == 5)
          Center(
            child: Image.asset(
              'assets/images/cancelled.png',
              color: Colors.red.withOpacity(0.1),
            ),
          ),
        if (order.orderStatusId == 8)
          Center(
            child: Image.asset(
              'assets/images/ban-user.png',
              color: Colors.red.withOpacity(0.1),
            ),
          ),
        if (order.orderStatusId == 6)
          Center(
            child: Image.asset(
              'assets/images/stop-button.png',
              color: Colors.red.withOpacity(0.1),
            ),
          ),
      ],
    );
  }
}
