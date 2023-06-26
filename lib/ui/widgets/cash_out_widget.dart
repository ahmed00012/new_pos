import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';
import '../../constants.dart';

class CashOutWidget extends ConsumerWidget {
String error = '';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(dataFuture);
    Size size = MediaQuery.of(context).size;
    return Container(

      width: size.width*0.4,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height:10,),
              Container(
                height: size.height*0.12,
                child: Row(

                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.black12, width: 1.2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            controller: viewModel.expenseDescription,
                            maxLines: 3,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              label: Text(
                                'description'.tr(),
                                style: TextStyle(
                                  fontSize: size.height * 0.02,
                                  color: Colors.black45,
                                ),
                              ),
                              border: InputBorder.none,
                            ),
                            // validator: (value){
                            //   if(value!.isEmpty)
                            //     return 'Description Required';
                            //   return null;
                            // },
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              SizedBox(height: 10,),

              Container(
                height: size.height*0.07,
                child: Row(

                  children: [
                    Container(
                      width:size.width * 0.3,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.black12, width: 1.2),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: viewModel.cashOutAmount,
                          keyboardType: TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            label: Text(
                              'amount'.tr(),
                              style: TextStyle(
                                fontSize: size.height * 0.02,
                                color: Colors.black45,
                              ),
                            ),
                            border: InputBorder.none,

                          ),
                          // validator: (value){
                          //   if(value!.isEmpty)
                          //     return 'Amount Required';
                          //   if(int.parse(value)==0)
                          //     return 'Amount can not be 0';
                          //   return null;
                          // },
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Text('SAR',style: TextStyle(fontSize: size.height*0.03,color: Constants.mainColor),)
                  ],
                ),
              ),
              SizedBox(height: 5,),
                Text(error,style: TextStyle(color: Colors.red),),
              SizedBox(height: 30,),
              StatefulBuilder(
                builder: (context,setState) {
                  return InkWell(
                    onTap: (){
                      if(viewModel.expenseDescription.text.isEmpty)
                        setState((){
                          error = 'Description Required';
                        });
                     else if(viewModel.cashOutAmount.text.isEmpty||viewModel.cashOutAmount.text=='0')
                        setState((){
                          error = 'Please Enter Amount';
                        });
                     else
                        setState((){
                          error = '';
                        });

                      if(error.isEmpty){
                        Navigator.pop(context);
                        viewModel.expense();
                      }

                    },
                    child: Container(
                      height: size.height*0.07,
                      width: size.width*0.1,
                      decoration: BoxDecoration(
                          color: Constants.mainColor,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Center(
                        child: Text('ok'.tr(),style: TextStyle(color: Colors.white,fontSize: size.height*0.025),),
                      ),
                    ),
                  );
                }
              ),
              SizedBox(height: 20,),

            ],
          ),
        ),
      ),
    );
  }
}
