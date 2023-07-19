
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shormeh_pos_new_28_11_2022/constants/api.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/colors.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/utils.dart';

import '../local_storage.dart';

class AuthRepository {

  Future loginCashier({required String email , required String password}) async {
    try{
    var response = await http.post(Uri.parse(ApiEndPoints.Login),
        body: {'email': email, 'password': password},
        headers: ApiEndPoints.headerWithoutToken);
    var data = json.decode(response.body);
    debugPrint(data);
    return data;
    }
    catch(e){
      return e.toString();
    }
    // if(response.statusCode ==200 ) {
    //   var data = json.decode(response.body);
    //   // print('asdas'+data.toString());
    //   return data;
    // }
    // else if(response.statusCode ==401)
    //   return {'status':false ,'msg': 'Wrong Password'};
    //
    // else if(response.statusCode ==403)
    //   return {'status':false ,'msg': 'This User Logged In From Another Device'};
    //
    // else if(response.statusCode ==422)
    //   return {'status':false ,'msg': 'Wrong Email'};
    //
    // else
    //   return {'status':false ,'msg': 'Bad Connection'};


  }

  Future logoutCashier() async {
    try{
      var response = await http.post(Uri.parse(ApiEndPoints.Logout),
        headers:  ApiEndPoints.headerWithToken,);
      // if(response.statusCode==200) {
      var data = json.decode(response.body);
      return data;
    }
    catch(e){
      return e.toString();
    }

    // var response = await http.post(Uri.parse(ApiEndPoints.Logout),
    //   headers:  {'AUTHORIZATION':'Bearer $token','Language': language},);
    // // if(response.statusCode==200) {
    //   var data = json.decode(response.body);
    //   return data;
    // }
    // if(response.statusCode==401) {
    //
    //   return 'unauthorized';
    // }
    // else {
    //   return false;
    // }
  }

  Future productsZReport() async {
    try{
    var response = await http.post(Uri.parse(ApiEndPoints.ProductsZReport),
      body: {'login_date':getLoginDate(), 'logout_date': DateTime.now().toUtc().toString()},
      headers:  ApiEndPoints.headerWithToken,);
    var data = json.decode(response.body);
    return data;
    }
    catch (e){
      return e.toString();
    }
    // if(response.statusCode==200) {
    //   var data = json.decode(response.body);
    //   return data['data'];
    // }
    // if(response.statusCode==401) {
    //
    //   return 'unauthorized';
    // }
    // else {
    //   return false;
    // }
  }

  Future startShiftCash({required String cash}) async {
    try{
      var response = await http.post(Uri.parse(ApiEndPoints.StartCash),
          body: {'status':  '1', 'cash': cash},
          headers: ApiEndPoints.headerWithToken);
      debugPrint(response.body);
      var data = json.decode(response.body);
      return data;
    }
    catch(e){
      return e.toString();
    }
  }

  Future endShiftCash({required String cash}) async {
    try{
      var response = await http.post(Uri.parse(ApiEndPoints.StartCash),
          body: {'status': '2',
            'cash': cash,
            'login_date': getLoginDate(),
            'logout_date': DateTime.now().toUtc().toString(),},
          headers: ApiEndPoints.headerWithToken);
      debugPrint(response.body);
      var data = json.decode(response.body);
      return data;
    }
    catch(e){
      return e.toString();
    }
  }

  // Future getPrinters(String token,String branch) async {
  //   var response = await http.get(
  //       Uri.parse("${LocalStorage.getData(key: 'baseUrl')}branch/$branch/printers"),
  //       headers: {'AUTHORIZATION': 'Bearer $token'});
  //   print(response.body);
  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.body);
  //     return data['data'];
  //   } else {
  //     return false;
  //   }
  // }

}