class ItemModel {
  final String itemName;
  final String itemPrice;
  final int id;
  String? orderQuantity;
  String? slNo;
  ItemModel(
      {required this.itemName,
      required this.itemPrice,
      required this.id,
      this.orderQuantity,
      this.slNo});
}
