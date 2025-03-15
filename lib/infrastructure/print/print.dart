// ignore_for_file: avoid_print
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:pappettante_chayakada/domain/sale/model/daily_sale_model.dart';
import 'package:pappettante_chayakada/domain/sale/model/detailed_daily_sale_model.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:pappettante_chayakada/domain/item_model/model/model.dart';
import 'package:pappettante_chayakada/domain/print/model/bill_model.dart';
import 'package:pappettante_chayakada/infrastructure/inventory/inventory.dart';
import 'package:pappettante_chayakada/infrastructure/storage/storage.dart';
import 'package:pappettante_chayakada/main.dart';
import 'package:pappettante_chayakada/valueNotifiers/value_notifiers.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class PrintBilll {
  Future<void> printBill({
    required List<ItemModel> items,
  }) async {
    try {
      Notifiers.totalBill.value = 0;

      int slNo = 0;
      final data = items.map((e) {
        slNo += 1;
        final price =
            int.parse(e.itemPrice) * int.parse(e.orderQuantity ?? '1');
        Notifiers.totalBill.value += price;
        e.slNo = slNo.toString();
        return price;
      });
      print(data);
      final date = DateTime.now();
      final id =
          '${date.month}${date.hour}${date.minute}${date.year}${date.second}${date.millisecond}${date.microsecond}';
      final BillModel model = BillModel(
        date: '${date.year}-${date.month}-${date.day}',
        items: items,
        billId: id,
        billPrice: Notifiers.totalBill.value.toString(),
      );

      await printBillSingle(model: model, reprint: false, detailedPrint: false);
    } catch (j) {
      log(j.toString());
    }
  }

  Future<void> printBillSingle(
      {required BillModel model,
      required bool reprint,
      required bool detailedPrint,
      List<DetiledDailySaleModel>? detailedPrintList,String?date}) async {
    try {
      log('print function called');
      if (reprint == false) await Storage.insertSales(model: model);
      log('connected to printer ${result.toString()}');
      if (result == true) {
        if (detailedPrint == false) {
          final byte = await generateByte(model);
          // await PrintBluetoothThermal
          // reconnectWithPrinter();
          await PrintBluetoothThermal.writeBytes(byte);
          await Future.delayed(Duration(seconds: 15), () async {
            // await PrintBluetoothThermal.writeBytes([]);
            printStatus.value = false;
          });

          // await Storage.insertSales(model: model);
          sfp = [];
          Notifiers.printitems.value = sfp;
          Notifiers.totalBill.value = 0;
        } else {
          final bytes = await detailedDailyReportPrint(detailedPrintList!, date!);
          await PrintBluetoothThermal.writeBytes(bytes);
          await Future.delayed(Duration(seconds: 3), () async {
            // await PrintBluetoothThermal.writeBytes([]);
            printStatus.value = false;
          });

          // await Storage.insertSales(model: model);
          sfp = [];
          Notifiers.printitems.value = sfp;
          Notifiers.totalBill.value = 0;
        }
      }
    } catch (e) {
      print(e.toString());
      log(e.toString());
    }
  }

  Future<void> reconnectWithPrinter() async {
    try {
      await PrintBluetoothThermal.disconnect;
      print('connecting to printer');
      final List<BluetoothInfo> listResult =
          await PrintBluetoothThermal.pairedBluetooths;
      log(listResult.toString());
      await Future.forEach(listResult, (BluetoothInfo bluetooth) {
        log(bluetooth.name);
        log(bluetooth.macAdress);
        // String name = bluetooth.name;
        // String mac = bluetooth.macAdress;
      });
      final String macId = 'ab:0a:20:24:41:12';
      result = await PrintBluetoothThermal.connect(macPrinterAddress: macId);
      log('connected to printer $result');
    } catch (e) {
      log(e.toString());
    }
  }
}

Future<List<int>> generateByte(BillModel model) async {
  List<int> bytes = [];

  // Load ESC/POS profile
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm58, profile);

  bytes += generator.reset();

  // Load and print logo
  // final ByteData data = await rootBundle.load('assets/logo.png');
  // final Uint8List bytesImg = data.buffer.asUint8List();
  // final image = Imag.decodeImage(bytesImg);
  // if (image != null) {
  //   bytes += generator.image(image);
  // }

  // Header
  final ByteData data = await rootBundle.load('assets/logopappan.png');
  final Uint8List byte = data.buffer.asUint8List();
  final Image? img = decodeImage(byte);
// final ByteData data = await rootBundle.load('assets/logo.png');
// final Uint8List bytes = data.buffer.asUint8List();
// final Image image = decodeImage(bytes);
// Using `ESC *`
  bytes += generator.image(img!);

// Using `GS v 0` (obsolete)
// generator.imageRaster(img);
// Using `GS ( L`
// generator.imageRaster(img);
  // bytes += generator.text('PAPPETTANTE CHAYAKADA',
  // styles: PosStyles(bold: true, align: PosAlign.center));
  bytes += generator.text('New Bus Stand',
      styles: PosStyles(align: PosAlign.center));
  bytes +=
      generator.text('KATTAPPANA', styles: PosStyles(align: PosAlign.center));
  bytes +=
      generator.text('Phone : +919207390047', styles: PosStyles(align: PosAlign.center));
  bytes += generator.feed(1);

  // Date & Bill Info
  final date = DateTime.now();
  bytes += generator.text(
      'DATE: ${date.day}-${date.month}-${date.year}  TIME: ${date.hour}:${date.minute}',
      styles: PosStyles(align: PosAlign.left));
  bytes += generator.text('BILL NO : ${model.billId}',
      styles: PosStyles(align: PosAlign.left));
  bytes += generator.hr(); // Divider

  // Title
  bytes += generator.text('SALE BILL',
      styles: PosStyles(bold: true, align: PosAlign.center));

  // Table Header
  bytes += generator.row([
    PosColumn(
        text: 'SL', width: 2, styles: PosStyles(bold: true)), // Increased to 2
    PosColumn(
        text: 'Item',
        width: 3,
        styles: PosStyles(bold: true)), // Increased to 4
    PosColumn(text: 'Qty', width: 2, styles: PosStyles(bold: true)),
    PosColumn(text: 'Rate', width: 2, styles: PosStyles(bold: true)),
    PosColumn(text: 'Price', width: 3, styles: PosStyles(bold: true)),
  ]);

  for (var item in model.items) {
    bytes += generator.row([
      PosColumn(text: item.slNo.toString(), width: 2), // Matches header width
      PosColumn(text: item.itemName, width: 3),
      PosColumn(text: item.orderQuantity.toString(), width: 2),
      PosColumn(text: item.itemPrice, width: 2),
      PosColumn(
          text: (int.parse(item.orderQuantity!) * int.parse(item.itemPrice))
              .toString(),
          width: 3),
    ]);
  }
  bytes += generator.hr(); // Divider

  // Total Amount
  bytes += generator.text('Total Amount : ${model.billPrice}',
      styles: PosStyles(bold: true, align: PosAlign.right));
  // bytes += generator.text('Additional Charges : ${model.additional}',
  //     styles: PosStyles(bold: true, align: PosAlign.right));
  bytes += generator.text('Final Amount : ${int.parse(model.billPrice)}',
      styles: PosStyles(bold: true, align: PosAlign.right));

  bytes += generator.hr(); // Divider

  // Footer Message
  bytes += generator.text('CAUTION: CONSUME PACKED FOOD WITHIN 2 HOURS',
      styles: PosStyles(align: PosAlign.center));
  bytes += generator.feed(1);
  bytes += generator.text('THANK YOU VISIT AGAIN',
      styles: PosStyles(bold: true, align: PosAlign.center));

  // QR Code
  // bytes += generator.text('example.com');

  bytes += generator.cut();
  return bytes;
}

Future<List<int>> detailedDailyReportPrint(
    List<DetiledDailySaleModel> model , String date) async {
  List<int> bytes = [];

  // Load ESC/POS profile
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm58, profile);

  bytes += generator.reset();

  // Load and print logo
  // final ByteData data = await rootBundle.load('assets/logo.png');
  // final Uint8List bytesImg = data.buffer.asUint8List();
  // final image = Imag.decodeImage(bytesImg);
  // if (image != null) {
  //   bytes += generator.image(image);
  // }

  // Header
  final ByteData data = await rootBundle.load('assets/logopappan.png');
  final Uint8List byte = data.buffer.asUint8List();
  final Image? img = decodeImage(byte);
// final ByteData data = await rootBundle.load('assets/logo.png');
// final Uint8List bytes = data.buffer.asUint8List();
// final Image image = decodeImage(bytes);
// Using `ESC *`
  bytes += generator.image(img!);

// Using `GS v 0` (obsolete)
// generator.imageRaster(img);
// Using `GS ( L`
// generator.imageRaster(img);
  // bytes += generator.text('PAPPETTANTE CHAYAKADA',
  // styles: PosStyles(bold: true, align: PosAlign.center));
  bytes += generator.text('New Bus Stand',
      styles: PosStyles(align: PosAlign.center));
  bytes +=
      generator.text('KATTAPPANA', styles: PosStyles(align: PosAlign.center));
  
  bytes += generator.feed(1);

  // Date & Bill Info
  // final date = DateTime.now();

  bytes += generator.text(
      "DATE : $date",
      styles: PosStyles(align: PosAlign.left));
  // bytes += generator.text('BILL NO : ${model.billId}',
  // styles: PosStyles(align: PosAlign.left));
  bytes += generator.hr(); // Divider

  // Title
  bytes += generator.text('ITEM DETAILED BILL',
      styles: PosStyles(bold: true, align: PosAlign.center));
  bytes += generator.hr(); // Divider


  // Table Header
  bytes += generator.row([
    // PosColumn(
    //     text: 'SL', width: 2, styles: PosStyles(bold: true)), // Increased to 2
    PosColumn(
        text: 'Item',
        width: 3,
        styles: PosStyles(bold: true)), // Increased to 4
    PosColumn(text: 'PRICE', width: 3, styles: PosStyles(bold: true)),
    PosColumn(text: 'QTY', width: 3, styles: PosStyles(bold: true)),
    PosColumn(text: 'TOTAL', width: 3, styles: PosStyles(bold: true)),
  ]);
  bytes += generator.hr(); // Divider


  for (var item in model) {
    bytes += generator.row([
      PosColumn(text: item.item, width: 3), // Matches header width
      PosColumn(text: item.itemPrice, width: 3),
      PosColumn(text: item.itemQuantity, width: 3),
      PosColumn(text: (int.parse(item.itemPrice)*int.parse(item.itemQuantity)).toString(), width: 3),
      // PosColumn(text: item.itemPrice, width: 2),
      // PosColumn(
      //     text: (int.parse(item.orderQuantity!) * int.parse(item.itemPrice))
      //         .toString(),
      //     width: 3),
    ]);
  }
  bytes += generator.hr(); // Divider
  int total = 0;

  for (var element in model) {
    int data = int.parse(element.itemQuantity)*int.parse(element.itemPrice);
    total+= data;
  }

  bytes += generator.text('TOTAL SALE :$total',
      styles: PosStyles(bold: true, align: PosAlign.right));

//  bytes+= PosColumn(text: ('TOTAL AMOUNT = $total'), width: 12);


  // Total Amount
  // bytes += generator.text('Total Amount : ${model.billPrice}',
      // styles: PosStyles(bold: true, align: PosAlign.right));
  // bytes += generator.text('Additional Charges : ${model.additional}',
  //     styles: PosStyles(bold: true, align: PosAlign.right));
  // bytes += generator.text('Final Amount : ${int.parse(model.billPrice)}',
      // styles: PosStyles(bold: true, align: PosAlign.right));

  bytes += generator.hr(); // Divider

  // Footer Message
  // bytes += generator.text('CAUTION: CONSUME PACKED FOOD WITHIN 2 HOURS',
  //     styles: PosStyles(align: PosAlign.center));
  // bytes += generator.feed(1);
  // bytes += generator.text('THANK YOU VISIT AGAIN',
  //     styles: PosStyles(bold: true, align: PosAlign.center));

  // QR Code
  // bytes += generator.text('example.com');

  bytes += generator.cut();
  return bytes;
}
