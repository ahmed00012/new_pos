import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/colors.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/home/widgets/branch_close_widget.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/home/widgets/category_item.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/home/widgets/product_item.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/home/widgets/single_item.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/home/widgets/upper_row.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/custom_button.dart';

import '../../../constants/styles.dart';
import '../../../data_controller/cart_controller.dart';
import '../../../data_controller/mobile_order_controller.dart';
import '../../../data_controller/new_order_controller.dart';
import '../../widgets/custom_text_field.dart';
import '../cart/cart_screen.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  NewHomeState createState() => NewHomeState();
}

class NewHomeState extends ConsumerState<Home> {
  TextEditingController anotherOption = TextEditingController();




  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(dataFuture);
    final cartController = ref.watch(cartFuture);
    // final orderMobile = ref.watch(mobileOrdersFuture(true));
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: false,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 4, 5),
                child: Cart(navigate: true),
              ),
              Expanded(
                child: Column(children: [
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
                                          ? CategoryItem(
                                          onTap: () {
                                            viewModel.chooseCategory(0);
                                          },
                                          title: 'options'.tr(),
                                          color: viewModel.options
                                              ? Constants.secondryColor
                                              : Constants.mainColor)
                                          : CategoryItem(
                                          onTap: () {
                                            viewModel.chooseCategory(i);
                                          },
                                          title: viewModel
                                              .categories[i - 1].title!.en!,
                                          color:
                                          viewModel.categories[i - 1].chosen
                                              ? Constants.secondryColor
                                              : Constants.mainColor);
                                    }),
                              ),
                              Expanded(
                                  child: viewModel.loading
                                      ? Container()
                                      : GridView.builder(
                                      itemCount: viewModel.options
                                          ? viewModel.optionsList.length + 1
                                          : viewModel.products.length,
                                      shrinkWrap: true,
                                      gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        childAspectRatio:
                                        viewModel.options ? 1.6 : 1,
                                      ),
                                      itemBuilder: (context, i) {
                                        return viewModel.options &&
                                            i == viewModel.optionsList.length
                                            ? ProductItemWidget(
                                          onTap: () {
                                            ConstantStyles.showPopup(
                                              context: context,
                                              title: 'anotherOption'.tr(),
                                              content: CustomTextField(
                                                controller: anotherOption,
                                                label: 'anotherOption'.tr(),
                                              ),
                                            );
                                          },
                                          title: 'anotherOption'.tr(),
                                        )
                                            : ProductItemWidget(
                                            onTap: () {
                                              if (!viewModel.options) {
                                                cartController.insertCart(
                                                    viewModel.products[i]);

                                                ConstantStyles.showPopup(
                                                    context: context,
                                                    content: SingleItem(
                                                      index: cartController
                                                          .orderDetails
                                                          .cart!
                                                          .length -
                                                          1,
                                                      customer: cartController
                                                          .orderDetails
                                                          .customer !=
                                                          null,
                                                      optionList: viewModel
                                                          .optionsList,
                                                      productID: viewModel
                                                          .products[i].id!,
                                                    ),
                                                    title: '');
                                              } else {
                                                cartController.insertOption(
                                                    indexOfProduct:
                                                    cartController
                                                        .orderDetails
                                                        .cart!
                                                        .length -
                                                        1,
                                                    note: viewModel
                                                        .optionsList[i]);
                                              }
                                            },
                                            title: viewModel.options
                                                ? viewModel
                                                .optionsList[i].titleEn!
                                                : viewModel
                                                .products[i].title!.en!,
                                            image: viewModel
                                                .products[i].image!.image!,
                                            price: viewModel.options
                                                ? viewModel.optionsList[i]
                                                .price !=
                                                0
                                                ? '${viewModel.optionsList[i].price!} SAR'
                                                : ''
                                                : cartController.orderDetails
                                                .customer !=
                                                null
                                                ? '${viewModel.products[i].customerPrice!} SAR'
                                                : '${viewModel.products[i].price!} SAR');

                                        // InkWell(
                                        //         onTap: () {
                                        //           if (!viewModel.options) {
                                        //             cartController.insertCart(
                                        //                 viewModel.products[i]);
                                        //             // viewModel.chosenItem = cartController
                                        //             //         .orderDetails.cart!.length - 1;
                                        //
                                        //             viewModel.getProductDetails(
                                        //                 productID:
                                        //                     viewModel.products[i].id!,
                                        //                 customerPrice: cartController
                                        //                         .orderDetails.customer !=
                                        //                     null);
                                        //
                                        //
                                        //
                                        //             // viewModel
                                        //             //     .getProductDetails(
                                        //             //         index: i,
                                        //             //         customerPrice: cartController
                                        //             //                 .orderDetails
                                        //             //                 .customer !=
                                        //             //             null)
                                        //             //     .then((value) {
                                        //             //   if (viewModel.attributes.isNotEmpty)
                                        //             //     viewModel.switchToCardItemWidget(
                                        //             //         true,
                                        //             //         i: cartController.orderDetails
                                        //             //                 .cart!.length -
                                        //             //             1);
                                        //             // });
                                        //
                                        //             showDialog(
                                        //                 context: context,
                                        //                 builder: (context) => AlertDialog(
                                        //                       content: Container(
                                        //                           height:
                                        //                               size.height * 0.8,
                                        //                           width: size.width * 0.7,
                                        //                           child: SingleItem()),
                                        //                     ));
                                        //           } else {
                                        //             cartController.insertOption(
                                        //                 indexOfProduct: cartController
                                        //                         .orderDetails
                                        //                         .cart!
                                        //                         .length -
                                        //                     1,
                                        //                 note: viewModel.optionsList[i]);
                                        //           }
                                        //         },
                                        //         child: Padding(
                                        //           padding: const EdgeInsets.fromLTRB(
                                        //               5, 0, 5, 10),
                                        //           child: Card(
                                        //             shape: RoundedRectangleBorder(
                                        //               borderRadius:
                                        //                   BorderRadius.circular(10),
                                        //             ),
                                        //             child: Container(
                                        //                 decoration: BoxDecoration(
                                        //                   borderRadius:
                                        //                       BorderRadius.circular(10),
                                        //                   border: Border.all(
                                        //                       color: viewModel.options
                                        //                           ? viewModel
                                        //                                       .optionsList[
                                        //                                           i]
                                        //                                       .onHover ??
                                        //                                   false
                                        //                               ? Constants
                                        //                                   .mainColor
                                        //                               : Colors.white
                                        //                           : viewModel.products[i]
                                        //                                       .onHover ??
                                        //                                   false
                                        //                               ? Constants
                                        //                                   .mainColor
                                        //                               : Colors.white),
                                        //                   color: Colors.white,
                                        //                 ),
                                        //                 child: Column(
                                        //                   mainAxisAlignment:
                                        //                       MainAxisAlignment
                                        //                           .spaceBetween,
                                        //                   children: [
                                        //                     Padding(
                                        //                       padding: const EdgeInsets
                                        //                           .fromLTRB(2, 5, 2, 0),
                                        //                       child: Text(
                                        //                         viewModel.options
                                        //                             ? viewModel
                                        //                                 .optionsList[i]
                                        //                                 .titleEn!
                                        //                             : viewModel
                                        //                                 .products[i]
                                        //                                 .title!
                                        //                                 .en!,
                                        //                         overflow:
                                        //                             TextOverflow.ellipsis,
                                        //                         maxLines: 2,
                                        //                         textAlign:
                                        //                             TextAlign.center,
                                        //                         style: TextStyle(
                                        //                           height:
                                        //                               !viewModel.options
                                        //                                   ? 1.1
                                        //                                   : 1.5,
                                        //                           fontSize:
                                        //                               size.height * 0.02,
                                        //                         ),
                                        //                       ),
                                        //                     ),
                                        //                     if (!viewModel.options &&
                                        //                         viewModel.products[i]
                                        //                                 .image !=
                                        //                             null)
                                        //                       Image.network(
                                        //                         viewModel.products[i]
                                        //                             .image!.image!,
                                        //                         height:
                                        //                             size.height * 0.095,
                                        //                       ),
                                        //                     viewModel.options
                                        //                         ? viewModel.optionsList[i]
                                        //                                     .price !=
                                        //                                 0
                                        //                             ? Text(
                                        //                                 viewModel
                                        //                                         .optionsList[
                                        //                                             i]
                                        //                                         .price!
                                        //                                         .toString() +
                                        //                                     ' SAR',
                                        //                                 style: TextStyle(
                                        //                                     fontSize:
                                        //                                         size.height *
                                        //                                             0.022,
                                        //                                     color: Constants
                                        //                                         .secondryColor,
                                        //                                     fontWeight:
                                        //                                         FontWeight
                                        //                                             .bold),
                                        //                               )
                                        //                             : Container()
                                        //                         : cartController
                                        //                                     .orderDetails
                                        //                                     .customer ==
                                        //                                 null
                                        //                             ? viewModel
                                        //                                         .products[
                                        //                                             i]
                                        //                                         .price !=
                                        //                                     '0'
                                        //                                 ? Text(
                                        //                                     viewModel
                                        //                                             .products[
                                        //                                                 i]
                                        //                                             .price! +
                                        //                                         ' SAR',
                                        //                                     style: TextStyle(
                                        //                                         fontSize:
                                        //                                             size.height *
                                        //                                                 0.022,
                                        //                                         color: Constants
                                        //                                             .secondryColor,
                                        //                                         fontWeight:
                                        //                                             FontWeight
                                        //                                                 .bold),
                                        //                                   )
                                        //                                 : Container()
                                        //                             : viewModel
                                        //                                         .products[
                                        //                                             i]
                                        //                                         .customerPrice !=
                                        //                                     '0'
                                        //                                 ? Text(
                                        //                                     viewModel
                                        //                                             .products[
                                        //                                                 i]
                                        //                                             .customerPrice! +
                                        //                                         ' SAR',
                                        //                                     style: TextStyle(
                                        //                                         fontSize:
                                        //                                             size.height *
                                        //                                                 0.022,
                                        //                                         color: Constants
                                        //                                             .secondryColor,
                                        //                                         fontWeight:
                                        //                                             FontWeight
                                        //                                                 .bold),
                                        //                                   )
                                        //                                 : Container(),
                                      }))
                            ],
                          )),
                    ),
                  if (viewModel.branchClosed) BranchClosed(),
                  SizedBox(
                    height: size.height * 0.105,
                  )
                ]),
              ),
            ],
          ),

          if(viewModel.loading)
            ConstantStyles.circularLoading()
        ],
      ),
    );
  }
}
