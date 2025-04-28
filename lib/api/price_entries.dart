import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:http_parser/http_parser.dart';
import 'package:quanly_sp_teca_fe/model/price_entries/pro_price_entries_respone.dart';
import 'package:quanly_sp_teca_fe/model/product/detail/detail_product_data_model.dart';
import 'dart:convert';
import 'package:quanly_sp_teca_fe/server/server.dart';

class ApiServicePriceEntries {
  static const String baseUrl = 'https://192.168.1.142:4000';

  // delete price_entries
  Future<String> deletePriceEntries(int id) async {
    final client = IOClient(getCustomHttpClient());
    var url = Uri.parse('$baseUrl/priceEntries/$id');
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    try {
      var response = await client.delete(url, headers: headers);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        print('Response data: $responseData'); // Debug dữ liệu JSON
        if (responseData['success'] == true) {
          return responseData['message'];
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
 
Future<String> addPriceEntries(
  int productId,
  double price,
  String origin,
  String brand,
  String supplier,
  String priceDate,
  String asker,
  String note
) async {
  final client = IOClient(getCustomHttpClient());
  var url = Uri.parse('$baseUrl/priceEntries/');
  var headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json' 
  };
  var body = {
    'product_id': productId,
    'price': price,
    'origin': origin,
    'brand': brand,
    'supplier': supplier,
    'price_date': priceDate,
    'asker': asker,
    'note': note
  };

  try {
    var response = await client.post(
      url,
      headers: headers,
      body: json.encode(body), 
    );

    if (response.statusCode == 201) { 
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
        'Gọi API nhập giá thất bại: ${response.statusCode}'
      );
    }
  } catch (e) {
    print('Error in addPriceEntries: $e');
    throw Exception('Lỗi khi nhập giá sản phẩm: $e');
  } finally {}
}


  // get price_entries theo từng product
  Future<List<DetailProductData>> getPriceEntriesForProduct() async {
    final client = IOClient(getCustomHttpClient());
    var url = Uri.parse('$baseUrl/priceEntries/');
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    try {
      var response = await client.get(url, headers: headers);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          var response = ProductForPriceEntriesRespone.fromJson(responseData);

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
}
