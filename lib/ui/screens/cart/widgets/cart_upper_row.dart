

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/prefs_utils.dart';
import '../../../../constants/colors.dart';

class CartUpperRow extends StatelessWidget {
final  String? tableTitle;
final  String? clientName;
final  VoidCallback onTapChooseClient;
final VoidCallback onTapSend;
final VoidCallback onTapTables;



  const CartUpperRow({Key? key, this.tableTitle , this.clientName ,
  required this.onTapChooseClient,required this.onTapSend , required this.onTapTables}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Image.asset(
              'assets/images/ahmed-01.png',
              width: size.width * 0.28,
            ),
            Column(
              children: [
                Container(
                  width: size.width * 0.28,
                  decoration: const BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: Constants.secondryColor, width: 5),
                          left: BorderSide(
                              color: Constants.secondryColor, width: 5))),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          '${'branch'.tr()} \n ${getBranchName()}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.height * 0.02,
                              color: Constants.mainColor),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          '${'employee'.tr()} \n ${getUserName()}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.height * 0.02,
                              color: Constants.mainColor),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, left: 3),
                  child: InkWell(
                    onTap: onTapSend,
                    child: Container(
                      height: size.height * 0.09,
                      width: size.height * 0.09,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Constants.mainColor),
                      child: Center(
                        child: Text(
                          'send'.tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.025,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            // textDirection: TextDirection.ltr,
            children: [
              InkWell(
                onTap: onTapChooseClient,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/ahmed-03.png',
                      width: size.width * 0.132,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            color: Constants.mainColor,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                            Container(
                              width: size.width * 0.08,
                              child: Text(
                                clientName ??    'customer'.tr(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Constants.mainColor,
                                    fontSize: size.height * 0.02),
                              ),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: size.width * 0.02,
              ),
              InkWell(
                onTap: onTapTables,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/ahmed-02.png',
                      width: size.width * 0.132,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/chair(2).png',
                            width: size.width * 0.03,
                            color: Constants.mainColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                             tableTitle ?? 'tables'.tr(),
                              style: TextStyle(
                                  color: Constants.mainColor,
                                  fontSize: size.height * 0.02),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
