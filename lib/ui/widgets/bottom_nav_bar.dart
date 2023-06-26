import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';

import 'package:shormeh_pos_new_28_11_2022/ui/screens/home.dart';

import '../../constants.dart';
import '../../local_storage.dart';

class BottomNavBar extends ConsumerWidget {

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final viewModel = ref.watch(dataFuture);
    // final ordersController = ref.watch(ordersFuture);

    Size size = MediaQuery.of(context).size;

    return  Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 5),
        child: DotNavigationBar(

          margin: EdgeInsets.only(
              left: 10, right: 10),
          boxShadow: [
            BoxShadow(
              color:
              Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 1,
            )
          ],
          currentIndex: SelectedTab.values
              .indexOf(viewModel.selectedTab),
          dotIndicatorColor: Colors.white,
          unselectedItemColor: Colors.black26,
          selectedItemColor:  Constants.mainColor,
          // enableFloatingNavBar: false,
          onTap: (index){
            viewModel.handleIndexChanged(index);
            // ordersController.chosenOrder=null;

          },

          items: [
            /// history
            DotNavigationBarItem(
              icon: Row(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: size.height * 0.03,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'orders'.tr(),
                    style: TextStyle(
                        fontSize:
                        size.height * 0.02,
                        color: viewModel
                            .selectedTab ==
                            SelectedTab
                                .orders
                            ?  Constants.mainColor
                            : Colors.black45),
                  )
                ],
              ),
            ),

            /// home
            DotNavigationBarItem(
              icon: Row(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home,
                    size: size.height * 0.03,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'home'.tr(),
                    style: TextStyle(
                        fontSize:
                        size.height * 0.02,
                        color: viewModel
                            .selectedTab ==
                            SelectedTab.home
                            ?  Constants.mainColor
                            : Colors.black45),
                  )
                ],
              ),
            ),

            //////////mobile orders //////////////
if( LocalStorage.getData(key: 'showMobileOrders',) == 1)
            DotNavigationBarItem(
              icon:Row(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                 Container(
                   height: size.height*0.03,
                   width: size.height*0.03,
                   decoration: BoxDecoration(
                     color:
                     viewModel
                         .selectedTab ==
                         SelectedTab
                             .mobileOrders?Constants.mainColor:
                     HomeController.ordersCount>0? Constants.secondryColor:Colors.black45 ,
                     shape: BoxShape.circle
                   ),
                   child: Center(
                     child: Text(
                       HomeController.ordersCount.toString(),
                       style: TextStyle(
                         color: Colors.white,
                         fontSize: size.height*0.02
                       ),
                     ),
                   ),
                 ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'mobileOrders'.tr(),
                    style: TextStyle(
                        fontSize:
                        size.height * 0.02,
                        color: viewModel
                            .selectedTab ==
                            SelectedTab.mobileOrders
                            ?  Constants.mainColor
                            : Colors.black45),
                  )
                ],
              )
            ),

            /// menu
            DotNavigationBarItem(
              icon: Row(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.view_comfortable,
                    size: size.height * 0.03,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'tables'.tr(),
                    style: TextStyle(
                        fontSize:
                        size.height * 0.02,
                        color: viewModel
                            .selectedTab ==
                            SelectedTab
                                .tables
                            ?  Constants.mainColor
                            : Colors.black45),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
