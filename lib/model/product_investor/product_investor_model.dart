class ProductInvestorModel {
  int? id;
  int? idInvestor;
  int? priceEntriesId;
  int? priceNhap;
  int? priceBan;
  int? quantity;
  int? totalNhap;
  int? totalBan;

  ProductInvestorModel(
      {this.id,
      this.idInvestor,
      this.priceEntriesId,
      this.priceNhap,
      this.priceBan,
      this.quantity,
      this.totalNhap,
      this.totalBan});

  ProductInvestorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idInvestor = json['id_investor'];
    priceEntriesId = json['price_entries_id'];
    priceNhap = json['price_nhap'];
    priceBan = json['price_ban'];
    quantity = json['quantity'];
    totalNhap = json['total_nhap'];
    totalBan = json['total_ban'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_investor'] = this.idInvestor;
    data['price_entries_id'] = this.priceEntriesId;
    data['price_nhap'] = this.priceNhap;
    data['price_ban'] = this.priceBan;
    data['quantity'] = this.quantity;
    data['total_nhap'] = this.totalNhap;
    data['total_ban'] = this.totalBan;
    return data;
  }
}