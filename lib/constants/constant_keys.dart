

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/prefs_utils.dart';

const String kLanguage ='language';
const String kToken ='token';
const String kPaymentMethods ='paymentMethods';
const String kOwners ='owners';
const String kCoupons ='coupons';
const String kBranch ='branch';
const String kOrderMethods ='orderMethods';
const String kReasons ='reasons';
const String kOrderStatus ='orderStatus';
const String kPrinters ='printers';
const String kOptions ='options';
const String kPaymentCustomers ='paymentCustomers';
const String kCategoriesId ='categoriesId';
const String kAllCategories ='allCategories';
const String kProductsId ='productsId';
const String kProducts ='products';
const String kProductDetails ='productDetails';

const String kUserName ='username';
const String kShowMobileOrders ='showMobileOrders';
const String kBranchCode ='branchCode';
const String kTaxNumber ='taxNumber';
const String kTax ='tax';
const String kBranchName ='branchName';
const String kInstagram ='instagram';
const String kTwitter ='twitter';
const String kPhone ='phone';
const String kLoginDate ='loginDate';
const String kOfflineOrdersCount ='offlineOrdersCount';
const String kMobileOrdersCount ='mobileOrdersCount';

const String iminPrintText ='printText';
const String iminFeed ='feed';
const String iminPaperCutter ='paperCutter';
const String iminShowImage ='showImage';
const String iminPrintBitmap ='printBitmap';
const String iminPrintQr ='printQr';



const String pusherCluster ='us2';
const String pusherAppKey ='084bdc917e1b8a627bc8';
String pusherGetOrderCountChannel ='create_order_from_phone_${getBranch()}';
 String pusherAcceptCancelOrderChannel ='accept_cancel_order_${getBranch()}';
const String pusherAcceptCancelEvent ='Modules\\Order\\Events\\AcceptCancelMobileOrder';
const String pusherGetOrderCountEvent ='Modules\\Order\\Events\\CreateOrderFromPhone';




// const String userNamePayIntegration = r'MIRAS-kSA\Support';
// const String passwordPayIntegration = 'Miras@123321';
 String basicAuth = 'Basic ${base64Encode(utf8.encode('${r'MIRAS-kSA\Support'}:Miras@123321'))}';
const MethodChannel channel = MethodChannel('com.imin.printersdk');