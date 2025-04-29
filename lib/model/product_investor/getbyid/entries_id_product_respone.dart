import 'package:quanly_sp_teca_fe/model/product_investor/product_investor_model.dart';

class GetEntriesByInvestorIdRespone {
  bool? success;
  String? message;
  List<ProductInvestorModel>? data;

  GetEntriesByInvestorIdRespone({this.success, this.message, this.data});

  GetEntriesByInvestorIdRespone.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductInvestorModel>[];
      json['data'].forEach((v) {
        data!.add(new ProductInvestorModel.fromJson(v));
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