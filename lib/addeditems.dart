import 'package:pappettante_chayakada/infrastructure/inventory/inventory.dart';
import 'package:pappettante_chayakada/inventory.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class Addeditems extends StatelessWidget {
  final String name;
  final String price;
  final int id;
  final int index;
  final String? orderQ;
  Addeditems({
    super.key,
    required this.name,
    required this.price,
    required this.id,
    required this.index,
    this.orderQ,
  });
  TextEditingController quantity = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (v) {
        // context.read<InventoryBloc>().add(const InventoryEvent.clearSFE());
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * .9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              name.toUpperCase(),
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Price : $price RS',
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                              Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width * .1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.yellow),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                      controller: quantity,
                                      onChanged: (v) {
                                        Inventory().editSfpItemQuantity(
                                            index: index,
                                            quantity: quantity.text);
                                      },
                                      decoration: InputDecoration( 
                                        
                                        hintStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                          border: InputBorder.none,
                                          hintText: orderQ),
                                    ),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: GestureDetector(
                onTap: () {
                  Inventory inventory = Inventory();
                  inventory.deleteSelectedForPrintingItem(id: id);
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
