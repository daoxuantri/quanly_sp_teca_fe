import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:quanly_sp_teca_fe/model/investor_info/getall/get_all_investorinfo_res.dart';
import 'package:quanly_sp_teca_fe/model/investor_info/investor_info_model.dart';
import 'package:quanly_sp_teca_fe/model/investor_info/product_for_proj/prod_for_proj_data.dart';
import 'package:quanly_sp_teca_fe/model/investor_info/product_for_proj/product_for_project_res.dart';
import 'dart:convert';
import 'package:quanly_sp_teca_fe/server/server.dart';

class ApiServiceInvestorInfo {
  static const String baseUrl = 'https://192.168.0.112:4000';

  // create investor_info
  Future<String> createInvestorInfo(String project_code , String name , String start_date, String end_date,
  String supervisor, String status) async {
    final client = IOClient(getCustomHttpClient());
    var url = Uri.parse('$baseUrl/investorInfo/');
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };
    var body = jsonEncode({
      'project_code': project_code,
      'name': name ,
      'start_date': start_date,
      'end_date': end_date,
      'supervisor': supervisor,
      'status': status
    });

    try {
      var response = await client.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return responseData['message'] ?? 'Thêm mới dự án thành công';
        } else {
          throw Exception(responseData['message'] ?? 'Thêm dự án thất bại');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Phiên đăng nhập hết hạn');
      } else {
        throw Exception('Gọi API thất bại: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in createInvestorInfo: $e');
      throw Exception('Lỗi khi thêm dự án: $e');
    }
  }

  // update investor_info
  Future<String> updateInvestorInfo(int id, String project_code, String name, String start_date, String end_date , String supervisor, String status) async {
    final client = IOClient(getCustomHttpClient());
    var url = Uri.parse('$baseUrl/investorInfo/$id');
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };
    var body = jsonEncode({
      'project_code': project_code,
      'name': name ,
      'start_date':start_date,
      'end_date': end_date,
      'supervisor': supervisor,
      'status': status
    });

    try {
      var response = await client.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return responseData['message'] ?? 'Cập nhật dự án thành công';
        } else {
          throw Exception(responseData['message'] ?? 'Cập nhật dự án thất bại');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Phiên đăng nhập hết hạn');
      } else {
        throw Exception('Gọi API thất bại: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in updateInvestorInfo: $e');
      throw Exception('Lỗi khi cập nhật dự án: $e');
    }
  }

  // delete investor_info
  Future<String> deleteInvestorInfo(int id) async {
    final client = IOClient(getCustomHttpClient());
    var url = Uri.parse('$baseUrl/investorInfo/$id');
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    try {
      var response = await client.delete(url, headers: headers);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return responseData['message'] ?? 'Xóa dự án thành công';
        } else {
          throw Exception(responseData['message'] ?? 'Xóa dự án thất bại');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Phiên đăng nhập hết hạn');
      } else {
        throw Exception('Gọi API thất bại: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in deleteInvestorInfo: $e');
      throw Exception('Lỗi khi xóa dự án: $e');
    }
  }

  // get All investor Info
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


  // get All investor Info
  Future<List<ProductForProjectDataModel>> getProductForProject() async {
    final client = IOClient(getCustomHttpClient());
    var url = Uri.parse('$baseUrl/investorInfo/allproductforproject');
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    try {
      var response = await client.get(url, headers: headers);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          var response = ProductForProjectRespone.fromJson(responseData);
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