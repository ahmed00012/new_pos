import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shormeh_pos_new_28_11_2022/constants/api.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/prefs_utils.dart';

class OrdersRepository {
  Future getOrders(int page,
      {int? orderMethod,
      int? paymentMethod,
      int? orderStatus,
      int? orderId,
      int? customer,
      String? client,
      int? owner,
      required bool mobileOrders}) async {
    try {
      String uri = mobileOrders? ApiEndPoints.MobileOrders : ApiEndPoints.CashierOrders;
      String finalQuery = '';

      Map queries ={
        'order_method_id':orderMethod,
        'payment_method_id':paymentMethod,
        'order_pos_status_id':orderStatus,
        'payment_customer_id':customer,
        'owner_id':owner,
        'client':client,
        'query':orderId
      };


      queries.forEach((key, value) {
        if(value!=null)
          finalQuery = finalQuery+'&${key}=${value}';
      });
      //
      // print('$uri?paginate=15&page=$page$finalQuery&date=${getLoginDate()}');
      // print(getUserToken());
      var response = await http.get(
          Uri.parse("$uri?paginate=15&page=$page$finalQuery&date=${getLoginDate()}"),
          headers: ApiEndPoints.headerWithToken(token:getUserToken() ,language: getLanguage()));

      var data = json.decode(response.body);
      log(data['data'].toString());
      return data;
    } catch (e) {
      return e.toString();
    }
  }

  Future cancelOrder(
      {required int orderID,
        required String notes,
        required  String secretId,
        required  String secretCode,}) async {
    try {
      var response = await http.post(Uri.parse(ApiEndPoints.CancelOrder),
          body: jsonEncode( {
            'order_id': orderID.toString(),
            'notes': notes,
            'secret_id': secretId,
            'secret_code': secretCode,
            'branch_id': getBranch()
          }),
          headers: ApiEndPoints.headerWithToken(token:getUserToken() ,language: getLanguage()));
      var data = json.decode(response.body);
      print(data.toString());
      return data;
    } catch (e) {
      return e.toString();
    }
  }

  Future complainOrder({
    required int orderID,
    required String secretId,
    required String secretCode,
    String? reason,
    required int reasonId,
    String? mobile,
  }) async {
    try {
      var response = await http.post(
          Uri.parse("${ApiEndPoints.ComplainOrder}$orderID/complain"),
          body: {
            'notes': reason,
            'secret_id': secretId,
            'secret_code': secretCode,
            'complain_reason_id': reasonId,
            'phone': mobile
          },
          headers: ApiEndPoints.headerWithToken(token:getUserToken() ,language: getLanguage()));
      var data = json.decode(response.body);
      return data;
    } catch (e) {
      return e.toString();
    }
  }

  Future getNewMobileOrdersCount() async {
    try {
      var response = await http.get(
        Uri.parse(ApiEndPoints.MobileOrdersCount),
        headers: ApiEndPoints.headerWithToken(token:getUserToken() ,language: getLanguage()),
      );
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        return data;
      }
    } catch (e) {
      return e.toString();
    }
  }


  Future cancelOrderMobile(
      {required int orderID,
      String? notes,
        required String secretId,
        required String secretCode,
     }) async {
    try {
      var response = await http.post(Uri.parse(ApiEndPoints.CancelMobileOrder),
          body: {
            'order_id': orderID.toString(),
            'notes': notes,
            'secret_id': secretId,
            'secret_code': secretCode,
            'branch_id': getBranch()
          },
          headers: ApiEndPoints.headerWithToken(token:getUserToken() ,language: getLanguage()));
      var data = json.decode(response.body);

      return data;
    } catch (e) {
      return e.toString();
    }
  }

  Future acceptOrder(int orderID) async {
    try {
      var response = await http.post(Uri.parse(ApiEndPoints.AcceptMobileOrder),
          body: {
            'order_id': orderID.toString(),
          },
          headers: ApiEndPoints.headerWithToken(token:getUserToken() ,language: getLanguage()));

      var data = json.decode(response.body);

      return data;
    } catch (e) {
      return e.toString();
    }
  }

}
