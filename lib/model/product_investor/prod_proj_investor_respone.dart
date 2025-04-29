import 'package:quanly_sp_teca_fe/model/product/detail/detail_product_data_model.dart';

class GetProjectwithProductInvestorRespone {
  bool? success;
  String? message;
  DetailProductData? data;

  GetProjectwithProductInvestorRespone({this.success, this.message, this.data});

  GetProjectwithProductInvestorRespone.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new DetailProductData.fromJson(json['data']) : null;
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