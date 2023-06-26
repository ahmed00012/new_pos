
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shormeh_pos_new_28_11_2022/constants.dart';

import '../local_storage.dart';

class AuthRepository {

  Future loginCashier(Map user,String language) async {
    var response = await http.post(
        Uri.parse("${Constants.baseURL}pos/auth/cashier/login"),body: user,headers: {
    'Language': language,
      'Accept':'application/json'
    });

    // var data = json.decode(response.body);
    // print(data);
    // return data;
    if(response.statusCode ==200 ) {
      var data = json.decode(response.body);
      // print('asdas'+data.toString());
      return data;
    }
    else if(response.statusCode ==401)
      return {'status':false ,'msg': 'Wrong Password'};

    else if(response.statusCode ==403)
      return {'status':false ,'msg': 'This User Logged In From Another Device'};

    else if(response.statusCode ==422)
      return {'status':false ,'msg': 'Wrong Email'};

    else
      return {'status':false ,'msg': 'Bad Connection'};


  }

  Future logoutCashier(String token,String language) async {
    var response = await http.post(
        Uri.parse("${Constants.baseURL}pos/auth/logout"),
      headers:  {'AUTHORIZATION':'Bearer $token','Language': language},);
    if(response.statusCode==200) {
      var data = json.decode(response.body);
      return data;
    }
    if(response.statusCode==401) {

      return 'unauthorized';
    }
    else {
      return false;
    }
  }

  Future productsZReport(String token,String loginDate) async {
    var response = await http.post(
        Uri.parse("${Constants.baseURL}productsZReport"),
      body: {'login_date':loginDate, 'logout_date': DateTime.now().toUtc().toString()},
      headers:  {'AUTHORIZATION':'Bearer $token'},);
    if(response.statusCode==200) {
      var data = json.decode(response.body);
      return data['data'];
    }
    if(response.statusCode==401) {

      return 'unauthorized';
    }
    else {
      return false;
    }
  }

  Future cashIn(Map cash,String token) async {

    var response = await http.post(
        Uri.parse("${Constants.baseURL}finance"),body: cash,headers: {'AUTHORIZATION':'Bearer $token',});
    print(response.body);
      var data = json.decode(response.body);
      return data;

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