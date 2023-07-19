import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/auth_controller.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';
import 'home/home.dart';

class Finance extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(financeFuture);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Center(
            child:  ListView(
              // mainAxisAlignment: MainAxisAlignment.center,

              children: [

                SizedBox(height: size.height*0.15,),
                Center(
                  child: Text(
                    'cashIn'.tr(),
                    style: TextStyle(
                        fontSize: size.height * 0.03,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 80,
                        width: 370,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                viewModel.endShiftCash.join(),
                                style: TextStyle(fontSize: size.height * 0.025),
                              ),
                            ),
                            Positioned(
                                right: 0,
                                child: InkWell(
                                    onTap: () {
                                      viewModel.removeNumberFinanceIn();
                                    },
                                    child: Container(
                                      height: 80,
                                      width: 60,
                                      color: Colors.red[500],
                                      child: Icon(
                                        Icons.backspace_outlined,
                                        size: size.height * 0.04,
                                        color: Colors.white,
                                      ),
                                    )))
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [1, 2, 3]
                          .map((e) => InkWell(
                                onTap: () {
                                  viewModel.addNumFinanceIn(e.toString());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    height: 80,
                                    width: 120,
                                    color: Colors.white,
                                    child: Center(
                                      child: Text(
                                        e.toString(),
                                        style: TextStyle(
                                            fontSize: size.height * 0.025),
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [4, 5, 6]
                          .map((e) => InkWell(
                                onTap: () {
                                  viewModel.addNumFinanceIn(e.toString());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    height: 80,
                                    width: 120,
                                    color: Colors.white,
                                    child: Center(
                                      child: Text(
                                        e.toString(),
                                        style: TextStyle(
                                            fontSize: size.height * 0.025),
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [7, 8, 9]
                          .map((e) => InkWell(
                                onTap: () {
                                  viewModel.addNumFinanceIn(e.toString());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    height: 80,
                                    width: 120,
                                    color: Colors.white,
                                    child: Center(
                                      child: Text(
                                        e.toString(),
                                        style: TextStyle(
                                            fontSize: size.height * 0.025),
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            viewModel.addNumFinanceIn('.');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              height: 80,
                              width: 120,
                              color: Colors.white,
                              child: Center(
                                child: Text(
                                  '.'.toString(),
                                  style:
                                      TextStyle(fontSize: size.height * 0.03),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            viewModel.addNumFinanceIn('0');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              height: 80,
                              width: 120,
                              color: Colors.white,
                              child: Center(
                                child: Text(
                                  '0',
                                  style:
                                      TextStyle(fontSize: size.height * 0.025),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: InkWell(
                            onTap: () {
                              // viewModel.setStartShiftCash(context).then((value){
                              //   Navigator.push(
                              //       context, MaterialPageRoute(builder: (context) => Home()));
                              // });
                              if(viewModel.startShiftCash.isEmpty)
                                ConstantStyles.displayToastMessage('cashCanNotBeEmpty'.tr(),true);
                              else {
                                viewModel.setStartShiftCash().then((value) {
                                  if (value != null && value == true) {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (_) => Home()),
                                            (route) => false);
                                  }
                                });
                              }
                            },
                            child: Container(
                              height: 80,
                              width: 120,
                              color: Colors.green,
                              child: Center(
                                child: Icon(
                                  Icons.check,
                                  size: size.height * 0.025,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                )
              ],
            ),
          ),
          if (viewModel.loading)
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
    );
  }
}
