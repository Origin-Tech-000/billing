import 'package:pappettante_chayakada/domain/item_model/model/model.dart';
import 'package:pappettante_chayakada/infrastructure/inventory/inventory.dart';
import 'package:pappettante_chayakada/valueNotifiers/value_notifiers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Itemswidget extends StatelessWidget {
  final String name;
  final String price;
  final int id;
  const Itemswidget({
    super.key,
    required this.name,
    required this.price,
    required this.id,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * .9,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
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
                      GestureDetector(
                        onTap: () async {
                          Notifiers.isLoading.value = true;
                          Inventory().selectedForPrinting(
                              model: ItemModel(
                                  itemName: name,
                                  itemPrice: price,
                                  id: id,
                                  orderQuantity: '1'));
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width * .2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.yellow),
                          child: Center(
                              child: Text(
                            'ADD',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        // Text('Available Qty:', style: GoogleFonts.poppins()),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
