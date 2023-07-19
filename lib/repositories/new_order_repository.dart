import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shormeh_pos_new_28_11_2022/constants/api.dart';




class NewOrderRepository {


  Future getTables() async {
    try{
      var response = await http.get(Uri.parse(ApiEndPoints.BranchTables),
          headers: ApiEndPoints.headerWithToken);
      log(response.body.toString());
      var data = json.decode(response.body);
      return data;
    }
    catch(e){
      return e.toString();
    }
  }


  Future confirmOrder(Map data) async {
    try{
      var response = await http.post(Uri.parse(ApiEndPoints.ConfirmOrder),
          headers: ApiEndPoints.headerWithToken, body: jsonEncode(data));
      var myData = json.decode(response.body);
      return myData;
    }
    catch(e){
      return e.toString();
    }
  }

  Future updateFromOrder(int itemId,Map data) async {
    try{
      var response = await http.post(
        Uri.parse("${ApiEndPoints.EditOrder}$itemId/updateDetails"),
        body: jsonEncode(data),
        headers: ApiEndPoints.headerWithToken,
      );
      var encodedResponse = json.decode(response.body);
      return encodedResponse;
    }
    catch(e){
      return e.toString();
    }

  }

  Future searchClient(String query) async {

    try{
      var response = await http.get(
        Uri.parse("${ApiEndPoints.SearchClient}$query"),
        headers: ApiEndPoints.headerWithToken,
      );
      var data = json.decode(response.body);
      return data;
    }
    catch(e){
      return e.toString();
    }
  }


  Future payIntegration(Map dataBody) async {
    var response = await http.post(
        Uri.parse(ApiEndPoints.PayIntegration),
        headers: ApiEndPoints.payIntegrationHeader,
        body:'${ApiEndPoints.PayIntegrationOpeningTags}${json.encode(dataBody)}${ApiEndPoints.PayIntegrationClosingTags}');
    debugPrint(response.statusCode.toString());
    debugPrint(response.body.toString());
    debugPrint(dataBody.toString());
  }
}
