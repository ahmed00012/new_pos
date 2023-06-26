

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/bottom_nav_bar.dart';

import '../../constants.dart';
import '../../data_controller/cart_controller.dart';
import '../../data_controller/home_controller.dart';

class ChooseClientWidget extends ConsumerWidget {
  BuildContext ?currentContext ;
   ChooseClientWidget({Key? key, required this.currentContext}) : super(key: key);

  @override
  Widget build(BuildContext context,ref) {
    final viewModel = ref.watch(dataFuture);
    final cartController = ref.watch(cartFuture);
    Size size = MediaQuery.of(context).size;
    return AlertDialog(

      title: Row(

        children: [
          SizedBox(width: size.width*0.3,),


          Text(
            'clients'.tr(),
            style: TextStyle(fontSize: size.height * 0.025),
          ),
          SizedBox(width: size.width*0.2,),

          InkWell(
            onTap: (){
              Navigator.pop(context);
              cartController.orderDetails.clientName = null;
              cartController.orderDetails.clientPhone = null;
              viewModel.customerPhone.text = '';
              viewModel.customerName.text = '';

              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    titlePadding: EdgeInsets.zero,

                    title: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: (){
                                  Navigator.pop(currentContext!);
                                },
                                child: Container(
                                  height: size.height*0.05,
                                  width: size.height*0.05,
                                  decoration: BoxDecoration(
                                      color: Colors.red[400],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Icon(
                                      Icons.clear,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )),
                        ),

                        Text(
                          'addClient'.tr(),
                          style: TextStyle(fontSize: size.height * 0.025),
                        ),
                      ],
                    ),
                    content: StatefulBuilder(builder:
                        (BuildContext context, StateSetter setState) {
                      return Container(
                        width: size.width * 0.4,
                        child: ListView(
                          shrinkWrap: true,
                          //   shrinkWrap: true,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [


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
                                      child: TextField(
                                        controller: viewModel.customerPhone,
                                        decoration: InputDecoration(
                                          contentPadding:
                                          EdgeInsets.all(10),
                                          // label: Text(
                                          //   'clientPhone'.tr(),
                                          //   style: TextStyle(
                                          //     fontSize:
                                          //     size.height * 0.02,
                                          //     color: Colors.black45,
                                          //   ),
                                          // ),
                                          hintText: '050*******',
                                          border: InputBorder.none,
                                          icon: Icon(
                                            Icons.phone,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                ///////////////customer name//////////////////////////////////////////
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
                                      child: TextField(
                                        controller: viewModel.customerName,
                                        decoration: InputDecoration(
                                          contentPadding:
                                          EdgeInsets.all(10),

                                          hintText: 'clientName'.tr(),
                                          border: InputBorder.none,
                                          icon: Icon(
                                            Icons.person,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    // cartController.chooseClient();
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
                                        'save'.tr(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                            size.height * 0.025),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    }),
                  ));
            },
            child: Container(
              height: size.height*0.06,
              width: size.width*0.1,
              decoration: BoxDecoration(
                  color: Constants.mainColor,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text(
                  'addClient'.tr(),
                  style: TextStyle(fontSize: size.height * 0.025,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      content: StatefulBuilder(
          builder: (context,setState) {
            return Container(
                width: size.width * 0.6,
                height: size.height*0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                          child: TextField(
                            // controller: viewModel.customerPhone,
                            decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.all(10),
                              label: Text(
                                'searchHere'.tr(),
                                style: TextStyle(
                                  fontSize:
                                  size.height * 0.02,
                                  color: Colors.black45,
                                ),
                              ),
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.search,
                                color: Colors.black45,
                              ),
                            ),
                            onChanged: (text){

                              setState((){
                                viewModel.onSearchTextChanged(text);
                              });
                            },
                          ),
                        ),
                      ),
                    ),

                    Container(
                      height: size.height*0.06,
                      child: Row(
                        children: [
                          SizedBox(width: 30,),
                          Container(
                              width: size.width*0.1,
                              child: Text('client'.tr(),
                                style: TextStyle(
                                    color: Colors.black38,

                                ),)),
                          Spacer(),
                          Container(
                              width: size.width*0.1,
                              child: Text('phone'.tr(),
                                style: TextStyle(
                                    color: Colors.black38,
                                ),)),
                          Spacer(),
                          Container(
                              width: size.width*0.05,
                              child: Text('points'.tr(),
                                style: TextStyle(
                                    color: Colors.black38,

                                ),)),
                          Spacer(),
                          Container(
                              width: size.width*0.05,
                              child: Text('balance'.tr(),
                              style: TextStyle(
                                color: Colors.black38,

                              ),)),
                          SizedBox(width: 10,),
                        ],
                      ),
                    ),
                    Divider(),

                    Expanded(
                      child:
                      viewModel.clientsLoading?
                      Center(child: CircularProgressIndicator(color: Constants.mainColor,)):
                      ListView.separated(
                        itemCount: viewModel.searchResultClients.isNotEmpty?
                        viewModel.searchResultClients.length:
                        viewModel.clients.length,
                        itemBuilder: (context,i){
                          return InkWell(
                            onTap: (){
                              // if( viewModel.searchResultClients.isNotEmpty)
                                // viewModel.chooseClient(client: viewModel.searchResultClients[i]);
                              // else
                              //   viewModel.chooseClient(client: viewModel.clients[i]);
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: size.height*0.07,
                              width: size.width*0.7,
                              child: Row(
                                children: [

                                  SizedBox(width: 30,),
                                  if( viewModel.searchResultClients.isNotEmpty && viewModel.searchResultClients[i].allowCreateOrder == 'false')
                                    Icon(Icons.block,color: Colors.red,),
                                  if( viewModel.clients.isNotEmpty && viewModel.clients[i].allowCreateOrder == 'false')
                                    Icon(Icons.block,color: Colors.red,),

                                    if((viewModel.searchResultClients.isNotEmpty && viewModel.searchResultClients[i].allowCreateOrder == 'true') ||
                                        (viewModel.clients.isNotEmpty && viewModel.clients[i].allowCreateOrder == 'true') )
                                  Icon(Icons.person_outline,color: Constants.mainColor,),
                                  SizedBox(width: 10,),
                                  if( viewModel.searchResultClients.isNotEmpty)
                                    Container(
                                        width: size.width*0.07,
                                        child: Text(viewModel.searchResultClients[i].name!,
                                        style: TextStyle(
                                          color: viewModel.searchResultClients[i].allowCreateOrder=='true'?
                                              Colors.black:Colors.red
                                        ),)),
                                  if( viewModel.searchResultClients.isEmpty)
                                    Container(
                                        width: size.width*0.1,
                                        child: Text(viewModel.clients[i].name!,
                                          style: TextStyle(
                                              color: viewModel.clients[i].allowCreateOrder=='true'?
                                              Colors.black:Colors.red
                                          ),)),
                                  Spacer(),
                                  Icon(Icons.phone,color: Constants.mainColor,),
                                  SizedBox(width: 10,),
                                  if( viewModel.searchResultClients.isNotEmpty)
                                    Container(
                                        width: size.width*0.1,
                                        child: Text(viewModel.searchResultClients[i].phone!,
                                          style: TextStyle(
                                              color: viewModel.searchResultClients[i].allowCreateOrder=='true'?
                                              Colors.black:Colors.red
                                          ),)),
                                  if( viewModel.searchResultClients.isEmpty)
                                    Container(
                                        width: size.width*0.1,
                                        child: Text(viewModel.clients[i].phone!,
                                          style: TextStyle(
                                              color: viewModel.clients[i].allowCreateOrder=='true'?
                                              Colors.black:Colors.red
                                          ),)),


                                  Spacer(),
                                  Icon(Icons.bookmark_border,color: Constants.mainColor,),
                                  SizedBox(width: 10,),
                                  if( viewModel.searchResultClients.isNotEmpty)
                                    viewModel.searchResultClients[i].points!='null'?
                                    Container(
                                        width: size.width*0.05,
                                        child: Text(viewModel.searchResultClients[i].points!,
                                          style: TextStyle(
                                              color: viewModel.searchResultClients[i].allowCreateOrder=='true'?
                                              Colors.black:Colors.red
                                          ),)):
                                    Container(
                                        width: size.width*0.05,
                                        child: Text('0',
                                          style: TextStyle(
                                              color: viewModel.searchResultClients[i].allowCreateOrder=='true'?
                                              Colors.black:Colors.red
                                          ),)),
                                  if( viewModel.searchResultClients.isEmpty)
                                    viewModel.clients[i].points!='null'?
                                    Container(
                                        width: size.width*0.05,
                                        child: Text(viewModel.clients[i].points!,
                                          style: TextStyle(
                                              color: viewModel.clients[i].allowCreateOrder=='true'?
                                              Colors.black:Colors.red
                                          ),)):
                                    Container(
                                        width: size.width*0.05,
                                        child: Text('0',
                                          style: TextStyle(
                                              color: viewModel.clients[i].allowCreateOrder=='true'?
                                              Colors.black:Colors.red
                                          ),)),

                                  Spacer(),
                                  Icon(Icons.monetization_on_outlined,color: Constants.mainColor,),
                                  SizedBox(width: 10,),
                                  if( viewModel.searchResultClients.isNotEmpty)
                                    viewModel.searchResultClients[i].balance!='null'?
                                    Text(viewModel.searchResultClients[i].balance!,
                                      style: TextStyle(
                                          color: viewModel.searchResultClients[i].allowCreateOrder=='true'?
                                          Colors.black:Colors.red
                                      ),):
                                    Text('0',
                                      style: TextStyle(
                                          color: viewModel.searchResultClients[i].allowCreateOrder=='true'?
                                          Colors.black:Colors.red
                                      ),),
                                  if( viewModel.searchResultClients.isEmpty)
                                    viewModel.clients[i].balance!='null'?
                                    Text(viewModel.clients[i].balance!,
                                      style: TextStyle(
                                          color: viewModel.clients[i].allowCreateOrder=='true'?
                                          Colors.black:Colors.red
                                      ),):
                                    Text('0',
                                      style: TextStyle(
                                          color: viewModel.clients[i].allowCreateOrder=='true'?
                                          Colors.black:Colors.red
                                      ),),
                                  SizedBox(width: 30,)

                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider();
                        },),
                    )
                    //
                    // SizedBox(
                    //   height: 30,
                    // ),
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     viewModel.chooseClient();
                    //   },
                    //   child: Container(
                    //     height: size.height * 0.07,
                    //     width: size.width * 0.2,
                    //     decoration: BoxDecoration(
                    //         color: Constants.mainColor,
                    //         borderRadius:
                    //         BorderRadius.circular(10)),
                    //     child: Center(
                    //       child: Text(
                    //         'save'.tr(),
                    //         style: TextStyle(
                    //             color: Colors.white,
                    //             fontSize:
                    //             size.height * 0.025),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                )
            );
          }
      ),
    );
  }
}
