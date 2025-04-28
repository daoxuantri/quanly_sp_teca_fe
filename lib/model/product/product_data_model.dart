class ProductDataModel {
  int? id;
  String? code;
  String? name;
  String? specificProduct;
  String? origin;
  String? brand;
  String? unit;
  String? priceDate;
  String? supplier;
  String? note;
  int? price;
  String? asker;
  int? quantity;

  ProductDataModel(
      {this.id,
      this.code,
      this.name,
      this.specificProduct,
      this.origin,
      this.brand,
      this.unit,
      this.priceDate,
      this.supplier,
      this.note,
      this.price,
      this.asker,
      this.quantity});

  ProductDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    specificProduct = json['specific_product'];
    origin = json['origin'];
    brand = json['brand'];
    unit = json['unit'];
    priceDate = json['price_date'];
    supplier = json['supplier'];
    note = json['note'];
    price = json['price'];
    asker = json['asker'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['specific_product'] = this.specificProduct;
    data['origin'] = this.origin;
    data['brand'] = this.brand;
    data['unit'] = this.unit;
    data['price_date'] = this.priceDate;
    data['supplier'] = this.supplier;
    data['note'] = this.note;
    data['price'] = this.price;
    data['asker'] = this.asker;
    data['quantity']= this.quantity;
    return data;
  }
}