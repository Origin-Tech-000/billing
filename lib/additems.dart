import 'dart:developer';

import 'package:pappettante_chayakada/infrastructure/storage/storage.dart';
import 'package:pappettante_chayakada/valueNotifiers/value_notifiers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Additem extends StatelessWidget {
  Additem({super.key});
  final TextEditingController name = TextEditingController();
  final TextEditingController price = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Text(
                    'ADD ITEMS',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2),
                  ),
                  const SizedBox()
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          controller: name,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(20),
                              hintStyle: GoogleFonts.poppins(),
                              border: InputBorder.none,
                              hintText: 'Item Name'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          controller: price,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(20),
                              hintStyle: GoogleFonts.poppins(),
                              border: InputBorder.none,
                              hintText: 'Price'),
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Notifiers.isLoading.value = true;

                          price.text.isEmpty
                              ? null
                              : Storage.insertItems(
                                  itemName: name.text, itemPrice: price.text);

                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return ValueListenableBuilder(
                                    valueListenable: Notifiers.isLoading,
                                    builder: ((context, isLoading, child) {
                                      return ValueListenableBuilder(
                                          valueListenable:
                                              Notifiers.itemInsertion,
                                          builder: (ctx, itemIsertion, child) {
                                            log(price.text);
                                            return AlertDialog(
                                              content: price.text.isEmpty
                                                  ? Text(
                                                      'ENTER DETAILS CORRECTLY')
                                                  : isLoading == true
                                                      ? const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        )
                                                      : itemIsertion == true
                                                          ? const Text(
                                                              'Item Added')
                                                          : const Text(
                                                              'Item Not Added'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      price.clear();
                                                      name.clear();
                                                      Notifiers.itemInsertion
                                                          .value = false;
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('OKAY'))
                                              ],
                                            );
                                          });
                                    }));
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * .2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.yellow),
                            child: Center(
                              child: Text(
                                'UPDATE',
                                style: GoogleFonts.poppins(),
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
