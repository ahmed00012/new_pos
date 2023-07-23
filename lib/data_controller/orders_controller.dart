import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/prefs_utils.dart';
import 'package:shormeh_pos_new_28_11_2022/models/customer_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/order_method_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/orders_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/payment_model.dart';
import 'package:shormeh_pos_new_28_11_2022/repositories/orders_repository.dart';
import 'package:soundpool/soundpool.dart';
import '../constants/constant_keys.dart';
import '../models/complain_reasons.dart';
import '../models/order_status_model.dart';
import '../models/owner_model.dart';


final ordersFuture = ChangeNotifierProvider.family.autoDispose<OrdersController , bool>(
    (ref, value) => OrdersController(value));

class OrdersController extends ChangeNotifier {
  OrdersRepository repo = OrdersRepository();
  List<OrdersModel> orders = [];
  int currentPage = 1;
  int lastPage = 1;
  List<PaymentModel> paymentMethods = [];
  List<OrderMethodModel> orderMethods = [];
  List<OrderStatusModel> orderStatus = [];
  List<ComplainReasons> reasons = [];
  List<CustomerModel> paymentCustomer = [];
  List<OwnerModel> owners = [];
  bool loading = false;
  bool isVisible = true;
  StreamController<String> _eventData = StreamController<String>.broadcast();
  Sink get _inEventData => _eventData.sink;
  PusherClient? pusher;
  Channel? pusherChannel;
  Timer? _timer;
  bool mobileOrders;
  List<String> images = [
    'assets/images/grid.png',
    'assets/images/pen.png',
    'assets/images/clock.png',
    'assets/images/work-done.png',
    'assets/images/positive-vote.png',
    'assets/images/cancelled.png',
    'assets/images/stop-button.png',
    'assets/images/report.png',
    'assets/images/block-user.png',
    'assets/images/cancel.png',
    'assets/images/delivery-man(2).png'
  ];




  OrdersController(this.mobileOrders) {
    getOrders(page: 1,mobileOrders: mobileOrders);
    getOrderMethods();
    getPaymentMethods();
    getOrderStatus();
    getPaymentCustomers();
    getReasons();
    getOwners();
    if(mobileOrders) {
      initPusher();
    }
  }


  void getOwners() {
    owners = List<OwnerModel>.from(
        json.decode(getOwnersPrefs()).map((e) => OwnerModel.fromJson(e)));
    notifyListeners();
  }

  void switchLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  Future getOrders(
      {required int page,
      required bool mobileOrders,
      int? orderMethod,
      int? paymentMethod,
      int? orderStatus,
      int? orderId,
      int? customer,
      String? client,
      int? ownerId,
      bool? paid,
      bool? notPaid}) async {
    if (page == 1) switchLoading(true);

    var data = await repo.getOrders(page,
        mobileOrders: mobileOrders,
        paymentMethod: paymentMethod,
        orderMethod: orderMethod,
        orderStatus: orderStatus,
        orderId: orderId,
        owner: ownerId,
        customer: customer,
        client: client);
    if (!data['status']) {
      ConstantStyles.displayToastMessage(data['msg'], true);
    } else {
      if (page <= data['data']['meta']['last_page']) {
        List list = List<OrdersModel>.from(
            data['data']['data'].map((order) => OrdersModel.fromJson(order)));
        list.forEach((element) {
          if (element.ownerId != null) {
            owners.forEach((owner) {
              if (owner.id == element.ownerId) {
                element.ownerName = owner.titleEn;
              }
            });
          }
          orders.add(element);
        });
        list = [];
        currentPage = data['data']['meta']['current_page'];
        lastPage = data['data']['meta']['last_page'];
      }
    }
    switchLoading(false);
    notifyListeners();
  }

  void getOrderMethods() async {
    orderMethods = List<OrderMethodModel>.from(json
        .decode(getOrderMethodsPrefs())
        .map((e) => OrderMethodModel.fromJson(e)));
    notifyListeners();
  }

  void getPaymentMethods() async {
    paymentMethods = List<PaymentModel>.from(json
        .decode(getPaymentMethodsPrefs())
        .map((e) => PaymentModel.fromJson(e)));
    notifyListeners();
  }

  void getOrderStatus() async {
    orderStatus = List<OrderStatusModel>.from(json
        .decode(getOrderStatusPrefs())
        .map((e) => OrderStatusModel.fromJson(e)));

    orderStatus.insert(
        0,
        OrderStatusModel(
            id: 0, chosen: true, title: StatusTitle(en: 'All', ar: 'الكل')));

    notifyListeners();
  }

  void getPaymentCustomers() async {
    paymentCustomer = List<CustomerModel>.from(json
        .decode(getPaymentCustomersPrefs())
        .map((e) => CustomerModel.fromJson(e)));
    notifyListeners();
  }

  void getReasons() async {
    reasons = List<ComplainReasons>.from(json
        .decode(getComplainReasonsPrefs())
        .map((e) => ComplainReasons.fromJson(e)));
    notifyListeners();
  }

  void cancelOrder(
      {required int id,
      required String secretId,
      required String secretCode,
      String? reason,
      }) async {
    switchLoading(true);
    var data = await repo.cancelOrder(
        orderID: id,
        notes: reason ?? '',
        secretCode: secretCode,
        secretId: secretId);
    if (!data['status']) {
      ConstantStyles.displayToastMessage(data['msg'], true);
    } else {
      ConstantStyles.displayToastMessage(data['msg'], false);
      orders.forEach((element) {
        if (element.id == id) {
          element.orderStatusId = 5;
          element.orderStatus = orderStatus[4].title!.en;
        }
      });
    }

    switchLoading(false);
    notifyListeners();
  }

  void cancelMobileOrder(
      {required int id,
      required String secretId,
      required String secretCode,
      String? reason,
      }) async {
    switchLoading(true);
    var data = await repo.cancelOrderMobile(
        orderID: id,
        notes: reason,
        secretCode: secretCode,
        secretId: secretId);
    if (!data['status']) {
      ConstantStyles.displayToastMessage(data['msg'], true);
    } else {
      ConstantStyles.displayToastMessage(data['msg'], false);
      orders.forEach((element) {
        if (element.id == id) {
          element.orderStatusId = 5;
          element.orderStatus = orderStatus[4].title!.en;
        }
      });
    }

    switchLoading(false);
    notifyListeners();
  }

  void complainOrder({
    required int id,
    required String secretId,
    required String secretCode,
    String? reason,
    required int reasonId,
    String? mobile,
  }) async {
    var data = await repo.complainOrder(
        orderID: id,
        secretId: secretId,
        secretCode: secretCode,
        reasonId: reasonId,
        mobile: mobile,
        reason: reason);
    if (data['status'] == false) {
      ConstantStyles.displayToastMessage(data['msg'], true);
    } else {
      ConstantStyles.displayToastMessage(data['msg'], false);
      orders.forEach((element) {
        if (element.id == id) {
          element.orderStatusId = 7;
          element.orderStatus = orderStatus[6].title!.en;
        }
      });
      reasons.forEach((element) {
        element.chosen = false;
      });
    }
    notifyListeners();
  }


  void initPusher() {
    if (Platform.isWindows) {
      _timer = Timer.periodic(Duration(seconds: 30), (timer) {
        getNewMobileOrders();
      });
    } else {
      PusherOptions options = PusherOptions(
        cluster: pusherCluster,
      );
      pusher =  PusherClient(pusherAppKey, options,
          autoConnect: true, enableLogging: true);
      pusher!.connect().then((value) {
        pusherChannel = pusher!.subscribe(pusherGetOrderCountChannel);
        getMobileOrderPusher();
      });
    }
    notifyListeners();
  }

  removeOrderPusher() {
    PusherOptions options = PusherOptions(
      cluster: pusherCluster,
    );
    pusher =  PusherClient(pusherAppKey, options,
        autoConnect: true, enableLogging: true);

    pusher!.connect().then((value) {
      pusherChannel = pusher!.subscribe(pusherAcceptCancelOrderChannel);
      pusherChannel!.bind(pusherAcceptCancelEvent,
              (PusherEvent? event) {
            String data = event!.data!;
              getOrders(page:  1 ,mobileOrders: mobileOrders);
            _inEventData.add(event.data);
          });
    });
    notifyListeners();
  }

  void getMobileOrderPusher() async {
    pusherChannel!.bind(pusherGetOrderCountEvent,
            (PusherEvent? event) {
          String data = event!.data!;
          // var json = jsonDecode(data);
          // print(json.toString() + 'NewOrdersPusher' + HomeController.ordersCount.toString());
          setMobileOrdersCount(getMobileOrdersCount() + 1);
          playSound();
          getOrders(page: 1 ,mobileOrders: mobileOrders);
          _inEventData.add(event.data);
        });
  }

  playSound() async {
    Soundpool pool = Soundpool(streamType: StreamType.notification);
    int soundId =
    await rootBundle.load("assets/sound/ss.wav").then((ByteData soundData) {
      return pool.load(soundData);
    });
    int streamId = await pool.play(soundId);
  }


  getNewMobileOrders() async {
    var data = await repo.getNewMobileOrdersCount();
    if (data != false && data != 0) {
      playSound();
      setMobileOrdersCount(data);
        getOrders(page: 1 ,mobileOrders: mobileOrders);
    }
  }


  Future acceptOrder(int id) async {
    switchLoading(true);
    var data = await repo.acceptOrder(id);
    if(data['status']){
          removeOrderPusher();
          ConstantStyles.displayToastMessage( data['msg'], false);
          orders.forEach((element) {
            if(element.id == id){
              element.orderStatusId = orderStatus[2].id;
              element.orderStatus = orderStatus[2].title!.en;
            }
          });
    }
    else{
      ConstantStyles.displayToastMessage( data['msg'], true);
    }
  }

  // void complain(Size size,BuildContext context,bool complainOrder,{int? orderId}){
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return ;
  //       }).then((value)  {
  //     description.text='';
  //     secretId.text='';
  //     secretCode.text='';
  //     mobile.text='';
  //     chosenReason=null;
  //     reasons.forEach((element) {element.chosen=false;});
  //   });
  // }


}
