import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/cash_logout.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/home/widgets/select_customer_dialog.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/home/widgets/upper_row_cart.dart';
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
  String? customerImage;


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
                       content: SelectCustomerDialog(
                         paymentCustomers: homeController.paymentCustomers,
                         onSelect: (index){
                           cartController.orderDetails.customer =
                           homeController.paymentCustomers[index];
                         },
                         customer: cartController.orderDetails.customer,
                       )).then((value) {
                             if(value!=null){
                             setState(() {
                               customerImage =cartController.orderDetails.customer!.image;
                             });
                             }
                   });
                 } else {
                   ConstantStyles.displayToastMessage('canNotOpen'.tr(), true);
                 }
               },
               title: 'partner'.tr(),
               icon: Icons.delivery_dining,
               image: customerImage,),

            UpperRowCard(
                onTap: (){
              if (cartController.orderDetails.cart != null) {
                ConstantStyles.showPopup(
                        context: context,
                        title: 'notes'.tr(),
                        content: Container(
                          width: size.width * 0.4,
                          height: size.height * 0.35,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: size.height * 0.22,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.black12, width: 1.2),
                                    borderRadius:
                                    BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: TextField(
                                    // controller: cartController.notes,
                                    maxLines: 7,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      label: Text(
                                        'notes'.tr(),
                                        style: TextStyle(
                                          fontSize: size.height * 0.02,
                                          color: Colors.black45,
                                        ),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      cartController.orderDetails.notes =
                                          value;
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.04,
                              ),
                              CustomButton(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                height: size.height * 0.07,
                                width: size.width * 0.2,
                                color: Constants.mainColor,
                                title: 'save'.tr(),)
                            ],
                          ),
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
                if (cartController.orderDetails.cart != null) {
                 ConstantStyles.showPopup(
                          context: context,
                          title:  'expense'.tr(),
                          content:  ExpenseDialog()
                      );
                }
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

              child:
              UpperRowCard(
                title:'language'.tr(),
                icon:Icons.language,
                onTap: (){},
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
