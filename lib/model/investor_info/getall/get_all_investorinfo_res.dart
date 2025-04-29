import 'package:quanly_sp_teca_fe/model/investor_info/investor_info_model.dart';

class GetAllInvestorInfoRespone {
  bool? success;
  String? message;
  List<InvestorInfoModel>? data;

  GetAllInvestorInfoRespone({this.success, this.message, this.data});

  GetAllInvestorInfoRespone.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <InvestorInfoModel>[];
      json['data'].forEach((v) {
        data!.add(new InvestorInfoModel.fromJson(v));
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