import 'package:pappettante_chayakada/domain/item_model/model/model.dart';

class BillModel {
  final List<ItemModel> items;
  final String billId;
  final String billPrice;

  final String date;
  BillModel({
    required this.items,
    required this.billId,
    required this.billPrice,
    required this.date,
  });
}
