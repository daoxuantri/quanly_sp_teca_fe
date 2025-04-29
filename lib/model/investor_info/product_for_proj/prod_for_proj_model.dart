class ProductsWithProjectModel {
  String? name;
  String? code;
  String? specificProduct;
  String? unit;
  int? priceNhap;
  int? priceBan;
  int? quantity;
  int? totalNhap;
  int? totalBan;
  String? origin;
  String? brand;
  String? supplier;
  String? priceDate;
  String? asker;
  String? note;

  ProductsWithProjectModel(
      {this.name,
      this.code,
      this.specificProduct,
      this.unit,
      this.priceNhap,
      this.priceBan,
      this.quantity,
      this.totalNhap,
      this.totalBan,
      this.origin,
      this.brand,
      this.supplier,
      this.priceDate,
      this.asker,
      this.note});

  ProductsWithProjectModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    specificProduct = json['specific_product'];
    unit = json['unit'];
    priceNhap = json['price_nhap'];
    priceBan = json['price_ban'];
    quantity = json['quantity'];
    totalNhap = json['total_nhap'];
    totalBan = json['total_ban'];
    origin = json['origin'];
    brand = json['brand'];
    supplier = json['supplier'];
    priceDate = json['price_date'];
    asker = json['asker'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['code'] = this.code;
    data['specific_product'] = this.specificProduct;
    data['unit'] = this.unit;
    data['price_nhap'] = this.priceNhap;
    data['price_ban'] = this.priceBan;
    data['quantity'] = this.quantity;
    data['total_nhap'] = this.totalNhap;
    data['total_ban'] = this.totalBan;
    data['origin'] = this.origin;
    data['brand'] = this.brand;
    data['supplier'] = this.supplier;
    data['price_date'] = this.priceDate;
    data['asker'] = this.asker;
    data['note'] = this.note;
    return data;
  }
}