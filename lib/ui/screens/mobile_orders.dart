import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shormeh_pos_new_28_11_2022/constants.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/filter_widget.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/numpad.dart';

import '../../data_controller/home_controller.dart';
import '../../data_controller/mobile_order_controller.dart';
import '../../local_storage.dart';
import '../widgets/filter_mobile_widget.dart';
import 'mobile_order_items.dart';


class MobileOrders extends ConsumerWidget  {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(mobileOrdersFuture(false));
    // final homeController = ref.watch(dataFuture);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Column(
          children: [

            Container(
              height: size.height * 0.12,
              width: size.width,
              alignment: Alignment.center,
              child: ListView.builder(
                  itemCount: viewModel.orderStatus.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,

                  itemBuilder: (context, i) {
                    return InkWell(
                      onTap: () {
                        if (viewModel.orderStatus[i].id != null)
                          viewModel.orderStatusFilter(
                              i, viewModel.orderStatus[i].id!);
                        else
                          viewModel.allFilter();
                      },
                      child: Container(
                          width: size.width * 0.13,
                          decoration: BoxDecoration(
                              color: viewModel.orderStatus[i].chosen!
                                  ? Constants.secondryColor
                                  : Constants.mainColor,
                              border: Border.all(color: Colors.white,)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 5,),
                              Image.asset(
                                viewModel.images[i],
                                color:  Colors.white,
                                width: size.width*0.05,
                                height: size.height*0.05,
                              ),
                              Spacer(),
                              Text(
                                viewModel.orderStatus[i].title!.en!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height * 0.019,
                                    height: 1,
                                    letterSpacing: 0.1
                                ),
                              ),
                              SizedBox(height: 5,),
                            ],
                          )),
                    );
                  }),
            ),
            Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                        height: size.height ,
                        width: size.width * 0.28,
                        child: Card(
                            elevation: 5,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child:
                            viewModel.chosenOrder!=null?
                            MobileOrderItems():Container())),
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
                                          color: Colors.black26,
                                          width: 1.2),
                                      borderRadius:
                                      BorderRadius.circular(10)),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: TextFormField(
                                            controller:
                                            viewModel.clientSearch,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.all(10),
                                              hintText: 'client'.tr(),
                                              hintStyle: TextStyle(
                                                color:
                                                Constants.mainColor,
                                              ),
                                              border: InputBorder.none,
                                              icon: Icon(
                                                Icons.person,
                                                color:
                                                Constants.mainColor,
                                              ),
                                            ),

                                            // onChanged: (value){
                                            //   viewModel.searchClient(value);
                                            // },
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment:
                                        Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () {
                                            viewModel.searchClient();
                                          },
                                          child: Container(
                                            width: size.width * 0.06,
                                            decoration: BoxDecoration(
                                                color: Constants
                                                    .mainColor,
                                                borderRadius:
                                                BorderRadius.only(
                                                    topRight: Radius
                                                        .circular(
                                                        8),
                                                    bottomRight: Radius
                                                        .circular(
                                                        8))),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: Constants
                                                  .scaffoldColor,
                                              content: Numpad(),
                                            );
                                          }).then((value) {
                                            if(value!=null)
                                              viewModel.searchOrder(int.parse(value)) ;
                                      });
                                    },
                                    child: Container(
                                        height: 55,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(
                                                10),
                                            border: Border.all(
                                                color: viewModel
                                                    .orderNum !=
                                                    null
                                                    ? Constants
                                                    .mainColor
                                                    : Colors.black26)),
                                        child: Padding(
                                          padding: const EdgeInsets
                                              .symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.search,
                                                color:
                                                Constants.mainColor,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  viewModel.orderNum !=
                                                      null
                                                      ? 'order'.tr() +
                                                      ' : ' +
                                                      viewModel
                                                          .orderNum
                                                          .toString()
                                                      : 'searchOrder'
                                                      .tr(),
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Constants
                                                          .mainColor,
                                                      fontSize:
                                                      size.height *
                                                          0.02),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: InkWell(
                                    onTap: () {
                                      if(viewModel.connected) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                height: size.height * 0.5,
                                                width: size.width * 0.7,
                                                child: AlertDialog(
                                                  backgroundColor:
                                                  Constants.scaffoldColor,
                                                  title: Center(
                                                      child: Text(
                                                        'filter'.tr(),
                                                        style: TextStyle(
                                                            fontSize:
                                                            size.height * 0.025,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      )),
                                                  content: FilterMobileWidget(),
                                                ),
                                              );
                                            });
                                      }
                                      else{
                                        viewModel.displayToastMessage('Bad Connection .....', true);
                                      }
                                    },
                                    child: Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          border: Border.all(
                                              color: viewModel
                                                  .orderNum !=
                                                  null
                                                  ? Constants.mainColor
                                                  : Colors.black26)),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.filter_alt_outlined,
                                              color:
                                              Constants.mainColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'filter'.tr(),
                                              style: TextStyle(
                                                  color: Constants
                                                      .mainColor,
                                                  fontSize:
                                                  size.height *
                                                      0.02),
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
                              // InkWell(
                              //     onTap: () {
                              //       viewModel.selectDate(context);
                              //     },
                              //     child: Icon(
                              //       Icons.date_range,
                              //       color: Constants.mainColor,
                              //       size: 35,
                              //     ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: viewModel.loading
                              ? const Center(
                            child: CircularProgressIndicator(
                              color: Constants.mainColor,
                              strokeWidth: 4,
                            ),
                          )
                              : SmartRefresher(
                            enablePullDown: false,
                            enablePullUp: true,
                            header: WaterDropHeader(),
                            controller:
                            viewModel.refreshController,
                            onLoading: viewModel.getOrders,
                            child: GridView.builder(
                              itemCount: viewModel.orders.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(right: 15),
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  childAspectRatio: 1.1),
                              itemBuilder: (context, i) {
                                return Stack(
                                  children: [
                                    Padding(
                                      padding:
                                      EdgeInsets.symmetric(
                                          vertical:10),
                                      child: Card(
                                        clipBehavior: Clip
                                            .antiAliasWithSaveLayer,
                                        elevation: 2,
                                        shape:
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius
                                              .circular(10.0),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            viewModel
                                                .chosenOrder = i;
                                            viewModel
                                                .chosenOrderNum =
                                                viewModel
                                                    .orders[i]
                                                    .uuid;
                                            viewModel.refresh();
                                          },
                                          child: Stack(
                                            children: [

                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        10),
                                                    border: Border.all(
                                                        color:
                                                        viewModel.orders[i].orderStatusId == 1?
                                                            Constants.mainColor:
                                                        viewModel.orders[i].paymentStatus==0 &&
                                                            viewModel.orders[i].orderStatusId != 5

                                                            ? Colors
                                                            .red
                                                            : Colors
                                                            .white)),
                                                child: Center(
                                                  child: Padding(
                                                      padding:
                                                      const EdgeInsets.all(
                                                          12),
                                                      child:
                                                      Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Text(
                                                            "order".tr() +
                                                                ' ${viewModel.orders[i].uuid}',
                                                            style: TextStyle(
                                                                color: Constants.mainColor,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: size.height * 0.02),
                                                          ),
                                                          // if (viewModel.orders[i].paymentCustomer !=
                                                          //     null)
                                                          //   Text(
                                                          //     viewModel.orders[i].paymentCustomer!,
                                                          //     style: TextStyle(
                                                          //         fontSize: size.height * 0.02,
                                                          //         fontWeight: FontWeight.bold,
                                                          //         color: Constants.mainColor),
                                                          //   ),
                                                          if( viewModel
                                                              .orders[i]
                                                              .orderMethodId!=2)
                                                            Text(
                                                              viewModel
                                                                  .orders[i]
                                                                  .orderMethod
                                                                  .toString(),
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: size.height * 0.02,
                                                                  color: Constants.lightBlue),
                                                            ),

                                                          if (viewModel.orders[i].orderStatusId ==
                                                              7)
                                                            Icon(
                                                              Icons.warning_amber_outlined,
                                                              color:
                                                              Colors.red[500],
                                                              size:
                                                              25,
                                                            ),

                                                          Spacer(),

                                                          if (viewModel.orders[i].clientPhone !=
                                                              null)
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [

                                                                Icon(Icons.phone,color: Constants.lightBlue,),
                                                                SizedBox(width: 10,),
                                                                Text(
                                                                  viewModel.orders[i].clientPhone!,
                                                                  style: TextStyle(
                                                                      fontSize: size.height * 0.02,
                                                                      color: Constants.lightBlue,
                                                                      fontWeight: FontWeight.bold),
                                                                ),

                                                              ],
                                                            ),



                                                        ],
                                                      )),
                                                ),
                                              ),
                                              if (viewModel
                                                  .orders[i]
                                                  .orderStatusId ==
                                                  5)
                                                Center(
                                                  child:
                                                  Image.asset(
                                                    'assets/images/cancelled.png',
                                                    color: Colors
                                                        .red
                                                        .withOpacity(
                                                        0.1),
                                                  ),
                                                ),
                                              if (viewModel
                                                  .orders[i]
                                                  .orderStatusId ==
                                                  8)
                                                Center(
                                                  child:
                                                  Image.asset(
                                                    'assets/images/ban-user.png',
                                                    color: Colors
                                                        .red
                                                        .withOpacity(
                                                        0.1),
                                                  ),
                                                ),
                                              if (viewModel
                                                  .orders[i]
                                                  .orderStatusId ==
                                                  6)
                                                Center(
                                                  child:
                                                  Image.asset(
                                                    'assets/images/stop-button.png',
                                                    color: Colors
                                                        .red
                                                        .withOpacity(
                                                        0.1),
                                                  ),
                                                ),
                                              if (viewModel
                                                  .orders[i]
                                                  .paymentMethodId ==
                                                  7)

                                                Center(
                                                  child:
                                                  Image.asset(
                                                    'assets/images/OnlinePayment.png',


                                                    height: size.height*00.14,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (viewModel.orders[i]
                                        .orderMethodId ==
                                        2)
                                      Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            shape:
                                            BoxShape.circle,
                                            color: Colors.white,
                                            border: Border.all(
                                              color: viewModel.orders[i].paymentStatus==0?Colors.red:
                                              Constants.mainColor,
                                            )),
                                        child: Center(
                                          child: Image.asset(
                                            'assets/images/chair(2).png',
                                            height: 30,
                                            color:viewModel.orders[i].paymentStatus==0?Colors.red:
                                            Constants.mainColor,
                                          ),
                                        ),
                                      ),

                                  ],
                                );
                              },
                            ),
                          )

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
        ));
  }
}
