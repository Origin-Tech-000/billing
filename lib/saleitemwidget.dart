import 'dart:developer';

import 'package:pappettante_chayakada/domain/print/model/bill_model.dart';
import 'package:pappettante_chayakada/infrastructure/print/print.dart';
import 'package:pappettante_chayakada/infrastructure/sales/sales_report.dart';
import 'package:pappettante_chayakada/infrastructure/storage/storage.dart';
import 'package:pappettante_chayakada/main.dart';
import 'package:pappettante_chayakada/print_preview.dart';
import 'package:pappettante_chayakada/saleitemdetails.dart';
import 'package:pappettante_chayakada/salereport.dart';
import 'package:pappettante_chayakada/valueNotifiers/value_notifiers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class saleitemdetailswidget extends StatelessWidget {
  final BillModel model;
  saleitemdetailswidget({super.key, required this.model});

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (ctx) => saleitemdetailspage(
          //           model: model,
          //         )));
        },
        child:
         Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 107, 106, 98),
              borderRadius: BorderRadius.circular(10)),
          width: MediaQuery.of(context).size.width * 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * .15,
                    child: Text(
                      model.billId,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, color: Colors.white),
                    )),
                SizedBox(
                    width: MediaQuery.of(context).size.width * .15,
                    child: Text(
                      model.date,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, color: Colors.white),
                    )),
                SizedBox(
                    width: MediaQuery.of(context).size.width * .15,
                    child: Text(
                      (int.parse(model.billPrice)).toString(),
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, color: Colors.white),
                    )),
                GestureDetector(
                  onTap: () async {
                    final data = await Storage.deleteBill(id: model.billId);
                    print(data);
                    await SalesReport.loadSalesReport();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(13),
                      child: Text('DELETE',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                ),
                ValueListenableBuilder(
                    valueListenable: printStatus,
                    builder: (context, s, _) {
                      return GestureDetector(
                        onTap: () async {
                          bool status = printStatus.value;
                          log(printStatus.value.toString());
                          if (status == false) {
                            printStatus.value = true;
                            PrintBilll()
                                .printBillSingle(model: model, reprint: true,detailedPrint: false);
                          } // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (ctx) => PrintPreview(model: model)));
                          else {
                            log('printing ----');
                            null;
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: s == false
                                ? Colors.cyan
                                : const Color.fromARGB(255, 87, 174, 185),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(13),
                            child: Text(
                              'PRINT',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
