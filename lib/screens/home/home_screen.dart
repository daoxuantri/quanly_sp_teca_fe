import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    // Filter by search query on both name and code
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

    // Apply sorting based on selected option
    if (sortOption == 'Sắp xếp theo ngày (gần nhất trước)') {
      filtered.sort((a, b) {
        // Parse priceDate as DateTime, default to 1970 if null or unparsable
        final dateA = a.priceDate != null ? DateTime.tryParse(a.priceDate!) ?? DateTime(1970) : DateTime(1970);
        final dateB = b.priceDate != null ? DateTime.tryParse(b.priceDate!) ?? DateTime(1970) : DateTime(1970);
        return dateB.compareTo(dateA); // Most recent first
      });
    }

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
              arguments: state.product);
        }else if (state is HomeProductRemovedClickedState){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBarLoginSuccess(state.message)
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
                            FloatingActionButton(
                              onPressed: () => showImportDialog(
                                context,
                                homeBloc,
                                () {
                                  homeBloc.add(HomeInitialEvent());
                                },
                              ),
                              backgroundColor: Colors.white,
                              mini: true,
                              child: Icon(Icons.upload,
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
                                    HomeProductClickedEvent(product: product)),
                                onEdit: () {
                                  
                                },
                                onDelete: () => showDeleteConfirmDialog(
                                  context,
                                  product,
                                  () {
                                    homeBloc.add(HomeProductRemovedClickedEvent(productId: product.id ?? 0 ));
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