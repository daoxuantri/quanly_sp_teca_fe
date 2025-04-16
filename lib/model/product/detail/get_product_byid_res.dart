import 'package:quanly_sp_teca_fe/model/product/product_data_model.dart';

class GetProductByIdRespone {
  bool? success;
  String? message;
  ProductDataModel? data;

  GetProductByIdRespone({this.success, this.message, this.data});

  GetProductByIdRespone.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new ProductDataModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}