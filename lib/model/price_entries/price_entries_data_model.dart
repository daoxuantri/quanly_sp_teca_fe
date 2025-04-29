class PriceEntriesDataModel {
  int? id;
  int? price;
  String? origin;
  String? brand;
  String? supplier;
  String? priceDate;
  String? asker;
  String? note;

  PriceEntriesDataModel(
      {this.id,
      this.price,
      this.origin,
      this.brand,
      this.supplier,
      this.priceDate,
      this.asker,
      this.note});

  PriceEntriesDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    origin = json['origin'];
    brand = json['brand'];
    supplier = json['supplier'];
    priceDate = json['price_date'];
    asker = json['asker'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['origin'] = this.origin;
    data['brand'] = this.brand;
    data['supplier'] = this.supplier;
    data['price_date'] = this.priceDate;
    data['asker'] = this.asker;
    data['note'] = this.note;
    return data;
  }
}