// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:pappettante_chayakada/domain/print/model/bill_model.dart';
import 'package:pappettante_chayakada/main.dart';

import 'package:pappettante_chayakada/valueNotifiers/value_notifiers.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:intl/intl.dart';

class Storage {
  static Future<Database> connDb() async {
    return await df.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onConfigure: (database) async {
          await database.execute("PRAGMA foreign_keys = ON");
        },
        onCreate: (database, v) async {
          await database.execute(
            'CREATE TABLE items(id INTEGER PRIMARY KEY NOT NULL, itemName TEXT NOT NULL,itemPrice TEXT NOT NULL)',
          );
          await database.execute(
            'CREATE TABLE bill(id STRING PRIMARY KEY NOT NULL, billPrice TEXT NOT NULL,billId TEXT NOT NULL,date TEXT NOT NULL)',
          );
          await database.execute(
            'CREATE TABLE billItems(id INTEGER PRIMARY KEY NOT NULL, itemName TEXT NOT NULL,orderQuantity TEXT NOT NULL,itemPrice TEXT NOT NULL,billId TEXT NOT NULL,FOREIGN KEY(billId) REFERENCES bill(id))',
          );
        },
      ),
    );
  }

  static Future<void> insertItems(
      {required String itemName, required String itemPrice}) async {
    try {
      final data = await db.rawInsert(
          "INSERT INTO items(itemName,itemPrice) VALUES (?,?)",
          [itemName, itemPrice]);
      if (data > 0) {
        Notifiers.itemInsertion.value = true;
        Notifiers.isLoading.value = false;
      } else {
        Notifiers.itemInsertion.value = false;
        Notifiers.isLoading.value = false;
      }
    } catch (e) {
      Notifiers.itemInsertion.value = false;
      Notifiers.isLoading.value = false;
    }
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    try {
      final data = await db.rawQuery("SELECT * FROM items");
      Notifiers.isLoading.value = false;
      return data;
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> deleleItem(id) async {
    try {
      final data = await db.rawQuery("DELETE FROM items WHERE id=?", [id]);
      Notifiers.isLoading.value = false;
      return data;
    } catch (e) {
      return [];
    }
  }

  static Future<void> insertSales({required BillModel model}) async {
    try {
      final data = await db.rawInsert(
          'INSERT INTO bill(id,billId,billPrice,date) VALUES (?,?,?,?)', [
        model.billId,
        model.billId,
        model.billPrice,
        // model.additional,
        model.date
      ]);
      if (data > 0) {
        print(model.items[0].itemName);
        final data = await Future.wait(model.items.map((e) async {
          return await db.rawInsert(
              'INSERT INTO billItems(itemName,itemPrice,orderQuantity,billId) VALUES(?,?,?,?)',
              [e.itemName, e.itemPrice, e.orderQuantity, model.billId]);
        }));
        print(data);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<List<Map>> loadSalesReport() async {
    try {
      final data = await db.rawQuery('SELECT * FROM bill');
      return data;
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<List<Map>> filterSalesReport({required String date}) async {
    try {
      final da = date.split('-');
      final d = DateFormat('yyyy-M-d').format(
          DateTime(int.parse(da[0]), int.parse(da[1]), int.parse(da[2])));
      final data = await db.rawQuery('SELECT * FROM bill WHERE date=?', [d]);
      return data;
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<List<Map>> loadBillItems({required String billId}) async {
    try {
      final data =
          await db.rawQuery("SELECT * FROM billItems WHERE billId=?", [billId]);
      print(data);
      return data;
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<List<Map<String, String>>> loadBillWithDate() async {
    try {
      List<Map<String, String>> dates = [];
      String prevDate = '';
      int billTotal = 0;
      final data = await db.rawQuery("SELECT * FROM bill");
      for (var element in data) {
        String eDate = element['date'].toString();
        if (prevDate != eDate) {
          dates.add({'date': eDate});
          prevDate = eDate;
        }
      }
      for (var d in dates) {
        final data =
            await db.rawQuery("SELECT * FROM bill WHERE date=?", [d['date']]);
        for (var e in data) {
          if (e['date'].toString() == d['date']) {
            billTotal += int.parse(e['billPrice'].toString());
            d['totalPrice'] = billTotal.toString();
          }
        }
        billTotal = 0;
      }
      return dates;
    } catch (e) {
      return [];
    }
    // throw UnimplementedError();
  }

  static Future<List<Map<String, dynamic>>> loadDetailedDailySaleReport(
      {required String date}) async {
    try {
      List<String> billId = [];
      List<Map<String, dynamic>> items = [];

      final itemList = await db.rawQuery("SELECT * FROM items");
      for (var item in itemList) {
        items.add({
          'item': item['itemName'].toString(),
          'itemPrice': item['itemPrice'].toString(),
          'itemQuantity': 0,
        });
      }
      final data = await db.rawQuery("SELECT * FROM bill WHERE date=?", [date]);
      for (var element in data) {
        String id = '';
        id = element['billId'].toString();
        billId.add(id);
      }
      List<Map<String, dynamic>> bill = [];
      for (var id in billId) {
        final billdata =
            await db.rawQuery("SELECT * FROM billItems WHERE billId=?", [id]);
        bill = bill + billdata;
      }
      // log(bill.toString());
      for (var item in items) {
        for (var billItem in bill) {
          log(billItem.toString());
          if (item['item'] == billItem['itemName']) {
            item['itemQuantity'] +=
                int.parse(billItem['orderQuantity'].toString());
          }
        }
      }
      log(items.toString());

      return items;
    } catch (e) {
      log(e.toString());
      return [];
    }
    // throw UnimplementedError();
  }

  static Future<bool> deleteBill({required String id}) async {
    try {
      await db.delete('billItems', where: 'billId=?', whereArgs: [id]);
      await db.delete('bill', where: 'billId=?', whereArgs: [id]);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
