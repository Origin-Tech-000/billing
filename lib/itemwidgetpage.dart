import 'package:pappettante_chayakada/dailysalewidget.dart';
import 'package:pappettante_chayakada/domain/print/model/bill_model.dart';
import 'package:pappettante_chayakada/domain/sale/model/detailed_daily_sale_model.dart';
import 'package:pappettante_chayakada/infrastructure/print/print.dart';
import 'package:pappettante_chayakada/valueNotifiers/value_notifiers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemWidgetPage extends StatelessWidget {
String? date;
  ItemWidgetPage({super.key, this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: BackButton(
          color: Colors.white,
        ),
        title: Text(date!, style: GoogleFonts.poppins(color: Colors.white),),
        actions: [
          GestureDetector(
            onTap: () async {
              PrintBilll p = PrintBilll();
              await p.printBillSingle(
                  model:
                      BillModel(items: [], billId: '', billPrice: '', date: ''),
                  reprint: false,
                  detailedPrint: true,
                  detailedPrintList: Notifiers.detiledDailyReport.value,date: date!);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.yellow,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text('PRINT',
                      style: GoogleFonts.poppins(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.black38,
          child: ValueListenableBuilder(
              valueListenable: Notifiers.detiledDailyReport,
              builder: (context, i, c) {
                return ListView.builder(
                  itemCount: i.length,
                  itemBuilder: (context, index) => DailySalewidget(
                    name: i[index].item,
                    price: i[index].itemPrice,
                    qty: i[index].itemQuantity,
                  ),
                );
              }),
        ),
      ),
    );
  }
}
