
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:quanly_sp_teca_fe/model/product/detail/get_product_byid_res.dart';
import 'package:quanly_sp_teca_fe/model/product/getall/get_all_product_res.dart';
import 'dart:convert';

import 'package:quanly_sp_teca_fe/model/product/product_data_model.dart';


class ApiServiceProducts {
  static const String baseUrl = 'http://103.245.245.189:4325';



//get all product
 Future<List<ProductDataModel>> getAllProduct() async {
  var url = Uri.parse('$baseUrl/products/');
  var headers = {'accept': 'application/json'};

  try {
    print('Calling API: $url'); // Debug URL
    var response = await http.get(url, headers: headers);
    print('Response status: ${response.statusCode}'); // Debug mã trạng thái
    print('Response body: ${response.body}'); // Debug nội dung phản hồi

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      print('Response data: $responseData'); // Debug dữ liệu JSON
      if (responseData['success'] == true) {
        var response = ListProductRespone.fromJson(responseData);
        print('Mapped products: ${response.data?.length ?? 0}'); // Debug số sản phẩm
        return response.data ?? [];
      } else {
        throw Exception(responseData['message']);
      }
    } else if (response.statusCode == 401) {
      throw Exception('Đang gặp lỗi');
    } else {
      throw Exception('Gọi api thất bại: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in getAllProduct: $e'); // Debug lỗi
    rethrow;
  }
}



  Future<ProductDataModel> getDetailProduct(int productId) async { 

    var url = Uri.parse('$baseUrl/products/$productId'); 

    var headers = {
      'accept': 'application/json'
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      if (responseData['success'] == true) {
      var response = GetProductByIdRespone.fromJson(responseData);
      return response.data!;
      } else {
        throw Exception(responseData['message']);
      }
    } else if (response.statusCode == 401) {
      throw Exception('phiên đăng nhập hết hạn');
    } else {
      throw Exception('fail to call api get detail product');
    }
  }

  // Future<List<ProductRelatedModel>?> getRelatedProduct(String productId) async {
    
  //   var url = Uri.parse('$baseUrl/products/$productId/relatedproduct');
  //   var headers = {
  //     'accept': 'application/json'
  //   };
    

  //   var response = await http.get(url, headers: headers);

  //   if (response.statusCode == 200) {
  //     var responseData = json.decode(response.body);
  //     if (responseData['success'] == true) {
  //     var response = ProductRelatedRespone.fromJson(responseData);
  //     print('Mapped Product Data: ${response.data}');
  //     return response.data;
  //     } else {
  //       throw Exception(responseData['message']);
  //     }
  //   } else if (response.statusCode == 401) {
  //     throw Exception('phiên đăng nhập hết hạn');
  //   } else {
  //     throw Exception('fail to call api get detail product');
  //   }
  // }
}
