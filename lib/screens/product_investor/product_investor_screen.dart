import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quanly_sp_teca_fe/api/product_investor.dart';
import 'package:quanly_sp_teca_fe/components_buttons/snackbar.dart';
import 'package:quanly_sp_teca_fe/model/investor_info/investor_info_model.dart';
import 'package:quanly_sp_teca_fe/model/price_entries/price_entries_data_model.dart';
import 'package:quanly_sp_teca_fe/model/product_investor/product_investor_model.dart';
import 'package:quanly_sp_teca_fe/screens/product_investor/bloc/product_investor_bloc.dart';

class ProductInvestorScreen extends StatefulWidget {
  static String routeName = "/product-investor";

  const ProductInvestorScreen({super.key});

  @override
  State<ProductInvestorScreen> createState() => _ProductInvestorScreenState();
}

class _ProductInvestorScreenState extends State<ProductInvestorScreen> {
  final ProductInvestorBloc productInvestorBloc = ProductInvestorBloc();
  late BuildContext _scaffoldContext; // Biến lưu context của Scaffold
  InvestorInfoModel? _selectedProject; // Lưu trữ selectedProject cho build
  List<ProductInvestorModel>? _products; // Lưu trữ products cho build

  @override
  void initState() {
    super.initState();
    productInvestorBloc.add(ProductInvestorInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    _scaffoldContext = context; // Lưu context của Scaffold

    return BlocConsumer<ProductInvestorBloc, ProductInvestorState>(
      bloc: productInvestorBloc,
      listenWhen: (previous, current) => current is ProductInvestorActionState,
      buildWhen: (previous, current) => current is! ProductInvestorActionState,
      listener: (context, state) {
        if (state is ProductInvestorSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBarLoginSuccess(state.message),
          );
        } else if (state is ProductInvestorErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ ${state.errorMessage}'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is ProductInvestorPriceEntriesErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ ${state.errorMessage}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ProductInvestorLoadingState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Danh sách sản phẩm cung cấp'),
              backgroundColor: Colors.blue.shade700,
            ),
            body: const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            ),
          );
        } else if (state is ProductInvestorErrorState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Danh sách sản phẩm cung cấp'),
              backgroundColor: Colors.blue.shade700,
            ),
            body: Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          );
        } else if (state is ProductInvestorProjectsLoadedState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Chọn dự án'),
              backgroundColor: Colors.blue.shade700,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: state.projects.isEmpty
                  ? const Center(
                      child: Text(
                        'Không có dự án nào',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : AnimatedList(
                      initialItemCount: state.projects.length,
                      itemBuilder: (context, index, animation) {
                        final project = state.projects[index];
                        return FadeTransition(
                          opacity: animation,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              title: Text(
                                project.projectName ?? 'Không có tên',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Ngày giao: ${project.deliveryDate != null ? DateFormat('dd/MM/yyyy').format(DateTime.parse(project.deliveryDate!)) : 'Không có'}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              onTap: () {
                                productInvestorBloc.add(
                                    ProductInvestorSelectProjectEvent(project: project));
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          );
        } else if (state is ProductInvestorProductsLoadedState) {
          _selectedProject = state.selectedProject; // Lưu trữ trạng thái
          _products = state.products; // Lưu trữ trạng thái
          return Scaffold(
            appBar: AppBar(
              title: Text(state.selectedProject.projectName ?? 'Dự án'),
              backgroundColor: Colors.blue.shade700,
              elevation: 0,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showAddProductDialog(state.selectedProject),
              backgroundColor: Colors.blue.shade700,
              child: const Icon(Icons.add, color: Colors.white),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: state.products.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Không có sản phẩm nào',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Nhấn nút + để thêm sản phẩm mới',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : AnimatedList(
                      initialItemCount: state.products.length,
                      itemBuilder: (context, index, animation) {
                        final product = state.products[index];
                        return FadeTransition(
                          opacity: animation,
                          child: _buildProductCard(context, product),
                        );
                      },
                    ),
            ),
          );
        } else if (state is ProductInvestorPriceEntriesLoadedState) {
          // Khi ở trạng thái này, vẫn hiển thị giao diện trước đó
          if (_selectedProject != null && _products != null) {
            return Scaffold(
              appBar: AppBar(
                title: Text(_selectedProject!.projectName ?? 'Dự án'),
                backgroundColor: Colors.blue.shade700,
                elevation: 0,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => _showAddProductDialog(_selectedProject!),
                backgroundColor: Colors.blue.shade700,
                child: const Icon(Icons.add, color: Colors.white),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _products!.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Không có sản phẩm nào',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Nhấn nút + để thêm sản phẩm mới',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : AnimatedList(
                        initialItemCount: _products!.length,
                        itemBuilder: (context, index, animation) {
                          final product = _products![index];
                          return FadeTransition(
                            opacity: animation,
                            child: _buildProductCard(context, product),
                          );
                        },
                      ),
              ),
            );
          }
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProductCard(BuildContext context, ProductInvestorModel product) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          'Sản phẩm ID: ${product.priceEntriesId ?? 'Không có'}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Giá nhập: ${product.priceNhap != null ? formatter.format(product.priceNhap) : 'Không có'}'),
            Text('Giá bán: ${product.priceBan != null ? formatter.format(product.priceBan) : 'Không có'}'),
            Text('Số lượng: ${product.quantity ?? 'Không có'}'),
            Text('Tổng nhập: ${product.totalNhap != null ? formatter.format(product.totalNhap) : 'Không có'}'),
            Text('Tổng bán: ${product.totalBan != null ? formatter.format(product.totalBan) : 'Không có'}'),
          ],
        ),
      ),
    );
  }

  void _showAddProductDialog(InvestorInfoModel project) {
    productInvestorBloc.add(ProductInvestorFetchPriceEntriesEvent(projectId: project.id));

    showDialog(
      context: _scaffoldContext,
      barrierColor: Colors.black54,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: BlocConsumer<ProductInvestorBloc, ProductInvestorState>(
          bloc: productInvestorBloc,
          listener: (context, state) {
            if (state is ProductInvestorPriceEntriesErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            PriceEntriesDataModel? selectedPriceEntry;
            final priceBanController = TextEditingController();
            final quantityController = TextEditingController();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: StatefulBuilder(
                builder: (context, setState) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thêm sản phẩm cho dự án',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    if (state is ProductInvestorLoadingState)
                      const Center(child: CircularProgressIndicator(color: Colors.blue))
                    else if (state is ProductInvestorPriceEntriesLoadedState) ...[
                      const Text(
                        'Chọn loại giá:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: state.priceEntries.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Không có loại giá nào. Vui lòng thêm loại giá trước.',
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.priceEntries.length,
                                itemBuilder: (context, index) {
                                  final entry = state.priceEntries[index];
                                  final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
                                  final isSelected = selectedPriceEntry == entry;
                                  return Card(
                                    color: isSelected ? Colors.blue.shade100 : Colors.white,
                                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(8),
                                      title: Text(
                                        '${entry.brand ?? entry.note ?? 'Giá ID: ${entry.id}'} - ${entry.supplier ?? 'Không có'}',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Giá: ${entry.price != null ? formatter.format(entry.price) : 'Không có'}'),
                                          Text('Nguồn gốc: ${entry.origin ?? 'Không có'}'),
                                          Text('Ghi chú: ${entry.note ?? 'Không có'}'),
                                        ],
                                      ),
                                      onTap: () {
                                        setState(() {
                                          selectedPriceEntry = entry;
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    TextField(
                      controller: priceBanController,
                      decoration: InputDecoration(
                        labelText: 'Giá bán',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: quantityController,
                      decoration: InputDecoration(
                        labelText: 'Số lượng',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            productInvestorBloc.add(ProductInvestorCancelAddProductEvent());
                            Navigator.pop(context);
                          },
                          child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (selectedPriceEntry == null ||
                                priceBanController.text.isEmpty ||
                                quantityController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Vui lòng nhập đầy đủ thông tin'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            if (selectedPriceEntry!.id == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Sản phẩm phải có ID hợp lệ'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            final priceBan = double.tryParse(priceBanController.text);
                            final quantity = int.tryParse(quantityController.text);
                            if (priceBan == null || quantity == null || quantity <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Giá bán và số lượng phải hợp lệ'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            productInvestorBloc.add(ProductInvestorAddProductEvent(
                              idInvestor: project.id!,
                              priceEntriesId: selectedPriceEntry!.id!,
                              priceNhap: selectedPriceEntry!.price?.toDouble() ?? 0.0,
                              priceBan: priceBan,
                              quantity: quantity,
                            ));
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Lưu'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
}
}