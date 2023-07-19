
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/orders_controller.dart';

import '../../constants/colors.dart';

class ComplainWidget extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  bool? complain;
  int? orderId;
  ComplainWidget({this.complain,this.orderId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(ordersFuture);
    Size size = MediaQuery.of(context).size;
   return AlertDialog(
     backgroundColor: Constants.scaffoldColor,
      title: Center(
        child: Text(
          complain!?
          'complain'.tr(): 'cancelOrder'.tr(),
          style: TextStyle(
              fontSize: size.height * 0.03),
        ),
      ),
      content: Container(
        height:complain!? size.height * 0.7:size.height * 0.5,
        width: size.width * 0.4,
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if(complain!)
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text('reason'.tr()+' : ',
                style: TextStyle(
                  fontSize: size.height*0.025,
                  fontWeight: FontWeight.bold
                ),),
              ),
          if(complain!)
          ListView.builder(
              itemCount: viewModel.reasons.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context,i){
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                onTap: (){
                viewModel.selectReason(i);
                },
                child: Container(
                  height: size.height*0.07,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: viewModel.reasons[i].chosen!?Constants.mainColor:Colors.black38,
                      width: viewModel.reasons[i].chosen!?1.2:1,
                    )

                  ),
                  child: Center(
                    child: Text(
                      viewModel.reasons[i].title!,
                      style: TextStyle(
                        color:viewModel.reasons[i].chosen!?Constants.mainColor:Colors.black,
                        fontSize: size.height*0.02
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),

              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 5, vertical: 10),
                child: Container(
                  height: size.height * 0.07,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.black12,
                          width: 1.2),
                      borderRadius:
                      BorderRadius.circular(10)),
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(
                        horizontal: 10),
                    child: TextFormField(
                      controller: viewModel.secretId,
                      keyboardType:
                      TextInputType.phone,
                      decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.all(10),
                        label: Text(
                          'id'.tr(),
                          style: TextStyle(
                            fontSize:
                            size.height * 0.02,
                            color: Colors.black45,
                          ),
                        ),
                        border: InputBorder.none,

                      ),
                      validator: (e) {
                        if (e!.isEmpty)
                          return 'IdEmpty'.tr();
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 5, vertical: 10),
                child: Container(
                  height: size.height * 0.07,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.black12,
                          width: 1.2),
                      borderRadius:
                      BorderRadius.circular(10)),
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(
                        horizontal: 10),
                    child: TextFormField(
                      controller: viewModel.secretCode,
                      keyboardType:
                      TextInputType.phone,
                      obscureText: viewModel.isVisible,

                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            viewModel.isVisible = !viewModel.isVisible;
                            viewModel.refresh();
                          },
                          child: Icon(
                            viewModel.isVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        contentPadding:
                        EdgeInsets.all(10),
                        label: Text(
                          'password'.tr(),
                          style: TextStyle(
                            fontSize:
                            size.height * 0.02,
                            color: Colors.black45,
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                      validator: (e) {
                        if (e!.isEmpty)
                          return 'passwordRequired'.tr();
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              if( complain!)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 5, vertical: 10),
                child: Container(
                  height: size.height * 0.07,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.black12,
                          width: 1.2),
                      borderRadius:
                      BorderRadius.circular(10)),
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(
                        horizontal: 10),
                    child: TextFormField(
                      controller: viewModel.mobile,
                      keyboardType:
                      TextInputType.phone,
                      decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.all(10),
                        label: Text(
                          'clientPhone'.tr(),
                          style: TextStyle(
                            fontSize:
                            size.height * 0.02,
                            color: Colors.black45,
                          ),
                        ),
                        border: InputBorder.none,

                      ),
                      validator: (e) {
                        if(complain!) {
                            if (e!.isEmpty) return 'mobileRequired'.tr();
                          }
                          return null;
                      },
                    ),
                  ),
                ),
              ),
              if(!complain!)
              SizedBox(
                height: 10,
              ),

              if(!complain!)
                            Container(
                              height: size.height * 0.12,
                              width: size.width * 0.4,
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
                                  controller:
                                      viewModel.reason,
                                  decoration:
                                      InputDecoration(
                                    contentPadding:
                                        const EdgeInsets
                                            .all(8.0),
                                    label: Padding(
                                      padding:
                                          const EdgeInsets
                                              .all(8.0),
                                      child: Text(
                                        'reason'.tr(),
                                        style: TextStyle(
                                          fontSize:
                                              size.height *
                                                  0.02,
                                          color: Colors
                                              .black45,
                                        ),
                                      ),
                                    ),
                                    border:
                                        InputBorder.none,
                                  ),
                                ),
                              ),
                            ),

              SizedBox(
                height: 50,
              ),
//////////////////done button////////////////////////
              InkWell(
                onTap: () {

                  if (_formKey.currentState!.validate()) {
                    if(complain!)
                    viewModel.complainOrder(viewModel.orders[viewModel.chosenOrder!].id!, context);
                    else
                      viewModel.cancelOrder(orderId!,context);
                  }
                },
                child: Container(
                  height: size.height * 0.07,
                  width: size.width * 0.2,
                  decoration: BoxDecoration(
                      color: Constants.mainColor,
                      borderRadius:
                      BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      'done'.tr(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize:
                          size.height * 0.025),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}