import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quanly_sp_teca_fe/components_buttons/loading.dart';
import 'package:quanly_sp_teca_fe/components_buttons/snackbar.dart';
import 'package:quanly_sp_teca_fe/model/product/product_data_model.dart';
import 'package:quanly_sp_teca_fe/screens/detailproduct/detail_product_screen.dart';
import 'package:quanly_sp_teca_fe/screens/home/bloc/home_bloc.dart';
import 'package:quanly_sp_teca_fe/size_config.dart';

class UpdateDeleteProductScreen extends StatefulWidget {
  static String routeName = '/update-delete-product-screen';
  const UpdateDeleteProductScreen({super.key});

  @override
  State<UpdateDeleteProductScreen> createState() => _UpdateDeleteProductScreenState();
}

class _UpdateDeleteProductScreenState extends State<UpdateDeleteProductScreen> {
  final HomeBloc homeBloc = HomeBloc();
  String searchQuery = '';

  @override
  void initState() {
    homeBloc.add(HomeInitialEvent());
    super.initState();
  }

  void showDeleteConfirmDialog(ProductDataModel product) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Xóa sản phẩm?"),
        content: Text("Bạn có chắc muốn xóa ${product.name ?? ''}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
               ScaffoldMessenger.of(context).showSnackBar(
                SnackBarLoginFail('Chưa có làm chức năng xóa'),
               );
              // TODO: Thêm sự kiện xóa sản phẩm
              // homeBloc.add(HomeDeleteProductEvent(product.id));
              Navigator.pop(context);
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  List<ProductDataModel> getFilteredProducts(List<ProductDataModel> products) {
    if (searchQuery.isEmpty) return products;
    return products.where((product) {
      final name = product.name?.toLowerCase() ?? '';
      final supplier = product.supplier?.toLowerCase() ?? '';
      final query = searchQuery.toLowerCase();
      return name.contains(query) || supplier.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {

      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeLoadingState:
            return const Center(child: LoadingScreen());
          case HomeLoadedSuccessState:
            final successState = state as HomeLoadedSuccessState;
            final products = successState.listproduct;
            return Scaffold(
              backgroundColor: Colors.grey.shade100,
              appBar: AppBar(
                title: const Text(
                  "Cập nhật/Xóa sản phẩm",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              body: Column(
                children: [
                  // Thanh tìm kiếm
                  Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm sản phẩm...",
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        prefixIcon: Icon(Icons.search, color: Colors.blue.shade700),
                        suffixIcon: searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                  // Tổng số sản phẩm
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Tổng cộng: ${getFilteredProducts(products).length} sản phẩm",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  ),
                  // Danh sách sản phẩm
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        homeBloc.add(HomeInitialEvent());
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: getFilteredProducts(products).length,
                        itemBuilder: (context, index) {
                          final product = getFilteredProducts(products)[index];
                          return Slidable(
                            key: Key(product.id.toString()),
                            endActionPane: ActionPane(
                              motion:  DrawerMotion(),
                              extentRatio: 0.25,
                              children: [
                                // SlidableAction(
                                //   onPressed: (_) {
                                //     // TODO: Chuyển đến màn hình chỉnh sửa
                                   
                                //   },
                                //   backgroundColor: Colors.blue.shade700,
                                //   foregroundColor: Colors.white,
                                //   icon: Icons.edit,
                                //   label: 'Sửa',
                                  
                                  
                                // ),
                                SlidableAction(
                                  onPressed: (_) {
                                    showDeleteConfirmDialog(product);
                                  },
                                  backgroundColor: Colors.red.shade600,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Xóa',
                                ),
                              ],
                            ),
                            child: AnimatedContainer(
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
                                title: Text(
                                  product.name ?? '',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey.shade400,
                                ),
                                onTap: () {
                                  // TODO: Thêm hành động khi nhấn vào sản phẩm

                                   // TODO: Chuyển đến màn hình chỉnh sửa
                                    Navigator.pushNamed(context, DetailProductScreen.routeName, arguments: product.id);
                                },
                              ),
                            ),
                          );
                        },
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
            return const SizedBox();
        }
      },
    );
  }
}
