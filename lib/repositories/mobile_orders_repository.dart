import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shormeh_pos_new_28_11_2022/constants/api.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/colors.dart';

class MobileOrdersRepository {
  Future getOrders(int page,
      {int? orderMethod,
      int? paymentMethod,
      int? orderStatus,
      String? date,
      int? orderId,
      int? customer,
      String? client}) async {
    // print(client);

    try {
      var response = await http.get(
        Uri.parse(
            "${ApiEndPoints.MobileOrders}?paginate=15&page=$page&order_method_id=${orderMethod ?? ''}&"
            "payment_method_id=${paymentMethod ?? ''}&order_pos_status_id=${orderStatus ?? ''}&date=${date ?? ''}"
            "&query=${orderId ?? ''}&payment_customer_id=${customer ?? ''}&client=$client"),
        headers: ApiEndPoints.headerWithToken,
      );
      var data = json.decode(response.body);
      return data;
    } catch (e) {
      return e;
    }
  }

  Future getNewMobileOrders() async {
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

  Future cancelOrder(int orderID, String notes, String secretId,
      String secretCode, String branchId) async {
    try {
      var response = await http.post(Uri.parse(ApiEndPoints.CancelMobileOrder),
          body: {
            'order_id': orderID.toString(),
            'notes': notes,
            'secret_id': secretId,
            'secret_code': secretCode,
            'branch_id': branchId
          },
          headers: ApiEndPoints.headerWithToken);
      var data = json.decode(response.body);

      return data;
    } catch (e) {
      return e.toString();
    }
  }

  Future acceptOrder(int orderID) async {
    try {
      var response = await http.post(Uri.parse(ApiEndPoints.AcceptMobileOrder),
          body: {
            'order_id': orderID.toString(),
          },
          headers: ApiEndPoints.headerWithToken);

      var data = json.decode(response.body);

      return data;
    } catch (e) {
      return e.toString();
    }
  }

  Future complainOrder(int orderID, Map body) async {
    try {
      var response = await http.post(
          Uri.parse("${ApiEndPoints.ComplainOrder}$orderID/complain"),
          body: jsonEncode(body),
          headers: ApiEndPoints.headerWithToken);
      var data = json.decode(response.body);
      return data;
    } catch (e) {
      return e.toString();
    }
  }
}
