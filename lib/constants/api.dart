import 'package:shormeh_pos_new_28_11_2022/constants/prefs_utils.dart';

import 'constant_keys.dart';

class ApiEndPoints{

  static Map<String,String> headerWithoutToken ({String ?language}) => {
  'Accept':'application/json',
    "Accept-Language": language ?? 'en',
  };

  static Map<String,String> headerWithToken({required String token,required String language}) => {
    'Content-Type': 'application/json',
    "Accept-Language": language,
    'AUTHORIZATION':'Bearer $token',
    'Content-Language':getLanguage(),
    'Accept':'application/json'
  };

  static Map<String,String> payIntegrationHeader =
  {
    "Content-Type": 'text/xml',
    "SoapAction":"SendPOSData",
    'Authorization': basicAuth };


  static const String baseURL =  'https://beta2.poss.app/api/';
  static String Login =  '${baseURL}pos/auth/cashier/login';
  static String Logout =  '${baseURL}pos/auth/logout';
  static String StartCash =  '${baseURL}finance';
  static String ProductsZReport =  '${baseURL}productsZReport';
  static String PaymentMethods =  '${baseURL}pos/paymentMethods';
  static String Owners =  '${baseURL}pos/owners';
  static String Coupons =  '${baseURL}coupons';
  static String OrderMethods =  '${baseURL}pos/orderMethods/';
  static String ComplainReasons =  '${baseURL}pos/complainReasons';
  static String OrderStatusPos =  '${baseURL}pos/orderPosStatus';
  static String OrderStatus =  '${baseURL}pos/orderStatus';
  static String Printers =  '${baseURL}branch/${getBranch()}/printers';
  static String GetNotes =  '${baseURL}pos/notes';
  static String PaymentCustomers =  '${baseURL}pos/paymentCustomers';
  static String GetCategories =  '${baseURL}pos/branch/${getBranch()}/categories';
  static String Products =  '${baseURL}branch/${getBranch()}/category/';
  static String ProductDetails =  '${baseURL}pos/product/';
  static String CashierOrders =  '${baseURL}pos/cashierPosOrders';
  static String CancelOrder=  '${baseURL}pos/cancelOrder';
  static String ComplainOrder=  '${baseURL}pos/order/';
  static String MobileOrders=  '${baseURL}pos/cashierMobileOrders';
  static String MobileOrdersCount=  '${baseURL}pos/cashierMobileOrdersCount';
  static String CancelMobileOrder=  '${baseURL}pos/refuseMobileOrder';
  static String AcceptMobileOrder=  '${baseURL}pos/confirm';
  static String DeleteItemOrder=  '${baseURL}pos/order/deleteDetails/';
  static String Expense =  '${baseURL}expense';
  static String SearchClient =  '${baseURL}clients/all?query=';
  static String ScreenImages =  '${baseURL}branch-screen-images?screen_number=1';
  static String BranchTables =  '${baseURL}branch/${getBranch()}/tables';
  static String ConfirmOrder =  '${baseURL}pos/orders';
  static String EditOrder =  '${baseURL}pos/order/';
  static String EditOrderStatus =  '${baseURL}pos/updateOrderStatus';
  static String GetDrivers =  '${baseURL}driver/getByBranchLocation/${getBranch()}';
  static String PayIntegration =  'http://c-miras.dyndns.org:2048/BC140_WS/WS/MIRAS/Codeunit/POSIntegrationV3';
  static String PayIntegrationClosingTags = '</pos:requestTxt><pos:reponseTxt></pos:reponseTxt></pos:SendPOSData></x:Body></x:Envelope>';
  static String PayIntegrationOpeningTags = '<x:Envelope xmlns:x="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pos="urn:microsoft-dynamics-schemas/codeunit/POSIntegrationV3"><x:Header/><x:Body><pos:SendPOSData><pos:requestTxt>';




}