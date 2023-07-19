


import 'package:flutter/material.dart';
import 'package:shormeh_pos_new_28_11_2022/models/cart_model.dart';

class ProductsTable extends StatelessWidget {
  final List<CartModel> cart ;
  const ProductsTable({Key? key, required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                      fontSize: 17,
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
                                fontSize: size.height*0.02,
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
                              fontSize: size.height*0.018,
                              fontWeight:
                              FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    ListView.builder(
                      itemCount: e.attributes!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, j) {
                        return Padding(
                          padding: const EdgeInsets
                              .symmetric(vertical: 5),
                          child: Container(
                            width: size.width*0.12,
                            child: Row(
                              children: [
                                const  SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .end,
                                      children: e
                                          .attributes![j]
                                          .values!
                                          .map((value) => e
                                          .allAttributesID!
                                          .contains(
                                          value.id)
                                          ? Row(
                                        children: [
                                          Expanded(

                                            child: Text(
                                                value.attributeValue!.en!,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(color: Colors.black,
                                                    fontSize: size.height*0.02,
                                                    fontWeight: FontWeight.w500)),
                                          ),
                                          SizedBox(width: 5,),

                                          if(value.realPrice!=null)
                                            Text(
                                                '${value.realPrice} SAR',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(color: Colors.black,
                                                    fontSize: size.height*0.018,
                                                    fontWeight: FontWeight.w500))
                                        ],
                                      )
                                          : Container())
                                          .toList()),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    if (e.extra != null)
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: e.extra!.map((extra) {
                          return Padding(
                            padding:
                            const EdgeInsets.all(
                                2.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    extra.titleEn!,

                                    style: TextStyle(
                                        fontSize: size.height*0.02,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight:
                                        FontWeight.w500),
                                  ),
                                ),

                                SizedBox(width: 5,),
                                Text(
                                  '${extra.price} SAR',
                                  style: TextStyle(
                                      fontSize: size.height*0.018,
                                      fontWeight:
                                      FontWeight.w500),
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    if (e.extraNotes != null)
                      Padding(
                        padding:
                        const EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                e.extraNotes!,
                                style: TextStyle(
                                    fontSize: size.height*0.02,
                                    fontWeight:
                                    FontWeight.w500),
                              ),
                            ),

                            // Spacer(),
                            SizedBox(width: 5,),
                            Text(
                              '0.0 SAR',
                              style: TextStyle(
                                  fontSize: size.height*0.018,
                                  fontWeight:
                                  FontWeight.w500),
                            )
                          ],
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
                      fontSize: 17,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ]);
      }).toList(),
    );
  }
}
