import 'dart:developer';

import 'package:pappettante_chayakada/addeditems.dart';
import 'package:pappettante_chayakada/infrastructure/inventory/inventory.dart';
import 'package:pappettante_chayakada/infrastructure/print/print.dart';
import 'package:pappettante_chayakada/itemselection.dart';
import 'package:pappettante_chayakada/main.dart';
import 'package:pappettante_chayakada/valueNotifiers/value_notifiers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrintBill extends StatelessWidget {
  final String? tableno;
  final String? orderType;
  const PrintBill({super.key, this.tableno, this.orderType});

  // TextEditingController additional = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            sfp = [];
            Notifiers.printitems.value = [];
            Navigator.of(context).pop();
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Colors.black),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Notifiers.isLoading.value = true;
                  Inventory.loadInventoryItem();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Itemselection()));
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                      color: Colors.yellow, shape: BoxShape.circle),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () async {
                    if (printStatus.value == false) {
                      PrintBilll().printBill(
                        items: Notifiers.printitems.value,
                        // additional: additional.text
                      );
                      Notifiers.printitems.value = [];
                      sfp = [];
                      Navigator.of(context).pop();
                    } else {
                      log('printing ongoing');
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/1234.jpg",
                  ),
                  fit: BoxFit.cover,
                  opacity: .004,
                  invertColors: true)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Text(
                        'PRINT BILL',
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 18),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                    Container(
                      child: Text(
                        'ADD ITEMS',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.white,
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: Notifiers.isLoading,
                    builder: (context, b, _) {
                      return ValueListenableBuilder(
                        valueListenable: Notifiers.printitems,
                        builder: (context, items, _) {
                          return ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(10),
                              child: Addeditems(
                                name: items[index].itemName,
                                price: items[index].itemPrice,
                                id: items[index].id,
                                orderQ: items[index].orderQuantity,
                                index: index,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
