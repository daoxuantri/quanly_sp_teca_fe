import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:quanly_sp_teca_fe/model/investor_info/getall/get_all_investorinfo_res.dart';
import 'package:quanly_sp_teca_fe/model/investor_info/investor_info_model.dart';
import 'package:quanly_sp_teca_fe/model/price_entries/getall/get_all_price_entries_res.dart';
import 'package:quanly_sp_teca_fe/model/price_entries/price_entries_data_model.dart';
import 'package:quanly_sp_teca_fe/model/product/detail/detail_product_data_model.dart';
import 'package:quanly_sp_teca_fe/model/product_investor/prod_proj_investor_respone.dart';
import 'package:quanly_sp_teca_fe/model/product_investor/product_investor_model.dart';
import 'dart:convert';
import 'package:quanly_sp_teca_fe/server/server.dart';

class ApiServiceProductInvestor {
  static const String baseUrl = 'https://192.168.1.9:4000';

  // Get all products by investor id
  Future<List<ProductInvestorModel>> getProductsByInvestor(int id) async {
    final client = IOClient(getCustomHttpClient());
    var url = Uri.parse('$baseUrl/productInvestor/investor/$id');
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    try {
      var response = await client.get(url, headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          return (responseData['data'] as List)
              .map((item) => ProductInvestorModel.fromJson(item))
              .toList();
        } else {
          // Handle success: false or data: null (no products)
          return [];
        }
      } else if (response.statusCode == 401) {
        throw Exception('Phiên đăng nhập hết hạn');
      } else {
        throw Exception('Gọi API thất bại: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getProductsByInvestor: $e');
      throw Exception('Lỗi khi lấy danh sách sản phẩm: $e');
    }
  }

  // Get investor info with products by id
  Future<DetailProductData> getInvestorInfoWithProductById(int id) async {
    final client = IOClient(getCustomHttpClient());
    var url = Uri.parse('$baseUrl/productInvestor/$id');
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    try {
      var response = await client.get(url, headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          var response = GetProjectwithProductInvestorRespone.fromJson(responseData);
          return response.data!;
        } else {
          throw Exception(responseData['message'] ?? 'Lấy dữ liệu thất bại');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Phiên đăng nhập hết hạn');
      } else {
        throw Exception('Gọi API thất bại: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getInvestorInfoWithProductById: $e');
      throw Exception('Lỗi khi lấy dữ liệu: $e');
    }
  }

  // Get price entries (used for list in dialog)
  Future<List<PriceEntriesDataModel>> getPriceEntries() async {
    final client = IOClient(getCustomHttpClient());
    var url = Uri.parse('$baseUrl/priceEntries/price-entries');
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    try {
      var response = await client.get(url, headers: headers);
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          var response = GetAllPriceEntriesRespone.fromJson(responseData);
          return response.data ?? [];
        } else {
          throw Exception(responseData['message'] ?? 'Lấy danh sách giá thất bại');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Phiên đăng nhập hết hạn');
      } else {
        throw Exception('Gọi API thất bại: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getPriceEntries: $e');
      throw Exception('Lỗi khi lấy danh sách giá: $e');
    }
  }

  // Create product investor
  Future<String> createProductInvestor(
      int idInvestor, int priceEntriesId, double priceNhap, double priceBan, int quantity) async {
    final client = IOClient(getCustomHttpClient());
    var url = Uri.parse('$baseUrl/productInvestor/product-investor');
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };
    var body = jsonEncode({
      'id_investor': idInvestor,
      'price_entries_id': priceEntriesId,
      'price_nhap': priceNhap,
      'price_ban': priceBan,
      'quantity': quantity,
    });

    try {
      var response = await client.post(url, headers: headers, body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return responseData['message'] ?? 'Thêm sản phẩm thành công';
        } else {
          throw Exception(responseData['message'] ?? 'Thêm sản phẩm thất bại');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Phiên đăng nhập hết hạn');
      } else {
        throw Exception('Gọi API thất bại: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in createProductInvestor: $e');
      throw Exception('Lỗi khi thêm sản phẩm: $e');
    }
  }

  // Get all investor info
  Future<List<InvestorInfoModel>> getAllInvestorInfo() async {
    final client = IOClient(getCustomHttpClient());
    var url = Uri.parse('$baseUrl/investorInfo/');
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    try {
      var response = await client.get(url, headers: headers);
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          var response = GetAllInvestorInfoRespone.fromJson(responseData);
          return response.data ?? [];
        } else {
          throw Exception(responseData['message'] ?? 'Lấy danh sách dự án thất bại');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Phiên đăng nhập hết hạn');
      } else {
        throw Exception('Gọi API thất bại: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getAllInvestorInfo: $e');
      throw Exception('Lỗi khi lấy danh sách dự án: $e');
    }
  }
}