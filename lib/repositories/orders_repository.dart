import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;


import '../constants.dart';
import '../local_storage.dart';

class OrdersRepository {
  Future getOrders(String token, String language, int page,
      {int? orderMethod,
        int? paymentMethod, int? orderStatus,String? date,int? orderId,int? customer,String? client, int? owner}) async {


      var response = await http.get(
          Uri.parse(
              "${Constants.baseURL}pos/cashierPosOrders?paginate=15&page=$page&order_method_id=${orderMethod ?? ''}&"
              "payment_method_id=${paymentMethod ?? ''}&order_pos_status_id=${orderStatus ?? ''}&date=${date ?? ''}"
              "&query=${orderId ?? ''}&payment_customer_id=${customer ?? ''}&owner_id=${owner ?? ''}&client=$client"),
          headers: {'AUTHORIZATION': 'Bearer $token', 'Language': language,
            'Content-Language':language,
          'Accept':'application/json'});

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        log(data['data'].toString());
        return data['data'];
      } else if(response.statusCode == 401){
        return 'unauthorized';
      }
      else {
        return false;
      }

  }

  // Future getOrderStatus(String token, String language) async {
  //   var response = await http.get(Uri.parse("${LocalStorage.getData(key: 'baseUrl')}pos/orderStatus"),
  //       headers: {'AUTHORIZATION': 'Bearer $token', 'Language': language});
  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.body);
  //     return data['data'];
  //   } else {
  //     return false;
  //   }
  // }


  Future cancelOrder(String token, String language , int orderID,String notes,String secretId,
      String secretCode , String branchId)async{
    var response = await http.post(Uri.parse("${Constants.baseURL}pos/cancelOrder"),

        body: {
      'order_id':orderID.toString(),
          'notes':notes,
          'secret_id':secretId,
          'secret_code':secretCode,
          'branch_id':branchId
        },
        headers: {'AUTHORIZATION': 'Bearer $token', 'Language': language});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return data;
    } else if(response.statusCode == 401){
      return 'unauthorized';
    }
    else {
      return false;
    }
  }

  Future complainOrder(String token, String language , int orderID, Map body)async{
    var response = await http.post(Uri.parse("${Constants.baseURL}pos/order/$orderID/complain"),
        body:jsonEncode(body),
        headers: {'AUTHORIZATION': 'Bearer $token', 'Language': language,
    "Accept": "application/json",
    'Content-type': 'application/json'});
    print(response.body);
    var data = json.decode(response.body);
   return data;
  }
  // Future getCustomers(String token, String language) async {
  //   var response = await http.get(
  //       Uri.parse("${LocalStorage.getData(key: 'baseUrl')}pos/paymentCustomers"),
  //       headers: {'AUTHORIZATION': 'Bearer $token', 'Language': language});
  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.body);
  //     return data['data'];
  //   } else {
  //     return false;
  //   }
  // }

  // Future getReasons(String token, String language) async {
  //   var response = await http.get(
  //       Uri.parse("${LocalStorage.getData(key: 'baseUrl')}pos/complainReasons"),
  //       headers: {'AUTHORIZATION': 'Bearer $token', 'Language': language});
  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.body);
  //     return data['data'];
  //   } else {
  //     return false;
  //   }
  // }



}
