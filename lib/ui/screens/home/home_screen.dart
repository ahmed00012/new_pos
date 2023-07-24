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
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/custom_progress_indicator.dart';

import '../../../constants/styles.dart';
import '../../../data_controller/cart_controller.dart';
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
                                width: size.width * 0.1,
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
                                              titleColor: Colors.white,
                                              color: viewModel.options
                                                  ? Constants.secondryColor
                                                  : Constants.mainColor)
                                          : CategoryItem(
                                              onTap: () {
                                                viewModel.chooseCategory(i);
                                              },
                                              title: viewModel
                                                  .categories[i - 1].title!.en!,
                                              borderColor: viewModel
                                                      .categories[i - 1].chosen
                                                  ? Constants.secondryColor
                                                  : Constants.mainColor,
                                              titleColor: Colors.black,
                                            );
                                    }),
                              ),
                              Expanded(
                                  child: viewModel.loading
                                      ? const CustomProgressIndicator()
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
                                                    i ==
                                                        viewModel
                                                            .optionsList.length
                                                ? ProductItemWidget(
                                                    onTap: () {
                                                      ConstantStyles.showPopup(
                                                        context: context,
                                                        title: 'anotherOption'
                                                            .tr(),
                                                        content:
                                                            CustomTextField(
                                                          controller:
                                                              anotherOption,
                                                          label: 'anotherOption'
                                                              .tr(),
                                                        ),
                                                      );
                                                    },
                                                    title: 'anotherOption'.tr(),
                                                  )
                                                : viewModel.options
                                                 ? ProductItemWidget(
                                                        onTap: () {
                                                          cartController.insertOption(
                                                              indexOfProduct:
                                                                  cartController
                                                                          .orderDetails
                                                                          .cart
                                                                          .length -
                                                                      1,
                                                              note: viewModel
                                                                  .optionsList[i]);
                                                        },
                                                        title: viewModel
                                                            .optionsList[i]
                                                            .titleEn!,
                                                        price: viewModel
                                                                    .optionsList[
                                                                        i]
                                                                    .price !=
                                                                0
                                                            ? '${viewModel.optionsList[i].price!} SAR'
                                                            : '')
                                                : ProductItemWidget(
                                                        onTap: () {
                                                          cartController
                                                              .insertCart(viewModel
                                                                  .products[i]);

                                                          ConstantStyles
                                                              .showPopup(
                                                                  context:
                                                                      context,
                                                                  content:
                                                                      SingleItem(
                                                                    index: cartController
                                                                            .orderDetails
                                                                            .cart
                                                                            .length -
                                                                        1,
                                                                    customer: cartController
                                                                            .orderDetails
                                                                            .customer !=
                                                                        null,
                                                                    optionList:
                                                                        viewModel
                                                                            .optionsList,
                                                                    productID:
                                                                        viewModel
                                                                            .products[i]
                                                                            .id!,
                                                                  ),
                                                                  title: '');
                                                        },
                                                        title: viewModel
                                                            .products[i]
                                                            .title!
                                                            .en!,
                                                        image: viewModel
                                                            .products[i]
                                                            .image!
                                                            .image!,
                                                        price: cartController
                                                                    .orderDetails
                                                                    .customer !=
                                                                null
                                                            ? '${viewModel.products[i].customerPrice!} SAR'
                                                            : '${viewModel.products[i].price!} SAR');
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
          if (viewModel.loading) ConstantStyles.circularLoading()
        ],
      ),
    );
  }
}
