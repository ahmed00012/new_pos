import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:shormeh_pos_new_28_11_2022/constants.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/single_item.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/upper_row.dart';

import '../../data_controller/cart_controller.dart';
import '../../data_controller/mobile_order_controller.dart';
import '../../data_controller/new_order_controller.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  NewHomeState createState() => NewHomeState();
}

class NewHomeState extends ConsumerState<ProductsScreen> {
  TextEditingController anotherOption = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(dataFuture);
    final cartController = ref.watch(cartFuture);
    final orderMobile = ref.watch(mobileOrdersFuture(true));

    // final printerController = ref.watch(printerFuture);
    // final orderController = ref.watch(newOrderFuture);
    // final orderController2 = ref.watch(orderMethodFuture);
    // final orderController = ref.watch(newOrderFuture);
    Size size = MediaQuery.of(context).size;
    return Column(children: [
      UpperRow(),
      SizedBox(
        height: 20,
      ),
      if (viewModel.branchClosed == false)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  child: ListView.builder(
                      itemCount: viewModel.categories.length + 1,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return i == 0
                            ? InkWell(
                                onTap: () {
                                  viewModel.chooseCategory(0);
                                },
                                child: Container(
                                  height: 50,
                                  color: viewModel.options
                                      ? Constants.secondryColor
                                      : Constants.mainColor,
                                  child: Center(
                                    child: Text(
                                      'options'.tr(),
                                      style: TextStyle(
                                          fontSize: size.height * 0.02,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  // viewModel
                                  //     .getProducts(viewModel.categories[i-1].id!);
                                  viewModel.chooseCategory(i);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Card(
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                              left: BorderSide(
                                                  color: viewModel
                                                              .categories[i - 1]
                                                              .chosen ??
                                                          false
                                                      ? Constants.secondryColor
                                                      : Constants.mainColor,
                                                  width: 7))),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: viewModel.categories[i - 1]
                                                      .title !=
                                                  null
                                              ? Text(
                                                  viewModel.categories[i - 1]
                                                      .title!.en!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.02,
                                                      color:
                                                          Constants.mainColor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              : Container(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                      }),
                ),
                Expanded(
                    child: viewModel.loading
                        ? Container()
                        : StatefulBuilder(builder: (context, setState) {
                            return GridView.builder(
                                itemCount: viewModel.options
                                    ? viewModel.optionsList.length + 1
                                    : viewModel.products.length,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: viewModel.options ? 1.6 : 1,
                                ),
                                itemBuilder: (context, i) {
                                  return viewModel.options &&
                                          i == viewModel.optionsList.length
                                      ? Theme(
                                          data: Theme.of(context).copyWith(
                                              splashFactory:
                                                  NoSplash.splashFactory,
                                              hoverColor: Colors.transparent),
                                          child: InkWell(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                        backgroundColor:
                                                            Constants
                                                                .scaffoldColor,
                                                        title: Center(
                                                          child: Text(
                                                            'anotherOption'
                                                                .tr(),
                                                            style: TextStyle(
                                                                fontSize:
                                                                    size.height *
                                                                        0.025),
                                                          ),
                                                        ),
                                                        content: Container(
                                                          width:
                                                              size.width * 0.4,
                                                          height: size.height *
                                                              0.25,
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Container(
                                                                height:
                                                                    size.height *
                                                                        0.1,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .black12,
                                                                        width:
                                                                            1.2),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10),
                                                                  child:
                                                                      TextField(
                                                                    controller:
                                                                        anotherOption,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      contentPadding:
                                                                          EdgeInsets.all(
                                                                              10),
                                                                      label:
                                                                          Text(
                                                                        'anotherOption'
                                                                            .tr(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              size.height * 0.02,
                                                                          color:
                                                                              Colors.black45,
                                                                        ),
                                                                      ),
                                                                      border: InputBorder
                                                                          .none,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height:
                                                                    size.height *
                                                                        0.04,
                                                              ),
                                                              //////////////////done button////////////////////////
                                                              InkWell(
                                                                onTap: () {
                                                                  cartController.addAnotherOption(
                                                                      index: i,
                                                                      anotherOption:
                                                                          anotherOption
                                                                              .text,
                                                                      itemWidget:
                                                                          viewModel
                                                                              .itemWidget);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      size.height *
                                                                          0.07,
                                                                  width:
                                                                      size.width *
                                                                          0.2,
                                                                  decoration: BoxDecoration(
                                                                      color: Constants
                                                                          .mainColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'ok'.tr(),
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              size.height * 0.025),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ));
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 0, 5, 10),
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Container(
                                                    height: 20,
                                                    width: 20,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            color: Constants
                                                                .mainColor)),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'addMore'.tr(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  size.height *
                                                                      0.02,
                                                              color: Constants
                                                                  .mainColor),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Icon(
                                                          Icons.add,
                                                          color: Constants
                                                              .mainColor,
                                                          size: size.height *
                                                              0.04,
                                                        )
                                                      ],
                                                    )),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Theme(
                                          data: Theme.of(context).copyWith(
                                              splashFactory:
                                                  NoSplash.splashFactory,
                                              hoverColor: Colors.transparent),
                                          child: InkWell(
                                            onHover: (value) {
                                              if (value) {
                                                setState(() {
                                                  viewModel.options
                                                      ? viewModel.optionsList[i]
                                                          .onHover = true
                                                      : viewModel.products[i]
                                                          .onHover = true;
                                                });
                                              } else {
                                                setState(() {
                                                  viewModel.options
                                                      ? viewModel.optionsList[i]
                                                          .onHover = false
                                                      : viewModel.products[i]
                                                          .onHover = false;
                                                });
                                              }
                                            },
                                            onTap: () {
                                              if (!viewModel.options) {
                                                cartController.insertCart(
                                                    viewModel.products[i]);
                                                viewModel.chosenItem =
                                                    cartController.orderDetails
                                                            .cart!.length -
                                                        1;
                                                viewModel
                                                    .getProductDetails(
                                                        index: i,
                                                        customerPrice:
                                                            cartController
                                                                    .orderDetails
                                                                    .customer !=
                                                                null)
                                                    .then((value) {
                                                  if (viewModel
                                                      .attributes.isNotEmpty)
                                                    viewModel
                                                        .switchToCardItemWidget(
                                                            true,
                                                            i: cartController
                                                                    .orderDetails
                                                                    .cart!
                                                                    .length -
                                                                1);
                                                });

                                                // showDialog(context: context,
                                                //     builder: (context)=>AlertDialog(
                                                //       content: Container(
                                                //           height: size.height*0.8,
                                                //           width: size.width*0.7,
                                                //           child: SingleItem()),
                                                //     ));
                                              } else
                                                cartController.insertOption(
                                                    indexOfProduct:
                                                        cartController
                                                                .orderDetails
                                                                .cart!
                                                                .length -
                                                            1,
                                                    note: viewModel
                                                        .optionsList[i]);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 0, 5, 10),
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: viewModel
                                                                  .options
                                                              ? viewModel
                                                                          .optionsList[
                                                                              i]
                                                                          .onHover ??
                                                                      false
                                                                  ? Constants
                                                                      .mainColor
                                                                  : Colors.white
                                                              : viewModel
                                                                          .products[
                                                                              i]
                                                                          .onHover ??
                                                                      false
                                                                  ? Constants
                                                                      .mainColor
                                                                  : Colors
                                                                      .white),
                                                      color: Colors.white,
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  2, 5, 2, 0),
                                                          child: Text(
                                                            viewModel.options
                                                                ? viewModel
                                                                    .optionsList[
                                                                        i]
                                                                    .titleEn!
                                                                : viewModel
                                                                    .products[i]
                                                                    .title!
                                                                    .en!,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              height: !viewModel
                                                                      .options
                                                                  ? 1.1
                                                                  : 1.5,
                                                              fontSize:
                                                                  size.height *
                                                                      0.02,
                                                            ),
                                                          ),
                                                        ),
                                                        if (!viewModel
                                                                .options &&
                                                            viewModel
                                                                    .products[i]
                                                                    .image !=
                                                                null)
                                                          Image.network(
                                                            viewModel
                                                                .products[i]
                                                                .image!
                                                                .image!,
                                                            height:
                                                                size.height *
                                                                    0.095,
                                                          ),
                                                        viewModel.options
                                                            ? viewModel
                                                                        .optionsList[
                                                                            i]
                                                                        .price !=
                                                                    0
                                                                ? Text(
                                                                    viewModel
                                                                            .optionsList[i]
                                                                            .price!
                                                                            .toString() +
                                                                        ' SAR',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            size.height *
                                                                                0.022,
                                                                        color: Constants
                                                                            .secondryColor,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )
                                                                : Container()
                                                            : cartController
                                                                        .orderDetails
                                                                        .customer ==
                                                                    null
                                                                ? viewModel
                                                                            .products[
                                                                                i]
                                                                            .price !=
                                                                        '0'
                                                                    ? Text(
                                                                        viewModel.products[i].price! +
                                                                            ' SAR',
                                                                        style: TextStyle(
                                                                            fontSize: size.height *
                                                                                0.022,
                                                                            color:
                                                                                Constants.secondryColor,
                                                                            fontWeight: FontWeight.bold),
                                                                      )
                                                                    : Container()
                                                                : viewModel.products[i]
                                                                            .customerPrice !=
                                                                        '0'
                                                                    ? Text(
                                                                        viewModel.products[i].customerPrice! +
                                                                            ' SAR',
                                                                        style: TextStyle(
                                                                            fontSize: size.height *
                                                                                0.022,
                                                                            color:
                                                                                Constants.secondryColor,
                                                                            fontWeight: FontWeight.bold),
                                                                      )
                                                                    : Container(),
                                                      ],
                                                    )),
                                              ),
                                            ),
                                          ),
                                        );
                                });
                          }))
              ],
            ),
          ),
        ),
      if (viewModel.branchClosed)
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/closed.png', height: size.height * 0.6),
            SizedBox(
              height: 20,
            ),
            Text(
              'closed'.tr(),
              style: TextStyle(
                  color: Colors.red,
                  fontSize: size.height * 0.025,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      SizedBox(
        height: size.height * 0.105,
      )
    ]);
  }
}
