import 'dart:developer';

import 'package:pappettante_chayakada/valueNotifiers/value_notifiers.dart';
import 'package:pappettante_chayakada/viewitemwidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class viewitem extends StatelessWidget {
  const viewitem({super.key});

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Text(
                  'ITEMS',
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
                const SizedBox()
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ValueListenableBuilder(
                  valueListenable: Notifiers.isLoading,
                  builder: (context, isLo, _) {
                    return isLo == false
                        ? ValueListenableBuilder(
                            valueListenable: Notifiers.items,
                            builder: (context, value, _) {
                              return ListView.builder(
                                  itemCount: value.length,
                                  itemBuilder: (context, index) {
                                    return value[index].id != 0
                                        ? Viewitemswidget(
                                            name: value[index].itemName,
                                            price: value[index].itemPrice,
                                            id: value[index].id
                                            // id: '',
                                            )
                                        : const SizedBox();
                                  });
                            })
                        : const Center(
                            child: CircularProgressIndicator(),
                          );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
