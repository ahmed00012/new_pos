

import 'package:flutter/material.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';

import '../../../../constants/colors.dart';
import '../../../../models/customer_model.dart';

class SelectCustomerDialog extends StatefulWidget {
  final List<CustomerModel> paymentCustomers;
  final Function(int) onSelect ;
  final CustomerModel ?customer ;
  const SelectCustomerDialog({Key? key ,required this.paymentCustomers ,
    required this.onSelect, this.customer}) : super(key: key);

  @override
  State<SelectCustomerDialog> createState() => _SelectCustomerDialogState();
}

class _SelectCustomerDialogState extends State<SelectCustomerDialog> {
  int ?selectedCustomerIndex;


  @override
  void initState() {
    // TODO: implement initState
    if(widget.customer != null){
      widget.paymentCustomers.asMap().forEach((index , element) {
        if(element.id == widget.customer!.id){
          selectedCustomerIndex = index ;
        }
      });
    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = ConstantStyles.contextSize(context);
    return Container(
      width: size.width * 0.4,
      height: size.height * 0.6,
      child: GridView.builder(
          itemCount: widget.paymentCustomers.length,
          gridDelegate:
         const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.5),
          itemBuilder: (context, i) {
            return InkWell(
              onTap: () {
                widget.onSelect(i);
                setState(() {
                  selectedCustomerIndex = i;
                });
                Navigator.pop(context,widget.customer);

              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                          color: selectedCustomerIndex == i
                              ? Constants.mainColor
                              : Constants.scaffoldColor,
                          width: 2)),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                    children: [
                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(
                            8),
                        child: Image.network(
                          widget.paymentCustomers[i].image!,
                          height: size.height * 0.06,
                        ),
                      ),
                      Text(
                        widget.paymentCustomers[i].title!,
                        style: TextStyle(
                            color: selectedCustomerIndex == i
                                ? Constants.mainColor
                                : Colors.black,
                            fontSize:
                            size.height * 0.02),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
