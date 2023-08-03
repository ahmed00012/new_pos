


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TableHeader extends StatelessWidget {
  const TableHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Table(
      border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(45),
        1: FlexColumnWidth(),
        2: FixedColumnWidth(90),
        3: FixedColumnWidth(70),
      },
      children: [
        TableRow(children: [
          TableCell(
              verticalAlignment:
              TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Center(
                  child: Text(
                    'qty'.tr(),
                    style: TextStyle(
                        fontSize: size.height*0.02,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              )),
          TableCell(
              verticalAlignment:
              TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Center(
                  child: Text(
                    'item'.tr(),
                    style:  TextStyle(
                        fontSize: size.height*0.02,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              )),
          TableCell(
              verticalAlignment:
              TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Center(
                  child: Text(
                    'price'.tr(),
                    style:  TextStyle(
                        fontSize: size.height*0.02,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              )),
          TableCell(
              verticalAlignment:
              TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Center(
                  child: Text(
                    'total'.tr(),
                    style:  TextStyle(
                        fontSize: size.height*0.02,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              )),
        ])
      ],
    );
  }
}
