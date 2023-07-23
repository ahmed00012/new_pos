import 'dart:convert';

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:easy_localization/src/public_ext.dart';
import 'package:enough_convert/enough_convert.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/prefs_utils.dart';
import 'package:shormeh_pos_new_28_11_2022/local_storage.dart';
import 'package:shormeh_pos_new_28_11_2022/models/cart_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/coupon_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/orders_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/owner_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/payment_model.dart';
import 'package:shormeh_pos_new_28_11_2022/repositories/new_order_repository.dart';
import '../constants/constant_keys.dart';
import '../models/integration_model.dart';
import '../models/printers_model.dart';


final newOrderFuture = ChangeNotifierProvider.autoDispose
    .family<NewOrderController, OrderDetails>(
        (ref, order) => NewOrderController(order));

class NewOrderController extends ChangeNotifier {
  NewOrderRepository repo = NewOrderRepository();
  List<PaymentModel> paymentMethods = [];
  List<PaymentModel> paymentCustomers = [];
  List<OwnerModel> owners = [];
  List<CouponModel> coupons = [];
  bool loading = false;
  bool selectCustomerChosen = false;

  TextEditingController coupon = TextEditingController();
  List<PrinterModel> printers = [];
  // String twitter = '';
  // String instagram = '';
  // String phone = '';

  int? collapseKey;
  double? predict1;
  double? predict2;
  double? predict3;
  double? predict4;
  // img.Image? productsScreenshot;
  // Uint8List? productsImage;
  double remaining = 0.0;
  OrderDetails? currentOrder;

  NewOrderController(OrderDetails order) {
    getPaymentMethods();
    collapse();
    getOwners();
    getPrinters();
    currentOrder = order;
    notifyListeners();
  }

  // testToken()async{
  //   LocalStorage.removeData(key: 'token');
  //   LocalStorage.removeData(key: 'branch');
  //   LocalStorage.removeData(key: 'coupons');
  //   navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (_)=>Login()), (route) => false);
  // }
  collapse() {
    int? newKey;
    do {
      collapseKey = new Random().nextInt(10000);
    } while (newKey == collapseKey!);
  }

  void getPaymentMethods() async {
    paymentMethods = List<PaymentModel>.from(json
        .decode(getPaymentMethodsPrefs())
        .map((e) => PaymentModel.fromJson(e)));
    paymentMethods.forEach((element) {
      element.chosen = false;
    });

    notifyListeners();
  }

  void getOwners() async {
    owners = List<OwnerModel>.from(
        json.decode(getOwnersPrefs()).map((e) => OwnerModel.fromJson(e)));
    notifyListeners();
  }

  // void getCoupons() async {
  //     coupons = List<CouponModel>.from(json
  //         .decode(getCouponsPrefs())
  //         .map((e) => CouponModel.fromJson(e)));
  //
  //   notifyListeners();
  // }

  Future getPrinters() async {
    List<PrinterModel> sortPrinters = [];
    sortPrinters = List<PrinterModel>.from(
        json.decode(getPrintersPrefs()).map((e) => PrinterModel.fromJson(e)));

    sortPrinters.forEach((element) {
      if (element.typeName != 'CASHIER') {
        printers.add(element);
      }
    });
    sortPrinters.forEach((element) {
      if (element.typeName == 'CASHIER') {
        printers.add(element);
      }
    });

    notifyListeners();
  }

  void selectOwner(OwnerModel owner) {
    owners.forEach((element) {
      element.chosen = false;
    });
    owner.chosen = true;
    currentOrder!.owner = owner;
    collapse();
    notifyListeners();
  }

  void cancelPayment() {
    paymentMethods.forEach((element) {
      element.chosen = false;
    });
    // currentOrder!.cancelPayment();
    notifyListeners();
  }

  void selectPayment(int i, double total) {
    owners.forEach((element) {
      element.chosen = false;
    });
    currentOrder!.owner = null;
    collapse();
    List<int> paymentIds = currentOrder!.payMethods.map((e) => e.id!).toList();

    if (!paymentIds.contains(paymentMethods[i].id)) {
      amountCalculator(total);
      currentOrder!.payMethods.add(OrderPaymentMethods(
        id: paymentMethods[i].id,
        title: paymentMethods[i].title!.en,
      ));
    }

    //  if(currentOrder!.payMethods.isEmpty){
    //    currentOrder!.payMethods.add(OrderPaymentMethods()) ;
    //    paymentMethods[i].chosen = true;
    //    amountCalculator(context);
    //  }
    //  else if(currentOrder!.payment1!=null&&
    //      currentOrder!.payment2 == null &&
    //  currentOrder!.getTotal()>currentOrder!.getTotalAmount()){
    //    currentOrder!.payment2 = paymentMethods[i];
    //    paymentMethods[i].chosen = true;
    //    amountCalculator(context);
    //  }
    //
    // else if(currentOrder!.payment1==paymentMethods[i]){
    //    paymentMethods[i].chosen = false;
    //    currentOrder!.payment1 = null;
    //    currentOrder!.amount1 = 0.0;
    //    print(currentOrder!.getTotalAmount());
    //    print(currentOrder!.getTotal());
    //    currentOrder!.getTotalAmount();
    //    currentOrder!.getTotal();
    //  }
    //  else if(currentOrder!.payment2==paymentMethods[i]){
    //    paymentMethods[i].chosen = false;
    //    currentOrder!.payment2 = null;
    //    currentOrder!.amount2 = 0.0;
    //  }
    //
    //  else if(currentOrder!.payment2!=null&&currentOrder!.payment1!=null){
    //
    //    paymentMethods.forEach((element) {
    //      if(element.id ==currentOrder!.payment2!.id){
    //       element.chosen = false;
    //      }
    //    });
    //    currentOrder!.amount2 = 0.0;
    //    paymentMethods[i].chosen = true;
    //    currentOrder!.payment2 = paymentMethods[i];
    //    amountCalculator(context);
    //
    //  }
    //
    //  currentOrder!.payment =paymentMethods[i].title!.en;

    notifyListeners();
  }

  amountCalculator(double totalWithTax) {
    // if (currentOrder!.amount1==0.0 && currentOrder!.amount2 == 0.0) {
    for (int i = 0; i < 5; i++) {
      if ((totalWithTax + i).ceil() % 5 == 0) {
        predict1 = (totalWithTax + i).ceil().toDouble();
        break;
      }
    }
    for (int i = 0; i < 10; i++) {
      if ((totalWithTax + i).ceil() % 10 == 0) {
        predict2 = (totalWithTax + i).ceil().toDouble();
        break;
      }
    }

    for (int i = 0; i < 50; i++) {
      if ((totalWithTax + i).ceil() % 50 == 0) {
        predict3 = (totalWithTax + i).ceil().toDouble();
        break;
      }
    }

    for (int i = 0; i < 100; i++) {
      if ((totalWithTax + i).ceil() % 100 == 0) {
        predict4 = (totalWithTax + i).ceil().toDouble();
        break;
      }
    }

    if (predict1 == predict2 && predict1! % 10 == 0)
      predict2 = predict2! + 10;
    else if (predict1 == predict2 && predict1! % 10 != 0)
      predict2 = predict2! + 5;

    if (predict3! <= predict2!) {
      for (int i = 0; i < 100; i++) {
        print(i);
        if ((predict3! + i) % 100.0 == 0.0) {
          predict3 = predict3! + i;
          break;
        }
      }
    }
    if (predict3 == predict4) predict4 = predict4! + 100;

    // currentOrder!.amount1 = double.parse(value);
    // if(currentOrder!.payment1!.id==1) {
    //   showDialog(
    //       context: context,
    //       builder: (context) {
    //         return AmountWidget(
    //           predict1: predict1 != predict2 ? predict1.toString() : null,
    //           predict2: predict2.toString(),
    //           predict3: predict3.toString(),
    //           predict4: predict4.toString(),
    //           showTextField: true,
    //         );
    //       }).then((value) {
    //     if (value != null) {
    //       // amount.insert(0, double.parse(value));
    //       currentOrder!.amount1 = double.parse(value);
    //       currentOrder!.paid = double.parse(value);
    //       notifyListeners();
    //     }
    //   });
    // }
    // else {
    //   showDialog(
    //       context: context,
    //       builder: (context) {
    //         return AmountWidget(
    //           predict1: currentOrder!.getTotal().toString(),
    //           showTextField: true,
    //         );
    //       }).then((value) {
    //
    //     if (value != null) {
    //
    //       // amount.insert(0, double.parse(value));
    //       currentOrder!.amount1 = double.parse(value);
    //       currentOrder!.paid = double.parse(value);
    //       notifyListeners();
    //     }
    //     else{
    //       currentOrder!.payment1!.chosen = false;
    //       currentOrder!.payment1 = null;
    //       notifyListeners();
    //
    //     }
    //   });
    // currentOrder!.amount1 =
    //     currentOrder!.getTotal();
    // currentOrder!.paid = currentOrder!.getTotal();
    //     notifyListeners();
    //   }
    // }
    // else {
    //   predict1 = null;
    //   predict2 = null;
    //   predict3 = null;
    //   predict4 = null;
    //   if(currentOrder!.amount1!=0) {
    //     currentOrder!.amount2 =
    //         currentOrder!.getTotal() -
    //             currentOrder!.getTotalAmount();
    //     currentOrder!.paid=    currentOrder!.amount2! +
    //         currentOrder!.amount1!;
    //     notifyListeners();
    //
    //   } else {
    //     currentOrder!.amount1 =
    //         currentOrder!.getTotal() -
    //             currentOrder!.getTotalAmount();
    //     currentOrder!.paid=currentOrder!.amount1!;
    //     notifyListeners();
    //     print(currentOrder!.amount2.toString() + 'slslls');
    //   }
    // }

    notifyListeners();
  }

  // double totalFromAmount() {
  //
  //   remaining =
  //       currentOrder!.getTotalAmount() -  currentOrder!.getTotal();
  //
  //   return remaining;
  // }

  void switchLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  // void closeOrder() {
  //   coupon.text = '';
  //   currentOrder = OrderDetails();
  //   paymentMethods.forEach((element) {
  //     element.chosen = false;
  //   });
  //   switchLoading(false);
  //   chosenOwner = null;
  //   notifyListeners();
  // }

  countingIntegration(OrderDetails orderDetails, dynamic orderResponse) {
    IntegrationModel integrationModel = IntegrationModel(orderDetail: []);
    orderDetails.cart.asMap().forEach((i, element) {
      OrderDetail countingIntegrationBody = OrderDetail(
          postingDate: DateTime.now().toString(),
          quantity: element.count.toString(),
          description: element.itemName.toString(),
          tax: (element.total * getTax() / 100).toString(),
          discount: orderDetails.discount.toString(),
          amount: element.total.toString(),
          paymentType: '',
          itemNo: element.itemCode,
          locationCode: getBranchCode(),
          type: 'Sale',
          unitOfMeasure: 'PCS',
          lineNo: orderResponse['id'].toString() + i.toString(),
          documentNo: '${orderResponse['id']}_${orderResponse['id']}$i',
          customerNo: orderResponse['client_id'].toString());
      integrationModel.orderDetail!.add(countingIntegrationBody);
    });

    orderDetails.payMethods.asMap().forEach((i, element) {
      integrationModel.orderDetail!.add(OrderDetail(
          postingDate: DateTime.now().toString(),
          quantity: '1',
          description: '',
          tax: currentOrder!.tax.toString(),
          discount: orderDetails.discount.toString(),
          amount: element.value,
          paymentType: currentOrder!.payment1!.id.toString(),
          itemNo: '',
          locationCode: getBranchCode(),
          type: 'Payment',
          unitOfMeasure: '',
          lineNo: '${orderResponse['id']}${i * 10}',
          documentNo: '${orderResponse['id']}_${orderResponse['id']}${i * 10}',
          customerNo: orderResponse['client_id'].toString()));
    });

    repo.payIntegration(integrationModel.toJson());
  }

  Future confirmOrder(
      OrderDetails orderDetails, int hold, String coupon , img.Image productsScreenshot,
      Uint8List productsImg) async {
    switchLoading(true);
    List<Order> details = [];
    if (orderDetails.customer != null) {
      orderDetails.payMethods.add(OrderPaymentMethods(id: 2, value: '0'));
    }
    orderDetails.cart.forEach((element) {
      details.add(Order(
          productId: element.id,
          quantity: element.count,
          note: element.extraNotes,
          notes: element.extra!.map((e) => e.id!).toList(),
          attributes: element.allAttributesID));
    });
    var responseValue = await repo.confirmOrder(orderDetails.toJson());
    if (responseValue['data'] != null) {
      testPrint(
        orderNo: responseValue['data']['uuid'],
        orderDetails: orderDetails,
        productsImage: productsImg,
        productsScreenshot: productsScreenshot
      ).then((value) {
        if (getBranchCode().isNotEmpty)
          countingIntegration(
            orderDetails,
            responseValue['data'],
          );
        ConstantStyles.displayToastMessage(
            '${'order'.tr()} ${responseValue['data']['uuid']}  ${'createdSuccessfully'.tr()}',
            false);
      });
    } else {
      ConstantStyles.displayToastMessage('Order Failed ${responseValue['msg']}', true);
    }

    switchLoading(false);
  }

  Future updateOrder(OrderDetails orderDetails, String coupon  ,
      img.Image productsScreenshot, Uint8List productsImg) async {
    switchLoading(true);
    List<Order> details = [];
    if (orderDetails.customer != null) {
      orderDetails.payMethods.add(OrderPaymentMethods(id: 2, value: '0'));
    }
    orderDetails.cart.forEach((element) {
      details.add(Order(
          productId: element.id,
          quantity: element.count,
          note: element.extraNotes,
          notes: element.extra!.map((e) => e.id!).toList(),
          attributes: element.allAttributesID));
    });
    var responseValue = await repo.updateFromOrder(
        orderDetails.orderUpdatedId!, orderDetails.toJson());
    if (responseValue['data'] != null) {
      testPrint(
        orderNo: responseValue['data']['uuid'],
        orderDetails: orderDetails,
          productsImage: productsImg,
          productsScreenshot: productsScreenshot
      ).then((value) {
        if (getBranchCode().isNotEmpty) {
          countingIntegration(
            orderDetails,
            responseValue['data'],
          );
        }
        ConstantStyles.displayToastMessage(responseValue['msg'], false);
      });
    } else {
      ConstantStyles.displayToastMessage('Order Failed ${responseValue['msg']}', true);
    }

    switchLoading(false);
  }

  // imageProductsPrinter(ScreenshotController screenshotController) async {
  //
  //   screenshotController.capture().then((Uint8List? image2) {
  //      productsScreenshot = img.decodePng(image2!);
  //     productsScreenshot!.setPixelRgba(0, 0, 255,255,255);
  //     productsScreenshot= img.copyResize(productsScreenshot!, width: 550);
  //     productsImage = image2;
  //     // setImageScreenshot(image2,productsScreenshot);
  //     notifyListeners();
  //   });
  // }

  // checkOrderDetails(int hold,BuildContext context,ScreenshotController screenshotController){
  //
  //   if(currentOrder!.orderUpdatedId==null){
  //     if(currentOrder!.customer!=null){
  //     if (currentOrder!.payment1!=null&& totalFromAmount()!=0.0) {
  //       showDialog(
  //           context: context,
  //           builder: (dialogContext) {
  //             return AlertDialog(
  //               title: Center(
  //                 child: Text(
  //                     'remaining'.tr() + ' ${totalFromAmount().toStringAsFixed(2)} SAR',
  //                     style: TextStyle(
  //                       fontSize: 24,
  //                     )),
  //               ),
  //               content: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Center(
  //                     child: Container(
  //                       height: MediaQuery.of(context).size.height*0.07,
  //                       width: MediaQuery.of(context).size.width*0.2,
  //                       decoration: BoxDecoration(
  //                           borderRadius:
  //                           BorderRadius.circular(
  //                               10),
  //                           color: Constants.mainColor),
  //                       child: InkWell(
  //                         onTap: () {
  //
  //                           Navigator.pop(dialogContext);
  //                           confirmOrder(hold,context).then((value) {
  //                             Navigator.pushAndRemoveUntil(context,
  //                                 MaterialPageRoute(builder: (_)=>Home()), (route) => false);
  //                           });
  //                         },
  //                         child: Center(
  //                           child: Text(
  //                             'ok'.tr(),
  //                             style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize:24),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           });
  //     }
  //       else {
  //
  //         confirmOrder(hold, context);
  //       }
  //     }
  //
  //    else if(currentOrder!.owner!=null){
  //       confirmOrder(hold,context);
  //     }
  //
  //    else if(hold==1) {
  //       confirmOrder(hold,context);
  //     }
  //    else{
  //
  //      if(currentOrder!.payment1==null){
  //        displayToastMessage('Please Choose Payment', true);
  //      }
  //     else if(currentOrder!.getTotalAmount()<currentOrder!.getTotal() ){
  //        displayToastMessage('Please Choose Payment', true);
  //      }
  //      else if (totalFromAmount()!=0.0) {
  //        showDialog(
  //            context: context,
  //            builder: (dialogContext) {
  //              return AlertDialog(
  //                title: Center(
  //                  child: Text(
  //                      'remaining'.tr() + ' ${totalFromAmount().toStringAsFixed(2)} SAR',
  //                      style: TextStyle(
  //                        fontSize: 24,
  //                      )),
  //                ),
  //                content: Column(
  //                  mainAxisSize: MainAxisSize.min,
  //                  children: [
  //
  //                    Center(
  //                      child: Container(
  //                        height: MediaQuery.of(context).size.height*0.07,
  //                        width: MediaQuery.of(context).size.width*0.2,
  //                        decoration: BoxDecoration(
  //                            borderRadius:
  //                            BorderRadius.circular(
  //                                10),
  //                            color: Constants.mainColor),
  //                        child: InkWell(
  //                          onTap: () {
  //
  //                             Navigator.pop(dialogContext);
  //                            confirmOrder(hold,context);
  //                          },
  //                          child: Center(
  //                            child: Text(
  //                              'ok'.tr(),
  //                              style: TextStyle(
  //                                  color: Colors.white,
  //                                  fontSize:24),
  //                            ),
  //                          ),
  //                        ),
  //                      ),
  //                    ),
  //                  ],
  //                ),
  //              );
  //            });
  //      }
  //     else{
  //        confirmOrder(hold,context);
  //      }
  //     }
  //   }
  //
  //   else{
  //     if(currentOrder!.customer!=null){
  //       updateOrder(currentOrder!.orderUpdatedId!, context);
  //     }
  //
  //     else{
  //
  //      if(
  //      currentOrder!.payment1!=null&&
  //      currentOrder!.getTotalAmount()<currentOrder!.getTotal() ){
  //            displayToastMessage('wrongAmount'.tr(), true);
  //       }
  //      else if (currentOrder!.payment1!=null&& totalFromAmount()!=0.0) {
  //        showDialog(
  //            context: context,
  //            builder: (dialogContext) {
  //              return AlertDialog(
  //                title: Center(
  //                  child: Text(
  //                      'remaining'.tr() + ' ${totalFromAmount().toStringAsFixed(2)} SAR',
  //                      style: TextStyle(
  //                        fontSize: 24,
  //                      )),
  //                ),
  //                content: Column(
  //                  mainAxisSize: MainAxisSize.min,
  //                  children: [
  //                    Center(
  //                      child: Container(
  //                        height: MediaQuery.of(context).size.height*0.07,
  //                        width: MediaQuery.of(context).size.width*0.2,
  //                        decoration: BoxDecoration(
  //                            borderRadius:
  //                            BorderRadius.circular(
  //                                10),
  //                            color: Constants.mainColor),
  //                        child: InkWell(
  //                          onTap: () {
  //                            Navigator.pop(dialogContext);
  //                            updateOrder(currentOrder!.orderUpdatedId!, context);
  //                          },
  //                          child: Center(
  //                            child: Text(
  //                              'ok'.tr(),
  //                              style: TextStyle(
  //                                  color: Colors.white,
  //                                  fontSize:24),
  //                            ),
  //                          ),
  //                        ),
  //                      ),
  //                    ),
  //                  ],
  //                ),
  //              );
  //            });
  //      }
  //       else{
  //
  //        updateOrder(currentOrder!.orderUpdatedId!, context);
  //       }
  //     }
  //   }
  // }

  // imageProductsPrinter(ScreenshotController screenshotController)  {
  //   // productsScreenshot = null;
  //
  //   screenshotController.capture().then((Uint8List? image2) {
  //     productsImage = image2;
  //     productsScreenshot = img.decodePng(image2!);
  //     productsScreenshot!.setPixelRgba(0, 0, 255,255,255);
  //     productsScreenshot= img.copyResize(productsScreenshot!, width: 550);
  //   });
  //
  //   notifyListeners();
  // }

  // imageDevicePrinter(ScreenshotController screenshotController)  {
  //   screenshotController.capture().then((Uint8List? image2) {
  //     productsImage = image2;
  //   });
  //   notifyListeners();
  // }

  String getQrCodeContent(String orderTotal, String orderTax) {
    final bytesBuilder = BytesBuilder();
    // 1. Seller Name
    bytesBuilder.addByte(1);
    final sellerNameBytes =
        utf8.encode(LocalStorage.getData(key: 'branchName').toString());
    bytesBuilder.addByte(sellerNameBytes.length);
    bytesBuilder.add(sellerNameBytes);
    // 2. VAT Registration
    bytesBuilder.addByte(2);
    final vatRegistrationBytes =
        utf8.encode(LocalStorage.getData(key: 'taxNumber').toString());
    bytesBuilder.addByte(vatRegistrationBytes.length);
    bytesBuilder.add(vatRegistrationBytes);
    // 3. Time
    bytesBuilder.addByte(3);
    // final time = utf8.encode('2022-04-25T15:30:00Z');
    final time = utf8.encode(DateTime.now().toString());
    bytesBuilder.addByte(time.length);
    bytesBuilder.add(time);
    // 4. total with vat
    bytesBuilder.addByte(4);
    final p1 = utf8.encode(orderTotal);
    bytesBuilder.addByte(p1.length);
    bytesBuilder.add(p1);
    // 5.  vat
    bytesBuilder.addByte(5);
    final p2 = utf8.encode(orderTax);
    bytesBuilder.addByte(p2.length);
    bytesBuilder.add(p2);

    final qrCodeAsBytes = bytesBuilder.toBytes();
    const b64Encoder = Base64Encoder();
    return b64Encoder.convert(qrCodeAsBytes);
  }

  Uint8List textEncoder(String word) {
    return Uint8List.fromList(
        Windows1256Codec(allowInvalid: false).encode(word));
  }

  testReceipt(img.Image productsScreenshot, NetworkPrinter printer,
      OrderDetails order, bool kitchen,
      {String? orderNo}) async {
    printer.setGlobalCodeTable('CP775');
    if (orderNo != null) printer.hr(ch: '_');
    if (orderNo != null) {
      printer.text('Order Number $orderNo',
          styles: const PosStyles(
              align: PosAlign.center,
              bold: true,
              height: PosTextSize.size2,
              width: PosTextSize.size2));
    }

    if (orderNo != null) printer.hr(ch: '_');

    if (order.clientName != null) {
      printer.textEncoded(
          textEncoder('${'clientName'.tr()} : ${order.clientName!}'),
          styles: ConstantStyles.centerBold);
    }

    if (!kitchen) {
      printer.textEncoded(textEncoder(' branch : ${getBranchName()}'),
          styles: ConstantStyles.centerBold);
    }

    if (!kitchen) {
      printer.text('Tax No. : ${getTaxNumber()}',
          styles: ConstantStyles.centerBold);
    }

    printer.text(DateTime.now().toString().substring(0, 16),
        styles: ConstantStyles.centerBold);

    if (order.orderMethod != null) {
      printer.textEncoded(
          textEncoder('${'orderMethod'.tr()} : ${order.orderMethod!}'),
          styles: ConstantStyles.centerBold);
    }

    order.payMethods.asMap().forEach((index, element) {
      printer.textEncoded(
          textEncoder('${'paymentMethod'.tr()} $index: ${element.title!}'),
          styles: ConstantStyles.centerBold);
    });

    if (order.customer != null && remaining < 0) {
      printer.textEncoded(
          textEncoder("${order.customer!.title!}  -  ${'payLater'.tr()}"),
          styles: ConstantStyles.centerBold);
    }
    if (order.customer != null && remaining >= 0) {
      printer.textEncoded(textEncoder(order.customer!.title!),
          styles: ConstantStyles.centerBold);
    }

    if (order.owner != null) {
      printer.textEncoded(
          textEncoder('${'paymentMethod'.tr()} : ${order.owner!.title!}'),
          styles: ConstantStyles.centerBold);
    }

    if (order.department != null) {
      printer.textEncoded(textEncoder(order.department!),
          styles: ConstantStyles.centerBold);
    }

    if (order.table != null) {
      printer.textEncoded(textEncoder('Table : ${order.table!}'),
          styles: ConstantStyles.centerBold);
    }
    if (!kitchen) {
      printer.textEncoded(textEncoder('Employee : ${getUserName()}'),
          styles: ConstantStyles.centerBold);
    }
    printer.emptyLines(1);
    printer.image(productsScreenshot, align: PosAlign.center);

    if (!kitchen) printer.emptyLines(1);
    if (!kitchen)
      printer.qrcode(
          getQrCodeContent(order.total.toString(), order.tax.toString()));
    printer.emptyLines(1);
    printer.textEncoded(textEncoder('هيئة الضريبة والدخل'),
        styles: ConstantStyles.centerBold);
    printer.drawer();
    printer.feed(2);
    printer.cut();
  }

  deviceReceipt(OrderDetails order, Uint8List? productsImage, {String? orderNo}) async {
    channel.invokeMethod("sdkInit");

    if (orderNo != null)
      channel.invokeMethod(iminPrintText, iminPrintTextChannel(text: 'Order Number $orderNo',fontSize: '50'));
    channel.invokeMethod(iminFeed);

    if (order.clientName != null)
      channel.invokeMethod(iminPrintText,
          iminPrintTextChannel(text: '${'clientName'.tr()} : ${order.clientName!}'));

    channel.invokeMethod(iminPrintText,
        iminPrintTextChannel(text: ' branch : ${getBranchName()}'));

    channel.invokeMethod(iminPrintText,
        iminPrintTextChannel(text: ' Tax No. : ${getTaxNumber()}'));

    channel.invokeMethod(
        iminPrintText, iminPrintTextChannel(text: DateTime.now().toString().substring(0, 16)));

    if (order.orderMethod != null)
      channel.invokeMethod(iminPrintText,
          iminPrintTextChannel(text:'${'orderMethod'.tr()} : ${order.orderMethod!}'));

    order.payMethods.asMap().forEach((index , element) {
      channel.invokeMethod(iminPrintText,
          iminPrintTextChannel(text:'${'paymentMethod'.tr()}$index : ${order.payment1!.title!.en!}'));
    });



    if (order.customer != null && remaining < 0)
      channel.invokeMethod(iminPrintText,
          iminPrintTextChannel(text:'${order.customer!.title!}  -  ${'payLater'.tr()}'));


    if (order.customer != null && remaining >= 0)
      channel.invokeMethod(iminPrintText,
          iminPrintTextChannel(text:'${order.customer!.title!}'));

    if (order.owner != null)
      channel.invokeMethod(iminPrintText,
          iminPrintTextChannel(text:'${'paymentMethod'.tr()} : ${order.owner!.title!}'));


    if (order.department != null)
      channel.invokeMethod(iminPrintText,
          iminPrintTextChannel(text :order.department!));

    if (order.table != null)
      channel.invokeMethod(iminPrintText, iminPrintTextChannel(text: 'Table : ${order.table!}'));


    channel.invokeMethod(iminPrintText,
        iminPrintTextChannel(text: 'Employee : ${getUserName()}'));
    channel.invokeMethod(iminFeed);
    channel.invokeMethod(iminPrintBitmap,
        {
      'image': productsImage,
      'type': 'image/png',
    });

    channel.invokeMethod(iminPrintQr,
        [getQrCodeContent(order.total.toString(), order.tax.toString())]);
    channel.invokeMethod(iminPrintText, iminPrintTextChannel(text: 'هيئة الضريبة والدخل' , fontSize: '20'));
    channel.invokeMethod(iminFeed);
    channel.invokeMethod(iminFeed);
    channel.invokeMethod(iminFeed);
    channel.invokeMethod(iminPaperCutter);
    channel.invokeMethod(iminFeed);

  }


  testPrint({String? orderNo , required OrderDetails orderDetails ,
    required img.Image productsScreenshot, required Uint8List? productsImage }) async {
    deviceReceipt(orderDetails, productsImage ,orderNo: orderNo);
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    printers.forEach((element) async {
      PosPrintResult res = await printer.connect(element.ip!, port: 9100);
      if (res == PosPrintResult.success) {
        await testReceipt(
            productsScreenshot, printer, orderDetails, element.typeName == 'Kitchen',
            orderNo: orderNo);
        printer.disconnect();
      }
    });
    notifyListeners();
  }

  List<dynamic> iminPrintTextChannel({required String text, String? fontSize, String? alignment}){
    return [text, fontSize ?? '25',alignment ?? '1'];
  }

  iminPrintDividerChannel(){
    channel.invokeMethod(iminPrintText, ['_____________________________________', '30', '1']);
  }


}
