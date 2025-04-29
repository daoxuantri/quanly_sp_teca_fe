class InvestorInfoModel {
  int? id;
  String? deliveryDate;
  String? projectName;

  InvestorInfoModel({this.id, this.deliveryDate, this.projectName});

  InvestorInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // Cắt chuỗi delivery_date để chỉ lấy YYYY-MM-DD
    deliveryDate = json['delivery_date'] != null
        ? json['delivery_date'].toString().split('T').first
        : null;
    projectName = json['project_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['delivery_date'] = deliveryDate;
    data['project_name'] = projectName;
    return data;
  }
}