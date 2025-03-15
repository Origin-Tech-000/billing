import 'package:pappettante_chayakada/infrastructure/inventory/inventory.dart';
import 'package:pappettante_chayakada/infrastructure/storage/storage.dart';
import 'package:pappettante_chayakada/valueNotifiers/value_notifiers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Viewitemswidget extends StatelessWidget {
  final String name;
  final String price;

  final int id;
  const Viewitemswidget(
      {super.key, required this.name, required this.price, required this.id});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromARGB(255, 219, 213, 151)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Name: ',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w400),
                        ),
                        Text(
                          name.toUpperCase(),
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Price: ',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w400),
                        ),
                        Text(
                          price,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    Notifiers.isLoading.value = true;
                    Storage.deleleItem(id);
                    Inventory.loadInventoryItem();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red,
                      ),
                      width: MediaQuery.of(context).size.width * .06,
                      child: Center(
                        child: Text('Delete',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
