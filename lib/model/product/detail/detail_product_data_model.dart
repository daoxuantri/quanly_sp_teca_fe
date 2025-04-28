import 'package:quanly_sp_teca_fe/model/product/price_entries_data_model.dart';

class DetailProductData {
  int? id;
  String? code;
  String? name;
  String? specificProduct;
  String? unit;
  String? note;
  List<PriceEntriesDataModel>? priceEntries;

  DetailProductData(
      {this.id,
      this.code,
      this.name,
      this.specificProduct,
      this.unit,
      this.note,
      this.priceEntries});

  DetailProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    specificProduct = json['specific_product'];
    unit = json['unit'];
    note = json['note'];
    if (json['price_entries'] != null) {
      priceEntries = <PriceEntriesDataModel>[];
      json['price_entries'].forEach((v) {
        priceEntries!.add(new PriceEntriesDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['specific_product'] = this.specificProduct;
    data['unit'] = this.unit;
    data['note'] = this.note;
    if (this.priceEntries != null) {
      data['price_entries'] =
          this.priceEntries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}