class ProductDataModel {
  int? id;
  String? code;
  String? name;
  String? origin;
  String? unit;
  String? priceDate;
  String? supplier;
  String? note;
  double? price;

  ProductDataModel(
      {this.id,
      this.code,
      this.name,
      this.origin,
      this.unit,
      this.priceDate,
      this.supplier,
      this.note,
      this.price});

  ProductDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    origin = json['origin'];
    unit = json['unit'];
    priceDate = json['price_date'];
    supplier = json['supplier'];
    note = json['note'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['origin'] = this.origin;
    data['unit'] = this.unit;
    data['price_date'] = this.priceDate;
    data['supplier'] = this.supplier;
    data['note'] = this.note;
    data['price'] = this.price;
    return data;
  }
}
