import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:shormeh_pos_new_28_11_2022/repositories/get_data.dart';
import 'package:shormeh_pos_new_28_11_2022/models/client_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/customer_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/notes_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/products_model.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/login.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/mobile_orders.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/order_method.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/payment_screen.dart';
import 'package:soundpool/soundpool.dart';
import '../constants.dart';
import '../local_storage.dart';
import '../main.dart';
import '../models/cart_model.dart';
import '../models/categories_model.dart';
import '../models/product_details_model.dart';
import '../repositories/products_repository.dart';
import '../ui/screens/home.dart';
import '../ui/screens/orders.dart';
import '../ui/screens/tables.dart';


const MethodChannel channel = MethodChannel('com.imin.printersdk');
final dataFuture = ChangeNotifierProvider.autoDispose<HomeController>(
    (ref) => HomeController());

class HomeController extends ChangeNotifier {
  ProductsRepo productsRepo = ProductsRepo();
  List<CategoriesModel> categories = [];
  // static OrderDetails orderDetails= OrderDetails();
  var selectedTab = SelectedTab.home;
  Widget current = Home();
  int? chosenItem;
  bool itemWidget = false;
  bool options = false;
  List<String> countText = [];
  List<ProductModel> products = [];
  List<NotesModel> optionsList = [];
  bool loading = true;
  bool clientsLoading = false;

  TextEditingController customerName = TextEditingController();
  TextEditingController customerPhone = TextEditingController();
  TextEditingController expenseDescription = TextEditingController();
  TextEditingController cashOutAmount = TextEditingController();
  TextEditingController anotherOption = TextEditingController();
  String lan = 'en';
  List<ClientModel> clients = [];
  List<ClientModel> searchResultClients = [];
  List<CustomerModel> paymentCustomers = [];
  PusherClient ?pusher;
  Channel? pusherChannel;
  static int ordersCount = 0;
  ProductDetailsModel productDetails = ProductDetailsModel();
  List<Attributes> attributes = [];
  bool changed = false;
  String url = 'https://beta2.poss.app/api/';
  GetData allData = GetData();
  bool branchClosed = false;
  Timer ? pusherTimer;
  Timer ?baseUrlTimer;
  Timer ?branchImagesTimer;
  bool disposed = false;
  List<String> branchScreenImages = [];
  int secondScreenDuration = 0;


  List<Widget> pages = [
    Orders(),
    Home(),
    MobileOrders(),
    TablesScreen(),
  ];

  HomeController() {
    getLanguage();
    getAllData();
    // refreshBaseUrl();
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


 Future syncServer()async{
    if(changed)
   await productsRepo.syncOrders();

  }


  @override
  void dispose() {
    if(baseUrlTimer!=null)
      baseUrlTimer!.cancel();
    if(pusherTimer!=null)
      pusherTimer!.cancel();
    if(branchImagesTimer!=null)
      branchImagesTimer!.cancel();
    disposed = true;
    super.dispose();
  }

  void initPusher( ) {

    if(Platform.isWindows) {
     pusherTimer = Timer.periodic(Duration(seconds: 30), (timer) {
        getNewMobileOrders();
      });
    }
    // else{
    //   PusherOptions options = PusherOptions(
    //     cluster: "us2",
    //   );
    //   pusher = new PusherClient("084bdc917e1b8a627bc8", options,
    //       autoConnect: true,enableLogging: true);
    //
    //   pusher!.connect().then((value) {
    //     channel = pusher!.subscribe("create_order_from_phone_${LocalStorage.getData(key: 'branch')}");
    //     getMobileOrder();
    //   });
    // }
    notifyListeners();

  }


  refreshList() {
    notifyListeners();
  }

  testToken()async{
    LocalStorage.removeData(key: 'token');
    LocalStorage.removeData(key: 'branch');
    LocalStorage.removeData(key: 'coupons');
    navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (_)=>Login()), (route) => false);
  }

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
          .decode(LocalStorage.getData(key: 'paymentCustomers'))
          .map((e) => CustomerModel.fromJson(e)));
    paymentCustomers.forEach((element) {
      element.chosen = false;
    });
    loading = false;
    notifyListeners();
  }



  void selectCustomer({required OrderDetails orderDetails,required int index}) {

    /// select customer upper row
    if (orderDetails.customer==null) {
      emptyCardList(orderDetails: orderDetails);
      paymentCustomers[index].chosen = true;
      orderDetails.customer = paymentCustomers[index];
      orderDetails.orderMethodId = 3;
      orderDetails.orderMethod = 'take away';
      orderDetails.paymentId = 2;
    }

    else if(orderDetails.customer!.id == paymentCustomers[index].id)
      {
        emptyCardList(orderDetails: orderDetails);
        paymentCustomers[index].chosen = false;
        orderDetails.customer = null;
        orderDetails.orderMethodId = null;
        orderDetails.paymentId = null;
      }
    /// select another payment customer
    else {
      paymentCustomers[index].chosen = true;
      orderDetails.customer = paymentCustomers[index];
      orderDetails.orderMethodId = 1;
      orderDetails.orderMethod = 'take away';
      orderDetails.paymentId = 2;
    }

    notifyListeners();
  }




  void emptyCardList({required OrderDetails orderDetails }) {
    itemWidget = false;
    orderDetails = OrderDetails();
    notifyListeners();
  }

  void switchToCardItemWidget(bool switchTo, {int? i}) {
    itemWidget = switchTo;
    chosenItem = i;
    notifyListeners();
  }




  void switchLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  Future getCategories() async {

  var data = await  allData.getCategories();
  if(data  == true) {
      categories = List<CategoriesModel>.from(json
          .decode(LocalStorage.getData(key: 'allCategories'))
          .map((e) => CategoriesModel.fromJson(e)));
      // categories.forEach((element) {
      //   getProducts (element.id!);
      // });

      getProducts(categories[0].id!,false);
      categories[0].chosen = true;
      branchClosed = false;
    }
  else if(data == 'branchClosed'){
   branchClosed = true;
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
    if (i == 0) {
      categories.forEach((element) {
        element.chosen = false;
      });
      options = true;
    } else {
      options = false;
      categories.forEach((element) {
        element.chosen = false;
      });
      categories[i - 1].chosen = true;
      getProducts(categories[i - 1].id!,false);
    }
    notifyListeners();
  }

  void handleIndexChanged(int i) {
    selectedTab = SelectedTab.values[i];
    current = pages[i];
    notifyListeners();
  }

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

  void synchronize(BuildContext context) {
    switchLoading(true);
    // bool synchronized = false;
    // if(LocalStorage.getData(key: 'baseUrl') == 'https://poss.app/api/'){
    //   synchronized = true;
    //   syncServer().then((value) {
    //
    //     getAllData();
    //   });
    //
    // }


    if (LocalStorage.getList(key: 'categoriesId') != null) {
      List cats = LocalStorage.getList(key: 'categoriesId');
      cats.forEach((element){
        LocalStorage.removeData(key: 'products$element');
      });

      categories = [];
      products = [];
      optionsList = [];
    }
    if(LocalStorage.getList(key: 'productsId') != null){
      List productsID = LocalStorage.getList(key: 'productsId');
      LocalStorage.removeData(key: 'productsId');
      productsID.forEach((element) {
        LocalStorage.removeData(key: 'productDetails$element');
      });

    }
    if (LocalStorage.getData(key: 'orderMethods') != null)
      LocalStorage.removeData(key: 'orderMethods');
    if (LocalStorage.getData(key: 'options') != null) {
      LocalStorage.removeData(key: 'options');
    }
    if (LocalStorage.getData(key: 'categoriesId') != null)
      LocalStorage.removeData(key: 'categoriesId');
    if (LocalStorage.getData(key: 'paymentMethods') != null) {
      LocalStorage.removeData(key: 'paymentMethods');

    }
    if (LocalStorage.getData(key: 'orderStatus') != null) {
      LocalStorage.removeData(key: 'orderStatus');

    }
    if (LocalStorage.getData(key: 'paymentCustomers') != null) {
      LocalStorage.removeData(key: 'paymentCustomers');
    }
    if (LocalStorage.getData(key: 'coupons') != null)
      LocalStorage.removeData(key: 'coupons');
    if (LocalStorage.getData(key: 'printers') != null) {
      LocalStorage.removeData(key: 'printers');
    }
    if (LocalStorage.getData(key: 'owners') != null) {
      LocalStorage.removeData(key: 'owners');
    }
    if (LocalStorage.getData(key: 'reasons') != null) {
      LocalStorage.removeData(key: 'reasons');
    }
     // allData.getAll().then((value) {
     //   getCategories();
     //   getNotes();
     //   getPaymentCustomers();
     //   // switchLoading(false);
     //   // displayToastMessage("refreshCompleted".tr(), false);
     // });

    getSecondScreenImages();
    // if(!synchronized)
    getAllData();
    notifyListeners();
  }

 Future getAllData()async{
    if(!disposed) {
      allData.getAll().then((value) {
        getCategories();
        getNotes();
        getPaymentCustomers();
        switchLoading(false);
        if (!value) {
          testToken();
        }
      });
    }
  }

  String getLanguage() {
    lan = LocalStorage.getData(key: 'language');
    notifyListeners();
    return lan;
  }

  changeLanguage(BuildContext context,String language) {
  if(language != lan) {
      language == 'en'
          ? context.setLocale(Locale('en'))
          : context.setLocale(Locale('ar'));
      language = context.locale.languageCode;
      lan = language;
      LocalStorage.saveData(key: 'language', value: language);
      categories = [];
      products = [];
      optionsList = [];
      synchronize(context);
    }

    notifyListeners();
  }

  chooseClient({ required OrderDetails orderDetails ,ClientModel? client}){

    if(client!=null)
    {
      orderDetails.clientPhone = client.phone!;
      orderDetails.clientName = client.name!;
      customerPhone.text = client.phone!;
      customerName.text = client.name!;

    }
    else{

      orderDetails.clientPhone = customerPhone.text;
      orderDetails.clientName = customerName.text;
    }
    clients = [];
    if(client!=null)
    clients.add(client);
    else
      clients.add(ClientModel(
        name: customerName.text,
        phone: customerPhone.text,
        balance: '0',
          points: '0',
        allowCreateOrder: 'true'
      ));


    notifyListeners();
  }


  onSearchTextChanged(String text) async {

    clientsLoading = true;
    final data = await productsRepo.searchClient(
        LocalStorage.getData(key: 'token'),text);
    clients = List<ClientModel>.from(
        data.map((client) => ClientModel.fromJson(client)));
    clientsLoading = false;
  notifyListeners();

}

  Future getProducts(int id, bool clear) async {


    products = [];
    products = await allData.getProducts(id);

    if(clear) {

      products.forEach((element2) {
        if (LocalStorage.getData(key: 'productDetails${element2.id}')
            .toString() != 'null')
          LocalStorage.removeData(key: 'productDetails${element2.id}');
      });
      LocalStorage.removeData(key: 'products${id}');
      products.clear();
    }

    // products.forEach((element) {
    //    getProductDetails(int.parse(element.id!),element);
    // });
    notifyListeners();
  }

  Future getProductDetails({required int index , required bool customerPrice}) async {
     attributes = await allData.getProductDetails(products[index].id!);
     int numberOfRequiredElements = 0;
    attributes.forEach((element) {

      if(element.required == 1) {
        numberOfRequiredElements += 1;
        print(numberOfRequiredElements);
      }
      element.values!.forEach((element2) {element2.chosen = false;
      if(customerPrice)
        element2.realPrice = element2.customerPrice;
      else
        element2.realPrice = element2.price;
      });

    // if(element.required == 1 && orderDetails.cart![productCartIndex].attributes!.length< numberOfRequiredElements){
      // editAttributes(orderDetails: orderDetails ,valueIndex:0,attributeIndex: attributes.indexOf(element) ,
      //     productIndex :productCartIndex,
      //     update: !orderDetails.cart![productCartIndex].newInCart!);
    // }
    });

     notifyListeners();
  }


  Future getNotes() async {
      optionsList = List<NotesModel>.from(json
          .decode(LocalStorage.getData(key: 'options'))
          .map((e) => NotesModel.fromJson(e)));
    notifyListeners();
  }

  Future getSecondScreenImages()async{
    branchScreenImages = [];
   var data = await productsRepo.getSecondScreenPicture();

   if(data != false) {
     secondScreenDuration = int.parse(data['seconds'].toString());
     data['screens'].forEach((e) {
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
    if(branchScreenImages.isNotEmpty) {
      branchImagesTimer = Timer.periodic(Duration(seconds: secondScreenDuration), (timer) {
        channel.invokeMethod("showImage",
            [branchScreenImages[Random().nextInt(branchScreenImages.length)]]);
      });
    }
    notifyListeners();
  }



  Future expense() async {
    var data = productsRepo.expense(LocalStorage.getData(key: 'token'),
        LocalStorage.getData(key: 'language'), {
      'title': expenseDescription.text,
      'price': int.parse(cashOutAmount.text),
      'branch_id': LocalStorage.getData(key: 'branch')
    });
    if (data != false) {
      expenseDescription.text = '';
      cashOutAmount.text = '';
      displayToastMessage('Expense Created Successfully', false);
    }

    notifyListeners();
  }




  // itemCount({required OrderDetails orderDetails,required int value,}){
  //   orderDetails.textCountController(chosenItem!,value);
  //   notifyListeners();
  // }


  updateAttributes( {required OrderDetails orderDetails,
    required int attributeIndex }){
    deleteFromOrder(orderDetails.cart![chosenItem!].rowId!);
    orderDetails.cart![chosenItem!].rowId = null;

    orderDetails.cart![chosenItem!].updated = true;
    int removeAt = 0;
    orderDetails.cart![chosenItem!].attributes!.removeWhere((element) =>
    attributes[attributeIndex].title!.en == element.title!.en );
    orderDetails.cart![chosenItem!].allAttributesID!.forEach((element) {
      attributes[attributeIndex].values!.forEach((element2) {
        if(element == element2.id)
          removeAt = orderDetails.cart![chosenItem!].allAttributesID!.indexOf(element);
      });
    });
    orderDetails.cart![chosenItem!].allAttributesID!.removeAt(removeAt);
    notifyListeners();
  }


  // void editAttributes(
  // {required OrderDetails orderDetails,required int valueIndex,
  //   required int attributeIndex ,required int productIndex}){
  //
  //
  //   //
  //   // if(!attributes[attributeIndex].values![valueIndex].chosen!) {
  //   //
  //   //
  //   //   orderDetails.addAttributes(attributes[attributeIndex],
  //   //       productIndex, attributes[attributeIndex].values![valueIndex]);
  //   // }
  //   //
  //   // else if(attributes[attributeIndex].values![valueIndex].chosen!){
  //   //   // int attributeIndexInsideCart = orderDetails.cart![productIndex].attributes!.indexOf(attributes[attributeIndex]);
  //   //   orderDetails.removeAttributes(attributes[attributeIndex], productIndex,
  //   //       attributes[attributeIndex].values![valueIndex],attributeIndex);
  //   //
  //   // }
  //
  //   notifyListeners();
  // }



  getNewMobileOrders() async{
      var data = await productsRepo.getNewMobileOrders(LocalStorage.getData(key: 'token'));
      if(data!=false && data!=0){
        ordersCount = data;
        playSound();
      }
      notifyListeners();
  }





  void displayToastMessage(var toastMessage, bool alert) {
    showSimpleNotification(
        Container(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(
              child: Text(
                toastMessage,
                style: TextStyle(
                    color: alert ? Colors.white : Constants.mainColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
        duration: Duration(seconds: 3),
        elevation: 2,
        background: alert ? Colors.red[500] : Constants.secondryColor);
  }
}
