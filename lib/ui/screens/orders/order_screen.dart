import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/colors.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/orders_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/orders/widgets/order_status_widget.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/orders/widgets/filter_widget.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/orders/widgets/order_widget.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/numpad.dart';
import '../../../models/orders_model.dart';
import 'widgets/order_items.dart';

class OrdersScreen extends StatefulWidget {
  OrdersScreen({super.key, required this.mobileOrders});
  final bool mobileOrders;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  TextEditingController clientSearch = TextEditingController();
  String orderNumSearch = '';
  ScrollController? controller;
  int? orderStatusIdFilter;
  int? orderMethodIdFilter;
  int? paymentIdFilter;
  int? ownerIdFilter;
  int? customerIdFilter;
  bool? paid;
  bool? notPaid;
  OrdersModel? chosenOrder;

  clearFilter() {
    setState(() {
      clientSearch = TextEditingController();
      orderNumSearch = '';
      orderStatusIdFilter = null;
      orderMethodIdFilter = null;
      paymentIdFilter = null;
      ownerIdFilter = null;
      customerIdFilter = null;
      paid = null;
      notPaid = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(body: Consumer(builder: (context, ref, child) {
      final ordersController = ref.watch(ordersFuture(widget.mobileOrders));
      return Column(
        children: [
          Container(
            height: size.height * 0.12,
            width: size.width,
            alignment: Alignment.center,
            child: ListView.builder(
                itemCount: ordersController.orderStatus.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) {
                  return InkWell(
                      onTap: () {
                        if (!ordersController.loading) {
                          if (ordersController.orderStatus[i].id != null) {
                            orderStatusIdFilter =
                                ordersController.orderStatus[i].id;
                            ordersController.getOrders(
                                page: 1,
                                mobileOrders: false,
                                orderStatus: orderStatusIdFilter);
                          } else {
                            clearFilter();
                            ordersController.getOrders(
                                page: 1, mobileOrders: false);
                          }
                        }
                      },
                      child: OrderStatusWidget(
                        title: ordersController.images[i],
                        color: ordersController.orderStatus[i].chosen
                            ? Constants.secondryColor
                            : Constants.mainColor,
                        image: ordersController.orderStatus[i].title!.en!,
                      ));
                }),
          ),
          Expanded(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                      height: size.height,
                      width: size.width * 0.28,
                      child: Card(
                          elevation: 5,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: chosenOrder != null
                              ? _buildOrderInvoiceScreen(order: chosenOrder!)
                              : Container())),
                ),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 55,
                        width: size.width,
                        alignment: Alignment.center,
                        child: Row(
                          // scrollDirection: Axis.horizontal,
                          // shrinkWrap: true,
                          children: [
                            Expanded(
                              flex: 6,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.black26, width: 1.2),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: TextFormField(
                                          controller: clientSearch,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(10),
                                            hintText: 'client'.tr(),
                                            hintStyle: TextStyle(
                                              color: Constants.mainColor,
                                            ),
                                            border: InputBorder.none,
                                            icon: Icon(
                                              Icons.person,
                                              color: Constants.mainColor,
                                            ),
                                          ),

                                          // onChanged: (value){
                                          //   viewModel.searchClient(value);
                                          // },
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () {
                                          ordersController.getOrders(
                                              page: 1,
                                              mobileOrders: false,
                                              client: clientSearch.text);
                                        },
                                        child: Container(
                                          width: size.width * 0.06,
                                          decoration: const BoxDecoration(
                                              color: Constants.mainColor,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(8),
                                                  bottomRight:
                                                      Radius.circular(8))),
                                          child: Center(
                                            child: Icon(
                                              Icons.search,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: InkWell(
                                  onTap: () {
                                    ConstantStyles.showPopup(
                                            context: context,
                                            content: Numpad(),
                                            title: '')
                                        .then((value) {
                                      if (value != null)
                                        ordersController.getOrders(
                                            page: 1,
                                            mobileOrders: false,
                                            orderId: int.parse(value));

                                      setState(() {
                                        orderNumSearch = value;
                                      });
                                    });
                                  },
                                  child: Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.search,
                                              color: Constants.mainColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                              child: Text(
                                                orderNumSearch.isNotEmpty
                                                    ? '${'order'.tr()} : $orderNumSearch'
                                                    : 'searchOrder'.tr(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Constants.mainColor,
                                                    fontSize:
                                                        size.height * 0.02),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: InkWell(
                                  onTap: () {
                                    // if(viewModel.connected) {
                                    ConstantStyles.showPopup(
                                      context: context,
                                      content: FilterWidget(
                                        orderMethods:
                                            ordersController.orderMethods,
                                        owners: ordersController.owners,
                                        paymentCustomers:
                                            ordersController.paymentCustomer,
                                        paymentMethods:
                                            ordersController.paymentMethods,
                                      ),
                                      title: 'filter'.tr(),
                                    ).then((customizedOrder) {
                                      if (customizedOrder != null) {
                                        orderMethodIdFilter =
                                            customizedOrder.orderMethodId;
                                        paymentIdFilter =
                                            customizedOrder.paymentMethod;
                                        ownerIdFilter = customizedOrder.owner;
                                        customerIdFilter =
                                            customizedOrder.paymentCustomerId;
                                        if (customizedOrder.paymentStatus !=
                                            null) {
                                          paid =
                                              customizedOrder.paymentStatus ==
                                                  1;
                                          notPaid =
                                              customizedOrder.paymentStatus ==
                                                  0;
                                        }

                                        ordersController.getOrders(
                                            page: 1,
                                            mobileOrders: false,
                                            orderStatus: orderStatusIdFilter,
                                            ownerId: ownerIdFilter,
                                            paymentMethod: paymentIdFilter,
                                            client: clientSearch.text,
                                            customer: customerIdFilter,
                                            orderMethod: orderMethodIdFilter,
                                            orderId: int.parse(orderNumSearch),
                                            notPaid: notPaid,
                                            paid: paid);
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 55,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: orderNumSearch.isNotEmpty
                                                ? Constants.mainColor
                                                : Colors.black26)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.filter_alt_outlined,
                                            color: Constants.mainColor,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'filter'.tr(),
                                            style: TextStyle(
                                                color: Constants.mainColor,
                                                fontSize: size.height * 0.02),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: ordersController.loading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Constants.mainColor,
                                  strokeWidth: 4,
                                ),
                              )
                            : GridView.builder(
                                controller: controller,
                                itemCount: ordersController.orders.length,
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(right: 15),
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5,
                                        childAspectRatio: 1.1),
                                itemBuilder: (context, i) {
                                  if (i == ordersController.orders.length - 1 &&
                                      ordersController.currentPage <
                                          ordersController.lastPage) {
                                    ordersController.getOrders(
                                        page: ordersController.currentPage + 1,
                                        mobileOrders: false,
                                        orderStatus: orderStatusIdFilter,
                                        ownerId: ownerIdFilter,
                                        paymentMethod: paymentIdFilter,
                                        client: clientSearch.text,
                                        customer: customerIdFilter,
                                        orderMethod: orderMethodIdFilter,
                                        orderId: int.parse(orderNumSearch),
                                        notPaid: notPaid,
                                        paid: paid);
                                  }
                                  return Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: size.height * 0.022),
                                        child: Card(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              // ordersController.chosenOrder = i;
                                              // ordersController.chosenOrderNum =
                                              //     ordersController
                                              //         .orders[i].uuid;
                                              setState(() {
                                                chosenOrder =
                                                    ordersController.orders[i];
                                              });
                                            },
                                            child: OrderWidget(
                                                order:
                                                    ordersController.orders[i]),
                                          ),
                                        ),
                                      ),
                                      // if (ordersController
                                      //         .orders[i].orderMethodId ==
                                      //     2)
                                      //   Container(
                                      //     height: 40,
                                      //     decoration: BoxDecoration(
                                      //         shape: BoxShape.circle,
                                      //         color: Colors.white,
                                      //         border: Border.all(
                                      //           color: ordersController.orders[i]
                                      //                       .ownerName !=
                                      //                   null
                                      //               ? Constants.secondryColor
                                      //               : ordersController.orders[i]
                                      //                           .paymentStatus ==
                                      //                       0
                                      //                   ? Colors.red
                                      //                   : Constants.mainColor,
                                      //         )),
                                      //     child: Center(
                                      //       child: Image.asset(
                                      //         'assets/images/chair(2).png',
                                      //         height: 30,
                                      //         color: ordersController.orders[i]
                                      //                     .paymentStatus == 0
                                      //             ? Colors.red
                                      //             : Constants.mainColor,
                                      //       ),
                                      //     ),
                                      //   ),
                                    ],
                                  );
                                },
                              ),
                      ),
                      SizedBox(
                        height: 70,
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      );
    }));
  }

  Widget _buildOrderInvoiceScreen({required OrdersModel order}) {
    return OrderItems(
      order: order,
      mobileOrders: false,
    );
  }
}
