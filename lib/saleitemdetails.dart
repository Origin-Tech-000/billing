import 'package:pappettante_chayakada/domain/print/model/bill_model.dart';
import 'package:flutter/material.dart';

class saleitemdetailspage extends StatelessWidget {
  final BillModel? model;
  const saleitemdetailspage({
    super.key,
    this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black,
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.width * 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .9,
              width: MediaQuery.of(context).size.width * .8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                            children: model!.items.map((e) {
                          return Column(children: [
                            Row(
                              children: [
                                Text("ITEMS "),
                                Text(" : "),
                                Text(e.itemName),
                              ],
                            ),
                            Row(
                              children: [
                                Text("PRICE "),
                                Text(" : "),
                                Text(e.itemPrice),
                              ],
                            ),
                            Row(
                              children: [
                                Text("QTY "),
                                Text("  : "),
                                Text(e.orderQuantity!),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "TOTAL AMOUNT ",
                                  style: TextStyle(color: Colors.red),
                                ),
                                Text(" : "),
                                Text(
                                  (int.parse(e.orderQuantity!) *
                                          int.parse(e.itemPrice))
                                      .toString(),
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ]);
                        }).toList()),
                      ),
                     
                      // Row(
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Text('Waiter Name:'),
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Text(model!.waiterId ?? ''),
                      //     ),
                      //   ],
                      // ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Date And Time : ' ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(model!.date ?? ''),
                          ),
                        ],
                      ),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
