import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/models/notes_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/product_details_model.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/home/widgets/product_item.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/home/widgets/single_item_upper_row.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/numpad.dart';

import '../../../../constants/colors.dart';
import '../../../../data_controller/cart_controller.dart';
import '../../../widgets/attributes.dart';
import '../../../widgets/custom_text_field.dart';

class SingleItem extends ConsumerStatefulWidget {
  final bool customer ;
  final int productID ;
  final int index ;
  final List<NotesModel> optionList ;
  const SingleItem({Key? key , required this.customer , required this.productID, required this.index,
  required this.optionList}) : super(key: key);

  @override
  SingleItemState createState() => SingleItemState();
}

class SingleItemState extends ConsumerState<SingleItem> {
  TextEditingController anotherOption = TextEditingController();
  List<Attributes> attributes = [];

  @override
  void initState() {
    ref.watch(dataFuture).getProductDetails(productID: widget.productID,
        customerPrice: widget.customer).then((value){
      attributes = List.from(ref.watch(dataFuture).attributes);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final viewModel = ref.watch(dataFuture);
    final cartController = ref.watch(cartFuture);
    Size size = MediaQuery.of(context).size;
    return  SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleItemUpperRow(
                    icon:  Icons.delete_outline,
                    color: Colors.red,
                    onTap: (){
                      cartController.removeCartItem(index: widget.index);
                    },),

                    SingleItemUpperRow(
                      icon:  Icons.add,
                      onTap: (){
                        cartController.plusController(widget.index);
                      },
                    ),

                    SingleItemUpperRow(
                      icon:  Icons.minimize,
                      onTap: (){
                        cartController.minusController(widget.index);
                      },
                    ),
                    SingleItemUpperRow(
                      icon:  Icons.keyboard,
                      onTap: (){
                       ConstantStyles.showPopup(
                           context: context,
                           title: 'qty'.tr(),
                           content: Numpad()).then((value) {
                         cartController.itemCount(index: widget.index , value: int.parse(value));
                       });
                      },
                    ),
                    SingleItemUpperRow(
                      icon:  Icons.arrow_back,
                      title:  'back'.tr(),
                      onTap: (){
                        // viewModel.switchToCardItemWidget(false);
                      },
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
                      '${cartController.orderDetails.cart![widget.index].count}X  ${cartController
                              .orderDetails.cart![widget.index].mainName!}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: size.height * 0.03,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 100,
                    ),
                    Text(
                      '${cartController.orderDetails.cart![widget.index].total} SAR',
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

                  AttributesWidget(productIndex: widget.index , attributes: attributes),

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
                    itemCount: widget.optionList.length + 1 ,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 1.8,
                    ),
                    itemBuilder: (context, i) {
                      return i == widget.optionList.length
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
                          :   ProductItemWidget(
                          onTap: () {
                              cartController.insertOption(
                                  indexOfProduct: cartController.orderDetails.cart!.length - 1,
                                  note: widget.optionList[i]);

                          },
                          title: widget.optionList[i].titleEn!,
                          price: widget.optionList[i].price != 0
                              ? '${widget.optionList[i].price!} SAR'
                              : '');
                    }),
              ],
            ),
        );
  }
}
