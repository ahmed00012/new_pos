import 'dart:convert';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:enough_convert/enough_convert.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/prefs_utils.dart';
import 'package:shormeh_pos_new_28_11_2022/local_storage.dart';
import 'package:shormeh_pos_new_28_11_2022/models/payment_details_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/printers_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/user_model.dart';
import 'package:shormeh_pos_new_28_11_2022/repositories/auth_repository.dart';
import '../constants/constant_keys.dart';
import 'home_controller.dart';

final financeFuture = ChangeNotifierProvider.autoDispose<FinanceController>(
    (ref) => FinanceController());

class FinanceController extends ChangeNotifier {
  List<String> startShiftCash = [];
  List<String> endShiftCash = [];
  // double cash = 0.0;
  bool loading = false;
  final AuthRepository _authRepository = AuthRepository();
  bool isVisible = true;
  List<PrinterModel> printers = [];
  double? actualTotalOrders = 0.0;
  double? totalTax = 0.0;
  double? totalDiscount = 0.0;
  int? totalClients = 0;
  int ordersCount = 0;
  int ordersNotPaidCount = 0;
  double? actualTotalNotPaidOrders = 0.0;
  List<PaymentDetailsModel> paymentDetails = [];
  List<PaymentDetailsModel> customerDetails = [];

  void loadingSwitch(bool load) {
    loading = load;
    notifyListeners();
  }

  seePassword() {
    isVisible = !isVisible;
    notifyListeners();
  }

  addNumberFinanceOut(String e) {
    if (endShiftCash.length < 6) endShiftCash.add(e);
    notifyListeners();
  }

  addNumFinanceIn(String e) {
    startShiftCash.add(e);
    notifyListeners();
  }

  removeNumberFinanceOut() {
    endShiftCash.remove(endShiftCash.last);
    notifyListeners();
  }

  removeNumberFinanceIn() {
    startShiftCash.remove(startShiftCash.last);
    notifyListeners();
  }
  List<dynamic> iminPrintTextChannel({required String text, String? fontSize, String? alignment}){
    return [text, fontSize ?? '30',alignment ?? '1'];
  }

  iminPrintDividerChannel(){
    channel.invokeMethod(iminPrintText, ['_____________________________________', '30', '1']);
  }

  Future setStartShiftCash() async {
   try {
      loadingSwitch(true);
      if (startShiftCash.isNotEmpty) {
        var data = await _authRepository.startShiftCash( cash: startShiftCash.join().toString());
        if (data['status']) {
          startShiftCash = [];
          loadingSwitch(false);
          return true;
        }
        else{
          ConstantStyles.displayToastMessage(data['msg'],true);
          return false;
        }
      }
    }
    catch(e){
      ConstantStyles.displayToastMessage(e.toString(),true);
    }
    notifyListeners();
  }

  Future logout() async {
    try{
      var data = await _authRepository.logoutCashier();
      if (!data['status']) {
        ConstantStyles.displayToastMessage(data['msg'],true);
      } else {
        clearData();
      }
    }
    catch(e){
      ConstantStyles.displayToastMessage(e.toString(),true);
    }
    loadingSwitch(false);
    notifyListeners();
  }

  clearData(){
    LocalStorage.clearStorage();
    startShiftCash = [];
    actualTotalOrders = 0.0;
    totalTax = 0.0;
    totalDiscount = 0.0;
    totalClients = 0;
    ordersCount = 0;
  }


  // testToken() async {
  //   LocalStorage.removeData(key: 'token');
  //   LocalStorage.removeData(key: 'branch');
  //   LocalStorage.removeData(key: 'coupons');
  //   navigatorKey.currentState!.pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (_) => Login()), (route) => false);
  // }

  Future login({required VoidCallback onSuccess , required String email ,
  required String password}) async {
    try {
      loadingSwitch(true);
      var data = await _authRepository.loginCashier(email:email, password: password);
      UserModel user =UserModel.fromJson(data['data']);
      if (data['status']) {
        setUserData(user);
        onSuccess();
      } else {
        ConstantStyles.displayToastMessage(data['msg'],true);
      }
    }
    catch (e){
      ConstantStyles.displayToastMessage(e.toString(),true);
    }
    loadingSwitch(false);
    notifyListeners();
  }

  getPrinters() {
      printers = List<PrinterModel>.from(json.decode(getPrinters())
          .map((e) => PrinterModel.fromJson(e)));
  }


  Uint8List textEncoder(String word) {
    return Uint8List.fromList(
        Windows1256Codec(allowInvalid: false).encode(word));
  }

  // String checkCurrentTimeZone(String time) {
  //   String year = time.substring(0, 4);
  //   String month = time.substring(5, 7);
  //   String day = time.substring(8, 10);
  //   String minute = time.substring(14, 16);
  //   String second = time.substring(17, 19);
  //
  //   int utc = DateTime.now().toUtc().hour;
  //   int current = DateTime.now().hour;
  //   int actualTime = current - utc;
  //
  //   return '${day}-${month}-${year}  ${utc + actualTime}:${minute}:${second}';
  // }

  void preparePaymentMethodsData(var data) {
    paymentDetails.clear();
    customerDetails.clear();

    if (getLanguage() == 'en') {
      data['payment_methods_details'].entries.map((entry) {
        paymentDetails.add(PaymentDetailsModel(
            title: entry.collapseKey,
            keys: List<KeyValue>.from(entry.value.entries
                .map((e) => KeyValue(key: e.collapseKey, value: e.value)))));
      }).toList();

      data['select_customer_details'].entries.map((entry) {
        customerDetails.add(PaymentDetailsModel(
            title: entry.collapseKey,
            keys: List<KeyValue>.from(entry.value.entries
                .map((e) => KeyValue(key: e.collapseKey, value: e.value)))));
      }).toList();
    } else {
      data['تفاصيل طرق الدفع'].entries.map((entry) {
        paymentDetails.add(PaymentDetailsModel(
            title: entry.collapseKey,
            keys: List<KeyValue>.from(entry.value.entries
                .map((e) => KeyValue(key: e.collapseKey, value: e.value)))));
      }).toList();

      data['تفاصيل اختيار عميل'].entries.map((entry) {
        customerDetails.add(PaymentDetailsModel(
            title: entry.collapseKey,
            keys: List<KeyValue>.from(entry.value.entries
                .map((e) => KeyValue(key: e.collapseKey, value: e.value)))));
      }).toList();
    }
  }

  Future endShift(bool logoutEmployee) async {
    loadingSwitch(true);
    try{
      var data = await _authRepository.endShiftCash(
          cash: endShiftCash.join().toString());
      if (!data['status']) {
        ConstantStyles.displayToastMessage(data['msg'],true);
        return false;
      } else {
        preparePaymentMethodsData(data['data']);
        totalCalculator();

        if (getLanguage() == 'en') {
          testPrint(
           time: DateTime.now().toString(),
           employeeCash: data['data']['employee_cash'].toStringAsFixed(2),
           startCash: data['data']['start_cash'].toStringAsFixed(2),
           expenses: data['data']['expenses'].toStringAsFixed(2),
           complains: data['data']['complains'].toStringAsFixed(2),
           cancelled: data['data']['cancel_orders_count'].toString(),
           ownerCount: data['data']['owner_orders_count'].toString(),
         ownerTotal:  data['data']['owner_orders_total'].toStringAsFixed(2),
          ).then((value) {
            if(logoutEmployee)
            logout();
          });
        }
        else {
          testPrint(
            time:  DateTime.now().toString(),
            employeeCash:  data['data']['نهاية الدرج'].toStringAsFixed(2),
            startCash: data['data']['بداية الدرج'].toStringAsFixed(2),
            expenses: data['data']['المصاريف'].toStringAsFixed(2),
            complains: data['data']['الشكاوي'].toStringAsFixed(2),
            cancelled:  data['data']['عدد الطلبات الملغية'].toString(),
            ownerCount: data['data']['عدد طلبات الملاك'].toString(),
            ownerTotal:  data['data']['اجمالي طلبات الملاك'].toStringAsFixed(2),
          ).then((value) {
            if(logoutEmployee)
            logout();
          });
        }
        return true;
      }
    }
    catch(e){
      ConstantStyles.displayToastMessage(e.toString(),true);
    }
    loadingSwitch(false);
  }

  totalCalculator() {
    paymentDetails.forEach((e) {
      totalTax = totalTax! + double.parse(e.keys![2].value.toString());
      totalDiscount =
          totalDiscount! + double.parse(e.keys![3].value.toString());
      totalClients = totalClients! + int.parse(e.keys![4].value.toString());
      ordersCount = ordersCount + int.parse(e.keys![5].value.toString());
      actualTotalOrders =
          actualTotalOrders! + double.parse(e.keys![0].value.toString());
    });
    customerDetails.forEach((e) {
      ordersCount = ordersCount +
          int.parse(e.keys![0].value.toString()) +
          int.parse(e.keys![1].value.toString());
      ordersNotPaidCount =
          ordersNotPaidCount + int.parse(e.keys![1].value.toString());
      actualTotalNotPaidOrders =
          actualTotalNotPaidOrders! + double.parse(e.keys![3].value.toString());
    });
  }

  Future productsZReport() async {
    try{
      const PaperSize paper = PaperSize.mm80;
      final profile = await CapabilityProfile.load();
      final printer = NetworkPrinter(paper, profile);
      var data = await _authRepository.productsZReport();
      if (data['msg']) {
        List<KeyValue> productsListZReport =
            List.from(data.map((e) => KeyValue.fromJson(e)));
        productsZReportReceiptDevice(productsListZReport);
        printers.forEach((element) async {
          PosPrintResult res = await printer.connect(element.ip!, port: 9100);
          if (element.typeName == 'CASHIER') {
            if (res == PosPrintResult.success) {
              await productsZReportReceipt(printer, productsListZReport);
              printer.disconnect();
            }
          } else {
            if (res == PosPrintResult.success) {
              printer.disconnect();
            }
            print('Print result: ${res.msg}');
          }
        });
      } else {
        ConstantStyles.displayToastMessage(data['msg'],true);
      }
    }
    catch(e){
      ConstantStyles.displayToastMessage(e.toString(),true);
    }
    notifyListeners();
  }

  Future productsZReportReceipt(NetworkPrinter printer, List<KeyValue> products) async {
    printer.setGlobalCodeTable('CP775');
    printer.textEncoded(textEncoder(getUserName()), styles: ConstantStyles.centerBold);
    printer.text(DateTime.now().toString(), styles: ConstantStyles.center);
    printer.textEncoded(textEncoder(getBranchName()), styles: ConstantStyles.center);
    printer.emptyLines(1);

    products.asMap().forEach((index, value) {
      if (value.value != 0) {
        printer.row([
          PosColumn(text: value.key!.replaceAll('_', ' '), width: 9, styles: ConstantStyles.leftBold),
          PosColumn(text: value.value.toString(), width: 2, styles: ConstantStyles.rightBold),
          PosColumn(text: ' ', width: 1,),
        ]);
      }
    });
    printer.feed(2);
    printer.cut();
  }

  Future productsZReportReceiptDevice(List<KeyValue> products) async {

    channel.invokeMethod(iminPrintText,iminPrintTextChannel(text: getUserName()));
    channel.invokeMethod(iminPrintText,iminPrintTextChannel(text: DateTime.now().toString()));
    channel.invokeMethod(iminPrintText,iminPrintTextChannel(text: getBranchName()));
    channel.invokeMethod(iminFeed);
    products.asMap().forEach((index, value) {
      if (value.value != 0) {
        channel.invokeMethod(iminPrintText,
            iminPrintTextChannel(text:  '${value.key!.replaceAll('_', ' ')} :  ${value.value}' ,
                alignment: '0'));
      }
    });
    channel.invokeMethod(iminFeed);
    channel.invokeMethod(iminFeed);
    channel.invokeMethod(iminFeed);
    channel.invokeMethod(iminPaperCutter);
    channel.invokeMethod(iminFeed);
  }



   externalPrinterZReport(
      {required NetworkPrinter printer,
        required String time,
        required String employeeCash,
        required String startCash,
        required String expenses,
        required String complains,
        required String cancelled,
        required String ownerCount,
        required String ownerTotal,
      }) {
    printer.setGlobalCodeTable('CP775');
    printer.textEncoded(textEncoder(getUserName()), styles: ConstantStyles.centerBold);
    printer.textEncoded(textEncoder('Logged Out Successfully'), styles: ConstantStyles.center);
    printer.text(time, styles: ConstantStyles.center);
    printer.textEncoded(textEncoder(getBranchName()), styles:ConstantStyles.center);
    printer.emptyLines(2);

    printer.row([
      PosColumn(textEncoded: textEncoder('startCash'.tr()), width: 8, styles: ConstantStyles.leftBold),
      PosColumn(text: startCash, width: 3, styles: ConstantStyles.rightBold),
      PosColumn(text: '', width: 1,),
    ]);

    printer.row([
      PosColumn(textEncoded: textEncoder('expenses'.tr()), width: 8, styles: ConstantStyles.leftBold),
      PosColumn(text: expenses, width: 3, styles: ConstantStyles.rightBold),
      PosColumn(text: ' ', width: 1,),
    ]);
    printer.row([
      PosColumn(
          textEncoded: textEncoder('complains'.tr()), width: 8, styles: ConstantStyles.leftBold),
      PosColumn(text: complains, width: 3, styles: ConstantStyles.rightBold),
      PosColumn(text: ' ', width: 1,),
    ]);
    printer.row([
      PosColumn(textEncoded: textEncoder("ownerOrdersCount".tr()), width: 8, styles: ConstantStyles.leftBold),
      PosColumn(text: ownerCount, width: 3, styles: ConstantStyles.rightBold),
      PosColumn(text: ' ', width: 1,),
    ]);
    printer.row([
      PosColumn(textEncoded: textEncoder("ownerOrdersTotal".tr()), width: 8, styles: ConstantStyles.leftBold),
      PosColumn(text: ownerTotal, width: 3, styles: ConstantStyles.rightBold),
      PosColumn(text: ' ', width: 1,),
    ]);
    printer.row([
      PosColumn(textEncoded: textEncoder('ordersCancelled'.tr()), width: 8, styles: ConstantStyles.leftBold),
      PosColumn(text: cancelled, width: 3, styles: ConstantStyles.rightBold),
      PosColumn(text: ' ', width: 1,),
    ]);
    printer.row([
      PosColumn(
          textEncoded: textEncoder('actualTotalCash'.tr()),
          width: 8,
          styles: ConstantStyles.leftBold),
      PosColumn(
          text: (actualTotalOrders! - double.parse(complains) - double.parse(expenses)).toStringAsFixed(2),
          width: 3, styles: ConstantStyles.rightBold),
      PosColumn(text: ' ', width: 1,),
    ]);
    printer.row([
      PosColumn(
          textEncoded: textEncoder('employeeCash'.tr()),
          width: 8,
          styles: ConstantStyles.leftBold),
      PosColumn(
          text: employeeCash,
          width: 3,
          styles: ConstantStyles.rightBold),
      PosColumn(
        text: ' ',
        width: 1,
      ),
    ]);

    printer.row([
      PosColumn(
          textEncoded: textEncoder('totalCashInTheDrawer'.tr()),
          width: 8,
          styles: ConstantStyles.leftBold),
      PosColumn(
          text:
              '${(double.parse(startCash) + actualTotalOrders! - double.parse(complains) - double.parse(expenses)).toStringAsFixed(2)}',
          width: 3,
          styles: ConstantStyles.rightBold),
      PosColumn(
        text: ' ',
        width: 1,
      ),
    ]);
    printer.hr();
    paymentDetails.forEach((value) {
      bool printSection = false;
      value.keys!.forEach((element) {
        if (int.tryParse(element.value.toString()) != 0) printSection = true;
      });

      if (printSection) {
        printer.textEncoded(textEncoder(value.title!), styles:ConstantStyles.centerBold);
        printer.hr();
        value.keys!.asMap().forEach((i, element) {
          if (i != 2 && i != 4 && i != 5) {
            printer.row([
              PosColumn(
                  textEncoded: textEncoder(element.key!.replaceAll('_', ' ')),
                  width: 9,
                  styles: ConstantStyles.leftBold),
              if (double.tryParse(element.value!.toString()) != null)
                PosColumn(
                    text: element.value!.toStringAsFixed(2),
                    width: 2,
                    styles: ConstantStyles.rightBold),
              PosColumn(
                text: ' ',
                width: 1,
              ),
            ]);
          }
        });
        printer.hr();
      }
    });
    customerDetails.forEach((value) {
     bool printSection = false;
      value.keys!.forEach((element) {
        if (element.value != 0) printSection = true;
      });

      if (printSection) {
        printer.textEncoded(textEncoder(value.title!),
            styles: ConstantStyles.centerBold);
        printer.hr();
        value.keys!.forEach((element) {
          if (element.value != 0) {
            printer.row([
              PosColumn(
                  textEncoded: textEncoder(element.key!.replaceAll('_', ' ')),
                  width: 9,
                  styles: ConstantStyles.leftBold),
              if (double.tryParse(element.value!.toString()) != null)
                PosColumn(
                    text: element.value!.toStringAsFixed(2),
                    width: 2,
                    styles: ConstantStyles.rightBold),
              PosColumn(
                text: ' ',
                width: 1,
              ),
            ]);
          }
        });

        printer.hr();
      }
    });

    printer.row([
      PosColumn(
          textEncoded: textEncoder('totalClients'.tr()),
          width: 8,
          styles: ConstantStyles.leftBold),
      PosColumn(
          text: totalClients.toString(),
          width: 3,
          styles: ConstantStyles.rightBold),
      PosColumn(
        text: ' ',
        width: 1,
      ),
    ]);
    printer.row([
      PosColumn(
          textEncoded: textEncoder('totalOrdersCount'.tr()),
          width: 8,
          styles: ConstantStyles.leftBold),
      PosColumn(
          text: ordersCount.toString(),
          width: 3,
          styles: ConstantStyles.rightBold),
      PosColumn(
        text: ' ',
        width: 1,
      ),
    ]);

    if (totalDiscount != null) {
      printer.row([
        PosColumn(
            textEncoded: textEncoder('totalDiscount'.tr()),
            width: 8,
            styles: ConstantStyles.leftBold),
        PosColumn(
            text: totalDiscount!.toStringAsFixed(2),
            width: 3,
            styles: ConstantStyles.rightBold),
        PosColumn(
          text: ' ',
          width: 1,
        ),
      ]);
    }

    if (totalTax != null) {
      printer.row([
        PosColumn(
            textEncoded: textEncoder('totalTax'.tr()),
            width: 8,
            styles: ConstantStyles.leftBold),
        PosColumn(
            text: totalTax!.toStringAsFixed(2),
            width: 3,
            styles: ConstantStyles.rightBold),
        PosColumn(
          text: ' ',
          width: 1,
        ),
      ]);
    }

    printer.hr();
    printer.row([
      PosColumn(
          textEncoded: textEncoder('totalAllOrders'.tr()),
          width: 8,
          styles: ConstantStyles.leftBold),
      PosColumn(
          text: actualTotalOrders.toString(),
          width: 3,
          styles: ConstantStyles.rightBold),
      PosColumn(
        text: ' ',
        width: 1,
      ),
    ]);

    printer.feed(2);
    printer.cut();
  }

  internalPrinterZReport(
      {required String time,
        required String employeeCash,
        required String startCash,
        required String expenses,
        required  String complains,
        required  String cancelled,
        required String ownerCount,
        required String ownerTotal,
  }) {
    channel.invokeMethod("sdkInit");

    channel.invokeMethod(iminPrintText, iminPrintTextChannel(text: getUserName()));
    channel.invokeMethod(iminPrintText, iminPrintTextChannel(text: 'loggedOutSuccessfully'.tr()));
    channel.invokeMethod(iminPrintText, iminPrintTextChannel(text: time));
    channel.invokeMethod(iminPrintText, iminPrintTextChannel(text: getBranchName()));
    channel.invokeMethod(iminFeed);
    channel.invokeMethod(iminPrintText, iminPrintTextChannel(text: '${'startCash'.tr()} :  $startCash',alignment: '0'));
    channel.invokeMethod(iminPrintText, iminPrintTextChannel(text: '${'expenses'.tr()} :  $expenses',alignment: '0'));
    channel.invokeMethod(iminPrintText, iminPrintTextChannel(text: '${'complains'.tr()} :  $complains',alignment: '0'));
    channel.invokeMethod(iminPrintText, iminPrintTextChannel(text: '${'ownerOrdersCount'.tr()} :  $ownerCount',alignment: '0'));
    channel.invokeMethod(iminPrintText, iminPrintTextChannel(text: '${'ordersCancelled'.tr()} :  $cancelled',alignment: '0'));
    channel.invokeMethod(iminPrintText, iminPrintTextChannel(
        text: '${'actualTotalCash'.tr()} :  ${(actualTotalOrders! - double.parse(complains) - double.parse(expenses)).toStringAsFixed(2)}',
        alignment: '0'));

    channel.invokeMethod(iminPrintText, iminPrintTextChannel(text: '${'employeeCash'.tr()} :  ${employeeCash}',alignment: '0'));
    channel.invokeMethod(iminPrintText, iminPrintTextChannel(text:
    '${'totalCashInTheDrawer'.tr()} :  ${(double.parse(startCash) + actualTotalOrders! - double.parse(complains) - double.parse(expenses)).toStringAsFixed(2)}',
        alignment: '0'));
    channel.invokeMethod(iminPrintText, iminPrintTextChannel(text: '${'employeeCash'.tr()} :  ${employeeCash}',alignment: '0'));
    channel.invokeMethod(iminPrintText, iminPrintTextChannel(text: '${'employeeCash'.tr()} :  ${employeeCash}',alignment: '0'));
    channel.invokeMethod(iminPrintText, iminPrintTextChannel(text: '${'employeeCash'.tr()} :  ${employeeCash}',alignment: '0'));
    iminPrintDividerChannel();

    paymentDetails.forEach((value) {
      bool printSection = false;
      value.keys!.forEach((element) {
        if (element.value != 0) printSection = true;
      });

      if (printSection) {
        channel.invokeMethod(iminPrintText, iminPrintTextChannel(text:  value.title!,fontSize: '32'));
      iminPrintDividerChannel();

        value.keys!.asMap().forEach((i, element) {
          if (i != 2 && i != 4 && i != 5) {
            channel.invokeMethod(iminPrintText, iminPrintTextChannel(text: '${element.key!.replaceAll('_', ' ')} :  ' +
                element.value!.toStringAsFixed(2), alignment: '0'));
          }
        });
        iminPrintDividerChannel();
      }
    });

    customerDetails.forEach((value) {
      bool printSection = false;
      value.keys!.forEach((element) {
        if (element.value != 0) printSection = true;
      });

      if (printSection) {
        channel.invokeMethod(iminPrintText, iminPrintTextChannel(text:  value.title!,fontSize: '32'));
        iminPrintDividerChannel();

        value.keys!.asMap().forEach((i, element) {
          if (i != 2 && i != 4 && i != 5) {
            channel.invokeMethod(iminPrintText, iminPrintTextChannel(text: '${element.key!.replaceAll('_', ' ')} :  ' +
                element.value!.toStringAsFixed(2), alignment: '0'));
          }
        });
        iminPrintDividerChannel();
      }
    });

    channel.invokeMethod(iminPrintText, iminPrintTextChannel(text: '${'totalClients'.tr()} :  $totalClients',alignment: '0'));
    channel.invokeMethod(iminPrintText,
        iminPrintTextChannel(text: '${'totalOrdersCount'.tr()} :  $ordersCount',alignment: '0'));
    channel.invokeMethod(iminPrintText,
        iminPrintTextChannel(text: '${'totalOrdersCount'.tr()} :  $ordersCount',alignment: '0'));

    if (totalDiscount != null) {
      channel.invokeMethod(
          iminPrintText,
          iminPrintTextChannel(
              text:
                  '${'totalDiscount'.tr()} :  ${totalDiscount!.toStringAsFixed(2)}',
              alignment: '0'));
    }
    if (totalTax != null) {
      channel.invokeMethod(
          iminPrintText,
          iminPrintTextChannel(
              text: '${'totalTax'.tr()} :  ${totalTax!.toStringAsFixed(2)}',
              alignment: '0'));
    }
    channel.invokeMethod(
        iminPrintText,
        iminPrintTextChannel(
            text: '${'totalAllOrders'.tr()} :  $actualTotalOrders',
            alignment: '0'));
    iminPrintDividerChannel();
    channel.invokeMethod(iminFeed);
    channel.invokeMethod(iminFeed);
    channel.invokeMethod(iminFeed);
    channel.invokeMethod(iminPaperCutter);
    channel.invokeMethod(iminFeed);
  }

  Future testPrint(
      {required String time,
        required String employeeCash,
        required String startCash,
        required  String expenses,
        required String complains,
        required String cancelled,
        required String ownerCount,
        required String ownerTotal,
   }) async {

    internalPrinterZReport(time : time,
        employeeCash:employeeCash,
        startCash:startCash,
        expenses :expenses,
        complains :complains,
        cancelled:cancelled,
        ownerCount:ownerCount,
        ownerTotal: ownerTotal);

    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    printers.forEach((element) async {
      PosPrintResult res = await printer.connect(element.ip!, port: 9100);
      print(element.typeName);
      if (element.typeName == 'CASHIER') {
        if (res == PosPrintResult.success) {
          await externalPrinterZReport(printer :printer,
              time:time, employeeCash : employeeCash, startCash : startCash,
              expenses:expenses, complains:complains, cancelled:cancelled,
              ownerCount:ownerCount, ownerTotal:ownerTotal);

          printer.disconnect();
        }
      } else {
        if (res == PosPrintResult.success) {
          printer.disconnect();
        }
      }
    });

    notifyListeners();
  }


}
