import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shormeh_pos_new_28_11_2022/constants.dart';

import '../local_storage.dart';

class MobileOrdersRepository {
  Future getOrders(String token, String language, int page,
      {int? orderMethod,
        int? paymentMethod, int? orderStatus,String? date,int? orderId,int? customer,String? client}) async {
    // print(client);

      var response = await http.get(
          Uri.parse(
              "${Constants.baseURL}pos/cashierMobileOrders?paginate=15&page=$page&order_method_id=${orderMethod ?? ''}&"
                  "payment_method_id=${paymentMethod ?? ''}&order_pos_status_id=${orderStatus ?? ''}&date=${date ?? ''}"
                  "&query=${orderId ?? ''}&payment_customer_id=${customer ?? ''}&client=$client"),
          headers: {'AUTHORIZATION': 'Bearer $token', 'Language': language,
            'Content-Language': LocalStorage.getData(key: 'language'),
            'Accept':'application/json'});

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['data'];
      } else if(response.statusCode == 401){
        return 'unauthorized';
      }
    else {
    return false;
    }

  }

  Future getNewMobileOrders(String token,) async {
    // String pattern
    // ?query=$pattern
    var response = await http.get(
      Uri.parse("${Constants.baseURL}pos/cashierMobileOrdersCount"),
      headers:  {'AUTHORIZATION':'Bearer $token',

        'Accept':'application/json'},
    );

    if(response.statusCode==200){
      var data = json.decode(response.body);
      return data['data'];
    }
    else return false;
  }


  Future cancelOrder(String token, String language , int orderID,String notes,String secretId,
      String secretCode , String branchId)async{
    var response = await http.post(Uri.parse("${Constants.baseURL}pos/refuseMobileOrder"),

        body: {
          'order_id':orderID.toString(),
          'notes':notes,
          'secret_id':secretId,
          'secret_code':secretCode,
          'branch_id':branchId
        },
        headers: {'AUTHORIZATION': 'Bearer $token',
          
          'Language': language,'Accept':'application/json'});
    print(response.body.toString()+'slslls');
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


  Future acceptOrder(String token, String language , int orderID)async{


    var response = await http.post(Uri.parse("${Constants.baseURL}pos/confirm"),

        body: {
          'order_id':orderID.toString(),
        },
        headers: {'AUTHORIZATION': 'Bearer $token', 'Language': language,'Accept':'application/json'});

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return data;
    }else if(response.statusCode == 401){
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

    var data = json.decode(response.body);
    return data;
  }



}