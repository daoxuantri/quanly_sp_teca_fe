import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:quanly_sp_teca_fe/components_buttons/loading.dart';
import 'package:quanly_sp_teca_fe/screens/home/bloc/home_bloc.dart';
import 'dart:convert';

import 'package:quanly_sp_teca_fe/size_config.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> products = [
    {
      "id": 1,
      "code": "PRD001",
      "name": "Sản phẩm A",
      "origin": "Việt Nam",
      "unit": "Cái",
      "price_date": "2025-04-14T00:00:00.000Z",
      "supplier": "Nhà cung cấp ABC",
      "note": "Sản phẩm chất lượng cao",
      "price": 129000.5,
    },
    {
      "id": 2,
      "code": "PRD002",
      "name": "Sản phẩm B",
      "origin": "Việt Nam",
      "unit": "Cái",
      "price_date": "2025-04-14T00:00:00.000Z",
      "supplier": "Nhà cung cấp XYZ",
      "note": "Sản phẩm thân thiện môi trường",
      "price": 250000.0,
    },
    {
      "id": 3,
      "code": "PRD003",
      "name": "Sản phẩm C",
      "origin": "Trung Quốc",
      "unit": "Cái",
      "price_date": "2025-04-14T00:00:00.000Z",
      "supplier": "Nhà cung cấp ABC",
      "note": "Sản phẩm giá rẻ",
      "price": 99000.0,
    },
  ];
  final HomeBloc homeBloc = HomeBloc();
  Set<int> selectedProductIds = {};
  bool isLoading = false;
  String selectedProvider = 'Tất cả';
  String selectedPrice = 'Tất cả';

  Map<String, bool> fieldSelection = {
    "Tên sản phẩm": true,
    "Giá": true,
    "Nhà cung cấp": true,
    "Nguồn gốc": false,
    "Đơn vị": false,
  };

  @override
  void initState() {
    homeBloc.add(HomeInitialEvent());
    super.initState();
  }

  Future<void> fetchProducts() async {
    setState(() => isLoading = true);
    try {
      // Thay bằng URL API thực tế nếu muốn gọi API
      final response = await http.get(Uri.parse('YOUR_API_ENDPOINT'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          setState(() {
            products = List<Map<String, dynamic>>.from(data['data']);
            selectedProductIds.clear(); // Xóa các lựa chọn khi tải lại dữ liệu
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Không thể tải dữ liệu!");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Lỗi: $e");
    }
    setState(() => isLoading = false);
  }

  void showExportDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade50, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Chọn trường cần xuất",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              ...fieldSelection.keys.map((field) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: fieldSelection[field]!
                        ? Colors.blue.shade100
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CheckboxListTile(
                    title: Text(field),
                    value: fieldSelection[field],
                    activeColor: Colors.blue.shade700,
                    onChanged: (val) {
                      setState(() {
                        fieldSelection[field] = val!;
                      });
                    },
                  ),
                );
              }),
              SizedBox(height: getProportionateScreenHeight(16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Hủy", style: TextStyle(color: Colors.grey)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      exportFile();
                    },
                    child: const Text("Xuất",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void exportFile() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => isLoading = false);
    Fluttertoast.showToast(
      msg: "Xuất file Excel thành công!",
      backgroundColor: Colors.blue.shade700,
      textColor: Colors.white,
    );
  }

  void showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Lọc sản phẩm",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
            ),
            SizedBox(height: getProportionateScreenHeight(16)),
            DropdownButtonFormField<String>(
              value: selectedPrice,
              items: ['Tất cả', '< 200000', '>= 200000']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => selectedPrice = val!),
              decoration: InputDecoration(
                labelText: "Lọc theo giá",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(16)),
            DropdownButtonFormField<String>(
              value: selectedProvider,
              items: [
                const DropdownMenuItem(value: 'Tất cả', child: Text('Tất cả')),
                ...products
                    .map((p) => p['supplier'] as String)
                    .toSet()
                    .map((e) => DropdownMenuItem(value: e, child: Text(e))),
              ],
              onChanged: (val) => setState(() => selectedProvider = val!),
              decoration: InputDecoration(
                labelText: "Nhà cung cấp",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(24)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Áp dụng",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get filteredProducts {
    return products.where((product) {
      bool matchPrice = selectedPrice == 'Tất cả' ||
          (selectedPrice == '< 200000' && product['price'] < 200000) ||
          (selectedPrice == '>= 200000' && product['price'] >= 200000);
      bool matchProvider = selectedProvider == 'Tất cả' ||
          product['supplier'] == selectedProvider;
      return matchPrice && matchProvider;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is HomeActionState,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeLoadingState:
            return Center(
              child: LoadingScreen(),
            );
          case HomeLoadedSuccessState:
            final successState = state as HomeLoadedSuccessState;
            return Scaffold(
              backgroundColor: Colors.grey.shade100,
              appBar: AppBar(
                title: Text(
                  "Quản lý sản phẩm",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: showExportDialog,
                    tooltip: "Xuất Excel",
                  ),
                ],
              ),
              body: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Tìm kiếm sản phẩm...",
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.7)),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.2),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: const Icon(Icons.search,
                                      color: Colors.white),
                                ),
                                style: const TextStyle(color: Colors.white),
                                onChanged: (value) {
                                  // Thêm logic tìm kiếm nếu cần
                                },
                              ),
                            ),
                            SizedBox(width: getProportionateScreenWidth(12)),
                            FloatingActionButton(
                              onPressed: showFilterDialog,
                              backgroundColor: Colors.white,
                              mini: true,
                              child: Icon(Icons.filter_list,
                                  color: Colors.blue.shade700),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: fetchProducts,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: Checkbox(
                                    value: selectedProductIds
                                        .contains(product['id']),
                                    activeColor: Colors.blue.shade700,
                                    onChanged: (val) {
                                      setState(() {
                                        if (val == true) {
                                          selectedProductIds.add(product['id']);
                                        } else {
                                          selectedProductIds
                                              .remove(product['id']);
                                        }
                                      });
                                    },
                                  ),
                                  title: Text(
                                    product['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    "${product['price'].toStringAsFixed(0)} VNĐ | ${product['supplier']}",
                                    style:
                                        TextStyle(color: Colors.grey.shade600),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Colors.grey.shade400,
                                  ),
                                  onTap: () {
                                    // Có thể thêm hành động khi nhấn vào sản phẩm
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.download),
                          label: const Text("Xuất Excel"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          onPressed: showExportDialog,
                        ),
                      ),
                    ],
                  ),
                  if (isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                ],
              ),
            );
          case HomeErrorState:
            final errorState = state as HomeErrorState;
            return Center(child: Text(errorState.errorMessage));
          default:
            return SizedBox();
        }
      },
    );
  }
}
