import 'package:pappettante_chayakada/infrastructure/inventory/inventory.dart';
import 'package:pappettante_chayakada/itemswidget.dart';
import 'package:pappettante_chayakada/valueNotifiers/value_notifiers.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class Itemselection extends StatelessWidget {
  const Itemselection({
    super.key,
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
        body: SafeArea(
          child:
              //  (BlocBuilder<InventoryBloc, InventoryState>(
              //   builder: (context, state) {
              //     return
              Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      onChanged: (v) {
                        print(v);
                        Inventory().searchInventoryItem(query: v);
                        // if (v != '') {
                        //   context.read<InventoryBloc>().add(
                        //       InventoryEvent.searchItems(
                        //           items: state.items, searchQuery: v));
                        // } else {
                        //   context
                        //       .read<InventoryBloc>()
                        //       .add(const InventoryEvent.started());
                        // }
                      },
                      style: GoogleFonts.poppins(),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search Food Or Beverages',
                          hintStyle: GoogleFonts.poppins(),
                          contentPadding: const EdgeInsets.all(10)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: ValueListenableBuilder(
                      valueListenable: Notifiers.isLoading,
                      builder: (context, v, _) {
                        return v == false
                            ? ValueListenableBuilder(
                                valueListenable: Notifiers.items,
                                builder: (context, items, _) {
                                  return ListView.builder(
                                    itemCount: items.length,
                                    itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Itemswidget(
                                        name: items[index].itemName,
                                        price: items[index].itemPrice,
                                        id: items[index].id,
                                      ),
                                    ),
                                  );
                                })
                            : const Center(
                                child: CircularProgressIndicator(),
                              );
                      }),
                )
              ],
              // );
              // },
              // )),
            ),
          ),
        ));
  }
}
