


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shormeh_pos_new_28_11_2022/models/cart_model.dart';

class ProductsTable extends StatelessWidget {
  final List<CartModel> cart ;
  const ProductsTable({Key? key, required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Table(
      border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(45),
        1: FlexColumnWidth(),
        // 2: FixedColumnWidth(90),
        2: FixedColumnWidth(70),
      },

      children:
      cart.map((e) {
        return TableRow(children: [
          TableCell(
            verticalAlignment:
            TableCellVerticalAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Center(
                child: Text(
                  e.count.toString(),
                  style:const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          TableCell(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          // width: size.width*0.25,
                          child: Text(
                            e.title!,
                            style: TextStyle(
                                fontSize: 18,
                                height: 1,
                                fontWeight:
                                FontWeight.w500),
                          ),
                        ),
                        const SizedBox(width: 5,),
                        // Spacer(),
                        Text(
                          '${e.price} SAR',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                              FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),

                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: e.attributes!.map((attribute) {
                        return Row(
                          children: [
                            const  SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .end,
                                  children:attribute.values!
                                      .map((value) => e
                                      .allAttributesValuesID!
                                      .contains(
                                      value.id)
                                      ? Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2),
                                        child: Row(
                                    children: [
                                        Expanded(
                                          child: Text(
                                              '- ${value.attributeValue!.en!}',

                                              style:const TextStyle(fontSize: 14,)),
                                        ),
                                        SizedBox(width: 5,),

                                        if(value.realPrice!=null && value.realPrice!= 0)
                                          Text(
                                              '${value.realPrice} SAR',
                                              style:const TextStyle(fontSize: 16,))
                                    ],
                                  ),
                                      )
                                      : Container())
                                      .toList()),
                            ),
                          ],
                        );
                      }).toList(),
                    ),

                    if (e.extra != null)
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: e.extra!.map((extra) {
                          return Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '- ${extra.titleEn!}',
                                    style: const TextStyle(fontSize: 16,),
                                  ),
                                ),

                                SizedBox(width: 5,),
                                if(extra.price!=0)
                                Text(
                                  '${extra.price} SAR',
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    if (e.extraNotes != null)
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 2),
                        child: Container(
                          width: double.infinity,

                          child: Text(
                           '- ${e.extraNotes!}',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 16,),
                          ),
                        ),
                      )
                  ],
                )),
          ),

          TableCell(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8, horizontal: 5),
              child: Center(
                child: Text(
                  '${e.total} SAR',
                  style: const TextStyle(
                      fontSize: 17,),
                ),
              ),
            ),
          ),
        ]);
      }).toList(),
    );
  }
}
