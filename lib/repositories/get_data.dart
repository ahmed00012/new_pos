import 'dart:convert';
import 'package:shormeh_pos_new_28_11_2022/constants/api.dart';
import '../constants/prefs_utils.dart';
import 'package:http/http.dart' as http;

class GetData {
  Future getAll() async{
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
   }

  Future getPaymentMethods() async {
    String data = getPaymentMethodsPrefs();
    try {
      if (data.isEmpty) {
        var response = await http.get(Uri.parse(ApiEndPoints.PaymentMethods),
            headers: ApiEndPoints.headerWithToken(token:getUserToken() ,language: getLanguage()));
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          setPaymentMethodsPrefs(json.encode(data['data']));
        }
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future getOwners() async {
    String data = getOwnersPrefs();
    try {
      if (data.isEmpty) {
        var response = await http.get(Uri.parse(ApiEndPoints.Owners),
            headers: ApiEndPoints.headerWithToken(token:getUserToken() ,language: getLanguage()));
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          setOwnersPrefs(json.encode(data['data']));
        }
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future getCoupons() async {
    String data = getCouponsPrefs();
    try {
      if (data.isEmpty) {
        var response = await http.get(Uri.parse(ApiEndPoints.Coupons),
            headers: ApiEndPoints.headerWithToken(token:getUserToken() ,language: getLanguage()));
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          setCouponsPrefs(json.encode(data['data']));
        }
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future getOrderMethods() async {
    String data = getOrderMethodsPrefs();
    try {
      if (data.isEmpty) {
        var response = await http.get(
            Uri.parse("${ApiEndPoints.OrderMethods}${getBranch()}"),
            headers: ApiEndPoints.headerWithToken(token:getUserToken() ,language: getLanguage()));
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          List methods = List.from(data['data']);
          // data['data'].forEach((element) {
          //   if(element['id'] == 1 || element['id'] == 2 || element['id'] == 3 || element['id'] == 4){
          //     methods.add(element);
          //   }
          // });
          setOrderMethodsPrefs(json.encode(methods));
        }
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future getReasons() async {
    try {
      String data = getComplainReasonsPrefs();
      if (data.isEmpty) {
        var response = await http.get(Uri.parse(ApiEndPoints.ComplainReasons),
            headers: ApiEndPoints.headerWithToken(token:getUserToken() ,language: getLanguage()));
        var data = json.decode(response.body);
        setComplainReasonsPrefs(json.encode(data['data']));
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future getOrderStatus() async {
    try {
      String data = getOrderStatusPrefs();
      if (data.isEmpty) {
        var response = await http.get(Uri.parse(ApiEndPoints.OrderStatus),
            headers: ApiEndPoints.headerWithToken(token:getUserToken() ,language: getLanguage()));
        var data = json.decode(response.body);
        setOrderStatusPrefs(json.encode(data['data']));
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future getPrinters() async {
    try {
      String data = getPrintersPrefs();
      if (data.isEmpty) {
        var response = await http.get(Uri.parse(ApiEndPoints.Printers),
            headers: ApiEndPoints.headerWithToken(token:getUserToken() ,language: getLanguage()));
        var data = json.decode(response.body);
        setPrintersPrefs(json.encode(data['data']));
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future getNotes() async {
    try {
      String data = getOptionsPrefs();
      if (data.isEmpty) {
        var response = await http.get(Uri.parse(ApiEndPoints.GetNotes),
            headers: ApiEndPoints.headerWithToken(token:getUserToken() ,language: getLanguage()));
        var data = json.decode(response.body);
        setOptionsPrefs(json.encode(data['data']));
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future getPaymentCustomers() async {
    try {
      String data = getPaymentCustomersPrefs();
      if (data.isEmpty) {
        var response = await http.get(Uri.parse(ApiEndPoints.PaymentCustomers),
            headers: ApiEndPoints.headerWithToken(token:getUserToken() ,language: getLanguage()));
        var data = json.decode(response.body);
        setPaymentCustomersPrefs(json.encode(data['data']));
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future getCategories() async {
    // try {
      String categoriesPrefs = getAllCategoriesPrefs();
      List<String> categoriesId = getCategoriesIdPrefs();
      var response = await http.get(Uri.parse(ApiEndPoints.GetCategories),
          headers: ApiEndPoints.headerWithToken(token:getUserToken() ,language: getLanguage()));
      if (categoriesPrefs.isEmpty) {
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          data['data'].forEach((element) async{
            categoriesId.add(element['id'].toString());
            await getProducts(element['id']);
          });
          setCategoriesIdPrefs(categoriesId);
          setAllCategoriesPrefs(json.encode(data['data']));
          return data;
        } else if (response.statusCode == 403) {
          return 'branchClosed';
        } else {
          return data;
        }
      }
    // } catch (e) {
    //   return e.toString();
    // }
  }

  Future getProducts(int id) async {
    String productPrefs = getProductsPrefs(id);
    List<String> productsId = getProductsIdPrefs();
    try {
      if (productPrefs.isEmpty) {
        var response = await http.get(
            Uri.parse("${ApiEndPoints.Products}$id/products"),
            headers: ApiEndPoints.headerWithToken(token:getUserToken() ,language: getLanguage()));
        var data = json.decode(response.body);
        data['data'].forEach((element) async{
          productsId.add(element['id'].toString());
         await getProductDetails(element['id']);
        });
        setProductsIdPrefs(productsId);
        setProductsPrefs(json.encode(data['data']), id);
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future getProductDetails(int id) async {
    String data = getProductDetailsPrefs(id);
    try {
      if (data.isEmpty) {
        var response = await http.get(
            Uri.parse("${ApiEndPoints.ProductDetails}$id/details"),
            headers: ApiEndPoints.headerWithToken(token:getUserToken() ,language: getLanguage()));
        var data = json.decode(response.body);
        setProductDetailsPrefs(json.encode(data['data']['attributes']), id);
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Future <bool> testToken() async{
  //   var response = await http.get(
  //       Uri.parse("${Constants.baseURL}pos/paymentMethods"),
  //       headers: {'AUTHORIZATION': 'Bearer ${LocalStorage.getData(key: 'token')}',});
  //   if(response.statusCode == 401)
  //     return false;
  //   else
  //     return true;
  // }
}
