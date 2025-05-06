class InvestorInfoModel {
  int? id;
  String? projectCode;
  String? name;
  String? startDate;
  String? endDate;
  String? supervisor;
  String? status;

  InvestorInfoModel(
      {this.id,
      this.projectCode,
      this.name,
      this.startDate,
      this.endDate,
      this.supervisor,
      this.status});

  InvestorInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectCode = json['project_code'];
    name = json['name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    supervisor = json['supervisor'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['project_code'] = this.projectCode;
    data['name'] = this.name;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['supervisor'] = this.supervisor;
    data['status'] = this.status;
    return data;
  }
}