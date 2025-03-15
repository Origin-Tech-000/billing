import 'package:pappettante_chayakada/infrastructure/sales/sales_report.dart';
import 'package:pappettante_chayakada/infrastructure/storage/storage.dart';
import 'package:pappettante_chayakada/itemwidgetpage.dart';
import 'package:pappettante_chayakada/valueNotifiers/value_notifiers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DailySales extends StatelessWidget {
  const DailySales({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: BackButton(
          color: Colors.white,
        ),
      )
    
      ,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width * .15,
                                child: Text(
                                  'DATE',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                )),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * .15,
                                child: Text(
                                  'TOTAL AMOUNT',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                )),
                            
                          ],
                        ),
          ),
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: Notifiers.isLoading,
                builder: (context, b, _) {
                  return ValueListenableBuilder(
                      valueListenable: Notifiers.dailySalesReport,
                      builder: (context, item, _) {
                        return ListView.builder(
                          itemCount: item.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () {
                                  SalesReport report = SalesReport();
                                  report.loadDailySaleReport(date: item[i].billDate);
                                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> ItemWidgetPage(date: item[i].billDate,)));
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
                            item[i].billDate,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600, color: Colors.white),
                          )),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * .15,
                          child: Text(
                            item[i].billPrice,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600, color: Colors.white),
                          )),
                  
                                
                                // Row(
                                //   children: [
                                //     Text(item[i].billDate),
                                //     SizedBox(width: 20),
                                //     Text(item[i].billPrice),
                                //     Divider(
                                //       thickness: 1.0,
                                //       color: Colors.black,
                                    
                                  ],
                                ),
                              ),))
                            );
                          },
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }
}
