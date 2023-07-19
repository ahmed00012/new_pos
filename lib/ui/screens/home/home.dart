
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/colors.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/cart_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/models/cart_model.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/payment/payment_screen.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/home/widgets/single_item.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/bottom_nav_bar.dart';
import '../../../constants/enums.dart';
import '../../../data_controller/home_controller.dart';
import '../../../local_storage.dart';
import '../../../models/orders_model.dart';
import '../cart/cart_screen.dart';
import 'new_home.dart';
import '../order_method/order_method_screen.dart';



class Home extends ConsumerStatefulWidget {
  final OrdersModel? order ;
  const Home({Key? key , this.order}): super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends ConsumerState<Home> {



  @override
  void initState() {
    // TODO: implement initState
    if(widget.order!=null){
      ref.watch(cartFuture).editOrder(widget.order!);
      if(widget.order!.paymentCustomerId!=null) {
        ref.watch(dataFuture).paymentCustomers.forEach((element) {
          if (element.id == widget.order!.paymentCustomerId)
            element.chosen = true;
        });
        if ( widget.order!.orderStatusId == 4 &&
            widget.order!.orderMethodId != 2 &&
            widget.order!.paymentStatus == 0) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => PaymentScreen(order:  ref.watch(cartFuture).orderDetails,)));
        }
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(dataFuture);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: false,
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: () {
          // viewModel.switchToOrderMethodWidget(false);
          // viewModel.switchToPaymentWidget(false);
          viewModel.switchToCardItemWidget(false);
          return Future.value(false);
        },
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (viewModel.selectedTab == SelectedTab.home)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 4, 5),
                            child: Cart(navigate: true),
                  ),
                // viewModel.itemWidget ? Expanded(child: SingleItem()):
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              viewModel.selectedTab ==
                                  SelectedTab.home
                                  ? ProductsScreen()
                                  : viewModel.current,

                              ///////////////////////////////// bottom nav bar//////////////////////
                              Align(
                                alignment: LocalStorage.getData(key: 'language')=='ar'?
                                Alignment.centerLeft:Alignment.centerRight,
                                child: Container(
                                    width: size.width * 0.7,
                                    child: BottomNavBar()
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if(viewModel.loading)
              Container(
                height: size.height,
                width: size.width,
                color: Colors.white.withOpacity(0.8),
                child: Center(
                  child:
                  LoadingAnimationWidget.inkDrop(
                    color: Constants.mainColor,
                    size: size.height*0.2,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
