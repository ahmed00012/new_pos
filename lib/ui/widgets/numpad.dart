import 'package:flutter/material.dart';

class Numpad extends StatefulWidget {
  @override
  State<Numpad> createState() => _NumpadState();
}

class _NumpadState extends State<Numpad> {
  // bool? ordersScreen;
  List<String> countText = [];

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Container(
              height: size.height*0.09,
              width: size.width*0.29,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: Text(countText.join(),
                    style: TextStyle(fontSize: size.height * 0.025)),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [1, 2, 3]
              .map((e) => InkWell(
                    onTap: () {
                   setState(() {
                     countText.add(e.toString());
                   });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        height: size.height*0.09,
                        width: size.width*0.09,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),

                        child: Center(
                          child: Text(
                            e.toString(),
                            style: TextStyle(fontSize: size.height * 0.022),
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

                      setState(() {
                        countText.add(e.toString());
                      });

                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        height: size.height*0.09,
                        width: size.width*0.09,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            e.toString(),
                            style: TextStyle(fontSize: size.height * 0.022),
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
                   setState(() {
                     countText.add(e.toString());
                   });

                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        height: size.height*0.09,
                        width: size.width*0.09,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            e.toString(),
                            style: TextStyle(fontSize: size.height * 0.022),
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
                if (countText.isNotEmpty)
                  setState(() {
                    countText.remove(countText.last);
                  });
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: size.height*0.09,
                  width: size.width*0.09,
                  decoration: BoxDecoration(
                    color: Colors.red[500],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),

                  child: Center(
                    child: Icon(
                      Icons.backspace_outlined,
                      size: size.height * 0.025,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (countText.isNotEmpty)
                 setState(() {
                   countText.add('0');
                 });
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: size.height*0.09,
                  width: size.width*0.09,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '0',
                      style: TextStyle(fontSize: size.height * 0.022),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                onTap: () {
                  // if (ordersScreen == null) {
                  //   // HomeController.orderDetails.cart![viewModel.chosenItem!].count =
                  //   //     int.parse(viewModel.countText.join());
                  //   viewModel.itemCount();
                  //
                  //   // HomeController.orderDetails.plusController(viewModel.chosenItem!);
                  //   // viewModel.refreshList();
                  // } else {
                  //   ordersController.searchOrder(int.parse(viewModel.countText.join())) ;
                  // }

                  Navigator.pop(context,countText.join());
                  countText = [];

                },
                child: Container(
                  height: size.height*0.09,
                  width: size.width*0.09,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),

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
        )
      ],
    ));
  }
}
