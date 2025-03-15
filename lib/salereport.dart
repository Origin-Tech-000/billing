import 'package:pappettante_chayakada/daily_sales.dart';
import 'package:pappettante_chayakada/fliterdate.dart';
import 'package:pappettante_chayakada/infrastructure/sales/sales_report.dart';
import 'package:pappettante_chayakada/infrastructure/storage/storage.dart';
import 'package:pappettante_chayakada/saleitemwidget.dart';
import 'package:pappettante_chayakada/valueNotifiers/value_notifiers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class salereport extends StatelessWidget {
  const salereport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 71, 71, 71),

      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const filterDate(),
              ));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green),
                child: Center(
                    child: Text(
                  'Filter',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, color: Colors.white),
                )),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              SalesReport report = SalesReport();
              Notifiers.isLoading.value = true;
              report.loadDailySaleDateAndPrice();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => DailySales()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // height: 30,
                width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.yellow),
                child: Center(child: Builder(builder: (context) {
                  return ValueListenableBuilder(
                      valueListenable: Notifiers.totalSales,
                      builder: (context, i, _) {
                        return Text(
                          'Total Sales :$i',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      });
                })),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //     height: 30,
          //     width: 100,
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10),
          //         color: Colors.cyanAccent),
          //     child: Center(
          //         child: Text(
          //       'Detailed',
          //       style: GoogleFonts.poppins(
          //         fontWeight: FontWeight.w500,
          //       ),
          //     )),
          //   ),
          // )
        ],
        backgroundColor: Colors.black,
      ),
      // backgroundColor: Bgcolor,
      body: Container(
        width: MediaQuery.of(context).size.width * 1,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/1234.jpg",
                ),
                fit: BoxFit.cover,
                opacity: .004,
                invertColors: true)),
        height: MediaQuery.of(context).size.height * 1,
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      height: 50,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: Color.fromARGB(255, 107, 106, 98),
                      ),
                      width: MediaQuery.of(context).size.width * 1,
                      child: 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .15,
                              child: Text(
                                'BILL ID',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              )),
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
                                'AMOUNT',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              )),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ValueListenableBuilder(
                        valueListenable: Notifiers.isLoading,
                        builder: (context, v, _) {
                          return v == false
                              ? ValueListenableBuilder(
                                  valueListenable: Notifiers.sales,
                                  builder: (context, s, _) {
                                    return ListView.builder(
                                      reverse: true,
                                      itemCount: s.length,
                                      itemBuilder: (context, index) {
                                        return saleitemdetailswidget(
                                          model: s[index],
                                        );
                                      },
                                    );
                                  })
                              : const Center(
                                  child: CircularProgressIndicator(),
                                );
                        }),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
