import 'package:quanly_sp_teca_fe/model/product/detail/detail_product_data_model.dart';

class ProductForPriceEntriesRespone {
  bool? success;
  String? message;
  List<DetailProductData>? data;

  ProductForPriceEntriesRespone({this.success, this.message, this.data});

  ProductForPriceEntriesRespone.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DetailProductData>[];
      json['data'].forEach((v) {
        data!.add(new DetailProductData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
