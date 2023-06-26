import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../local_storage.dart';


class ProductsRepo {

  //String branchID, String token
  // Future getAllCategories(int branchID, String token,String language) async {
  //
  //   var response = await http.get(
  //     Uri.parse("${LocalStorage.getData(key: 'baseUrl')}branch/$branchID/categories"),
  //   headers:  {'AUTHORIZATION':'Bearer $token','Language':language},
  //   );
  //
  //   if(response.statusCode==200){
  //     var data = json.decode(response.body);
  //     return data;
  //   }
  //   else return false;
  //
  // }

  // Future getCustomers(String token, String language) async {
  //   var response = await http.get(
  //       Uri.parse("${LocalStorage.getData(key: 'baseUrl')}paymentCustomers"),
  //       headers: {'AUTHORIZATION': 'Bearer $token', 'Language': language});
  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.body);
  //     return data['data'];
  //   } else {
  //     return false;
  //   }
  // }

  // Future getAllProducts(int branchID,String category, String token,String language) async {
  //   var response = await http.get(
  //     Uri.parse("${LocalStorage.getData(key: 'baseUrl')}branch/$branchID/category/$category/products"),
  //     headers:  {'AUTHORIZATION':'Bearer $token','Language':language},
  //   );
  //   if(response.statusCode==200){
  //     var data = json.decode(response.body);
  //     return data['data'];
  //   }
  //   else return false;
  // }


  // Future getDetails(int id,String token,String language) async {
  //   var response = await http.get(
  //     Uri.parse("${Constants.baseURL}product/$id/details"),
  //     headers:  {'AUTHORIZATION':'Bearer $token','Language': language},
  //   );
  //   if(response.statusCode==200){
  //     var data = json.decode(response.body);
  //     return data['data'];
  //   }
  //   else return false;
  // }


  // Future getNotes(String token,String language) async {
  //   var response = await http.get(
  //     Uri.parse("${LocalStorage.getData(key: 'baseUrl')}notes"),
  //     headers:  {'AUTHORIZATION':'Bearer $token','Language': language},
  //   );
  //   if(response.statusCode==200){
  //     var data = json.decode(response.body);
  //     return data['data'];
  //   }
  //   else return false;
  // }

  Future deleteFromOrder(String token,String language,int itemId) async {
    print(token);
    var response = await http.post(
      Uri.parse("${Constants.baseURL}pos/order/deleteDetails/$itemId"),
      headers:  {'AUTHORIZATION':'Bearer $token','Language': language},
    );

    if(response.statusCode==200){
      var data = json.decode(response.body);
      return data;
    }
    else return false;

  }


  Future expense(String token,String language,Map data) async {
    var response = await http.post(
      Uri.parse("${Constants.baseURL}expense"),
      body: jsonEncode(data),
      headers:  {'AUTHORIZATION':'Bearer $token','Language': language,
        "Accept": "application/json",
        'Content-type': 'application/json'},
    );
    print(response.body);
    if(response.statusCode==200){
      var data = json.decode(response.body);
      return data;
    }
    else return false;
  }


  Future searchClient(String token,String query) async {
    // String pattern
    // ?query=$pattern
    var response = await http.get(
      Uri.parse("${Constants.baseURL}clients/all?query=$query"),
      headers:  {'AUTHORIZATION':'Bearer $token',
      'Accept':'application/json'},
    );
    print(response.body);
    if(response.statusCode==200){
      var data = json.decode(response.body);
      return data['data'];
    }
    else return false;
  }

  Future getNewMobileOrders(String token,) async {
    // String pattern
    // ?query=$pattern
    var response = await http.get(
      Uri.parse("${Constants.baseURL}pos/cashierMobileOrdersCount"),
      headers:  {'AUTHORIZATION':'Bearer $token',
        'Language': LocalStorage.getData(key: 'language'),
        'Accept':'application/json'},
    );
    print(response.body);
    if(response.statusCode==200){
      var data = json.decode(response.body);
      return data['data'];
    }
    else return false;
  }

  Future getSecondScreenPicture() async {
    // String pattern
    // ?query=$pattern
    var response = await http.get(
      Uri.parse("${Constants.baseURL}branch-screen-images?screen_number=1"),
      headers:  {'AUTHORIZATION':'Bearer ${LocalStorage.getData(key: 'token')}',
        'Language': LocalStorage.getData(key: 'language'),
        'Accept':'application/json'},
    );
    print(response.body);
    if(response.statusCode==200){
      var data = json.decode(response.body);
      return data['data'];
    }
    else return false;
  }

  // Future getReasons(String token, String language) async {
  //   var response = await http.get(
  //       Uri.parse("${LocalStorage.getData(key: 'baseUrl')}complainReasons"),
  //       headers: {'AUTHORIZATION': 'Bearer $token', 'Language': language});
  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.body);
  //     return data['data'];
  //   } else {
  //     return false;
  //   }
  // }


  Future syncOrders()async{
    var response =
   await http.get(Uri.parse('http://192.168.1.11:8000/api/sync'));
    print(response.body.toString());
  }

  // Future getOrderStatus(String token, String language) async {
  //   var response = await http.get(Uri.parse("${LocalStorage.getData(key: 'baseUrl')}orderStatus"),
  //       headers: {'AUTHORIZATION': 'Bearer $token', 'Language': language});
  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.body);
  //     return data['data'];
  //   } else {
  //     return false;
  //   }
  // }

}