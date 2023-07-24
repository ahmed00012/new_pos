import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/prefs_utils.dart';
import '../../constants/colors.dart';
import '../../constants/enums.dart';

import '../screens/home/home_screen.dart';
import '../screens/orders/order_screen.dart';
import '../screens/tables.dart';

class BottomNavBar extends StatefulWidget {
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  Widget current = Home();

  SelectedTab selectedTab = SelectedTab.home;

  List<Widget> pages = [
    OrdersScreen(mobileOrders: false),
    Home(),
    OrdersScreen(mobileOrders: true),
    TablesScreen(),
  ];

  void handleIndexChanged(int i) {
    setState(() {
      selectedTab = SelectedTab.values[i];
      current = pages[i];
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          current,
          Align(
            alignment: getLanguage() == 'ar'
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: SizedBox(
              width: size.width * 0.7,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: DotNavigationBar(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 1,
                      )
                    ],
                    currentIndex: SelectedTab.values.indexOf(selectedTab),
                    dotIndicatorColor: Colors.white,
                    unselectedItemColor: Colors.black26,
                    selectedItemColor: Constants.mainColor,
                    // enableFloatingNavBar: false,
                    onTap: (index) {
                      handleIndexChanged(index);
                    },

                    items: [
                      /// history
                      DotNavigationBarItem(
                        icon: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                  fontSize: size.height * 0.02,
                                  color: selectedTab == SelectedTab.orders
                                      ? Constants.mainColor
                                      : Colors.black45),
                            )
                          ],
                        ),
                      ),

                      /// home
                      DotNavigationBarItem(
                        icon: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                  fontSize: size.height * 0.02,
                                  color: selectedTab == SelectedTab.home
                                      ? Constants.mainColor
                                      : Colors.black45),
                            )
                          ],
                        ),
                      ),

                      //////////mobile orders //////////////
                      if (getShowMobileOrders() == 1)
                        DotNavigationBarItem(
                            icon: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: size.height * 0.03,
                                  width: size.height * 0.03,
                                  decoration: BoxDecoration(
                                      color: selectedTab == SelectedTab.mobileOrders
                                          ? Constants.mainColor
                                          : getMobileOrdersCount() > 0
                                          ? Constants.secondryColor
                                          : Colors.black45,
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: Text(
                                      getMobileOrdersCount().toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.height * 0.02),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'mobileOrders'.tr(),
                                  style: TextStyle(
                                      fontSize: size.height * 0.02,
                                      color: selectedTab == SelectedTab.mobileOrders
                                          ? Constants.mainColor
                                          : Colors.black45),
                                )
                              ],
                            )),

                      /// menu
                      DotNavigationBarItem(
                        icon: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                  fontSize: size.height * 0.02,
                                  color: selectedTab == SelectedTab.tables
                                      ? Constants.mainColor
                                      : Colors.black45),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
