import 'dart:developer';

import 'package:pappettante_chayakada/domain/item_model/model/model.dart';
import 'package:pappettante_chayakada/domain/print/model/bill_model.dart';
import 'package:pappettante_chayakada/domain/sale/model/daily_sale_model.dart';
import 'package:pappettante_chayakada/domain/sale/model/detailed_daily_sale_model.dart';
import 'package:pappettante_chayakada/infrastructure/storage/storage.dart';
import 'package:pappettante_chayakada/valueNotifiers/value_notifiers.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

class SalesReport {
  static Future<void> loadSalesReport() async {
    try {
      Notifiers.totalSales.value = 0;
      final data = await Storage.loadSalesReport();
      final List<BillModel> model = await Future.wait((data.map((e) async {
        final billItems = await Storage.loadBillItems(billId: e['billId']);
        int slNo = 0;
        final List<ItemModel> model = billItems.map(
          (r) {
            slNo += 1;
            return ItemModel(
              itemName: r['itemName'],
              itemPrice: r['itemPrice'],
              id: r['id'],
              orderQuantity: r['orderQuantity'],
              slNo: slNo.toString(),
            );
          },
        ).toList();
        final price = int.parse(e['billPrice']);
        Notifiers.totalSales.value += price;
        final date = DateTime.now();

        return BillModel(
          date: '${date.year}-${date.month}-${date.day}',
          items: model,
          billId: e['billId'],
          billPrice: e['billPrice'],
          // additional: e['additional'],
        );
      }).toList()));
      Notifiers.sales.value = model;
      Notifiers.isLoading.value = false;
    } catch (e) {
      log(e.toString());
      Notifiers.sales.value = [];
    }
  }

  static Future<void> filterSaleReport({required DateRange range}) async {
    try {
      final startDate =
          DateTime(range.start.year, range.start.month, range.start.day);
      final endDate = DateTime(range.end.year, range.end.month, range.end.day);
      List<DateTime> days = [];
      for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
        days.add(startDate.add(Duration(days: i)));
      }
      List<Map<dynamic, dynamic>> list = [];
      final data = await Future.wait(
        days.map((e) async {
          final sortedData =
              await Storage.filterSalesReport(date: e.toString().split(' ')[0]);
          return sortedData;
        }),
      );
      final d = data.map((e) {
        return e.map((j) {
          list.add(j);
          return j;
        });
      });
      log(d.toString());
      log(list.toString());
      final model = await Future.wait((list.map((e) async {
        print(e);
        // return e;
        final billItems = await Storage.loadBillItems(billId: e['billId']);
        int slNo = 0;
        final List<ItemModel> model = billItems.map(
          (r) {
            slNo += 1;
            return ItemModel(
              itemName: r['itemName'],
              itemPrice: r['itemPrice'],
              id: r['id'],
              orderQuantity: r['orderQuantity'],
              slNo: slNo.toString(),
            );
          },
        ).toList();
        final price = int.parse(e['billPrice']);
        Notifiers.totalSales.value += price;
        final date = DateTime.now();

        return BillModel(
          date: '${date.year}-${date.month}-${date.day}',
          items: model,
          billId: e['billId'],
          billPrice: e['billPrice'],
          // additional: e['additional'],
        );
      }).toList()));
      Notifiers.sales.value = model;
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadDailySaleDateAndPrice() async {
    try {
      final List<Map<String, String>> dates = await Storage.loadBillWithDate();
      List<DailySaleModel> models = (dates as List).map((e) {
        log(e.toString());
        return DailySaleModel(billDate: e['date'], billPrice: e['totalPrice']);
      }).toList();
      Notifiers.isLoading.value = false;
      Notifiers.dailySalesReport.value = models;
    } catch (e) {
      log(e.toString());
      Notifiers.isLoading.value = false;
      Notifiers.dailySalesReport.value = [];
      // return [];
    }
    // throw UnimplementedError();
  }

  Future<void> loadDailySaleReport({required String date}) async {
    try {
      final data = await Storage.loadDetailedDailySaleReport(date: date);
      final List<DetiledDailySaleModel> detailed = (data as List).map((e) {
        return DetiledDailySaleModel(
            item: e['item'],
            itemPrice: e['itemPrice'],
            itemQuantity: e['itemQuantity'].toString());
      }).toList();
      // Notifiers.isLoading.value = false;
      Notifiers.detiledDailyReport.value = detailed;
    } catch (e) {
      log(e.toString());
      Notifiers.detiledDailyReport.value = [];
    }
    // throw UnimplementedError();
  }
}
