import 'package:pappettante_chayakada/domain/item_model/model/model.dart';
import 'package:pappettante_chayakada/domain/print/model/bill_model.dart';
import 'package:pappettante_chayakada/domain/sale/model/daily_sale_model.dart';
import 'package:pappettante_chayakada/domain/sale/model/detailed_daily_sale_model.dart';
import 'package:flutter/material.dart';

class Notifiers {
  static ValueNotifier<bool> itemInsertion = ValueNotifier(false);
  static ValueNotifier<bool> isLoading = ValueNotifier(false);
  static ValueNotifier<List<ItemModel>> items = ValueNotifier([]);
  static ValueNotifier<List<ItemModel>> printitems = ValueNotifier([]);
  static ValueNotifier<List<BillModel>> sales = ValueNotifier([]);
  static ValueNotifier<List<DetiledDailySaleModel>> detiledDailyReport =
      ValueNotifier([]);
  static ValueNotifier<List<DailySaleModel>> dailySalesReport =
      ValueNotifier([]);
  static ValueNotifier<int> totalBill = ValueNotifier(0);
  static ValueNotifier<int> totalSales = ValueNotifier(0);
  static ValueNotifier<String> alertText = ValueNotifier('');
  static ValueNotifier<bool> alertS = ValueNotifier(true);
}
