import 'package:quanly_sp_teca_fe/model/investor_info/product_for_proj/prod_for_proj_data.dart';

class ProductForProjectRespone {
  bool? success;
  String? message;
  List<ProductForProjectDataModel>? data;

  ProductForProjectRespone({this.success, this.message, this.data});

  ProductForProjectRespone.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductForProjectDataModel>[];
      json['data'].forEach((v) {
        data!.add(new ProductForProjectDataModel.fromJson(v));
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