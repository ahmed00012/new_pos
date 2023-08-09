import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/models/notes_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/product_details_model.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/home/widgets/product_item.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/home/widgets/single_item_upper_row.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/custom_button.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/numpad.dart';

import '../../../../constants/colors.dart';
import '../../../../data_controller/cart_controller.dart';
import 'attributes.dart';
import '../../../widgets/custom_text_field.dart';



class SingleItem extends ConsumerWidget {
  final TextEditingController anotherOption = TextEditingController();

  final List<Attributes> attributes;
  final int index ;
  final List<NotesModel> optionList ;
   SingleItem({Key? key , required this.index,
    required this.attributes ,required this.optionList}) : super(key: key);
  // List<Attributes> attributes = [];

  // @override
  // void initState() {
  //   ref.watch(dataFuture).getProductDetails(productID: productID,
  //       customerPrice: customer).then((value){
  //     attributes = List.from(ref.watch(dataFuture).attributes);
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context, ref) {

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
                      Navigator.pop(context);
                      cartController.removeCartItem(index: index);

                    },),

                    SingleItemUpperRow(
                      icon:  Icons.add,
                      onTap: (){

                          cartController.plusController(index, attributes);
                      },
                    ),

                    SingleItemUpperRow(
                      icon:  Icons.minimize,
                      onTap: (){
                        cartController.minusController(index);
                      },
                    ),
                    SingleItemUpperRow(
                      icon:  Icons.keyboard,
                      onTap: (){

                       ConstantStyles.showPopup(
                           context: context,
                           title: 'qty'.tr(),
                           content: Numpad()).then((value) {
                             if(value!=null)
                         cartController.itemCount(index: index , value: int.parse(value));
                       });
                      },
                    ),
                    SingleItemUpperRow(
                      icon:  Icons.arrow_back,
                      title:  'back'.tr(),
                      onTap: (){
                  Navigator.pop(context);
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
                      '${cartController.orderDetails.cart[index].count}X  ${cartController
                              .orderDetails.cart[index].mainName!}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: size.height * 0.03,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 100,
                    ),
                    Text(
                      '${cartController.orderDetails.cart[index].total} SAR',
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

                  AttributesWidget(productIndex: index , attributes: attributes),

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
                    itemCount: optionList.length + 1 ,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 1.8,
                    ),
                    itemBuilder: (context, i) {
                      return i == optionList.length
                          ? ProductItemWidget(
                        onTap: () {
                          ConstantStyles.showPopup(
                            context: context,
                            height: size.height*0.4,
                            width: size.width*0.5,
                            title: 'anotherOption'.tr(),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomTextField(
                                  controller: anotherOption,
                                  maxLines: 4,
                                  label: 'anotherOption'.tr(),
                                ),
                                CustomButton(title: 'save'.tr(),
                                    onTap: (){
                                  Navigator.pop(context);
                                      cartController.addAnotherOption(itemWidget: false ,
                                          anotherOption: anotherOption.text);
                                    })
                              ],
                            )
                          );
                        },
                        title: 'anotherOption'.tr(),
                      )
                          :   ProductItemWidget(
                          onTap: () {
                              cartController.insertOption(
                                  indexOfProduct: cartController.orderDetails.cart.length - 1,
                                  note: optionList[i]);

                          },
                          title: optionList[i].titleEn!,
                          price: optionList[i].price != 0
                              ? '${optionList[i].price!}'
                              : null);
                    }),
              ],
            ),
        );
  }
}
