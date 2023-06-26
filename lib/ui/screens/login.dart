import 'dart:async';

import 'package:easy_localization/src/public_ext.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:shormeh_pos_new_28_11_2022/constants.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/auth_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/local_storage.dart';

import 'home.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {


  @override
  void initState() {
    if(LocalStorage.getData(key: 'token')!=null)
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>Home()), (route) => false);

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer(
      builder: (context, ref , child) {
        final viewModel = ref.watch(financeFuture);
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: Colors.white,

            body: SingleChildScrollView(
              child:Stack(
                children: [
                  Form(
                    // key: _formKey,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [


                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          Lottie.asset(
                            'assets/images/lf20_nyostiev.json',
                            height: size.height * 0.4,
                          ),
                          Card(
                            elevation: 3,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side:const BorderSide(
                                color: Constants.mainColor,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: size.width*0.6,
                                    child: TextFormField(

                                      controller: viewModel.phoneController,
                                      cursorColor: Constants.mainColor,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.email,
                                          color: Constants.mainColor,
                                        ),
                                        suffixIcon: viewModel.phoneController.text.isEmpty
                                            ? Text('')
                                            : GestureDetector(
                                            onTap: () {
                                              viewModel.phoneController.clear();
                                            },
                                            child: const Icon(
                                              Icons.close,
                                              color: Constants.mainColor,
                                            )),
                                        hintText: 'email'.tr(),
                                        label:  Text(
                                          'email'.tr(),
                                          style: TextStyle(color: Constants.mainColor),
                                        ),
                                        border: const OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(8)),
                                            borderSide: BorderSide(
                                                width: 1, color: Constants.mainColor)),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(
                                              width: 2, color: Constants.mainColor),
                                        ),
                                      ),

                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: size.width*0.6,
                                    child: Text(viewModel.mailError!,

                                      style: TextStyle(color: Colors.red),),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    width: size.width*0.6,
                                    child: TextFormField(
                                      obscureText: viewModel.isVisible,
                                      controller: viewModel.passwordController,
                                      decoration: InputDecoration(
                                        suffixIcon: GestureDetector(
                                          onTap: () {

                                            viewModel.seePassword();
                                          },
                                          child: Icon(
                                            viewModel.isVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Constants.mainColor,
                                        ),
                                        hintText: 'password'.tr(),
                                        label: Text(
                                          'password'.tr(),
                                          style: TextStyle(color: Constants.mainColor),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(8)),
                                            borderSide: BorderSide(
                                                width: 1, color: Constants.mainColor)),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(
                                              width: 2, color: Constants.mainColor),
                                        ),
                                      ),

                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: size.width*0.6,
                                    child: Text(viewModel.passwordError!,

                                      style: TextStyle(color: Colors.red),),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    height: 70,
                                  ),
                                  InkWell(
                                    onTap: () {


                                        viewModel.login(context);

                                    },
                                    child: Container(
                                      height: size.height * 0.07,
                                      width: size.width * 0.4,
                                      decoration: BoxDecoration(
                                        color: Constants.mainColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'login'.tr(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: size.height * 0.02),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if(viewModel.loading)
                    Container(
                      height: size.height,
                      width: size.width,
                      color: Colors.white.withOpacity(0.7),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Constants.mainColor,
                          strokeWidth: 4,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
