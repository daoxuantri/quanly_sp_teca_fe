import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quanly_sp_teca_fe/components_buttons/loading.dart';
import 'package:quanly_sp_teca_fe/model/product/product_data_model.dart';
import 'package:quanly_sp_teca_fe/screens/detailproduct/detail_product_screen.dart';
import 'package:quanly_sp_teca_fe/screens/home/bloc/home_bloc.dart';
import 'package:quanly_sp_teca_fe/screens/home/components/delete_confirm_dialog.dart';
import 'package:quanly_sp_teca_fe/screens/home/components/export_dialog.dart';
import 'package:quanly_sp_teca_fe/screens/home/components/filter_dialog.dart';
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
  String selectedProvider = 'Tất cả';
  String selectedBrand = 'Tất cả';
  List<ProductDataModel> products = [];
  String searchQuery = ''; // Biến lưu trữ giá trị tìm kiếm

  Map<String, bool> fieldSelection = {
    "Tên sản phẩm": true,
    "Giá": true,
    "Nhà cung cấp": true,
    "Xuất xứ": false,
    "Thương hiệu": false,
  };

  @override
  void initState() {
    homeBloc.add(HomeInitialEvent());
    super.initState();
  }

  List<ProductDataModel> getFilteredProducts(List<ProductDataModel> products) {
    final filtered = products.where((product) {
      bool matchBrand =
          selectedBrand == 'Tất cả' || product.brand == selectedBrand;
      bool matchProvider =
          selectedProvider == 'Tất cả' || product.supplier == selectedProvider;
      bool matchSearch = searchQuery.isEmpty ||
          (product.name ?? '')
              .toLowerCase()
              .contains(searchQuery.toLowerCase()); // Tìm kiếm theo tên
      return matchBrand && matchProvider && matchSearch;
    }).toList();
    print('Filtered products count: ${filtered.length}');
    return filtered;
  }

  String truncateWithEllipsis(int cutoff, String text) {
    return (text.length <= cutoff) ? text : '${text.substring(0, cutoff)}...';
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
              arguments: state.productId);
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeLoadingState:
            return const Center(child: LoadingScreen());
          case HomeLoadedSuccessState:
            final successState = state as HomeLoadedSuccessState;
            products = successState.listproduct;
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
                                  setState(() {
                                    searchQuery = value; // Cập nhật giá trị tìm kiếm
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: getProportionateScreenWidth(12)),
                            FloatingActionButton(
                              onPressed: () => showFilterDialog(
                                context,
                                products,
                                selectedBrand,
                                selectedProvider,
                                (brand, provider) => setState(() {
                                  selectedBrand = brand;
                                  selectedProvider = provider;
                                }),
                              ),
                              backgroundColor: Colors.white,
                              mini: true,
                              child: Icon(Icons.filter_list,
                                  color: Colors.blue.shade700),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Tổng cộng: ${getFilteredProducts(products).length} sản phẩm",
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
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: getFilteredProducts(products).length,
                            itemBuilder: (context, index) {
                              final product =
                                  getFilteredProducts(products)[index];
                              return ProductListItem(
                                product: product,
                                onTap: () => homeBloc.add(
                                    HomeProductClickedEvent(
                                        productId: product.id ?? 0)),
                                onEdit: () {
                                  // TODO: Chuyển đến màn hình chỉnh sửa
                                },
                                onDelete: () => showDeleteConfirmDialog(
                                  context,
                                  product,
                                  () {
                                    // TODO: Thêm sự kiện xóa sản phẩm
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