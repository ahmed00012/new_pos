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
import 'package:shormeh_pos_new_28_11_2022/local_storage.dart';
import 'package:shormeh_pos_new_28_11_2022/models/payment_details_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/printers_model.dart';
import 'package:shormeh_pos_new_28_11_2022/repositories/auth_repository.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/finance.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/home.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/login.dart';
import '../main.dart';
import 'home_controller.dart';

final financeFuture = ChangeNotifierProvider.autoDispose<FinanceController>(
    (ref) => FinanceController());

class FinanceController extends ChangeNotifier {
  List<String> cashIn = [];
  List<String> cashInInit = [];
  double cash = 0.0;
  bool loading = false;
  final AuthRepository _authRepository = AuthRepository();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = true;
  List<PrinterModel> printers = [];
  double? actualTotalOrders = 0.0;
  double? totalTax = 0.0;
  double? totalDiscount = 0.0;
  int? totalClients = 0;
  int ordersCount = 0;
  int ordersNotPaidCount = 0;
  double? actualTotalNotPaidOrders = 0.0;

  String? mailError = '';
  String? passwordError = '';
  List<PaymentDetailsModel> paymentDetails = [];
  List<PaymentDetailsModel> customerDetails = [];

  void loadingSwitch(bool load) {
    loading = load;
    notifyListeners();
  }

  FinanceController() {
    getPrinters();
  }

  seePassword() {
    isVisible = !isVisible;
    notifyListeners();
  }

  addNumberFinanceOut(String e) {
    if (cashIn.length < 6) cashIn.add(e);
    notifyListeners();
  }

  addNumFinanceIn(String e) {
    cashInInit.add(e);
    notifyListeners();
  }

  removeNumberFinanceOut() {
    cashIn.remove(cashIn.last);
    notifyListeners();
  }

  removeNumberFinanceIn() {
    cashInInit.remove(cashInInit.last);
    notifyListeners();
  }

  Future doneButtonCashFinanceIn(BuildContext context) async {
    loadingSwitch(true);
    if (cashInInit.isNotEmpty) {
      var data = await _authRepository.cashIn(
          {'status': '1', 'cash': cashInInit.join().toString()},
          LocalStorage.getData(key: 'token'));
      if (data != false) {
        cashInInit = [];
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
        loadingSwitch(false);
      }
    } else {
      displayToastMessage('cashCanNotBeEmpty'.tr());
      loadingSwitch(false);
    }
    notifyListeners();
  }

  Future logout(BuildContext context) async {
    var data = await _authRepository.logoutCashier(
        LocalStorage.getData(key: 'token'),
        LocalStorage.getData(key: 'language'));
    print(data);
    if (data == 'unauthorized')
      testToken();
    else if (data == false) {
      displayToastMessage('Something wrong');
    } else {
      LocalStorage.removeData(key: 'token');
      LocalStorage.removeData(key: 'branch');
      LocalStorage.removeData(key: 'coupons');
      cashIn = [];
      actualTotalOrders = 0.0;
      totalTax = 0.0;
      totalDiscount = 0.0;
      totalClients = 0;
      ordersCount = 0;
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => Login()), (route) => false);
    }
    loadingSwitch(false);
    notifyListeners();
  }

  testToken() async {
    LocalStorage.removeData(key: 'token');
    LocalStorage.removeData(key: 'branch');
    LocalStorage.removeData(key: 'coupons');
    navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => Login()), (route) => false);
  }

  void login(BuildContext context) async {
    if (phoneController.text.isEmpty) {
      mailError = 'emailRequired'.tr();
    } else {
      mailError = '';
    }
    if (passwordController.text.isEmpty) {
      passwordError = 'passwordRequired'.tr();
    } else if (passwordController.text.isNotEmpty &&
        passwordController.text.length < 6) {
      passwordError = 'passwordShort'.tr();
    } else {
      passwordError = '';
    }
    if (phoneController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        passwordController.text.length >= 6) {
      passwordError = '';
      mailError = '';
      loadingSwitch(true);
      var data = await _authRepository.loginCashier(
          {'email': phoneController.text, 'password': passwordController.text},
          'en');

      if (data['status'] != false) {
        LocalStorage.saveData(
            key: 'token', value: data['data']['access_token']);
        LocalStorage.saveData(
            key: 'username', value: data['data']['employee']['name']);
        LocalStorage.saveData(
            key: 'branch', value: data['data']['employee']['branch_id']);
        LocalStorage.saveData(
            key: 'showMobileOrders',
            value: data['data']['employee']['show_mobile_orders']);
        LocalStorage.saveData(
            key: 'branchCode', value: data['data']['branch_code']);
        LocalStorage.saveData(
            key: 'taxNumber', value: data['data']['tax_number']);
        LocalStorage.saveData(key: 'tax', value: data['data']['tax']);
        LocalStorage.saveData(key: 'branchName', value: data['data']['branch']);
        LocalStorage.saveData(
            key: 'instagram', value: data['data']['web_links']['instagram']);
        LocalStorage.saveData(
            key: 'twitter', value: data['data']['web_links']['twitter']);
        LocalStorage.saveData(key: 'phone', value: data['data']['phone']);
        LocalStorage.saveData(
            key: 'loginDate', value: DateTime.now().toUtc().toString());
        LocalStorage.saveData(key: 'offlineOrdersCount', value: 0);
        phoneController.text = '';
        passwordController.text = '';

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Finance()));
        loadingSwitch(false);
      } else {
        displayToastMessage(data['msg']);
        loadingSwitch(false);
      }
    }
    notifyListeners();
  }

  getPrinters() {
    if (LocalStorage.getData(key: 'printers') != null)
      printers = List<PrinterModel>.from(json
          .decode(LocalStorage.getData(key: 'printers'))
          .map((e) => PrinterModel.fromJson(e)));
    print('printers ${printers.length}');
    notifyListeners();
  }


  Uint8List textEncoder(String word) {
    return Uint8List.fromList(
        Windows1256Codec(allowInvalid: false).encode(word));
  }

  String checkCurrentTimeZone(String time) {
    String year = time.substring(0, 4);
    String month = time.substring(5, 7);
    String day = time.substring(8, 10);
    String minute = time.substring(14, 16);
    String second = time.substring(17, 19);

    int utc = DateTime.now().toUtc().hour;
    int current = DateTime.now().hour;
    int actualTime = current - utc;

    return '${day}-${month}-${year}  ${utc + actualTime}:${minute}:${second}';
  }

  void preparePaymentMethodsData(var data) {
    paymentDetails.clear();
    customerDetails.clear();

    if (LocalStorage.getData(key: 'language') == 'en') {
      data['payment_methods_details'].entries.map((entry) {
        paymentDetails.add(PaymentDetailsModel(
            title: entry.key,
            keys: List<KeyValue>.from(entry.value.entries
                .map((e) => KeyValue(key: e.key, value: e.value)))));
      }).toList();

      data['select_customer_details'].entries.map((entry) {
        customerDetails.add(PaymentDetailsModel(
            title: entry.key,
            keys: List<KeyValue>.from(entry.value.entries
                .map((e) => KeyValue(key: e.key, value: e.value)))));
      }).toList();
    } else {
      data['تفاصيل طرق الدفع'].entries.map((entry) {
        paymentDetails.add(PaymentDetailsModel(
            title: entry.key,
            keys: List<KeyValue>.from(entry.value.entries
                .map((e) => KeyValue(key: e.key, value: e.value)))));
      }).toList();

      data['تفاصيل اختيار عميل'].entries.map((entry) {
        customerDetails.add(PaymentDetailsModel(
            title: entry.key,
            keys: List<KeyValue>.from(entry.value.entries
                .map((e) => KeyValue(key: e.key, value: e.value)))));
      }).toList();
    }
  }

  Future doneButtonCashFinanceOut(
      BuildContext context, bool logoutEmployee) async {
    //
    loadingSwitch(true);

    if (cashIn.isNotEmpty) {
      var data = await _authRepository.cashIn({
        'status': '2',
        'cash': cashIn.join().toString(),
        'login_date': LocalStorage.getData(key: 'loginDate'),
        'logout_date': DateTime.now().toUtc().toString(),
        'lang': LocalStorage.getData(key: 'language')
      }, LocalStorage.getData(key: 'token'));

      if (data['status'] == false) {
        displayToastMessage(data['msg']);
        loadingSwitch(false);
        Navigator.pop(context);
      } else {
        preparePaymentMethodsData(data['data']);
        totalCalculator();

        if (LocalStorage.getData(key: 'language') == 'en') {
          testPrint(
            checkCurrentTimeZone(DateTime.now().toString()),
            double.parse(data['data']['employee_cash'].toString())
                .toStringAsFixed(2),
            double.parse(data['data']['start_cash'].toString())
                .toStringAsFixed(2),
            double.parse(data['data']['expenses'].toString())
                .toStringAsFixed(2),
            double.parse(data['data']['complains'].toString())
                .toStringAsFixed(2),
            data['data']['cancel_orders_count'].toString(),
            data['data']['owner_orders_count'].toString(),
            double.parse(data['data']['owner_orders_total'].toString())
                .toStringAsFixed(2),
          ).then((value) {
            if (logoutEmployee)
              Future.delayed(Duration(seconds: 2), () {
                logout(context);
              });
          });
        } else {
          testPrint(
            checkCurrentTimeZone(DateTime.now().toString()),
            double.parse(data['data']['نهاية الدرج'].toString())
                .toStringAsFixed(2),
            double.parse(data['data']['بداية الدرج'].toString())
                .toStringAsFixed(2),
            double.parse(data['data']['المصاريف'].toString())
                .toStringAsFixed(2),
            double.parse(data['data']['الشكاوي'].toString()).toStringAsFixed(2),
            data['data']['عدد الطلبات الملغية'].toString(),
            data['data']['عدد طلبات الملاك'].toString(),
            double.parse(data['data']['اجمالي طلبات الملاك'].toString())
                .toStringAsFixed(2),
          ).then((value) {
            if (logoutEmployee)
              Future.delayed(Duration(seconds: 2), () {
                logout(context);
              });
          });
        }
      }
    } else {
      displayToastMessage('cashCanNotBeEmpty'.tr());
      loadingSwitch(false);
    }

    notifyListeners();
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
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    var data = await _authRepository.productsZReport(
        LocalStorage.getData(key: 'token'),
        LocalStorage.getData(key: 'loginDate'));

    if (data != false && data != 'unauthorized') {
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
    }

    notifyListeners();
  }

  Future productsZReportReceipt(
      NetworkPrinter printer, List<KeyValue> products) async {
    printer.setGlobalCodeTable('CP775');
    printer.textEncoded(textEncoder(LocalStorage.getData(key: 'username')),
        styles: PosStyles(align: PosAlign.center, bold: true));

    printer.text(checkCurrentTimeZone(DateTime.now().toString()),
        styles: PosStyles(
          align: PosAlign.center,
        ));

    printer.textEncoded(textEncoder(LocalStorage.getData(key: 'branchName')),
        styles: PosStyles(
          align: PosAlign.center,
        ));
    printer.emptyLines(1);

    products.asMap().forEach((index, value) {
      if (value.value != 0) {
        printer.row([
          PosColumn(
              text: value.key!.replaceAll('_', ' '),
              width: 9,
              styles: PosStyles(
                align: PosAlign.left,
                bold: true,
              )),
          PosColumn(
              text: value.value.toString(),
              width: 2,
              styles: PosStyles(align: PosAlign.right, bold: true)),
          PosColumn(
            text: ' ',
            width: 1,
          ),
        ]);
      }
    });

    printer.feed(2);
    printer.cut();
  }

  Future productsZReportReceiptDevice(List<KeyValue> products) async {
    channel.invokeMethod(
        "printText", [LocalStorage.getData(key: 'username'), '30', '1']);
    channel.invokeMethod("printText",
        [checkCurrentTimeZone(DateTime.now().toString()), '30', '1']);
    channel.invokeMethod(
        "printText", [LocalStorage.getData(key: 'branchName'), '30', '1']);
    channel.invokeMethod(
        "printText", [LocalStorage.getData(key: 'username'), '30', '1']);
    channel.invokeMethod("feed");

    products.asMap().forEach((index, value) {
      if (value.value != 0) {
        channel.invokeMethod("printText", [
          value.key!.replaceAll('_', ' ') + ' :  ' + value.value.toString(),
          '30',
          '0'
        ]);
      }
    });

    channel.invokeMethod("feed");
    channel.invokeMethod("feed");
    channel.invokeMethod("feed");
    channel.invokeMethod("paperCutter");
    channel.invokeMethod("feed");
  }

  Future testReceipt(
      NetworkPrinter printer,
      String time,
      String employeeCash,
      String startCash,
      String expenses,
      String complains,
      String cancelled,
      String ownerCount,
      String ownerTotal) async {
    printer.setGlobalCodeTable('CP775');
    printer.textEncoded(textEncoder(LocalStorage.getData(key: 'username')),
        styles: PosStyles(align: PosAlign.center, bold: true));
    printer.textEncoded(textEncoder('Logged Out Successfully'),
        styles: PosStyles(
          align: PosAlign.center,
        ));
    printer.text(time,
        styles: PosStyles(
          align: PosAlign.center,
        ));

    printer.textEncoded(textEncoder(LocalStorage.getData(key: 'branchName')),
        styles: PosStyles(
          align: PosAlign.center,
        ));
    printer.emptyLines(2);

    printer.row([
      PosColumn(
          textEncoded: textEncoder('startCash'.tr()),
          width: 8,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: startCash,
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
        text: '',
        width: 1,
      ),
    ]);

    printer.row([
      PosColumn(
          textEncoded: textEncoder('expenses'.tr()),
          width: 8,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: expenses,
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
        text: ' ',
        width: 1,
      ),
    ]);
    printer.row([
      PosColumn(
          textEncoded: textEncoder('complains'.tr()),
          width: 8,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: complains,
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
        text: ' ',
        width: 1,
      ),
    ]);
    printer.row([
      PosColumn(
          textEncoded: textEncoder("ownerOrdersCount".tr()),
          width: 8,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: ownerCount,
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
        text: ' ',
        width: 1,
      ),
    ]);
    printer.row([
      PosColumn(
          textEncoded: textEncoder("ownerOrdersTotal".tr()),
          width: 8,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: ownerTotal,
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
        text: ' ',
        width: 1,
      ),
    ]);
    printer.row([
      PosColumn(
          textEncoded: textEncoder('ordersCancelled'.tr()),
          width: 8,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: cancelled,
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
        text: ' ',
        width: 1,
      ),
    ]);
    printer.row([
      PosColumn(
          textEncoded: textEncoder('actualTotalCash'.tr()),
          width: 8,
          styles: PosStyles(
            align: PosAlign.left,
            bold: true,
          )),
      PosColumn(
          text: (actualTotalOrders! -
                  double.parse(complains) -
                  double.parse(expenses))
              .toStringAsFixed(2),
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
        text: ' ',
        width: 1,
      ),
    ]);
    printer.row([
      PosColumn(
          textEncoded: textEncoder('employeeCash'.tr()),
          width: 8,
          styles: PosStyles(
            align: PosAlign.left,
            bold: true,
          )),
      PosColumn(
          text: employeeCash,
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
        text: ' ',
        width: 1,
      ),
    ]);

    printer.row([
      PosColumn(
          textEncoded: textEncoder('totalCashInTheDrawer'.tr()),
          width: 8,
          styles: PosStyles(
            align: PosAlign.left,
            bold: true,
          )),
      PosColumn(
          text:
              '${(double.parse(startCash) + actualTotalOrders! - double.parse(complains) - double.parse(expenses)).toStringAsFixed(2)}',
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
        text: ' ',
        width: 1,
      ),
    ]);
    printer.hr();
    paymentDetails.forEach((value) {
      List<int> print = [];
      value.keys!.forEach((element) {
        if (int.tryParse(element.value.toString()) == 0) print.add(0);
        if (int.tryParse(element.value.toString()) != 0) print.add(1);
      });

      if (print.contains(1)) {
        printer.textEncoded(textEncoder(value.title!),
            styles: PosStyles(
              align: PosAlign.center,
              bold: true,
            ));
        printer.hr();
        value.keys!.asMap().forEach((i, element) {
          if (i != 2 && i != 4 && i != 5) {
            printer.row([
              PosColumn(
                  textEncoded: textEncoder(element.key!.replaceAll('_', ' ')),
                  width: 9,
                  styles: PosStyles(
                    align: PosAlign.left,
                    bold: true,
                  )),
              if (double.tryParse(element.value!.toString()) != null)
                PosColumn(
                    text: element.value!.toStringAsFixed(2),
                    width: 2,
                    styles: PosStyles(align: PosAlign.right, bold: true)),
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
      List<int> print = [];
      value.keys!.forEach((element) {
        if (element.value == 0) print.add(0);
        if (element.value != 0) print.add(1);
      });

      if (print.contains(1)) {
        printer.textEncoded(textEncoder(value.title!),
            styles: PosStyles(
              align: PosAlign.center,
              bold: true,
            ));
        printer.hr();
        value.keys!.forEach((element) {
          if (element.value != 0) {
            printer.row([
              PosColumn(
                  textEncoded: textEncoder(element.key!.replaceAll('_', ' ')),
                  width: 9,
                  styles: PosStyles(
                    align: PosAlign.left,
                    bold: true,
                  )),
              if (double.tryParse(element.value!.toString()) != null)
                PosColumn(
                    text: element.value!.toStringAsFixed(2),
                    width: 2,
                    styles: PosStyles(align: PosAlign.right, bold: true)),
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
          styles: PosStyles(
            align: PosAlign.left,
            bold: true,
          )),
      PosColumn(
          text: totalClients.toString(),
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
        text: ' ',
        width: 1,
      ),
    ]);
    printer.row([
      PosColumn(
          textEncoded: textEncoder('totalOrdersCount'.tr()),
          width: 8,
          styles: PosStyles(
            align: PosAlign.left,
            bold: true,
          )),
      PosColumn(
          text: ordersCount.toString(),
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
        text: ' ',
        width: 1,
      ),
    ]);

    if (totalDiscount != null)
      printer.row([
        PosColumn(
            textEncoded: textEncoder('totalDiscount'.tr()),
            width: 8,
            styles: PosStyles(
              align: PosAlign.left,
              bold: true,
            )),
        PosColumn(
            text: totalDiscount!.toStringAsFixed(2),
            width: 3,
            styles: PosStyles(align: PosAlign.right, bold: true)),
        PosColumn(
          text: ' ',
          width: 1,
        ),
      ]);

    if (totalTax != null)
      printer.row([
        PosColumn(
            textEncoded: textEncoder('totalTax'.tr()),
            width: 8,
            styles: PosStyles(
              align: PosAlign.left,
              bold: true,
            )),
        PosColumn(
            text: totalTax!.toStringAsFixed(2),
            width: 3,
            styles: PosStyles(align: PosAlign.right, bold: true)),
        PosColumn(
          text: ' ',
          width: 1,
        ),
      ]);

    printer.hr();
    printer.row([
      PosColumn(
          textEncoded: textEncoder('totalAllOrders'.tr()),
          width: 8,
          styles: PosStyles(
            align: PosAlign.left,
            bold: true,
          )),
      PosColumn(
          text: actualTotalOrders.toString(),
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
        text: ' ',
        width: 1,
      ),
    ]);

    printer.feed(2);
    printer.cut();
  }

  deviceReceipt(
      String time,
      String employeeCash,
      String startCash,
      String expenses,
      String complains,
      String cancelled,
      String ownerCount,
      String ownerTotal) async {
    channel.invokeMethod("sdkInit");

    channel.invokeMethod(
        "printText", [LocalStorage.getData(key: 'username'), '30', '1']);
    channel
        .invokeMethod("printText", ['loggedOutSuccessfully'.tr(), '30', '1']);
    channel.invokeMethod("printText", [time, '30', '1']);
    channel.invokeMethod(
        "printText", [LocalStorage.getData(key: 'branchName'), '30', '1']);
    channel.invokeMethod("feed");
    channel.invokeMethod(
        "printText", ['${'startCash'.tr()} :  $startCash', '30', '0']);
    channel.invokeMethod(
        "printText", ['${'expenses'.tr()} :  $expenses', '30', '0']);
    channel.invokeMethod(
        "printText", ['${'complains'.tr()} :  $complains', '30', '0']);
    channel.invokeMethod(
        "printText", ['${'ownerOrdersCount'.tr()} :  $ownerCount', '30', '0']);
    channel.invokeMethod(
        "printText", ['${'ownerOrdersTotal'.tr()} :  $ownerTotal', '30', '0']);
    channel.invokeMethod(
        "printText", ['${'ordersCancelled'.tr()} :  $cancelled', '30',  '0']);
    channel.invokeMethod("printText", [
      '${'actualTotalCash'.tr()} :  ${(actualTotalOrders! - double.parse(complains) - double.parse(expenses)).toStringAsFixed(2)}',
      '30',
      '0'
    ]);
    channel.invokeMethod(
        "printText", ['${'employeeCash'.tr()} :  ${employeeCash}', '30', '0']);
    channel.invokeMethod("printText", [
      '${'totalCashInTheDrawer'.tr()} :  ${(double.parse(startCash) + actualTotalOrders! - double.parse(complains) - double.parse(expenses)).toStringAsFixed(2)}',
      '30',
      '0'
    ]);
    channel.invokeMethod(
        "printText", ['_____________________________________', '30', '1']);
    paymentDetails.forEach((value) {
      List<int> print = [];
      value.keys!.forEach((element) {
        if (element.value == 0) print.add(0);
        if (element.value != 0) print.add(1);
      });

      if (print.contains(1)) {
        channel.invokeMethod("printText", [value.title!, '32', '1']);
        channel.invokeMethod(
            "printText", ['_____________________________________', '30', '1']);

        value.keys!.asMap().forEach((i, element) {
          if (i != 2 && i != 4 && i != 5) {
            channel.invokeMethod("printText", [
              element.key!.replaceAll('_', ' ') +
                  ' :  ' +
                  element.value!.toStringAsFixed(2),
              '30',
              '0'
            ]);
          }
        });

        channel.invokeMethod(
            "printText", ['_____________________________________', '30', '1']);
      }
    });

    customerDetails.forEach((value) {
      List<int> print = [];
      value.keys!.forEach((element) {
        if (element.value == 0) print.add(0);
        if (element.value != 0) print.add(1);
      });

      if (print.contains(1)) {
        channel.invokeMethod("printText", [value.title!, '32', '1']);
        channel.invokeMethod(
            "printText", ['_____________________________________', '30', '1']);
        value.keys!.forEach((element) {
          if (element.value != 0) {
            channel.invokeMethod("printText", [
              element.key!.replaceAll('_', ' ') +
                  ' :  ' +
                  element.value!.toStringAsFixed(2),
              '30',
              '0'
            ]);
          }
        });

        channel.invokeMethod(
            "printText", ['_____________________________________', '30', '1']);
      }
    });

    channel.invokeMethod(
        "printText", ['${'totalClients'.tr()} :  $totalClients', '30', '0']);
    channel.invokeMethod(
        "printText", ['${'totalOrdersCount'.tr()} :  $ordersCount', '30', '0']);
    if (totalDiscount != null)
      channel.invokeMethod("printText", [
        '${'totalDiscount'.tr()} :  ${totalDiscount!.toStringAsFixed(2)}',
        '30',
        '0'
      ]);
    if (totalTax != null)
      channel.invokeMethod("printText",
          ['${'totalTax'.tr()} :  ${totalTax!.toStringAsFixed(2)}', '30', '0']);
    channel.invokeMethod("printText",
        ['${'totalAllOrders'.tr()} :  $actualTotalOrders', '30', '0']);

    channel.invokeMethod(
        "printText", ['_____________________________________', '30', '1']);

    channel.invokeMethod("feed");
    channel.invokeMethod("feed");
    channel.invokeMethod("feed");
    channel.invokeMethod("paperCutter");
    channel.invokeMethod("feed");
  }

  Future testPrint(
      String time,
      String employeeCash,
      String startCash,
      String expenses,
      String complains,
      String cancelled,
      String ownerCount,
      String ownerTotal) async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    deviceReceipt(time, employeeCash, startCash, expenses, complains, cancelled,
        ownerCount, ownerTotal);
    printers.forEach((element) async {
      PosPrintResult res = await printer.connect(element.ip!, port: 9100);
      print(element.typeName);
      if (element.typeName == 'CASHIER') {
        if (res == PosPrintResult.success) {
          await testReceipt(printer, time, employeeCash, startCash, expenses,
              complains, cancelled, ownerCount, ownerTotal);

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

  void displayToastMessage(var toastMessage) {
    showSimpleNotification(
        Container(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(
              child: Text(
                toastMessage,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
        duration: Duration(seconds: 3),
        elevation: 2,
        background: Colors.red[500]);
  }
}
