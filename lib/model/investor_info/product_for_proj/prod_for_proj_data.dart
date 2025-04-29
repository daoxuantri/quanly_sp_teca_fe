import 'package:quanly_sp_teca_fe/model/investor_info/product_for_proj/prod_for_proj_model.dart';

class ProductForProjectDataModel {
  int? projectId;
  String? projectName;
  String? deliveryDate;
  List<ProductsWithProjectModel>? products;

  ProductForProjectDataModel({this.projectId, this.projectName, this.deliveryDate, this.products});

  ProductForProjectDataModel.fromJson(Map<String, dynamic> json) {
    projectId = json['project_id'];
    projectName = json['project_name'];
    deliveryDate = json['delivery_date'];
    if (json['products'] != null) {
      products = <ProductsWithProjectModel>[];
      json['products'].forEach((v) {
        products!.add(new ProductsWithProjectModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['project_id'] = this.projectId;
    data['project_name'] = this.projectName;
    data['delivery_date'] = this.deliveryDate;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}