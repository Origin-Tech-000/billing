import 'dart:developer';
import 'package:pappettante_chayakada/infrastructure/print/print.dart';
import 'package:pappettante_chayakada/infrastructure/sales/sales_report.dart';
import 'package:pappettante_chayakada/inventory.dart';
import 'package:pappettante_chayakada/print.dart';
import 'package:pappettante_chayakada/salereport.dart';
import 'package:pappettante_chayakada/infrastructure/storage/storage.dart';
import 'package:pappettante_chayakada/valueNotifiers/value_notifiers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as p;

ValueNotifier<bool> result = ValueNotifier(false);
late io.Directory dir;
late Database db;
late DatabaseFactory df;
late String dbPath;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  df = databaseFactory;
  dir = await getApplicationDocumentsDirectory();
  dbPath = p.join(dir.path, "database", "pappettantekada.db");
  db = await Storage.connDb();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> connectToPrinter() async {
    try {
      print('connecting to printer');
      final List<BluetoothInfo> listResult =
          await PrintBluetoothThermal.pairedBluetooths;
      log(listResult.toString());
      await Future.forEach(listResult, (BluetoothInfo bluetooth) {
        // log(bluetooth.name);
        // log(bluetooth.macAdress);
        // String name = bluetooth.name;
        // String mac = bluetooth.macAdress;
      });
      final String macId = 'ab:0a:20:24:41:12';

      final connected = await PrintBluetoothThermal.connect(
        macPrinterAddress: macId,
      );
      result.value = connected;
      log('connected to printer $connected');
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    connectToPrinter();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PAPPAETTANTEA CHAYAKADA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const pappettante_chayakadamenu(),
    );
  }
}

ValueNotifier<bool> printStatus = ValueNotifier(false);

class pappettante_chayakadamenu extends StatelessWidget {
  const pappettante_chayakadamenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('', style: GoogleFonts.poppins(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'PRINTER STATUS',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: result,
            builder: (context, c, _) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: c == true ? Colors.green : Colors.red,
                  ),
                  height: 10,
                  width: 10,
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                final print = PrintBilll();
                print.reconnectWithPrinter();
              },
              child: Text('RECONNECT'),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 104, 100, 85),
          image: DecorationImage(
            image: AssetImage("assets/1234.jpg"),
            fit: BoxFit.cover,
            opacity: .004,
            invertColors: true,
          ),
        ),
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.width * 1,
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const inventory(),
                          ),
                        );
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * .4,
                        width: MediaQuery.of(context).size.width * .22,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage("assets/pattern.jpg"),
                            fit: BoxFit.cover,
                            opacity: .3,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 20,
                              spreadRadius: 5,
                              color: Colors.black,
                            ),
                          ],
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                'ITEMS',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: SizedBox(
                                height: 120,
                                child: LottieBuilder.asset('assets/food1.json'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ), //inventory
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Notifiers.isLoading.value = true;
                        SalesReport.loadSalesReport();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const salereport(),
                          ),
                        );
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * .4,
                        width: MediaQuery.of(context).size.width * .22,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage("assets/pattern.jpg"),
                            fit: BoxFit.cover,
                            opacity: .3,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 20,
                              spreadRadius: 5,
                              color: Colors.black,
                            ),
                          ],
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                'SALE REPORT',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 1,
                              right: -1,
                              child: SizedBox(
                                height: 120,
                                child: LottieBuilder.asset('assets/bill1.json'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ), //sale report
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: printStatus,
                      builder: (context, s, _) {
                        return GestureDetector(
                          onTap: () {
                            if (s == true) {
                              log('printing process going on ');
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PrintBill(),
                                ),
                              );
                            }
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * .4,
                            width: MediaQuery.of(context).size.width * .22,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage("assets/pattern.jpg"),
                                fit: BoxFit.cover,
                                opacity: .3,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                  color: Colors.black,
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Text(
                                    'PRINT',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: SizedBox(
                                    height: 120,
                                    width: 100,
                                    child: LottieBuilder.asset(
                                      'assets/print.json',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
