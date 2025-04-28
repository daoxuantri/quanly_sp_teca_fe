import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:http_parser/http_parser.dart';
import 'package:quanly_sp_teca_fe/model/product/detail/detail_product_data_model.dart';
import 'package:quanly_sp_teca_fe/model/product/detail/get_product_byid_res.dart';
import 'package:quanly_sp_teca_fe/model/product/getall/get_all_product_res.dart';
import 'dart:convert';

import 'package:quanly_sp_teca_fe/model/product/product_data_model.dart';
import 'package:quanly_sp_teca_fe/server/server.dart';

class ApiServiceProducts {
  static const String baseUrl = 'https://192.168.1.142:4000';

  // Get all products
  Future<List<ProductDataModel>> getAllProduct() async {
    final client = IOClient(getCustomHttpClient());
    var url = Uri.parse('$baseUrl/products/');
    var headers = {'accept': 'application/json'};

    try {
      print('Calling API: $url'); // Debug URL
      var response = await client.get(url, headers: headers);
      print('Response status: ${response.statusCode}'); // Debug mã trạng thái
      print('Response body: ${response.body}'); // Debug nội dung phản hồi

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        print('Response data: $responseData'); // Debug dữ liệu JSON
        if (responseData['success'] == true) {
          var response = ListProductRespone.fromJson(responseData);
          print(
              'Mapped products: ${response.data?.length ?? 0}'); // Debug số sản phẩm
          return response.data ?? [];
        } else {
          throw Exception(responseData['message']);
        }
      } else if (response.statusCode == 401) {
        throw Exception('Đang gặp lỗi');
      } else {
        throw Exception('Gọi API thất bại: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getAllProduct: $e');
      throw Exception(
          'Lỗi khi lấy danh sách sản phẩm: $e'); // Sửa: Ném ngoại lệ để tránh null
    } finally {}
  }

  // Get product detail
  Future<DetailProductData> getDetailProduct(int productId) async {
    final client = IOClient(getCustomHttpClient());
    var url = Uri.parse('$baseUrl/products/$productId');
    var headers = {'accept': 'application/json'};

    try {
      var response = await client.get(url, headers: headers);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          var response = GetProductByIdRespone.fromJson(responseData);
          return response.data!;
        } else {
          throw Exception(responseData['message']);
        }
      } else if (response.statusCode == 401) {
        throw Exception('Phiên đăng nhập hết hạn');
      } else {
        throw Exception(
            'Gọi API chi tiết sản phẩm thất bại: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getDetailProduct: $e');
      throw Exception('Lỗi khi lấy chi tiết sản phẩm: $e');
    } finally {}
  }

  // Get main product detail
  Future<String> updateMainProduct(int productId, String code, String name,
      String specificProduct, String unit, String note) async {
    final client = IOClient(getCustomHttpClient());
    var url = Uri.parse('$baseUrl/products/$productId');
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };
    

    var body = json.encode({
      'code': code,
      'name': name,
      'specific_product': specificProduct,
      'unit': unit,
      'note': note,
    });

    try {
      var response = await client.put(url, headers: headers, body: body);
       print('📦 Sending PUT request to: $url');
  print('📝 Headers: $headers');
  print('📤 Body: $body');

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return responseData['message'];
        } else {
          throw Exception(responseData['message']);
        }
      } else if (response.statusCode == 401) {
        throw Exception('Phiên đăng nhập hết hạn');
      } else {
        throw Exception(
            'Gọi API chi tiết sản phẩm thất bại: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getDetailProduct: $e');
      throw Exception('Lỗi khi lấy chi tiết sản phẩm: $e');
    } finally {}
  }
}
