
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/tables_controller.dart';
import '../../../constants/colors.dart';
import '../../../data_controller/cart_controller.dart';
import 'widgets/num_of_guests.dart';
import '../reciept/receipt_screen.dart';
import '../cart/cart_screen.dart';

class TablesScreen extends ConsumerWidget {
  // ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tablesController = ref.watch(tablesFuture);

    final cartController = ref.watch(cartFuture);
    // final printerController = ref.watch(printerFuture);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Cart(navigate: true,)

              ),
              Expanded(
                child:Stack(
                  children: [
                      //
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20),
                      //   child: Container(
                      //     width: size.width * 0.3,
                      //     child: Receipt(screenshotController: screenshotController,
                      //         order: cartController.orderDetails,
                      //         onScreenShot: (){}),
                      //   ),
                      // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: size.width ,
                        height: size.height,
                        color: Constants.scaffoldColor,
                      ),
                    ),
                    Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: tablesController.departments.length,
                              itemBuilder: (context, index) {
                                return ListView(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    SizedBox(
                                      height: 35,
                                    ),
                                    Center(
                                      child: Text(
                                        tablesController.departments[index].title!,
                                        style: TextStyle(
                                            fontSize: size.height * 0.03,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            color: Constants.lightBlue),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    GridView.builder(
                                      itemCount:
                                      tablesController.departments[index].tables!.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 6,
                                        childAspectRatio: 1.5,
                                      ),
                                      itemBuilder: (context, i) {
                                        return Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          elevation: 2,
                                          child: Consumer(
                                            builder: (context, ref , child) {
                                              final homeController = ref.watch(dataFuture);
                                              return InkWell(
                                                onTap: () {
                                                  if(tablesController.departments[index].tables![i].currentOrder==null
                                                  && cartController.orderDetails.cart!=null) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                            backgroundColor:
                                                                Constants
                                                                    .scaffoldColor,
                                                            title: Center(
                                                              child: Text(
                                                                'Count Of Guests',
                                                                style: TextStyle(
                                                                  fontSize:
                                                                      size.height *
                                                                          0.03,
                                                                ),
                                                              ),
                                                            ),
                                                            content: CountOfGuests());
                                                      }).then((value) {
                                                    if (value != null) {

                                                      // tablesController
                                                      //     .reserveTable(
                                                      //         index,
                                                      //         tablesController
                                                      //             .departments[
                                                      //                 index]
                                                      //             .tables![i],
                                                      //         value,
                                                      //         context,false,
                                                      //     cartController.orderDetails)
                                                      //     .then((value) {
                                                      //   // homeController.selectedTab =
                                                      //   //     SelectedTab.home;
                                                      // });
                                                    }
                                                  });
                                                }
                                                  else if(tablesController.departments[index].tables![i].currentOrder!=null){
                                                    tablesController.getCurrentOrder( index, i);
                                                  }

                                                  else{

                                                    tablesController.displayToastMessage('No order found', true);
                                                  }
                                                // tablesController.confirmOrderPrinter(index, i, context, size, cartController, printerController);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: tablesController
                                                          .departments[index]
                                                          .tables![i]
                                                          .currentOrder !=
                                                          null ||
                                                          tablesController.departments[index]
                                                              .tables![i].chosen!
                                                          ? Constants.mainColor
                                                          : Colors.white,
                                                      borderRadius:
                                                      BorderRadius.circular(10.0),
                                                      border: Border.all(
                                                          color: Constants.mainColor,)),
                                                  child: Center(
                                                    child: Text(
                                                      tablesController
                                                          .departments[index].tables![i].title!.toString(),
                                                      style: TextStyle(
                                                          color: tablesController
                                                              .departments[index]
                                                              .tables![i]
                                                              .currentOrder !=
                                                              null ||
                                                              tablesController
                                                                  .departments[index]
                                                                  .tables![i]
                                                                  .chosen!
                                                              ? Colors.white
                                                              : Constants.mainColor,
                                                          fontSize: size.height * 0.03),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              }),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                    if(tablesController.loading)
                      Container(
                        height: size.height,
                        width: size.width,
                        color: Colors.white.withOpacity(0.5),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Constants.mainColor,
                          ),
                        ),
                      )
                  ],
                )
              )
            ],
          ),

        ],
      ),
    );
  }
}
