import 'dart:developer';

import 'package:pappettante_chayakada/domain/item_model/model/model.dart';
import 'package:pappettante_chayakada/infrastructure/storage/storage.dart';
import 'package:pappettante_chayakada/valueNotifiers/value_notifiers.dart';

List<ItemModel> sfp = [];

class Inventory {
  static Future<void> loadInventoryItem() async {
    try {
      final data = await Storage.getItems();
      final responseData = data.map((e) {
        print(e);
        return ItemModel(
            itemName: e['itemName'], itemPrice: e['itemPrice'], id: e['id']);
      }).toList();
      Notifiers.isLoading.value = false;
      Notifiers.items.value = responseData;
    } catch (e) {
      Notifiers.items.value = [];
    }
  }

  Future<void> selectedForPrinting({required ItemModel model}) async {
    try {
      sfp.add(model);
      Notifiers.printitems.value = sfp;
    } catch (e) {
      Notifiers.printitems.value = sfp;
    }
  }

  Future<void> deleteSelectedForPrintingItem({required int id}) async {
    try {
      // sfp.add(model);
      // log(sfp.toString());
      int? sI;
      final cSfp = sfp;
      for (var element in cSfp) {
        if (element.id == id) {
          final index = sfp.indexOf(element);
          sI = index;
        }
      }
      if (sI != null) {
        sfp.removeAt(sI);
      } else {
        log(sfp.toString());
      }
      Notifiers.printitems.value = sfp;
      Notifiers.isLoading.value = false;
      // for (ItemModel element in sfp) {}
    } catch (e) {
      Notifiers.isLoading.value = !Notifiers.isLoading.value;
      Notifiers.printitems.value = [];
      log(e.toString());
      // Notifiers.printitems.value = sfp;
    }
  }

  Future<void> editSfpItemQuantity(
      {required int index, required String quantity}) async {
    try {
      sfp[index].orderQuantity = quantity;
      Notifiers.printitems.value = sfp;
    } catch (e) {
      Notifiers.printitems.value = sfp;
    }
  }

  Future<void> searchInventoryItem({required String query}) async {
    try {
      final queryString = RegExp(query, caseSensitive: false);
      final data = await Storage.getItems();
      final model = data.map((e) {
        final b = queryString.hasMatch(e['itemName']);
        if (b == true) {
          return ItemModel(
              itemName: e['itemName'], itemPrice: e['itemPrice'], id: e['id']);
        } else {
          return ItemModel(itemName: '00', itemPrice: '', id: 0);
        }
      }).toList();
      // print(model);
      final List<ItemModel> list = [];
      final listToSend = model.map((e) {
        if (e.itemName != '00') {
          list.add(e);
          return e;
        }
      }).toList();
      // print(listToSend);
      // print(list);
      Notifiers.items.value = list;
    } catch (e) {
      print(e);
    }
  }
}
