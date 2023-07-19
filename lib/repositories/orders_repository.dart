import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shormeh_pos_new_28_11_2022/constants/api.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/utils.dart';

class OrdersRepository {
  Future getOrders(int page,
      {int? orderMethod,
      int? paymentMethod,
      int? orderStatus,
      int? orderId,
      int? customer,
      String? client,
      int? owner}) async {
    try {
      var response = await http.get(
          Uri.parse(
              "${ApiEndPoints.CashierOrders}?paginate=15&page=$page&order_method_id=${orderMethod ?? ''}&"
              "payment_method_id=${paymentMethod ?? ''}&order_pos_status_id=${orderStatus ?? ''}&date=${getLoginDate()}"
              "&query=${orderId ?? ''}&payment_customer_id=${customer ?? ''}&owner_id=${owner ?? ''}&client=$client"),
          headers: ApiEndPoints.headerWithToken);

      var data = json.decode(response.body);
      log(data['data'].toString());
      return data;
    } catch (e) {
      return e.toString();
    }
  }

  Future cancelOrder(int orderID, String notes, String secretId,
      String secretCode, String branchId) async {
    try {
      var response = await http.post(Uri.parse(ApiEndPoints.CancelOrder),
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
