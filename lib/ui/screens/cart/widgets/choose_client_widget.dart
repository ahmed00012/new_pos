import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/models/client_model.dart';
import '../../../../constants/colors.dart';
import '../../../../data_controller/cart_controller.dart';

class ChooseClientWidget extends ConsumerWidget {
  const ChooseClientWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final cartController = ref.watch(cartFuture);
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [


        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Container(
            height: size.height * 0.07,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12, width: 1.2),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                // controller: viewModel.customerPhone,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  label: Text(
                    'searchHere'.tr(),
                    style: TextStyle(
                      fontSize: size.height * 0.02,
                      color: Colors.black45,
                    ),
                  ),
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.search,
                    color: Colors.black45,
                  ),
                ),
                onChanged: (text) {
                  cartController.onSearchClientTextChanged(text);
                },
              ),
            ),
          ),
        ),

        SizedBox(
          height: size.height * 0.06,
          child: Row(
            children: [
              const SizedBox(
                width: 30,
              ),
              SizedBox(
                  width: size.width * 0.1,
                  child: Text(
                    'client'.tr(),
                    style: const TextStyle(
                      color: Colors.black38,
                    ),
                  )),
              const Spacer(),
              SizedBox(
                  width: size.width * 0.1,
                  child: Text(
                    'phone'.tr(),
                    style: const TextStyle(
                      color: Colors.black38,
                    ),
                  )),
              const Spacer(),
              SizedBox(
                  width: size.width * 0.05,
                  child: Text(
                    'points'.tr(),
                    style: const TextStyle(
                      color: Colors.black38,
                    ),
                  )),
              const Spacer(),
              SizedBox(
                  width: size.width * 0.05,
                  child: Text(
                    'balance'.tr(),
                    style: const TextStyle(
                      color: Colors.black38,
                    ),
                  )),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
        Divider(),

        Expanded(
          child: cartController.clientsLoading
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Constants.mainColor,
                ))
              : ListView.separated(
                  itemCount: cartController.clients.length,
                  itemBuilder: (context, i) {
                    ClientModel client = cartController.clients[i];
                    return InkWell(
                      onTap: () {
                        cartController.chooseClient(name: client.name! , phone: client.phone! );
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: size.height * 0.07,
                        width: size.width * 0.7,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 30,
                            ),
                            if (client.allowCreateOrder)
                              const Icon(
                                Icons.block,
                                color: Colors.red,
                              ),
                            if (client.allowCreateOrder)
                              const Icon(
                                Icons.person_outline,
                                color: Constants.mainColor,
                              ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                                width: size.width * 0.1,
                                child: Text(
                                  client.name!,
                                  style: TextStyle(
                                      color: client.allowCreateOrder
                                          ? Colors.black
                                          : Colors.red),
                                )),
                            const Spacer(),
                            const Icon(
                              Icons.phone,
                              color: Constants.mainColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                                width: size.width * 0.1,
                                child: Text(
                                  client.phone!,
                                  style: TextStyle(
                                      color: client.allowCreateOrder
                                          ? Colors.black
                                          : Colors.red),
                                )),
                            const Spacer(),
                            const Icon(
                              Icons.bookmark_border,
                              color: Constants.mainColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                                width: size.width * 0.05,
                                child: Text(
                                  client.points ?? '0',
                                  style: TextStyle(
                                      color: client.allowCreateOrder
                                          ? Colors.black
                                          : Colors.red),
                                )),
                            const Spacer(),
                            const Icon(
                              Icons.monetization_on_outlined,
                              color: Constants.mainColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              client.balance ?? '0',
                              style: TextStyle(
                                  color: client.allowCreateOrder
                                      ? Colors.black
                                      : Colors.red),
                            ),
                            SizedBox(
                              width: 30,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                ),
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
    );
  }
}
