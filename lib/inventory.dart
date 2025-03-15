import 'package:pappettante_chayakada/additems.dart';
import 'package:pappettante_chayakada/infrastructure/inventory/inventory.dart';
import 'package:pappettante_chayakada/valueNotifiers/value_notifiers.dart';
import 'package:pappettante_chayakada/viewitem.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class inventory extends StatelessWidget {
  const inventory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 77, 75, 57),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 104, 100, 85),
            image: DecorationImage(
                image: AssetImage(
                  "assets/1234.jpg",
                ),
                fit: BoxFit.cover,
                opacity: .004,
                invertColors: true)),
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Additem(),
                          ));
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * .4,
                          width: MediaQuery.of(context).size.width * .22,
                          decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage(
                                  "assets/pattern.jpg",
                                ),
                                fit: BoxFit.cover,
                                opacity: .3,
                              ),
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(10)),
                          child: Stack(
                            children: [
                              Center(
                                  child: Text(
                                'Add Items',
                                style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2),
                              )),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: SizedBox(
                                    height: 120,
                                    child: LottieBuilder.asset(
                                      'assets/add.json',
                                    )),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )), //add Items
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Notifiers.isLoading.value = true;
                        Inventory.loadInventoryItem();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const viewitem()));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * .4,
                        width: MediaQuery.of(context).size.width * .22,
                        decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage(
                                "assets/pattern.jpg",
                              ),
                              fit: BoxFit.cover,
                              opacity: .3,
                            ),
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)),
                        child: Stack(
                          children: [
                            Center(
                                child: Text(
                              'View/Edit Items',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2),
                            )),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: SizedBox(
                                  height: 120,
                                  child: LottieBuilder.asset(
                                    'assets/edit.json',
                                  )),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ), //View Items;
          ],
        ),
      ),
    );
  }
}
