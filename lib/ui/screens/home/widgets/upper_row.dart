import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/auth_screens/cash_logout.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/home/widgets/select_customer_dialog.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/home/widgets/upper_row_cart.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/custom_text_field.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';
import '../../../../constants/prefs_utils.dart';
import '../../../../data_controller/cart_controller.dart';
import 'expense_widget.dart';
import '../../../widgets/custom_button.dart';

class UpperRow extends ConsumerStatefulWidget {
  const UpperRow({super.key});

  @override
  UpperRowState createState() => UpperRowState();
}

class UpperRowState extends ConsumerState {
  TextEditingController notes = TextEditingController();



  @override
  Widget build(BuildContext context) {
    final homeController = ref.watch(dataFuture);
    final cartController = ref.watch(cartFuture);
    Size size = ConstantStyles.contextSize(context);
    return Container(
      height: size.height * 0.15,
      width: double.infinity,
      color: Constants.scaffoldColor,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
           const SizedBox(
              width: 10,
            ),
             UpperRowCard(
               onTap: (){
                 if (cartController.orderDetails.orderUpdatedId == null) {
                   ConstantStyles.showPopup(
                       context: context,
                       title: 'partners'.tr(),
                       height: size.height*0.5,
                       content: SelectCustomerDialog(
                         paymentCustomers: homeController.paymentCustomers,
                         onSelect: (index){
                           cartController.orderDetails.customer =
                           homeController.paymentCustomers[index];
                           setState(() {});
                         },
                         customer: cartController.orderDetails.customer,
                       ));
                 } else {
                   ConstantStyles.displayToastMessage('canNotOpen'.tr(), true);
                 }
               },
               title: 'partner'.tr(),
               icon: Icons.delivery_dining,
               image: cartController.orderDetails.customer!=null ?
               cartController.orderDetails.customer!.image : null,),

            UpperRowCard(
                onTap: (){
              if (cartController.orderDetails.cart.isNotEmpty) {
                ConstantStyles.showPopup(
                        context: context,
                        height: size.height*0.65,
                        title: 'notes'.tr(),
                        content: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextField(controller: notes,
                              label:   'notes'.tr(),
                            maxLines: 7,
                            ),
                            SizedBox(
                              height: size.height * 0.04,
                            ),
                            CustomButton(
                              onTap: () {
                                cartController.orderDetails.notes = notes.text;
                                notes.clear();
                                Navigator.pop(context);
                              },
                              height: size.height * 0.07,
                              width: size.width * 0.2,
                              color: Constants.mainColor,
                              title: 'save'.tr(),)
                          ],
                        )
                    );
              } else {
                ConstantStyles.displayToastMessage('noOrderFound'.tr(), true);
              }
            },
              title:   'notes'.tr(),
            icon: Icons.note_outlined,
            ),


            UpperRowCard(
              onTap: (){
                ConstantStyles.showPopup(
                    context: context,
                    height: size.height*0.7,
                    title:  'expense'.tr(),
                    content:  ExpenseDialog(
                      onTap: (description,price){
                        homeController.expense(description, price);
                      },
                    )
                );
              },
              title: 'expense'.tr(),
              icon: Icons.call_made_sharp,
            ),

          PopupMenuButton<int>(
            position: PopupMenuPosition.under,
              tooltip: '',
              padding: EdgeInsets.only(right: 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),

              child: UpperRowCard(
                title:'language'.tr(),
                icon:Icons.language,

              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  onTap: (){
                    homeController.changeLanguage(context,'en');
                  },
                  child: Text("English",style: TextStyle(
                      color: getLanguage() =='en'? Constants.mainColor:Colors.black,
                    fontSize: size.height*0.02
                  ),),
                ),
                PopupMenuItem(
                  value: 2,
                  onTap: (){
                    homeController.changeLanguage(context,'ar');
                  },
                  child: Text("Arabic",style: TextStyle(
                      color: getLanguage() == 'ar'? Constants.mainColor:Colors.black,
                      fontSize: size.height*0.02
                  ),),),
              ]),


            UpperRowCard(
              onTap: (){
                homeController.synchronize();
              },
              title:'synchronize'.tr(),
              icon: Icons.sync,
            ),

            UpperRowCard(
              onTap: ()async{
                await launchUrl(Uri.parse('https://beta3.poss.app/'),
                    mode: LaunchMode.externalApplication);
              },
              title:'version 1.0.14',
              icon:  Icons.vertical_align_bottom_sharp,
            ),

            UpperRowCard(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => FinanceOut()));
              },
              title: 'logout'.tr(),
              icon:  Icons.logout,
            ),
          ],
        ),
      ),
    );
  }
}
