import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';
import 'package:shormeh_pos_new_28_11_2022/repositories/get_data.dart';
import 'package:shormeh_pos_new_28_11_2022/models/customer_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/notes_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/products_model.dart';
import 'package:soundpool/soundpool.dart';
import '../constants/constant_keys.dart';
import '../constants/prefs_utils.dart';
import '../models/categories_model.dart';
import '../models/product_details_model.dart';
import '../repositories/products_repository.dart';



final dataFuture = ChangeNotifierProvider.autoDispose<HomeController>(
    (ref) => HomeController());

class HomeController extends ChangeNotifier {
  ProductsRepo productsRepo = ProductsRepo();
  List<CategoriesModel> categories = [];
  // static OrderDetails orderDetails= OrderDetails();
  // var selectedTab = SelectedTab.home;

  int? chosenItem;
  bool itemWidget = false;
  bool options = false;
  List<String> countText = [];
  List<ProductModel> products = [];
  List<NotesModel> optionsList = [];
  bool loading = true;

  //
  // TextEditingController customerName = TextEditingController();
  // TextEditingController customerPhone = TextEditingController();
  // TextEditingController expenseDescription = TextEditingController();
  // TextEditingController cashOutAmount = TextEditingController();
  // TextEditingController anotherOption = TextEditingController();
  //
  List<CustomerModel> paymentCustomers = [];
  List<Attributes> attributes = [];
  bool changed = false;
  GetData allData = GetData();
  bool branchClosed = false;
  Timer ? pusherTimer;
  // Timer ?baseUrlTimer;
  Timer ?branchImagesTimer;
  List<String> branchScreenImages = [];
  int secondScreenDuration = 0;
  StreamController<String> _eventData = StreamController<String>.broadcast();
  Sink get _inEventData => _eventData.sink;


  HomeController() {
    getAllData();
    initPusher( );
    getSecondScreenImages();

  }


  // bool _mounted = false;
  // bool get mounted => _mounted;
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   _mounted = true;
  // }

//   refreshBaseUrl(){
//  baseUrlTimer =  Timer.periodic(Duration(seconds: 5), (timer) async{
//     bool repeat = !changed;
//     if(repeat)
//       getBase();
//     else {
//
//      await syncServer();
//       // sleep(const Duration(seconds: 30),);
//       repeat = true;
//       changed = false;
//       switchLoading(false);
//       notifyListeners();
//     };
//   });
// }

  // getBase()async{
  //
  //   if(!disposed) {
  //     bool result = await InternetConnectionChecker().hasConnection;
  //     if (result == true) {
  //       if (url != LocalStorage.getData(key: 'baseUrl')) {
  //         loading = true;
  //
  //         changed = true;
  //         url = 'https://beta2.poss.app/api/';
  //         LocalStorage.saveData(
  //             key: 'baseUrl', value: 'https://beta2.poss.app/api/');
  //         notifyListeners();
  //       } else
  //         LocalStorage.saveData(
  //             key: 'baseUrl', value: 'https://beta2.poss.app/api/');
  //       notifyListeners();
  //     } else {
  //       LocalStorage.saveData(
  //           key: 'baseUrl', value: 'http://192.168.1.11:8000/api/');
  //       url = 'http://192.168.1.11:8000/api/';
  //       notifyListeners();
  //     }
  //
  //   }
  // }


 // Future syncServer()async{
 //    if(changed)
 //   await productsRepo.syncOrders();
 //
 //  }


  @override
  void dispose() {
    // if(baseUrlTimer!=null)
    //   baseUrlTimer!.cancel();
    if(pusherTimer!=null)
      pusherTimer!.cancel();
    if(branchImagesTimer!=null)
      branchImagesTimer!.cancel();
    super.dispose();
  }

  PusherClient? pusher;
  Channel? pusherChannel;



  // refreshList() {
  //   notifyListeners();
  // }

  // testToken()async{
  //   LocalStorage.removeData(key: 'token');
  //   LocalStorage.removeData(key: 'branch');
  //   LocalStorage.removeData(key: 'coupons');
  //   navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (_)=>Login()), (route) => false);
  // }

  // void getMobileOrder() async{
  //
  //   channel!.bind("Modules\\Order\\Events\\CreateOrderFromPhone", (PusherEvent ?event) {
  //
  //     String data = event!.data!;
  //     var json = jsonDecode(data);
  //      _inEventData.add(event.data);
  //     playSound();
  //     ordersCount = ordersCount + 1;
  //     notifyListeners();
  //   });
  //   notifyListeners();
  // }

  playSound() async {
    Soundpool pool = Soundpool(streamType: StreamType.notification);

    int soundId = await rootBundle.load("assets/sound/ss.wav").then((ByteData soundData) {
      return pool.load(soundData);
    });
    int streamId = await pool.play(soundId);
  }

  void getPaymentCustomers() async {
      paymentCustomers = List<CustomerModel>.from(json
          .decode(getPaymentCustomersPrefs())
          .map((e) => CustomerModel.fromJson(e)));
    paymentCustomers.forEach((element) {
      element.chosen = false;
    });
    loading = false;
    notifyListeners();
  }



  // void selectCustomer({required OrderDetails orderDetails,required int index}) {
  //
  //   /// select customer upper row
  //   if (orderDetails.customer==null) {
  //     emptyCardList(orderDetails: orderDetails);
  //     paymentCustomers[index].chosen = true;
  //     orderDetails.customer = paymentCustomers[index];
  //     orderDetails.orderMethodId = 3;
  //     orderDetails.orderMethod = 'take away';
  //     orderDetails.paymentId = 2;
  //   }
  //
  //   else if(orderDetails.customer!.id == paymentCustomers[index].id)
  //     {
  //       emptyCardList(orderDetails: orderDetails);
  //       paymentCustomers[index].chosen = false;
  //       orderDetails.customer = null;
  //       orderDetails.orderMethodId = null;
  //       orderDetails.paymentId = null;
  //     }
  //   /// select another payment customer
  //   else {
  //     paymentCustomers[index].chosen = true;
  //     orderDetails.customer = paymentCustomers[index];
  //     orderDetails.orderMethodId = 1;
  //     orderDetails.orderMethod = 'take away';
  //     orderDetails.paymentId = 2;
  //   }
  //
  //   notifyListeners();
  // }



  //
  // void emptyCardList({required OrderDetails orderDetails }) {
  //   itemWidget = false;
  //   orderDetails = OrderDetails(cart: [],payMethods: []);
  //   notifyListeners();
  // }
  //
  // void switchToCardItemWidget(bool switchTo, {int? i}) {
  //   itemWidget = switchTo;
  //   chosenItem = i;
  //   notifyListeners();
  // }
  //



  void switchLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  Future getCategories() async {
  var data = await allData.getCategories();
  if(data == 'branchClosed'){
   branchClosed = true;

  }
  else{
    categories = List<CategoriesModel>.from(json.decode(getAllCategoriesPrefs())
        .map((e) => CategoriesModel.fromJson(e)));
    // categories.forEach((element) {
    //   getProducts (element.id!);
    // });
    getProducts(categories[0].id!);
    categories[0].chosen = true;
    branchClosed = false;
  }
    notifyListeners();
  }

  // addAnotherOption({required OrderDetails orderDetails }){
  //   if(itemWidget)
  //     {
  //     orderDetails.cart![chosenItem!].extraNotes = anotherOption;
  //     orderDetails.cart![chosenItem!].updated=true;
  //     }
  //
  //   else {
  //     orderDetails.cart!.last.extraNotes = anotherOption;
  //   }
  //
  //  anotherOption = '';
  //   notifyListeners();
  // }

  void chooseCategory(int i) {
    categories.forEach((element) {
      element.chosen = false;
    });
    if (i == 0) {
      options = true;
    } else {
      options = false;
      categories[i - 1].chosen = true;
      getProducts(categories[i - 1].id!);
    }
    notifyListeners();
  }

  // void handleIndexChanged(int i) {
  //   selectedTab = SelectedTab.values[i];
  //   current = pages[i];
  //   notifyListeners();
  // }

 // void insertCart({required OrderDetails orderDetails , required int i}){
 //      orderDetails.insertIntoCart(products[i]);
 //      chosenItem = orderDetails.cart!.length-1;
 //      // getProductDetails(int.parse(products[i].id!));
 //      notifyListeners();
 //  }

  // void insertOption(
  // {required OrderDetails orderDetails , required int indexOfOption,required CardModel product}){
  //
  //   int indexOfProduct = orderDetails.cart!.indexOf(product);
  //   orderDetails.addOption(optionsList[indexOfOption], indexOfProduct);
  //   notifyListeners();
  // }

  void synchronize() {
    categories = [];
    products = [];
    optionsList = [];
    attributes = [];
    switchLoading(true);
    print(loading);
    syncAppData();
    getSecondScreenImages();
    getAllData();
    print(loading);
  }

  getAllData(){
    if(getProductsIdPrefs().isEmpty) {
      allData.getAll().then((value) {
        getCategories();
        getNotes();
        getPaymentCustomers();
        switchLoading(false);
      });
    }
    else{
      getCategories();
      getNotes();
      getPaymentCustomers();
      switchLoading(false);
    }

  }

  // String getLanguage() {
  //   String  language = LocalStorage.getData(key: 'language') ?? 'en';
  //   return language;
  // }

  changeLanguage(BuildContext context,String language) {
  if(language != getLanguage()) {
      language == 'en'
          ? context.setLocale(Locale('en'))
          : context.setLocale(Locale('ar'));
      language = context.locale.languageCode;
      setLanguage(language);
      synchronize();
    }

    notifyListeners();
  }






  Future getProducts(int id) async {
    // , bool clear
    // products = [];

    var data = await allData.getProducts(id);
    products = List<ProductModel>.from(json.decode(getProductsPrefs(id))
        .map((e) => ProductModel.fromJson(e)));
    // if(clear) {
    //   products.forEach((element) {
    //     if (getProductDetailsPrefs(id).isNotEmpty) {
    //       setProductDetailsPrefs('', id);
    //     }
    //   });
    //   setProductsPrefs('', id);
    //   products.clear();
    // }

    // products.forEach((element) {
    //    getProductDetails(int.parse(element.id!),element);
    // });
    notifyListeners();
  }

  Future getProductDetails({required int productID , required bool customerPrice}) async {
    int numberOfRequiredElements = 0;
     var data = await allData.getProductDetails(productID);
    attributes = List<Attributes>.from(json.decode(getProductDetailsPrefs(productID))
        .map((e) => Attributes.fromJson(e)));
    attributes.forEach((element) {

      if(element.required == 1) {
        numberOfRequiredElements += 1;
        debugPrint(numberOfRequiredElements.toString());
      }
      element.values!.forEach((element) {
        element.chosen = false;
      if(customerPrice)
        element.realPrice = element.customerPrice;
      else
        element.realPrice = element.price;
      });
    });

     notifyListeners();
  }


  Future getNotes() async {
      optionsList = List<NotesModel>.from(json
          .decode(getOptionsPrefs())
          .map((e) => NotesModel.fromJson(e)));
    notifyListeners();
  }

  Future getSecondScreenImages()async{
    branchScreenImages = [];
   var data = await productsRepo.getSecondScreenPicture();

   if(data['status']) {
     secondScreenDuration = int.parse(data['data']['seconds'].toString());
     data['data']['screens'].forEach((e) {
       branchScreenImages.add(e['image']);
     });
   }
     else {
       branchScreenImages = ['assets/images/2.png'];
   }
    changeBranchImage();
   notifyListeners();
  }


  changeBranchImage(){
    if(branchScreenImages.isNotEmpty && !Platform.isWindows) {
      branchImagesTimer = Timer.periodic(Duration(seconds: secondScreenDuration), (timer) {
        channel.invokeMethod(iminShowImage,
            [branchScreenImages[Random().nextInt(branchScreenImages.length)]]);
      });
    }
    notifyListeners();
  }



  Future expense(String description , String price) async {
    try{
      var data = await productsRepo.expense(description, double.parse(price));
      ConstantStyles.displayToastMessage(data['msg'], !data['status']);
    }
    catch(e){
      ConstantStyles.displayToastMessage(e.toString(), true);
    }
  }

  void initPusher( ) async{
    if(Platform.isWindows) {
      pusherTimer = Timer.periodic(Duration(seconds: 30), (timer) {
        getNewMobileOrders();

      });
    }
    else{
      PusherOptions options = PusherOptions(
        cluster: pusherCluster,
      );
      pusher = new PusherClient(pusherAppKey, options,
          autoConnect: true, enableLogging: true);
      pusher!.connect().then((value) {
        pusherChannel = pusher!.subscribe(pusherGetOrderCountChannel);
        pusherChannel!.bind(pusherGetOrderCountEvent,
                (PusherEvent? event) {
              setMobileOrdersCount(getMobileOrdersCount() + 1);
              playSound();
              _inEventData.add(event!.data);
              notifyListeners();
            });

      });
    }



  }



   Future getNewMobileOrders() async{
    try{
      var data = await productsRepo.getNewMobileOrdersCount();
      if (data['status'] != false && data['data'].toString() != '0') {
        setMobileOrdersCount(data['data']);
        playSound();
      }
    }
    catch (e){}
    notifyListeners();
  }



}
