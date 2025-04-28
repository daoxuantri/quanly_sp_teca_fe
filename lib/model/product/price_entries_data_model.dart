class PriceEntriesDataModel {
  int? id;
  int? price;
  String? supplier;
  String? priceDate;
  String? asker;
  String? note;
  String? origin;
  String? brand;

  PriceEntriesDataModel(
      {this.id,
      this.price,
      this.supplier,
      this.priceDate,
      this.asker,
      this.note,
      this.origin,
      this.brand});

  PriceEntriesDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    supplier = json['supplier'];
    priceDate = json['price_date'];
    asker = json['asker'];
    note = json['note'];
    origin = json['origin'];
    brand = json['brand'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['supplier'] = this.supplier;
    data['price_date'] = this.priceDate;
    data['asker'] = this.asker;
    data['note'] = this.note;
    data['origin'] = this.origin;
    data['brand'] = this.brand;
    return data;
  }
}