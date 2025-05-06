import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:quanly_sp_teca_fe/model/product_price/getall/all_product_price_res.dart';
import 'dart:convert';
import 'package:quanly_sp_teca_fe/model/product_price/product_price_model.dart';
import 'package:quanly_sp_teca_fe/server/server.dart';

class ApiServiceProductPrice {
  static const String baseUrl = 'https://192.168.0.112:4000';

  // Get all products
  Future<List<ProductPriceModel>> getAllProduct() async {
    final client = IOClient(getCustomHttpClient());
    var url = Uri.parse('$baseUrl/productPrice/');
    var headers = {'accept': 'application/json'};
    try {
      var response = await client.get(url, headers: headers);
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          var response = GetAllProductPriceRespone.fromJson(responseData);
          return response.data!;
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
      throw Exception('Lỗi khi lấy danh sách sản phẩm: $e');
    } finally {}
  }

  //create excel
  Future<void> createProduct(ProductPriceModel product) async {
    final client = IOClient(getCustomHttpClient());
    final response = await client.post(
      Uri.parse('$baseUrl/productPrice'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create product: ${response.body}');
    }
  }

  // Update chi tiết sản phẩm
  Future<String> updateDetailProductPrice(
      int productId,
      String? code,
      String? name,
      String? specificProduct,
      String? unit,
      int? price,
      String? priceDate,
      String? origin,
      String? brand,
      String? supplier,
      String? asker,
      String? note) async {
    final client = IOClient(getCustomHttpClient());
    // Sửa endpoint thành /products/:id
    var url = Uri.parse('$baseUrl/productPrice/$productId');
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // Giữ price_date ở định dạng DD/MM/YYYY hoặc '' nếu rỗng
    String? formattedPriceDate;
    if (priceDate != null && priceDate.isNotEmpty) {
      try {
        // Đảm bảo priceDate đã ở định dạng DD/MM/YYYY
        DateFormat('dd/MM/yyyy').parseStrict(priceDate);
        formattedPriceDate = priceDate; // Giữ nguyên DD/MM/YYYY
      } catch (e) {
        formattedPriceDate = ''; // Gửi chuỗi rỗng nếu định dạng không hợp lệ
      }
    } else {
      formattedPriceDate = '';
    }

    var body = json.encode({
      'code': code ?? '',
      'name': name,
      'specific_product': specificProduct,
      'unit': unit,
      'price': price ?? 0,
      'price_date': formattedPriceDate,
      'origin': origin,
      'brand': brand,
      'supplier': supplier ?? '',
      'asker': asker ?? '',
      'note': note,
    });

    // Logging chi tiết các giá trị
    print('Updating product with ID: $productId');
    print('Request URL: $url');
    print('Request body: $body');

    try {
      var response = await client.put(url, headers: headers, body: body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return responseData['message'];
        } else {
          throw Exception(responseData['message']);
        }
      } else if (response.statusCode == 404) {
        var responseData = json.decode(response.body);
        throw Exception(
            'Sản phẩm không tồn tại (ID: $productId). Message: ${responseData['message']}');
      } else if (response.statusCode == 401) {
        throw Exception('Phiên đăng nhập hết hạn');
      } else {
        throw Exception(
            'Gọi API cập nhật sản phẩm thất bại: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in updateDetailProductPrice: $e');
      throw Exception('Lỗi khi cập nhật chi tiết sản phẩm: $e');
    } finally {
      client.close();
    }
  }

  // delete product
  Future<String> deleteProductPrice(int productId) async {
    final client = IOClient(getCustomHttpClient());
    var url = Uri.parse('$baseUrl/productPrice/$productId');
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    try {
      var response = await client.delete(url, headers: headers);

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

  // add product
  Future<String> addProductPrice(
      String code,
      String name,
      String specific_product,
      String unit,
      int price,
      String price_date,
      String origin,
      String brand,
      String supplier,
      String asker,
      String note) async {
    final client = IOClient(getCustomHttpClient());
    var url = Uri.parse('$baseUrl/productPrice/');
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    var body = json.encode({
      'code': code,
      'name': name,
      'specific_product': specific_product,
      'unit': unit,
      'price': price,
      'price_date': price_date,
      'origin': origin,
      'brand': brand,
      'supplier': supplier,
      'asker': asker,
      'note': note,
    });

    try {
      var response = await client.post(url, headers: headers, body: body);

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
            'Gọi API chi tiết sản phẩm thất bại: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getDetailProduct: $e');
      throw Exception('Lỗi khi lấy chi tiết sản phẩm: $e');
    } finally {}
  }
}
