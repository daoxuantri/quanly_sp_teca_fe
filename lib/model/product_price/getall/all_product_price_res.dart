import 'package:quanly_sp_teca_fe/model/product_price/product_price_model.dart';

class GetAllProductPriceRespone {
  bool? success;
  String? message;
  List<ProductPriceModel>? data;

  GetAllProductPriceRespone({this.success, this.message, this.data});

  GetAllProductPriceRespone.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductPriceModel>[];
      json['data'].forEach((v) {
        data!.add(new ProductPriceModel.fromJson(v));
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