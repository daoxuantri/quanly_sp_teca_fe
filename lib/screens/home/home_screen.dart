import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quanly_sp_teca_fe/components_buttons/loading.dart';
import 'package:quanly_sp_teca_fe/components_buttons/snackbar.dart';
import 'package:quanly_sp_teca_fe/model/product_price/product_price_model.dart';
import 'package:quanly_sp_teca_fe/screens/detailproduct/detail_product_screen.dart';
import 'package:quanly_sp_teca_fe/screens/home/bloc/home_bloc.dart';
import 'package:quanly_sp_teca_fe/screens/home/components/delete_confirm_dialog.dart';
import 'package:quanly_sp_teca_fe/screens/home/components/export_dialog.dart';
import 'package:quanly_sp_teca_fe/screens/home/components/import_dialog.dart';
import 'package:quanly_sp_teca_fe/screens/home/components/product_list_item.dart';
import 'package:quanly_sp_teca_fe/size_config.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeBloc homeBloc = HomeBloc();
  Set<int> selectedProductIds = {};
  String sortOption = 'Không sắp xếp'; // Default sorting option
  List<ProductPriceModel> products = [];
  String searchQuery = '';

  Map<String, bool> fieldSelection = {
    "Tên sản phẩm": true,
    "Mã sản phẩm": true,
    "Ngày hỏi giá": true,
  };

  @override
  void initState() {
    homeBloc.add(HomeInitialEvent());
    super.initState();
  }

  List<ProductPriceModel> getFilteredProducts(List<ProductPriceModel> products) {
    var filtered = products.where((product) {
      bool matchSearch = searchQuery.isEmpty ||
          (product.name ?? '')
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          (product.code ?? '')
              .toLowerCase()
              .contains(searchQuery.toLowerCase());
      return matchSearch;
    }).toList();

    if (sortOption == 'Sắp xếp theo ngày (gần nhất trước)') {
      filtered.sort((a, b) {
        final dateA = a.priceDate != null ? DateTime.tryParse(a.priceDate!) ?? DateTime(1970) : DateTime(1970);
        final dateB = b.priceDate != null ? DateTime.tryParse(b.priceDate!) ?? DateTime(1970) : DateTime(1970);
        return dateB.compareTo(dateA);
      });
    }

    print('Filtered products count: ${filtered.length}');
    return filtered;
  }

  String truncateWithEllipsis(int cutoff, String text) {
    return (text.length <= cutoff) ? text : '${text.substring(0, cutoff)}...';
  }

  void _showCreateProductDialog(BuildContext context, String searchQuery) {
    final nameController = TextEditingController(text: searchQuery);
    final codeController = TextEditingController();
    final priceController = TextEditingController();
    final supplierController = TextEditingController();
    final brandController = TextEditingController();
    final originController = TextEditingController();
    final priceDateController = TextEditingController();
    final specificProductController = TextEditingController();
    final unitController = TextEditingController();
    final askerController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tạo sản phẩm mới',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                      onPressed: () {
                        FocusScope.of(dialogContext).unfocus();
                        Navigator.pop(dialogContext);
                      },
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(8)),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Tên sản phẩm',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
                SizedBox(height: getProportionateScreenHeight(8)),
                TextField(
                  controller: codeController,
                  decoration: InputDecoration(
                    labelText: 'Mã sản phẩm',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
                SizedBox(height: getProportionateScreenHeight(8)),
                TextField(
                  controller: specificProductController,
                  decoration: InputDecoration(
                    labelText: 'Thông tin cụ thể',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
                SizedBox(height: getProportionateScreenHeight(8)),
                TextField(
                  controller: unitController,
                  decoration: InputDecoration(
                    labelText: 'Đơn vị',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
                SizedBox(height: getProportionateScreenHeight(8)),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: 'Giá nhập',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: getProportionateScreenHeight(8)),
                TextField(
                  controller: supplierController,
                  decoration: InputDecoration(
                    labelText: 'Nhà cung cấp',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
                SizedBox(height: getProportionateScreenHeight(8)),
                TextField(
                  controller: brandController,
                  decoration: InputDecoration(
                    labelText: 'Thương hiệu',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
                SizedBox(height: getProportionateScreenHeight(8)),
                TextField(
                  controller: originController,
                  decoration: InputDecoration(
                    labelText: 'Nguồn gốc',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
                SizedBox(height: getProportionateScreenHeight(8)),
                TextField(
                  controller: priceDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Ngày giá (dd/MM/yyyy)',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Icon(Icons.calendar_today, color: Colors.grey[600]),
                  ),
                  style: const TextStyle(fontSize: 14),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: dialogContext,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      priceDateController.text =
                          DateFormat('dd/MM/yyyy').format(picked);
                    }
                  },
                ),
                SizedBox(height: getProportionateScreenHeight(8)),
                TextField(
                  controller: askerController,
                  decoration: InputDecoration(
                    labelText: 'Người hỏi',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
                SizedBox(height: getProportionateScreenHeight(8)),
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    labelText: 'Ghi chú',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                  maxLines: 3,
                ),
                SizedBox(height: getProportionateScreenHeight(16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        FocusScope.of(dialogContext).unfocus();
                        Navigator.pop(dialogContext);
                      },
                      child: const Text(
                        'Hủy',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(width: getProportionateScreenWidth(8)),
                    ElevatedButton(
                      onPressed: () {
                        if (codeController.text.isEmpty ||
                            supplierController.text.isEmpty ||
                            askerController.text.isEmpty) {
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Mã sản phẩm, nhà cung cấp và người hỏi không được để trống'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        final price = int.tryParse(priceController.text);
                        if (price != null && price <= 0) {
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            const SnackBar(
                              content: Text('Giá nhập phải là số dương'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        if (priceDateController.text.isNotEmpty) {
                          try {
                            DateFormat('dd/MM/yyyy')
                                .parseStrict(priceDateController.text);
                          } catch (e) {
                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Ngày giá phải có định dạng dd/MM/yyyy'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                        }
                        homeBloc.add(
                          HomeCreateProductEvent(
                            code: codeController.text,
                            name: nameController.text.isEmpty
                                ? null
                                : nameController.text,
                            specificProduct:
                                specificProductController.text.isEmpty
                                    ? null
                                    : specificProductController.text,
                            unit: unitController.text.isEmpty
                                ? null
                                : unitController.text,
                            price: price,
                            priceDate: priceDateController.text,
                            origin: originController.text.isEmpty
                                ? null
                                : originController.text,
                            brand: brandController.text.isEmpty
                                ? null
                                : brandController.text,
                            supplier: supplierController.text,
                            asker: askerController.text,
                            note: noteController.text.isEmpty
                                ? null
                                : noteController.text,
                          ),
                        );
                        FocusScope.of(dialogContext).unfocus();
                        Navigator.pop(dialogContext);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Lưu',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).then((_) {
      Future.delayed(Duration(milliseconds: 100), () {
        nameController.dispose();
        codeController.dispose();
        priceController.dispose();
        supplierController.dispose();
        brandController.dispose();
        originController.dispose();
        priceDateController.dispose();
        specificProductController.dispose();
        unitController.dispose();
        askerController.dispose();
        noteController.dispose();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeProductClickedState) {
          Navigator.pushNamed(context, DetailProductScreen.routeName,
              arguments: state.product);
        } else if (state is HomeProductRemovedClickedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBarLoginSuccess(state.message),
          );
          setState(() {
            homeBloc.add(HomeInitialEvent());
          });
        } else if (state is HomeCreateProductSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBarLoginSuccess(state.message),
          );
          setState(() {
            homeBloc.add(HomeInitialEvent());
          });
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeLoadingState:
            return const Center(child: LoadingScreen());
          case HomeLoadedSuccessState:
            final successState = state as HomeLoadedSuccessState;
            products = successState.listproduct;
            final filteredProducts = getFilteredProducts(products);
            return Scaffold(
              backgroundColor: Colors.grey.shade100,
              appBar: AppBar(
                title: const Text(
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
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => ExportDialog(
                        fieldSelection: fieldSelection,
                        onExport: () {
                          // Will be handled in export_utils.dart
                        },
                      ),
                    ),
                    tooltip: "Xuất Excel",
                  ),
                ],
              ),
              body: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
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
                                  hintText: "Tìm kiếm sản phẩm hoặc mã...",
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
                                  setState(() {
                                    searchQuery = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: getProportionateScreenWidth(12)),
                            // FloatingActionButton(
                            //   onPressed: () => showImportDialog(
                            //     context,
                            //     homeBloc,
                            //     () {
                            //       homeBloc.add(HomeInitialEvent());
                            //     },
                            //   ),
                            //   backgroundColor: Colors.white,
                            //   mini: true,
                            //   child: Icon(Icons.upload,
                            //       color: Colors.blue.shade700),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Tổng cộng: ${filteredProducts.length} sản phẩm",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            homeBloc.add(HomeInitialEvent());
                          },
                          child: filteredProducts.isEmpty && searchQuery.isNotEmpty
                              ? ListView(
                                  padding: const EdgeInsets.all(16),
                                  children: [
                                    ListTile(
                                      leading: const Icon(
                                        Icons.add_circle_outline,
                                        color: Colors.blue,
                                      ),
                                      title: Text(
                                        'Không tìm thấy sản phẩm. Thêm "$searchQuery"?',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                      onTap: () {
                                        _showCreateProductDialog(context, searchQuery);
                                      },
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: filteredProducts.length,
                                  itemBuilder: (context, index) {
                                    final product = filteredProducts[index];
                                    return ProductListItem(
                                      product: product,
                                      onTap: () => homeBloc.add(
                                          HomeProductClickedEvent(product: product)),
                                      onEdit: () {},
                                      onDelete: () => showDeleteConfirmDialog(
                                        context,
                                        product,
                                        () {
                                          homeBloc.add(HomeProductRemovedClickedEvent(
                                              productId: product.id ?? 0));
                                        },
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
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
                          onPressed: () => showDialog(
                            context: context,
                            builder: (_) => ExportDialog(
                              fieldSelection: fieldSelection,
                              onExport: () {
                                // Will be handled in export_utils.dart
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          case HomeErrorState:
            final errorState = state as HomeErrorState;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lỗi: ${errorState.errorMessage}'),
                  ElevatedButton(
                    onPressed: () => homeBloc.add(HomeInitialEvent()),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}