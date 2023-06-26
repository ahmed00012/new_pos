import 'dart:convert';
import 'dart:developer';

import '../constants.dart';
import '../local_storage.dart';
import 'package:http/http.dart' as http;

import '../models/product_details_model.dart';
import '../models/products_model.dart';

class GetData{

 Future getAll()async{
   // await   getCategories();
   await  getNotes();
   await  getPaymentCustomers();
   await  getPaymentMethods();
  await   getOwners() ;
  await getCoupons();
  await getOrderMethods();
  await getReasons();
  await  getOrderStatus();
  await  getPrinters();
  return await testToken();
  }

  Future getPaymentMethods() async {

    if (LocalStorage.getData(key: 'paymentMethods') == null) {
      int ?removeId ;
      var response = await http.get(
          Uri.parse("${Constants.baseURL}pos/paymentMethods"),
          headers: {'AUTHORIZATION': 'Bearer ${LocalStorage.getData(key: 'token')}',
            'Language': LocalStorage.getData(key: 'language')});
      if(response.statusCode == 200)
      {
        var data = json.decode(response.body);
        LocalStorage.saveData(
            key: 'paymentMethods', value: json.encode(data['data']));
      }
    }
  }

 Future getOwners() async {
    if (LocalStorage.getData(key: 'owners') == null) {
      var response = await http.get(
          Uri.parse("${Constants.baseURL}pos/owners"),
          headers: {'AUTHORIZATION': 'Bearer ${LocalStorage.getData(key: 'token')}',
            'Language': LocalStorage.getData(key: 'language')});
      if(response.statusCode == 200) {
        var data = json.decode(response.body);
        LocalStorage.saveData(key: 'owners', value: json.encode(data['data']));
      }
    }
  }

 Future getCoupons() async {
    if (LocalStorage.getData(key: 'coupons') == null) {
      var response = await http.get(
          Uri.parse("${Constants.baseURL}coupons"),
          headers: {'AUTHORIZATION': 'Bearer ${LocalStorage.getData(key: 'token')}',
            'Language': LocalStorage.getData(key: 'language')});
      if(response.statusCode == 200) {
        var data = json.decode(response.body);
        LocalStorage.saveData(key: 'coupons', value: json.encode(data['data']));
      }
    }
  }

 Future getOrderMethods() async {
   if(LocalStorage.getData(key: 'orderMethods')==null) {
      var response = await http.get(
          Uri.parse(
              "${Constants.baseURL}pos/orderMethods/${LocalStorage.getData(key: 'branch')}"),
          headers: {
            'AUTHORIZATION': 'Bearer ${LocalStorage.getData(key: 'token')}',
            'Language': LocalStorage.getData(key: 'language')
          });
      if(response.statusCode == 200)
      {
        var data = json.decode(response.body);
        List methods = List.from(data['data']);
        // data['data'].forEach((element) {
        //   if(element['id'] == 1 || element['id'] == 2 || element['id'] == 3 || element['id'] == 4){
        //     methods.add(element);
        //   }
        // });

        LocalStorage.saveData(key: 'orderMethods', value: json.encode(methods));
      }
    }
  }

 Future getReasons()async{
    if (LocalStorage.getData(key: 'reasons') == null) {
      var response = await http.get(
          Uri.parse("${Constants.baseURL}pos/complainReasons"),
          headers: {'AUTHORIZATION': 'Bearer ${LocalStorage.getData(key: 'token')}',
            'Language': LocalStorage.getData(key: 'language'),
            'Content-Language':LocalStorage.getData(key: 'language'),});
      if(response.statusCode == 200)
      {
        var data = json.decode(response.body);

        LocalStorage.saveData(key: 'reasons', value: json.encode(data['data']));
      }
    }

  }

 Future getOrderStatus() async {
    if(LocalStorage.getData(key: 'orderStatus')==null) {
      var response = await http.get(Uri.parse("${Constants.baseURL}pos/orderStatus"),
          headers: {'AUTHORIZATION': 'Bearer ${LocalStorage.getData(key: 'token')}',
            'Language': LocalStorage.getData(key: 'language')});
      if(response.statusCode == 200)
      {
        var data = json.decode(response.body);
        LocalStorage.saveData(
            key: 'orderStatus', value: json.encode(data['data']));
      }
    }

  }

  Future getPrinters() async {
    if (LocalStorage.getData(key: 'printers') == null) {
      var response = await http.get(
          Uri.parse("${Constants.baseURL}branch/${LocalStorage.getData(key: 'branch').toString()}/printers"),
          headers: {'AUTHORIZATION': 'Bearer ${LocalStorage.getData(key: 'token')}',
            'Language': LocalStorage.getData(key: 'language')});
      if(response.statusCode == 200)
      {
        var data = json.decode(response.body);
        LocalStorage.saveData(
            key: 'printers', value: json.encode(data['data']));
      }
    }
  }

  Future getNotes() async {
    if (LocalStorage.getData(key: 'options') == null) {
        var response = await http.get(
          Uri.parse("${Constants.baseURL}pos/notes"),
            headers: {'AUTHORIZATION': 'Bearer ${LocalStorage.getData(key: 'token')}',
              'Language': LocalStorage.getData(key: 'language')});
        if(response.statusCode == 200)
        {
        var data = json.decode(response.body);
        LocalStorage.saveData(key: 'options', value: json.encode(data['data']));
      }
    }
  }


 Future getPaymentCustomers() async {
    if (LocalStorage.getData(key: 'paymentCustomers') == null) {
      var response = await http.get(
          Uri.parse("${Constants.baseURL}pos/paymentCustomers"),
          headers: {'AUTHORIZATION': 'Bearer ${LocalStorage.getData(key: 'token')}',
            'Language': LocalStorage.getData(key: 'language')});
      if(response.statusCode == 200) {
        var data = json.decode(response.body);
        LocalStorage.saveData(
            key: 'paymentCustomers', value: json.encode(data['data']));
      }
    }
  }


  Future getCategories() async {
    List<String> categoriesId = [];

    var response = await http.get(
      Uri.parse("${Constants.baseURL}pos/branch/${LocalStorage.getData(key: 'branch')}/categories"),
        headers: {'AUTHORIZATION': 'Bearer ${LocalStorage.getData(key: 'token')}',
          'Language': LocalStorage.getData(key: 'language')});


if(response.statusCode == 200) {
  var data = json.decode(response.body);
      data['data'].forEach((element) {
        categoriesId.add(element['id'].toString());
      });

      LocalStorage.saveList(key: 'categoriesId', value: categoriesId);
      LocalStorage.saveData(
          key: 'allCategories', value: json.encode(data['data']));
      categoriesId.forEach((element) async {
        await getProducts(int.parse(element));
      });
      return true;
    }
else if(response.statusCode == 403){
  return 'branchClosed' ;
}
else{
  return 'unauthorized';
}
  }


  // Future getProducts(int id) async {
  //   if (LocalStorage.getData(key: 'products$id') == null) {
  //
  //     var response = await http.get(
  //       Uri.parse("${Constants.baseURL}branch/${LocalStorage.getData(key: 'branch')}/category/$id/products"),
  //         headers: {'AUTHORIZATION': 'Bearer ${LocalStorage.getData(key: 'token')}',
  //           'Language': LocalStorage.getData(key: 'language')});
  //     var data = json.decode(response.body);
  //     print('dsasad'+data.toString());
  //     LocalStorage.saveData(key: 'products$id', value: json.encode(data['data']));
  //
  //
  //
  //   }
  // }

 Future getProducts(int id) async {
// String language = LocalStorage.getData(key: 'language');
   List<String> productsId = [];



   if (LocalStorage.getData(key: 'products$id') == null) {
     var response = await http.get(
         Uri.parse("${Constants.baseURL}branch/${LocalStorage.getData(key: 'branch')}/category/$id/products"),
         headers: {'AUTHORIZATION': 'Bearer ${LocalStorage.getData(key: 'token')}',
           'Language': LocalStorage.getData(key: 'language'),
           'Accept': 'application/json'});

     if(response.statusCode == 200)
     {
        var data = json.decode(response.body);

        data['data'].forEach((element) {
          productsId.add(element['id'].toString());
        });
        LocalStorage.saveList(key: 'productsId', value: productsId);

        LocalStorage.saveData(key: 'products$id', value: json.encode(data['data']));
        return List<ProductModel>.from(
            data['data'].map((product) => ProductModel.fromJson(product)));
      }
    }
   else{


     List<ProductModel> products = List<ProductModel>.from(json
         .decode(LocalStorage.getData(key: 'products$id'))
         .map((product) => ProductModel.fromJson(product)));

     return products;
   }
 }


 Future getProductDetails(int id) async {

   // String language = LocalStorage.getData(key: 'language');

   //
   //  LocalStorage.removeData(key: 'productDetails$id');

   if (LocalStorage.getData(key: 'productDetails$id').toString() == 'null') {
     var response = await http.get(
         Uri.parse("https://beta2.poss.app/api/pos/product/$id/details"),
         headers: {'AUTHORIZATION': 'Bearer ${LocalStorage.getData(key: 'token')}',
           'Language': LocalStorage.getData(key: 'language'),
           'Accept': 'application/json'});
     if(response.statusCode == 200)
     {
        var data = json.decode(response.body);

        LocalStorage.saveData(
            key: 'productDetails$id',
            value: json.encode(data['data']['attributes']));
        List<Attributes> attributes = List.from(
            data['data']['attributes'].map((e) => Attributes.fromJson(e)));
        return data['data'] != null ? attributes : null;
      }
    }
   else{

     List<Attributes>? attributes = List.from(jsonDecode(LocalStorage.getData(key: 'productDetails$id'))
         .map((e)=> Attributes.fromJson(e)));
     // Attributes.fromJson(json.decode(
     //     LocalStorage.getData(key: 'productDetails$id')));
     return attributes;
   }
 }

 Future <bool> testToken() async{
   var response = await http.get(
       Uri.parse("${Constants.baseURL}pos/paymentMethods"),
       headers: {'AUTHORIZATION': 'Bearer ${LocalStorage.getData(key: 'token')}',});
   if(response.statusCode == 401)
     return false;
   else
     return true;
 }

}



