


import 'package:flutter/material.dart';
import 'package:shormeh_pos_new_28_11_2022/models/order_method_model.dart';

import '../../../../constants/colors.dart';

class OrderMethodItem extends StatefulWidget {
  final int index;
  final List<OrderMethodModel> orderMethods;
  final VoidCallback onTap;
  const OrderMethodItem({Key? key, required this.index , required this.orderMethods ,
  required this.onTap}) : super(key: key);

  @override
  State<OrderMethodItem> createState() => _OrderMethodItemState();
}

class _OrderMethodItemState extends State<OrderMethodItem> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () {

          setState(() {
            widget.orderMethods.forEach((element) {element.chosen = false;});
            widget.orderMethods[widget.index].chosen = true;
          });
          widget.onTap();
          //
          // orderController.setOrderMethod(
          //     orderController.orderMethods[index], index);
          // if (orderController.orderMethods[index].id ==
          //     1) {
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (_) => PaymentScreen(order: cartController.orderDetails,)));
          // }
          // if (orderController.orderMethods[index].id ==
          //     3) {
          //
          //   Future.delayed(Duration(milliseconds: 100),(){
          //     imageProductsPrinter();
          //     orderController.confirmOrder(context);
          //
          //   });
          //
          //
          //
          // }   if (orderController.orderMethods[index].id == 2) {
          //   showDialog(
          //       context: context,
          //       builder: (context) {
          //         return AlertDialog(
          //             titlePadding: EdgeInsets.zero,
          //             contentPadding: EdgeInsets.zero,
          //             title: Column(
          //               children: [
          //                 Padding(
          //                   padding: const EdgeInsets.fromLTRB(
          //                       10, 10, 10, 0),
          //                   child: Align(
          //                       alignment: Alignment.topRight,
          //                       child: InkWell(
          //                         onTap: () {
          //                           Navigator.pop(context);
          //                         },
          //                         child: Container(
          //                           height: size.height * 0.05,
          //                           width: size.height * 0.05,
          //                           decoration: BoxDecoration(
          //                               color: Colors.red[400],
          //                               borderRadius:
          //                               BorderRadius.circular(
          //                                   10)),
          //                           child: Center(
          //                             child: Icon(
          //                               Icons.clear,
          //                               color: Colors.white,
          //                             ),
          //                           ),
          //                         ),
          //                       )),
          //                 ),
          //               ],
          //             ),
          //             content: Container(
          //                 height: size.height * 0.7,
          //                 width: size.width * 0.7,
          //                 child: TablesDialog()));
          //       }).then((value) async{
          //
          //     if(value!=null)
          //       Future.delayed(Duration(milliseconds: 100),(){
          //         imageProductsPrinter();
          //         orderController.confirmOrder(context,guestsCount: value);
          //
          //       });
          //   });
          //
          //
          //
          // }
          //
          // if (orderController.orderMethods[index].id ==
          //     4) {
          //   orderController.getCoupons();
          //   orderController.getClients();
          //   if(cartController.orderDetails.clientPhone==null){
          //     orderController.customerPhone.text = '';
          //     orderController.customerName.text = '';
          //   }
          //   else{orderController.refreshData();}
          //   showDialog(
          //       context: context,
          //       builder: (context) {
          //         return AlertDialog(
          //           contentPadding: EdgeInsets.zero,
          //
          //           title: Center(
          //             child: Text(
          //               'orderDetails'.tr(),
          //               style: TextStyle(
          //                   fontSize:
          //                   size.height * 0.025),
          //             ),
          //           ),
          //           content: DeliveryOrder(order: widget.order),
          //         );
          //       }).then((value) async{
          //     if(value==true) {
          //       Future.delayed(
          //           Duration(milliseconds: 100),
          //               () {
          //             imageProductsPrinter();
          //             orderController
          //                 .confirmOrder(context);
          //           });
          //     } else{
          //       orderController.coupon.text = '';
          //       orderController.deliveryFee.text = '';
          //       cartController.orderDetails.deliveryFee = null;
          //       ref.refresh(orderMethodFuture(widget.order));
          //
          //     }
          //   });
          // }
        },
        child: Container(
          height: size.height * 0.2,
          width: size.width * 0.2,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  color:widget.orderMethods[widget.index].chosen!
                      ? Constants.mainColor
                      : Colors.black12,
                  width: widget.orderMethods[widget.index].chosen!
                      ? 2 : 1)),
          child: Center(
            child: Text(
              widget.orderMethods[widget.index].title!.en!,
              style: TextStyle(
                  fontSize: size.height * 0.025,
                  fontWeight: FontWeight.w500,
                  color: widget.orderMethods[widget.index].chosen!
                      ? Constants.mainColor
                      : Colors.black45),
            ),
          ),
        ),
      ),
    );
  }
}
