import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quanly_sp_teca_fe/components_buttons/snackbar.dart';
import 'package:quanly_sp_teca_fe/model/investor_info/investor_info_model.dart';
import 'package:quanly_sp_teca_fe/model/product_investor/product_investor_model.dart';
import 'package:quanly_sp_teca_fe/model/product_price/product_price_model.dart';
import 'package:quanly_sp_teca_fe/screens/projectdetail/bloc/project_detail_bloc.dart';
import 'package:quanly_sp_teca_fe/size_config.dart';

class ProjectDetailScreen extends StatefulWidget {
  final InvestorInfoModel project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  late ProjectDetailBloc projectDetailBloc;

  @override
  void initState() {
    super.initState();
    projectDetailBloc = ProjectDetailBloc();
    if (widget.project.id != null) {
      projectDetailBloc
          .add(ProjectDetailInitialEvent(projectId: widget.project.id!));
    }
  }

  @override
  void dispose() {
    projectDetailBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocProvider(
      create: (context) => projectDetailBloc,
      child: BlocConsumer<ProjectDetailBloc, ProjectDetailState>(
        listener: (context, state) {
          if (!mounted) return; // Kiểm tra mounted
          if (state is ProjectDetailSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBarLoginSuccess(state.message),
            );
          } else if (state is ProjectDetailCreateProductSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBarLoginSuccess(state.message),
            );
          } else if (state is ProjectDetailErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ ${state.errorMessage}'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ProjectDetailPriceEntriesErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ ${state.errorMessage}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          List<ProductInvestorModel> products = [];
          if (state is ProjectDetailProductsLoadedState) {
            products = state.products;
          } else if (state is ProjectDetailPriceEntriesLoadedState) {
            products = state.products;
          } else if (state is ProjectDetailCreateProductSuccessState) {
            products = state.products;
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.project.name ?? 'Dự án',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showAddProductDialog(context, widget.project),
              backgroundColor: Colors.blue.shade700,
              child: const Icon(Icons.add, color: Colors.white),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: state is ProjectDetailLoadingState
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.blue))
                  : products.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Không có sản phẩm nào',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              SizedBox(height: getProportionateScreenHeight(8)),
                              const Text(
                                'Nhấn nút + để thêm sản phẩm mới',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : AnimatedList(
                          initialItemCount: products.length,
                          itemBuilder: (context, index, animation) {
                            final product = products[index];
                            return FadeTransition(
                              opacity: animation,
                              child: GestureDetector(
                                onTap: () =>
                                    _showProductDetailDialog(context, product),
                                onLongPress: () =>
                                    _confirmDeleteProduct(context, product),
                                child: _buildProductCard(context, product),
                              ),
                            );
                          },
                        ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ProductInvestorModel product) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      shadowColor: Colors.grey.withOpacity(0.2),
      margin: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(10),
        horizontal: getProportionateScreenWidth(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    product.productName ?? 'Sản phẩm không tên',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(8),
                    vertical: getProportionateScreenHeight(4),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'ID: ${product.id ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(8)),
            Text(
              'Mã: ${product.code ?? 'Không có'}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(4)),
            Text(
              'Nhà cung cấp: ${product.supplier ?? 'Không có'}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetailDialog(
      BuildContext context, ProductInvestorModel product) {
    showDialog(
      context: context,
      builder: (dialogContext) => ProductDetailDialog(product: product),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {required IconData icon, required Color iconColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: iconColor),
        SizedBox(width: getProportionateScreenWidth(8)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddProductDialog(BuildContext context, InvestorInfoModel project,
      {String? initialSearchQuery}) {
    if (project.id == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dự án không có ID hợp lệ'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Sử dụng projectDetailBloc từ _ProjectDetailScreenState
    if (mounted) {
      projectDetailBloc
          .add(ProjectDetailFetchPriceEntriesEvent(projectId: project.id));
    }
    final searchController = TextEditingController(text: initialSearchQuery);

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<ProjectDetailBloc, ProjectDetailState>(
            bloc: projectDetailBloc, // Sử dụng projectDetailBloc
            builder: (builderContext, state) {
              ProductPriceModel? selectedPriceEntry;
              final priceBanController = TextEditingController();
              final quantityController = TextEditingController();
              String searchQuery = initialSearchQuery?.toLowerCase() ?? '';

              return StatefulBuilder(
                builder: (statefulContext, setState) => ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(statefulContext).size.height * 0.7,
                    maxWidth: 500,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Thêm sản phẩm',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close,
                                size: 20, color: Colors.grey),
                            onPressed: () {
                              if (mounted) {
                                projectDetailBloc
                                    .add(ProjectDetailCancelAddProductEvent());
                              }
                              Navigator.pop(dialogContext);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: getProportionateScreenHeight(8)),
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Tìm theo tên hoặc mã sản phẩm...',
                          prefixIcon: const Icon(Icons.search,
                              size: 20, color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(fontSize: 14),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                      SizedBox(height: getProportionateScreenHeight(12)),
                      const Text(
                        'Loại giá:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(8)),
                      Expanded(
                        child: state is ProjectDetailLoadingState
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                  strokeWidth: 3,
                                ),
                              )
                            : state is ProjectDetailPriceEntriesLoadedState ||
                                    state
                                        is ProjectDetailCreateProductSuccessState
                                ? Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Builder(
                                      builder: (context) {
                                        final priceEntries = state
                                                is ProjectDetailPriceEntriesLoadedState
                                            ? state.priceEntries
                                            : (state
                                                    as ProjectDetailCreateProductSuccessState)
                                                .priceEntries;

                                        if (priceEntries.isEmpty) {
                                          return const Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Text(
                                              'Chưa có loại giá.',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          );
                                        }

                                        final visibleEntries =
                                            priceEntries.where((entry) {
                                          if (searchQuery.isEmpty) return true;
                                          return (entry.code
                                                      ?.toLowerCase()
                                                      .contains(searchQuery) ??
                                                  false) ||
                                              (entry.name
                                                      ?.toLowerCase()
                                                      .contains(searchQuery) ??
                                                  false);
                                        }).toList();

                                        if (visibleEntries.isEmpty &&
                                            searchQuery.isNotEmpty) {
                                          return ListView(
                                            shrinkWrap: true,
                                            children: [
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.add_circle_outline,
                                                  color: Colors.blue,
                                                ),
                                                title: Text(
                                                  'Không tìm thấy sản phẩm. Thêm "${searchQuery}"?',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.blueGrey,
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.pop(dialogContext);
                                                  // Truyền projectDetailBloc thay vì context
                                                  _showCreateProductDialog(
                                                      context,
                                                      project,
                                                      searchQuery,
                                                      projectDetailBloc);
                                                },
                                              ),
                                            ],
                                          );
                                        }

                                        return ListView.separated(
                                          shrinkWrap: true,
                                          itemCount: priceEntries.length,
                                          separatorBuilder: (context, index) =>
                                              Divider(
                                            height: 1,
                                            thickness: 1,
                                            color: Colors.grey.shade300,
                                          ),
                                          itemBuilder: (context, index) {
                                            final entry = priceEntries[index];
                                            final formatter =
                                                NumberFormat.currency(
                                                    locale: 'vi_VN',
                                                    symbol: '₫');
                                            String formattedPriceDate =
                                                'Không có';
                                            if (entry.priceDate != null) {
                                              try {
                                                final date = DateTime.parse(
                                                    entry.priceDate!);
                                                formattedPriceDate =
                                                    DateFormat('dd/MM/yyyy')
                                                        .format(date);
                                              } catch (e) {
                                                formattedPriceDate =
                                                    entry.priceDate!;
                                              }
                                            }

                                            if (searchQuery.isNotEmpty &&
                                                !(entry.code
                                                        ?.toLowerCase()
                                                        .contains(
                                                            searchQuery) ??
                                                    false) &&
                                                !(entry.name
                                                        ?.toLowerCase()
                                                        .contains(
                                                            searchQuery) ??
                                                    false)) {
                                              return const SizedBox.shrink();
                                            }

                                            final isSelected =
                                                selectedPriceEntry == entry;
                                            return Card(
                                              color: isSelected
                                                  ? Colors.blue.shade50
                                                  : Colors.white,
                                              elevation: isSelected ? 3 : 0,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 3,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: ListTile(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 6,
                                                ),
                                                title: Text(
                                                  entry.name ??
                                                      'ID: ${entry.id}',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors
                                                        .blueGrey.shade700,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                        height:
                                                            getProportionateScreenHeight(
                                                                4)),
                                                    Text(
                                                      'Mã: ${entry.code ?? 'N/A'}',
                                                      style: const TextStyle(
                                                          fontSize: 13),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      'Giá: ${entry.price != null ? formatter.format(entry.price) : 'N/A'}',
                                                      style: const TextStyle(
                                                          fontSize: 13),
                                                    ),
                                                    Text(
                                                      'Nhà cung cấp: ${entry.supplier ?? 'N/A'}',
                                                      style: const TextStyle(
                                                          fontSize: 13),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      'Thương hiệu: ${entry.brand ?? 'N/A'} · Nguồn: ${entry.origin ?? 'N/A'}',
                                                      style: const TextStyle(
                                                          fontSize: 13),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      'Ngày giá: $formattedPriceDate',
                                                      style: const TextStyle(
                                                          fontSize: 13),
                                                    ),
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
                                        );
                                      },
                                    ),
                                  )
                                : const SizedBox.shrink(),
                      ),
                      SizedBox(height: getProportionateScreenHeight(12)),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: priceBanController,
                              decoration: InputDecoration(
                                labelText: 'Giá bán',
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
                          ),
                          SizedBox(width: getProportionateScreenWidth(12)),
                          Expanded(
                            child: TextField(
                              controller: quantityController,
                              decoration: InputDecoration(
                                labelText: 'Số lượng',
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
                          ),
                        ],
                      ),
                      SizedBox(height: getProportionateScreenHeight(16)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              if (mounted) {
                                projectDetailBloc
                                    .add(ProjectDetailCancelAddProductEvent());
                              }
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
                              if (selectedPriceEntry == null ||
                                  priceBanController.text.isEmpty ||
                                  quantityController.text.isEmpty) {
                                if (mounted) {
                                  ScaffoldMessenger.of(builderContext)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Vui lòng nhập đầy đủ thông tin'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                                return;
                              }
                              if (selectedPriceEntry!.id == null) {
                                if (mounted) {
                                  ScaffoldMessenger.of(builderContext)
                                      .showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Sản phẩm phải có ID hợp lệ'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                                return;
                              }
                              final priceBan =
                                  double.tryParse(priceBanController.text);
                              final quantity =
                                  int.tryParse(quantityController.text);
                              if (priceBan == null ||
                                  quantity == null ||
                                  quantity <= 0) {
                                if (mounted) {
                                  ScaffoldMessenger.of(builderContext)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Giá bán và số lượng phải hợp lệ'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                                return;
                              }
                              if (mounted) {
                                projectDetailBloc.add(
                                  ProjectDetailAddProductEvent(
                                    idInvestor: project.id!,
                                    priceEntriesId: selectedPriceEntry!.id!,
                                    priceNhap:
                                        selectedPriceEntry!.price?.toDouble() ??
                                            0.0,
                                    priceBan: priceBan,
                                    quantity: quantity,
                                  ),
                                );
                              }
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
              );
            },
          ),
        ),
      ),
    );
  }

  void _showCreateProductDialog(BuildContext context, InvestorInfoModel project,
      String searchQuery, ProjectDetailBloc bloc) {
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
                      icon:
                          const Icon(Icons.close, size: 20, color: Colors.grey),
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
                    suffixIcon:
                        Icon(Icons.calendar_today, color: Colors.grey[600]),
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
                        // Kiểm tra các trường bắt buộc
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
                        // Kiểm tra giá nhập
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
                        // Kiểm tra định dạng ngày giá
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
                        // Gửi sự kiện sử dụng instance bloc được truyền vào
                        bloc.add(
                          ProjectDetailCreateProductEvent(
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
                            projectId: project.id!,
                            searchQuery: searchQuery,
                          ),
                        );
                        // Loại bỏ focus trước khi đóng dialog
                        FocusScope.of(dialogContext).unfocus();
                        // Đóng dialog và mở dialog mới với dialogContext
                        Navigator.pop(dialogContext);
                        Future.delayed(Duration.zero, () {
                          if (mounted) {
                            _showAddProductDialog(dialogContext, project,
                                initialSearchQuery: searchQuery);
                          }
                        });
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
      // Trì hoãn hủy TextEditingController để đảm bảo focus được xử lý
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

  void _confirmDeleteProduct(
      BuildContext context, ProductInvestorModel product) {
    if (widget.project.id == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dự án không có ID hợp lệ'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Xác nhận xóa',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: getProportionateScreenHeight(16)),
                  Text(
                      'Bạn có chắc chắn muốn xóa sản phẩm "${product.productName ?? 'N/A'}"?'),
                  SizedBox(height: getProportionateScreenHeight(16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text('Hủy',
                            style: TextStyle(color: Colors.grey)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (product.id != null) {
                            if (mounted) {
                              BlocProvider.of<ProjectDetailBloc>(context).add(
                                ProjectDetailDeleteProductEvent(
                                  productId: product.id!,
                                  projectId: widget.project.id!,
                                ),
                              );
                            }
                          } else {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Sản phẩm không có ID hợp lệ'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                          Navigator.pop(dialogContext);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Xóa'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductDetailDialog extends StatelessWidget {
  final ProductInvestorModel product;

  const ProductDetailDialog({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      product.productName ?? 'Sản phẩm không tên',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(8)),
              _buildInfoRow(
                'ID',
                product.id?.toString() ?? 'N/A',
                icon: Icons.label,
                iconColor: Colors.blue.shade700,
              ),
              _buildInfoRow(
                'Mã',
                product.code ?? 'Không có',
                icon: Icons.code,
                iconColor: Colors.grey.shade700,
              ),
              _buildInfoRow(
                'Nhà cung cấp',
                product.supplier ?? 'Không có',
                icon: Icons.business,
                iconColor: Colors.grey.shade700,
              ),
              Divider(
                height: getProportionateScreenHeight(24),
                thickness: 1,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          'Giá nhập',
                          product.priceNhap != null
                              ? formatter.format(product.priceNhap)
                              : 'Không có',
                          icon: Icons.arrow_downward,
                          iconColor: Colors.red.shade400,
                        ),
                        SizedBox(height: getProportionateScreenHeight(8)),
                        _buildInfoRow(
                          'Giá bán',
                          product.priceBan != null
                              ? formatter.format(product.priceBan)
                              : 'Không có',
                          icon: Icons.arrow_upward,
                          iconColor: Colors.green.shade400,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: getProportionateScreenWidth(16)),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          'Tổng nhập',
                          product.totalNhap != null
                              ? formatter.format(product.totalNhap)
                              : 'Không có',
                          icon: Icons.account_balance_wallet,
                          iconColor: Colors.red.shade400,
                        ),
                        SizedBox(height: getProportionateScreenHeight(8)),
                        _buildInfoRow(
                          'Tổng bán',
                          product.totalBan != null
                              ? formatter.format(product.totalBan)
                              : 'Không có',
                          icon: Icons.account_balance,
                          iconColor: Colors.green.shade400,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: _buildInfoRow(
                      'Số lượng',
                      product.quantity?.toString() ?? 'Không có',
                      icon: Icons.inventory,
                      iconColor: Colors.blue.shade600,
                    ),
                  ),
                  SizedBox(width: getProportionateScreenWidth(16)),
                  Flexible(
                    fit: FlexFit.loose,
                    child: _buildInfoRow(
                      'Price Entry ID',
                      product.priceEntriesId?.toString() ?? 'N/A',
                      icon: Icons.label,
                      iconColor: Colors.purple.shade400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(8)),
              _buildInfoRow(
                'Investor ID',
                product.idInvestor?.toString() ?? 'N/A',
                icon: Icons.person,
                iconColor: Colors.orange.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {required IconData icon, required Color iconColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: iconColor),
        SizedBox(width: getProportionateScreenWidth(8)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
