import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/auth_controller.dart';
import '../../../constants/colors.dart';
import 'login.dart';



class FinanceOut extends ConsumerWidget {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   // ref.watch(financeFuture).getPrinters();
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context , ref) {
    final viewModel = ref.watch(financeFuture);
    // final homeController = ref.watch(dataFuture);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [

            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: InkWell(
                  onTap: (){
                    viewModel.productsZReport();
                  },
                  child: Container(
                    height: size.height*0.07,
                    width: size.width*0.2,

                    decoration: BoxDecoration(
                      color: Constants.mainColor,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.print, color: Colors.white,),
                        SizedBox(width: 15,),
                        Text('Print Products Z Report',style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height*0.02
                        ),),

                      ],
                    )
                  ),
                ),
              ),

            ),
            Column(

              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: 50,
                    width: size.width,
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Icon(Icons.close,size: 30,color: Colors.white,),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // viewModel.visaCashSwap(0);
                  },
                  child: Container(
                      width: size.width * 0.4,
                      height: size.height * 0.08,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Constants.mainColor,

                              width: 2)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'cash'.tr(),
                            style: TextStyle(
                                fontSize: size.height * 0.03,
                                color:  Constants.mainColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            viewModel.endShiftCash.isEmpty
                                ? '0.0'
                                : viewModel.endShiftCash.join(),
                            style: TextStyle(
                                fontSize: size.height * 0.03,
                                color:  Constants.mainColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                ),
                // SizedBox(
                //   height: 10,
                // ),
                // InkWell(
                //   onTap: () {
                //     viewModel.visaCashSwap(1);
                //   },
                //   child: Container(
                //       width: size.width * 0.4,
                //       height: size.height * 0.08,
                //       padding: EdgeInsets.symmetric(
                //         horizontal: 30,
                //       ),
                //       decoration: BoxDecoration(
                //           color: Colors.white,
                //           border: Border.all(
                //               color: viewModel.chosenVisa
                //                   ? Constants.mainColor
                //                   : Colors.black38,
                //               width: 2)),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //             'visa'.tr(),
                //             style: TextStyle(
                //                 fontSize: size.height * 0.03,
                //                 color: viewModel.chosenVisa
                //                     ? Constants.mainColor
                //                     : Colors.black38,
                //                 fontWeight: FontWeight.bold),
                //           ),
                //           Text(
                //             viewModel.visaIn.isEmpty
                //                 ? '0.0'
                //                 : viewModel.visaIn.join(),
                //             style: TextStyle(
                //                 fontSize: size.height * 0.03,
                //                 color: viewModel.chosenVisa
                //                     ? Constants.mainColor
                //                     : Colors.black38,
                //                 fontWeight: FontWeight.bold),
                //           ),
                //         ],
                //       )),
                // ),
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
                                      viewModel.removeNumberFinanceOut();

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
                                  viewModel.addNumberFinanceOut(e.toString());
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
                                  viewModel.addNumberFinanceOut(e.toString());
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
                                  viewModel.addNumberFinanceOut(e.toString());
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
                            viewModel.addNumberFinanceOut('.');
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
                            viewModel.addNumberFinanceOut('0');
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
                              // if (viewModel.chosenCash)
                              //   viewModel.cashInDone();
                              // else
                              //   viewModel.visaInDone();
                            },
                            child: Container(
                              height: 80,
                              width: 120,
                              color: Colors.white,
                              // child: Center(
                              //   child: Icon(
                              //     Icons.check,
                              //     size: size.height * 0.025,
                              //     color: Colors.white,
                              //   ),
                              // ),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () {
                  if(viewModel.endShiftCash.isEmpty)
                    ConstantStyles.displayToastMessage('cashCanNotBeEmpty'.tr(),true);
                  else {
                    viewModel.endShift(true).then((value) {
                      if (value != null && value == true) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => Login()),
                            (route) => false);
                      }
                    });
                  }
                  // .then((value) {
                      // homeController.synchronize(context);
                      // homeController.categories=[];
                      // homeController.products=[];
                      // homeController.optionsList=[];
                      // homeController.emptyCardList();
                    // });
                },
                child: Container(
                    height: size.height * 0.08,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.red,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'logout'.tr(),
                          style: TextStyle(
                              fontSize: size.height * 0.025,
                              color: Colors.white),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: size.height * 0.03,
                        )
                      ],
                    )),
              ),
            ),
            if(viewModel.loading)
              Container(
                height: size.height,
                width: size.width,
                color: Colors.white.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Constants.mainColor,
                    strokeWidth: 4,
                  ),
                ),
              )
          ],
        ));
  }
}
