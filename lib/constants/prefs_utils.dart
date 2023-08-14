
import 'dart:async';

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

setOrderStatusPosPrefs(String orderStatusPos) {
  LocalStorage.saveData(
    key: kOrderStatusPos,
    value: orderStatusPos,
  );
}
getOrderStatusPosPrefs() {
  return LocalStorage.getData(key: kOrderStatusPos) ?? '';
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

setCategoriesIdPrefs(List<String> categoriesId) {
  LocalStorage.saveList(key: kCategoriesId, value: categoriesId);
}

List<String >getCategoriesIdPrefs() {
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

setProductsIdPrefs(List<String> productsId) {
  LocalStorage.saveList(key: kProductsId, value: productsId);
}

List<String> getProductsIdPrefs() {
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

getUpdateStatusPermission() {
  return LocalStorage.getData(key: kUserUpdateStatus) ?? 0;
}

syncAppData() {
  LocalStorage.removeData(key: kPaymentMethods);
  LocalStorage.removeData(key: kOwners);
  LocalStorage.removeData(key: kCoupons);
  LocalStorage.removeData(key: kOrderMethods);
  LocalStorage.removeData(key: kReasons);
  LocalStorage.removeData(key: kPrinters);
  LocalStorage.removeData(key: kOrderStatus);
  LocalStorage.removeData(key: kOrderStatusPos);
  LocalStorage.removeData(key: kOptions);
  LocalStorage.removeData(key: kPaymentCustomers);
  LocalStorage.removeData(key: kAllCategories);
  if(LocalStorage.getList(key: kCategoriesId)!=null)
  LocalStorage.getList(key: kCategoriesId).forEach((element) {
    LocalStorage.removeData(key: '$kProducts$element');
  });
  if(LocalStorage.getList(key: kProductsId)!=null)
  LocalStorage.getList(key: kProductsId).forEach((element) {
    LocalStorage.removeData(key: '$kProductDetails$element');
  });
  LocalStorage.removeData(key: kCategoriesId);
  LocalStorage.removeData(key: kProductsId);
}

setUserData(UserModel user) {
  setUserToken(user.accessToken!);
  setBranch(user.employee!.branchId!);
  LocalStorage.saveData(
    key: kUserName,
    value: user.employee!.name,
  );


  LocalStorage.saveData(
    key: kUserUpdateStatus,
    value: user.employee!.isUpdateStatus,
  );


  LocalStorage.saveData(
    key: kShowMobileOrders,
    value: user.employee!.showMobileOrders,
  );
  LocalStorage.saveData(
    key: kBranchCode??'',
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



