class ProductPriceModel {
  int? id;
  String? code;
  String? name;
  String? specificProduct;
  String? unit;
  int? price;
  String? priceDate;
  String? origin;
  String? brand;
  String? supplier;
  String? asker;
  String? note;

  ProductPriceModel({
    this.id,
    this.code,
    this.name,
    this.specificProduct,
    this.unit,
    this.price,
    this.priceDate,
    this.origin,
    this.brand,
    this.supplier,
    this.asker,
    this.note,
  });

  ProductPriceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    specificProduct = json['specific_product'];
    unit = json['unit'];
    price = json['price'];
    priceDate = json['price_date'];
    origin = json['origin'];
    brand = json['brand'];
    supplier = json['supplier'];
    asker = json['asker'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['specific_product'] = this.specificProduct;
    data['unit'] = this.unit;
    data['price'] = this.price;
    data['price_date'] = this.priceDate;
    data['origin'] = this.origin;
    data['brand'] = this.brand;
    data['supplier'] = this.supplier;
    data['asker'] = this.asker;
    data['note'] = this.note;
    return data;
  }
}