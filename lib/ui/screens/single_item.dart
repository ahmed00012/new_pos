import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/models/notes_model.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/numpad.dart';

import '../../constants.dart';
import '../../data_controller/cart_controller.dart';
import '../widgets/attributes.dart';

class SingleItem extends ConsumerStatefulWidget {
  const SingleItem({Key? key}) : super(key: key);

  @override
  SingleItemState createState() => SingleItemState();
}

class SingleItemState extends ConsumerState<SingleItem> {

  TextEditingController anotherOption = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(dataFuture);
    final cartController = ref.watch(cartFuture);

    Size size = MediaQuery.of(context).size;
    return viewModel.chosenItem == null
        ? Container()
        : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,


              // shrinkWrap: true,

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        // if(viewModel.updateOrder)
                        //   viewModel.deleteFromOrder(cartController.cardItems[viewModel.chosenItem!].id!);
                        if(cartController.orderDetails.cart!.length>1)
                        cartController.removeCartItem(index: viewModel.chosenItem!);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: size.height * 0.15,
                          width: size.width * 0.1,
                          decoration: BoxDecoration(
                              color: Colors.red[500],
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Icon(
                              Icons.delete_outline,
                              size: size.height * 0.05,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // viewModel.plusController(viewModel.chosenItem!);
                        cartController.orderDetails.plusController(viewModel.chosenItem!);
                        viewModel.refreshList();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: size.height * 0.15,
                          width: size.width * 0.1,
                          decoration: BoxDecoration(
                              color: Constants.mainColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: size.height * 0.05,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // viewModel.minusController(viewModel.chosenItem!);
                        cartController.orderDetails.minusController(viewModel.chosenItem!);
                        viewModel.refreshList();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: size.height * 0.15,
                          width: size.width * 0.1,
                          decoration: BoxDecoration(
                              color: Constants.mainColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Icon(
                              Icons.minimize,
                              size: size.height * 0.05,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        cartController.orderDetails.cart![viewModel.chosenItem!].updated =
                            true;
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  backgroundColor: Constants.scaffoldColor,
                                  title: Center(
                                    child: Text(
                                      'qty'.tr(),
                                      style: TextStyle(
                                          fontSize: size.height * 0.025,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  content: Container(
                                      height: size.height * 0.55,
                                      child: Numpad()),
                                )).then((value){
                                  if(value!=null)
                          cartController.itemCount(index: viewModel.chosenItem! , value: int.parse(value));
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: size.height * 0.15,
                          width: size.width * 0.1,
                          decoration: BoxDecoration(
                              color: Constants.mainColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Icon(
                              Icons.keyboard,
                              size: size.height * 0.05,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        viewModel.switchToCardItemWidget(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: size.height * 0.15,
                          width: size.width * 0.1,
                          decoration: BoxDecoration(
                              color: Constants.mainColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                size: size.height * 0.05,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'back'.tr(),
                                style: TextStyle(
                                    fontSize: size.height * 0.019,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cartController.orderDetails.cart![viewModel.chosenItem!].count
                              .toString() +
                          'X     ' +
                          cartController
                              .orderDetails.cart![viewModel.chosenItem!].mainName!,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: size.height * 0.03,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 100,
                    ),
                    Text(
                      cartController.orderDetails.cart![viewModel.chosenItem!].total
                              .toString() +
                          ' SAR',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: size.height * 0.03,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),




                  AttributesWidget(productIndex: viewModel.chosenItem!),

                Container(
                  width: size.width,
                  child: Text(
                    'Extra',
                    style: TextStyle(
                        color: Constants.mainColor,
                        fontSize: size.height * 0.032,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10,),
                GridView.builder(
                    itemCount: viewModel.optionsList.length + 1,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 1.8,
                    ),
                    itemBuilder: (context, i) {
                      return i == viewModel.optionsList.length
                          ? InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor:
                                Constants.scaffoldColor,
                                title: Center(
                                  child: Text(
                                    'anotherOption'.tr(),
                                    style: TextStyle(
                                        fontSize:
                                        size.height * 0.025),
                                  ),
                                ),
                                content: Container(
                                  width: size.width * 0.4,
                                  height: size.height * 0.25,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: size.height * 0.1,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.black12,
                                                width: 1.2),
                                            borderRadius:
                                            BorderRadius.circular(
                                                10)),
                                        child: Padding(
                                          padding: const EdgeInsets
                                              .symmetric(
                                              horizontal: 10),
                                          child: TextField(
                                            controller: anotherOption,
                                            decoration:
                                            InputDecoration(
                                              contentPadding:
                                              EdgeInsets.all(10),
                                              label: Text(
                                                'anotherOption'.tr(),
                                                style: TextStyle(
                                                  fontSize:
                                                  size.height *
                                                      0.02,
                                                  color:
                                                  Colors.black45,
                                                ),
                                              ),
                                              border:
                                              InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.04,
                                      ),
                                      //////////////////done button////////////////////////
                                      InkWell(
                                        onTap: () {
                                          cartController.addAnotherOption(index: viewModel.chosenItem!,
                                          itemWidget: true,
                                          anotherOption: anotherOption.text);
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: size.height * 0.07,
                                          width: size.width * 0.2,
                                          decoration: BoxDecoration(
                                              color:
                                              Constants.mainColor,
                                              borderRadius:
                                              BorderRadius
                                                  .circular(10)),
                                          child: Center(
                                            child: Text(
                                              'ok'.tr(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                  size.height *
                                                      0.025),
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
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(

                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,

                                ),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text('addMore'.tr(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: size.height * 0.02,
                                          color: Constants.mainColor),
                                    ),
                                    SizedBox(height: 5,),
                                    Icon(Icons.add,color: Constants.mainColor,size: size.height*0.04,)
                                  ],
                                )),
                          ),
                        ),
                      )
                          :    InkWell(
                        onTap: () {
                          cartController.insertOption(
                              indexOfProduct: viewModel.chosenItem!,
                              note: viewModel.optionsList[i]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(

                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: cartController.orderDetails.cart![viewModel.chosenItem!].extra!
                                            .contains(viewModel.optionsList[i])? Constants.mainColor:Colors.white

                                    )
                                ),

                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      viewModel.optionsList[i].titleEn!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: size.height * 0.02),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      viewModel.optionsList[i].price ==0
                                          ? ''
                                          : viewModel.optionsList[i].price
                                          .toString() +
                                          ' SAR',
                                      style: TextStyle(
                                          fontSize: size.height * 0.02,
                                          color: Constants.secondryColor,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                          ),
                        ),
                      );
                    }),
              ],
            ),
        );
  }
}
