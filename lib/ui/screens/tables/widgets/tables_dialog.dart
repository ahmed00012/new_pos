import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/tables_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/bottom_nav_bar.dart';
import '../../../../constants/colors.dart';
import '../../../../data_controller/cart_controller.dart';
import 'num_of_guests.dart';


class TablesDialog extends ConsumerWidget {
  const TablesDialog({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final tablesController = ref.watch(tablesFuture);
    final cartController = ref.watch(cartFuture);
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
        shrinkWrap: true,
        itemCount: tablesController.departments.length,
        padding: EdgeInsets.symmetric(horizontal: 20),
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
                physics:const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 1.5,
                ),
                itemBuilder: (context, i) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 2,
                    child: InkWell(
                      onTap: () {
                        if(tablesController.departments[index].tables![i].currentOrder==null
                            && cartController.orderDetails.cart.isNotEmpty) {

                          ConstantStyles.showPopup(context: context,
                              height: size.height*0.7,
                              content:const CountOfGuests(),
                              title: 'guests'.tr()).then((value) {
                                if(value!=null) {

                              // tablesController.reserveTable(
                              //     order: cartController.orderDetails,
                              //     i: i,
                              //     count: value,
                              //     table: tablesController
                              //         .departments[index].tables![i]);
                                  cartController.orderDetails.table = tablesController.departments[index].
                                  tables![i].id.toString();
                                  cartController.orderDetails.tableTitle =  tablesController.departments[index].
                                  tables![i].title;
                                  cartController.orderDetails.department = tablesController.departments[index].title;
                                  cartController.orderDetails.orderMethod = 'restaurant';
                                  cartController.orderDetails.orderMethodId = 2;
                                    Navigator.pop(context, true);
                            }
                          });

                        }
                        else if(tablesController.departments[index].tables![i].currentOrder!=null){
                          tablesController.displayToastMessage('Table Busy', true);
                        }

                        else{

                          tablesController.displayToastMessage('No order found', true);
                        }
                        // tablesController.confirmOrderPrinter(index, i, context, size, homeController, printerController);
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
                    ),
                  );
                },
              ),
            ],
          );
        });
  }
}
