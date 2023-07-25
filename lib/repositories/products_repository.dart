import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shormeh_pos_new_28_11_2022/constants/api.dart';

import '../constants/colors.dart';
import '../constants/prefs_utils.dart';
import '../local_storage.dart';


class ProductsRepo {


  Future deleteFromOrder(int itemId) async {
    try{
      var response = await http.post(
        Uri.parse("${ApiEndPoints.DeleteItemOrder}$itemId"),
        headers: ApiEndPoints.headerWithToken,
      );
      var data = json.decode(response.body);
      return data;
    }
    catch(e){
      return e.toString();
    }
  }


  Future expense(String title , double price) async {
    try{
      var response = await http.post(
        Uri.parse(ApiEndPoints.Expense),
        body: jsonEncode({
          'title': title,
          'price': price,
          'branch_id': getBranch()
        }),
        headers: ApiEndPoints.headerWithToken,
      );
      var data = json.decode(response.body);
      return data;
    }
    catch(e){
      return e;
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

  Future getNewMobileOrdersCount() async {
    try {
      var response = await http.get(
        Uri.parse(ApiEndPoints.MobileOrdersCount),
        headers: ApiEndPoints.headerWithToken,
      );
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        return data;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future getSecondScreenPicture() async {
  try  {
      var response = await http.get(
        Uri.parse(ApiEndPoints.ScreenImages),
        headers: ApiEndPoints.headerWithToken,
      );
      print(response.body.toString()+'sdfljdhf');
      var data = json.decode(response.body);
      return data;
    }
    catch(e){
    return e.toString();
    }
  }


  // Future syncOrders()async{
  //   var response =
  //  await http.get(Uri.parse('http://192.168.1.11:8000/api/sync'));
  //   print(response.body.toString());
  // }

}