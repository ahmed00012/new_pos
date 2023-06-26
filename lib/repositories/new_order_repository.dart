import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../constants.dart';
import '../local_storage.dart';


class NewOrderRepository {

  // Future getOrderMethods(String token, String language,int branch) async {
  //   var response = await http.get(Uri.parse("${LocalStorage.getData(key: 'baseUrl')}pos/orderMethods/$branch"),
  //       headers: {'AUTHORIZATION': 'Bearer $token', 'Language': language});
  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.body);
  //     return data;
  //   } else {
  //     return false;
  //   }
  // }

  Future getTables(String token, String language, int branch) async {
    var response = await http.get(
        Uri.parse("${Constants.baseURL}branch/$branch/tables"),
        headers: {'AUTHORIZATION': 'Bearer $token', 'Language': language,  'Content-Language':language,});
    log(response.body.toString());
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

  // Future getPaymentMethods(String token, String language) async {
  //   var response = await http.get(
  //       Uri.parse("${LocalStorage.getData(key: 'baseUrl')}pos/paymentMethods"),
  //       headers: {'AUTHORIZATION': 'Bearer $token', 'Language': language});
  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.body);
  //     return data['data'];
  //   } else {
  //     return false;
  //   }
  // }

  Future confirmOrder(String token, String language, Map data) async {

      var response = await http.post(Uri.parse("${Constants.baseURL}pos/orders"),
          headers: {
            'AUTHORIZATION': 'Bearer $token',
            'Language': language,
            "Accept": "application/json",
            'Content-type': 'application/json',
          },
          body: jsonEncode(data));

      var myData = json.decode(response.body);
      return myData;

  }

  Future updateFromOrder(String token,String language,int itemId,Map data) async {

      var response = await http.post(
        Uri.parse("${Constants.baseURL}pos/order/$itemId/updateDetails"),
        body: jsonEncode(data),
        headers: {
          'AUTHORIZATION': 'Bearer $token',
          'Language': language,
          "Accept": "application/json",
          'Content-type': 'application/json',
        },
      );

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

  // Future getCoupons(String token, String language) async {
  //   var response = await http.get(
  //       Uri.parse("${LocalStorage.getData(key: 'baseUrl')}coupons"),
  //       headers: {'AUTHORIZATION': 'Bearer $token', 'Language': language});
  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.body);
  //     return data['data'];
  //   } else {
  //     return false;
  //   }
  // }

  // Future getPrinters(String token,String branch) async {
  //   var response = await http.get(
  //       Uri.parse("${LocalStorage.getData(key: 'baseUrl')}branch/$branch/printers"),
  //       headers: {'AUTHORIZATION': 'Bearer $token'});
  //
  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.body);
  //     return data['data'];
  //   } else {
  //     return false;
  //   }
  // }


  // Future getOwners(String token,String language) async {
  //   var response = await http.get(
  //       Uri.parse("${LocalStorage.getData(key: 'baseUrl')}pos/owners"),
  //       headers: {'AUTHORIZATION': 'Bearer $token','Language': language});
  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.body);
  //     return data['data'];
  //   } else {
  //     return false;
  //   }
  // }

//   Future uploadOfflineOrders(String token,String language , Map data) async {
// print('slsoosos');
//     var response = await http.post(
//         Uri.parse("${LocalStorage.getData(key: 'baseUrl')}offline_orders"),
//         headers: {'AUTHORIZATION': 'Bearer $token','Language': language,
//           "Accept": "application/json",
//           'Content-type': 'application/json',},
//     body: jsonEncode(data));
//     log(response.body.toString()+'sksksk');
//     if (response.statusCode == 200) {
//       var data = json.decode(response.body);
//       return data['data'];
//     } else {
//       return false;
//     }
//   }


  Future searchClient(String token, {String? pattern}) async {
    var response = await http.get(
      Uri.parse("${Constants.baseURL}clients/all"),
      headers:  {'AUTHORIZATION':'Bearer $token'},
    );
    if(response.statusCode==200){
      var data = json.decode(response.body);
      return data['data'];
    }
    else if(response.statusCode == 401){
      return 'unauthorized';
    }
    else {
      return false;
    }
  }


  Future payIntegration(Map dataBody) async {


    String userName = r'MIRAS-KSA\Support';
    // String password = 'Gfp4KYMh3eYwAuFQNBib4RvrJJql35Z90+98jIt8UI8=';
    String password = 'Miras@123321';
    // String basicAuth =
    //     'Basic ' + base64.encode(utf8.encode('$userName:$password'));
String basicAuth =
        'Basic ' +base64Encode(utf8.encode('$userName:$password'));




    var response = await http.post(
        Uri.parse("http://c-miras.dyndns.org:2048/BC140_WS/WS/MIRAS/Codeunit/POSIntegrationV3"),
        headers: {
          "Content-Type": 'text/xml',
          "SoapAction":"SendPOSData",
          'Authorization': basicAuth},

        // body:'<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">\r\n    <Body>\r\n        <SendPOSData xmlns="urn:microsoft-dynamics-schemas/codeunit/POSIntegrationV3">\r\n            <requestTxt>${json.encode(dataBody)}</requestTxt>\r\n            <reponseTxt>[string]</reponseTxt>\r\n        </SendPOSData>\r\n    </Body>\r\n</Envelope>');



        // body:'<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/" xmlns="urn:microsoft-dynamics-schemas/codeunit/POSIntegrationV3">\r\n <Header/> <Body> <SendPOSData> <requestTxt>${json.encode(dataBody)}</requestTxt>\r\n </SendPOSData></Body>\r\n </Envelope>');
// body:'<x:Envelope xmlns:x="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pos="urn:microsoft-dynamics-schemas/codeunit/POSIntegrationV3">\r\n  <x:Header/>\r\n<x:Body>\r\n<pos:SendPOSData><pos:requestTxt>{"OrderDetail":[{"Document No.":"D-00041-Try4","LineNo":"13","Type": "Sale","PostingDate": "2022-11-23","ItemNo": "100-BEF-001","Description":"BEEF BURGER SADIA 1344GRM*6PKT*24PCS/CTN","Unit_of_Measure": "PCS","Quantity": "1","Amount": "5","Payment_Type": "","Customer_No": "","Location_Code": "","Tax": "0",  "Discount": "0","TIP_Amount": "0"},{"Document No.":"D-00041-Try4","LineNo":"12","Type": "Sale","PostingDate": "2022-11-23","ItemNo": "100-BEF-001","Description":"BEEF BURGER SADIA 1344GRM*6PKT*24PCS/CTN","Unit_of_Measure": "PCS","Quantity": "1","Amount": "5","Payment_Type": "","Customer_No": "","Location_Code": "","Tax": "0",  "Discount": "0","TIP_Amount": "0"}]}</pos:requestTxt>\r\n</pos:SendPOSData>\r\n</x:Body>\r\n</x:Envelope>');
body:'<x:Envelope xmlns:x="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pos="urn:microsoft-dynamics-schemas/codeunit/POSIntegrationV3"><x:Header/><x:Body><pos:SendPOSData><pos:requestTxt>${json.encode(dataBody)}</pos:requestTxt><pos:reponseTxt></pos:reponseTxt></pos:SendPOSData></x:Body></x:Envelope>');

    print(response.statusCode);
    print(response.body);
    print(dataBody);
  }
}
