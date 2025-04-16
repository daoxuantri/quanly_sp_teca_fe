import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quanly_sp_teca_fe/components_buttons/loading.dart';
import 'package:quanly_sp_teca_fe/model/product/product_data_model.dart';
import 'package:quanly_sp_teca_fe/screens/detailproduct/detail_product_screen.dart';
import 'package:quanly_sp_teca_fe/screens/home/bloc/home_bloc.dart';
import 'package:quanly_sp_teca_fe/size_config.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

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
              // TODO: Thêm sự kiện xóa sản phẩm
              Navigator.pop(context);
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void showExportDialog() {
    showDialog(
      context: context,
      builder: (_) => ExportDialog(
        fieldSelection: fieldSelection,
        onExport: () {
          exportFile();
        },
      ),
    );
  }

  void exportFile() async {
    print('Export file - Current state: ${homeBloc.state.runtimeType}');
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (!status.isGranted) {
          if (status.isPermanentlyDenied) {
            await openAppSettings();
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Quyền truy cập bộ nhớ bị từ chối")),
          );
          return;
        }
      }
    }

    if (products.isEmpty) {
      homeBloc.add(HomeInitialEvent());
      await homeBloc.stream.firstWhere((state) => state is HomeLoadedSuccessState || state is HomeErrorState);
      final state = homeBloc.state;
      if (state is HomeLoadedSuccessState) {
        products = state.listproduct;
      } else {
        print('Export file - Failed to load products');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Không thể tải dữ liệu sản phẩm")),
        );
        return;
      }
    }

    final filteredProducts = getFilteredProducts(products);
    print('Export file - Filtered products count: ${filteredProducts.length}');
    if (filteredProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không có sản phẩm nào khớp với bộ lọc")),
      );
      return;
    }

    var excel = Excel.createExcel();
    Sheet sheet = excel['Sheet1'];

    List<String> headers = [];
    if (fieldSelection["Tên sản phẩm"]!) headers.add("Tên sản phẩm");
    if (fieldSelection["Giá"]!) headers.add("Giá");
    if (fieldSelection["Nhà cung cấp"]!) headers.add("Nhà cung cấp");
    if (fieldSelection["Xuất xứ"]!) headers.add("Xuất xứ");
    if (fieldSelection["Thương hiệu"]!) headers.add("Thương hiệu");

    sheet.appendRow(headers);

    for (var product in filteredProducts) {
      List<dynamic> row = [];
      if (fieldSelection["Tên sản phẩm"]!) row.add(product.name ?? '');
      if (fieldSelection["Giá"]!) row.add(product.price?.toString() ?? '0');
      if (fieldSelection["Nhà cung cấp"]!) row.add(product.supplier ?? '');
      if (fieldSelection["Xuất xứ"]!) row.add(product.origin ?? 'N/A');
      if (fieldSelection["Thương hiệu"]!) row.add(product.brand ?? '');
      sheet.appendRow(row);
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/products_export.xlsx';

      final excelData = excel.encode();
      if (excelData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lỗi: Không thể mã hóa file Excel")),
        );
        return;
      }

      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(excelData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đã xuất file tại $filePath")),
      );

      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Không thể mở file: ${result.message}")),
        );
      }
    } catch (e) {
      print('Lỗi xuất file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi xuất file: $e")),
      );
    }
  }

  void showFilterDialog(List<ProductDataModel> products) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
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
              value: selectedBrand,
              items: [
                const DropdownMenuItem(value: 'Tất cả', child: Text('Tất cả')),
                ...products
                    .map((p) => p.brand ?? '')
                    .toSet()
                    .map((e) => DropdownMenuItem(value: e, child: Text(e))),
              ],
              onChanged: (val) => setState(() => selectedBrand = val!),
              decoration: InputDecoration(
                labelText: "Lọc theo nhãn hiệu",
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
                    .map((p) => p.supplier ?? '')
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Áp dụng",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ProductDataModel> getFilteredProducts(List<ProductDataModel> products) {
    print('Selected Brand: $selectedBrand, Selected Provider: $selectedProvider');
    final filtered = products.where((product) {
      bool matchBrand =
          selectedBrand == 'Tất cả' || product.brand == selectedBrand;
      bool matchProvider =
          selectedProvider == 'Tất cả' || product.supplier == selectedProvider;
      print(
          'Product: ${product.name}, Match Brand: $matchBrand, Match Provider: $matchProvider');
      return matchBrand && matchProvider;
    }).toList();
    print('Filtered products count: ${filtered.length}');
    return filtered;
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
                                  // Thêm logic tìm kiếm nếu cần
                                },
                              ),
                            ),
                            SizedBox(width: getProportionateScreenWidth(12)),
                            FloatingActionButton(
                              onPressed: () => showFilterDialog(products),
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
                            "Tổng cộng: ${products.length} sản phẩm",
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
                              return Slidable(
                                key: Key(product.id.toString()),
                                endActionPane: ActionPane(
                                  motion: DrawerMotion(),
                                  extentRatio: 0.5,
                                  children: [
                                    SlidableAction(
                                      onPressed: (_) {
                                        // TODO: Chuyển đến màn hình chỉnh sửa
                                      },
                                      backgroundColor: Colors.blue.shade700,
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                      label: 'Sửa',
                                    ),
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
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      "Giá: ${(product.price ?? 0).toStringAsFixed(0)} VNĐ"
                                      " | Hãng: ${product.brand ?? ''}"
                                      " | Nhà cung cấp: ${product.supplier ?? ''}",
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Colors.grey.shade400,
                                    ),
                                    onTap: () {
                                      homeBloc.add(HomeProductClickedEvent(
                                          productId: product.id ?? 0));
                                    },
                                  ),
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
                          onPressed: showExportDialog,
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

class ExportDialog extends StatefulWidget {
  final Map<String, bool> fieldSelection;
  final VoidCallback onExport;

  const ExportDialog({
    super.key,
    required this.fieldSelection,
    required this.onExport,
  });

  @override
  _ExportDialogState createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  late Map<String, bool> localFieldSelection;

  @override
  void initState() {
    super.initState();
    localFieldSelection = Map.from(widget.fieldSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
            ...localFieldSelection.keys.map((field) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: localFieldSelection[field]!
                      ? Colors.blue.shade100
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CheckboxListTile(
                  title: Text(field),
                  value: localFieldSelection[field],
                  activeColor: Colors.blue.shade700,
                  onChanged: (val) {
                    setState(() {
                      localFieldSelection[field] = val!;
                      widget.fieldSelection[field] = val;
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
                  child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
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
                    widget.onExport();
                  },
                  child: const Text("Xuất", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}