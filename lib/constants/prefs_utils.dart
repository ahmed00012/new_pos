import 'package:flutter/animation.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:shormeh_pos_new_28_11_2022/local_storage.dart';
import '../models/user_model.dart';
import 'constant_keys.dart';

setUserToken(String token) {
  LocalStorage.saveData(
    key: kToken,
    value: token,
  );
}

getUserToken() {
  return LocalStorage.getData(key: kToken) ?? '';
}

setLanguage(String language) {
  LocalStorage.saveData(
    key: kLanguage,
    value: language,
  );
}

getLanguage() {
  return LocalStorage.getData(key: kLanguage) ?? 'en';
}

setBranch(int branch) {
  LocalStorage.saveData(
    key: kBranch,
    value: branch,
  );
}

getBranch() {
  return LocalStorage.getData(key: kBranch) ?? 1;
}
setMobileOrdersCount(int count) {
  LocalStorage.saveData(
    key: kMobileOrdersCount,
    value: count,
  );
}

getMobileOrdersCount() {
  return LocalStorage.getData(key: kMobileOrdersCount) ?? 0;
}

setPaymentMethodsPrefs(String paymentMethods) {
  LocalStorage.saveData(
    key: kPaymentMethods,
    value: paymentMethods,
  );
}

getPaymentMethodsPrefs() {
  return LocalStorage.getData(key: kPaymentMethods) ?? '';
}

setOwnersPrefs(String owners) {
  LocalStorage.saveData(
    key: kOwners,
    value: owners,
  );
}

getOwnersPrefs() {
  return LocalStorage.getData(key: kOwners) ?? '';
}

setCouponsPrefs(String coupons) {
  LocalStorage.saveData(
    key: kCoupons,
    value: coupons,
  );
}

getCouponsPrefs() {
  return LocalStorage.getData(key: kCoupons) ?? '';
}

setOrderMethodsPrefs(String orderMethods) {
  LocalStorage.saveData(
    key: kOrderMethods,
    value: orderMethods,
  );
}

getOrderMethodsPrefs() {
  return LocalStorage.getData(key: kOrderMethods) ?? '';
}

setComplainReasonsPrefs(String reasons) {
  LocalStorage.saveData(
    key: kReasons,
    value: reasons,
  );
}

getComplainReasonsPrefs() {
  return LocalStorage.getData(key: kReasons) ?? '';
}

setOrderStatusPrefs(String orderStatus) {
  LocalStorage.saveData(
    key: kOrderStatus,
    value: orderStatus,
  );
}

getOrderStatusPrefs() {
  return LocalStorage.getData(key: kOrderStatus) ?? '';
}

setPrintersPrefs(String printers) {
  LocalStorage.saveData(
    key: kPrinters,
    value: printers,
  );
}

getPrintersPrefs() {
  return LocalStorage.getData(key: kPrinters) ?? '';
}

setPaymentCustomersPrefs(String paymentCustomers) {
  LocalStorage.saveData(
    key: kPaymentCustomers,
    value: paymentCustomers,
  );
}

getPaymentCustomersPrefs() {
  return LocalStorage.getData(key: kPaymentCustomers) ?? '';
}

setCategoriesIdPrefs(List categoriesId) {
  LocalStorage.saveList(key: kCategoriesId, value: categoriesId);
}

getCategoriesIdPrefs() {
  return LocalStorage.getList(key: kCategoriesId) ?? [];
}

setAllCategoriesPrefs(String allCategories) {
  LocalStorage.saveData(
    key: kAllCategories,
    value: allCategories,
  );
}

getAllCategoriesPrefs() {
  return LocalStorage.getData(key: kAllCategories) ?? '';
}

setProductsIdPrefs(List productsId) {
  LocalStorage.saveList(key: kProductsId, value: productsId);
}

getProductsIdPrefs() {
  return LocalStorage.getList(key: kProductsId) ?? [];
}

setProductsPrefs(String products, int id) {
  LocalStorage.saveData(
    key: '$kProducts$id',
    value: products,
  );
}

getProductsPrefs(int id) {
  return LocalStorage.getData(key: '$kProducts$id') ?? '';
}

setProductDetailsPrefs(String productDetails, int id) {
  LocalStorage.saveData(
    key: '$kProductDetails$id',
    value: productDetails,
  );
}

getProductDetailsPrefs(int id) {
  return LocalStorage.getData(key: '$kProductDetails$id') ?? '';
}

setOptionsPrefs(String options) {
  LocalStorage.saveData(
    key: kOptions,
    value: options,
  );
}

getOptionsPrefs() {
  return LocalStorage.getData(key: kOptions) ?? '';
}

getUserName() {
  return LocalStorage.getData(key: kUserName) ?? '';
}

getShowMobileOrders() {
  return LocalStorage.getData(key: kShowMobileOrders) ?? false;
}

getBranchCode() {
  return LocalStorage.getData(key: kBranchCode) ?? '';
}

getTaxNumber() {
  return LocalStorage.getData(key: kTaxNumber) ?? '';
}

getTax() {
  return LocalStorage.getData(key: kTax) ?? 0.0;
}

getBranchName() {
  return LocalStorage.getData(key: kBranchName) ?? '';
}

getInstagram() {
  return LocalStorage.getData(key: kInstagram) ?? '';
}

getTwitter() {
  return LocalStorage.getData(key: kTwitter) ?? '';
}

getPhone() {
  return LocalStorage.getData(key: kPhone) ?? '';
}

getLoginDate() {
  return LocalStorage.getData(key: kLoginDate) ?? '';
}

syncAppData() {
  LocalStorage.removeData(key: kPaymentMethods);
  LocalStorage.removeData(key: kOwners);
  LocalStorage.removeData(key: kCoupons);
  LocalStorage.removeData(key: kOrderMethods);
  LocalStorage.removeData(key: kReasons);
  LocalStorage.removeData(key: kPrinters);
  LocalStorage.removeData(key: kOptions);
  LocalStorage.removeData(key: kPaymentCustomers);
  LocalStorage.removeData(key: kAllCategories);
  LocalStorage.getList(key: kCategoriesId).forEach((element) {
    LocalStorage.removeData(key: '$kProducts$element');
  });
  LocalStorage.getList(key: kProductsId).forEach((element) {
    LocalStorage.removeData(key: '$kProductDetails$element');
  });
  LocalStorage.removeData(key: kCategoriesId);
  LocalStorage.removeData(key: kProductsId);
}

setUserData(UserModel user) {
  print(user.toJson().toString());
  setUserToken(user.accessToken!);
  setBranch(user.employee!.branchId!);
  LocalStorage.saveData(
    key: kUserName,
    value: user.employee!.name,
  );
  LocalStorage.saveData(
    key: kShowMobileOrders,
    value: user.employee!.showMobileOrders,
  );
  LocalStorage.saveData(
    key: kBranchCode,
    value: user.branchCode,
  );
  LocalStorage.saveData(
    key: kTaxNumber,
    value: user.taxNumber,
  );
  LocalStorage.saveData(
    key: kTax,
    value: user.tax,
  );
  LocalStorage.saveData(
    key: kBranchName,
    value: user.branch,
  );
  LocalStorage.saveData(
    key: kInstagram,
    value: user.webLinks!.instagram,
  );
  LocalStorage.saveData(
    key: kTwitter,
    value: user.webLinks!.twitter,
  );
  LocalStorage.saveData(
    key: kPhone,
    value: user.phone,
  );
  LocalStorage.saveData(
      key: kLoginDate, value: DateTime.now().toUtc().toString());
  LocalStorage.saveData(key: kOfflineOrdersCount, value: 0);
}

initializePusher(
    {required String channel,
    required String event,
    required Future function}) {
  PusherEvent? data;
  PusherOptions options = PusherOptions(
    cluster: pusherCluster,
  );
  PusherClient pusher = PusherClient(pusherAppKey, options,
      autoConnect: true, enableLogging: true);

  pusher.connect().then((value) {
    Channel pusherChannel = pusher.subscribe(channel);
    pusherChannel.bind(event, (PusherEvent? event) {
       function;
      data = event!;
    });
  });
  return data;
}
