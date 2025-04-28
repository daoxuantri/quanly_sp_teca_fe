import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quanly_sp_teca_fe/components_buttons/loading.dart';
import 'package:quanly_sp_teca_fe/components_buttons/snackbar.dart';
import 'package:quanly_sp_teca_fe/model/product/product_data_model.dart';
import 'package:quanly_sp_teca_fe/screens/price_entries/bloc/price_entries_bloc.dart'; 
import 'package:quanly_sp_teca_fe/size_config.dart';
import 'package:intl/intl.dart';

class PriceEntriesScreen extends StatefulWidget {
  static String routeName = '/price-entries';
  const PriceEntriesScreen({super.key});
  @override
  State<PriceEntriesScreen> createState() => _PriceEntriesScreenState();
}

class _PriceEntriesScreenState extends State<PriceEntriesScreen> {
  final PriceEntriesBloc priceEntriesBloc = PriceEntriesBloc();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _priceDateController = TextEditingController();
  final TextEditingController _askerController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _originFocusNode = FocusNode();
  final FocusNode _brandFocusNode = FocusNode();
  final FocusNode _supplierFocusNode = FocusNode();
  final FocusNode _priceDateFocusNode = FocusNode();
  final FocusNode _askerFocusNode = FocusNode();
  final FocusNode _noteFocusNode = FocusNode();
  bool _showForm = false;
  int? _selectedProductId;

  @override
  void initState() {
    super.initState();
    _priceDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    priceEntriesBloc.add(PriceEntriesLoadProductsEvent());
  }

  @override
  void dispose() {
    _priceController.dispose();
    _originController.dispose();
    _brandController.dispose();
    _supplierController.dispose();
    _priceDateController.dispose();
    _askerController.dispose();
    _noteController.dispose();
    _priceFocusNode.dispose();
    _originFocusNode.dispose();
    _brandFocusNode.dispose();
    _supplierFocusNode.dispose();
    _priceDateFocusNode.dispose();
    _askerFocusNode.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  void _unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _priceDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _priceController.clear();
    _originController.clear();
    _brandController.clear();
    _supplierController.clear();
    _priceDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _askerController.clear();
    _noteController.clear();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return BlocConsumer<PriceEntriesBloc, PriceEntriesState>(
      bloc: priceEntriesBloc,
      listenWhen: (previous, current) => current is PriceEntriesActionState,
      buildWhen: (previous, current) => current is! PriceEntriesActionState,
      listener: (context, state) {
        if (state is PriceEntriesSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBarLoginSuccess(state.message),
          );
          setState(() {
            _showForm = false;
            _selectedProductId = null;
            _resetForm();
          });
          priceEntriesBloc.add(PriceEntriesLoadProductsEvent());
        }
      },
      builder: (context, state) {
        if (state is PriceEntriesLoadingState) {
          return const Center(child: LoadingScreen());
        } else if (state is PriceEntriesErrorState) {
          return Center(
            child: Text(
              state.errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        } else if (state is PriceEntriesProductsLoadedState) {
          if (_showForm && _selectedProductId != null) {
            return _buildPriceEntryForm(context, state.products);
          }
          return _buildProductList(context, state.products);
        }
        return const Center(child: LoadingScreen());
      },
    );
  }

  Widget _buildProductList(BuildContext context, List<ProductDataModel> products) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chọn Sản Phẩm',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade700, Colors.teal.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  product.name ?? 'Không có tên',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                  'Mã: ${product.code ?? 'Không có'} | ${product.specificProduct ?? 'Không có chi tiết'}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  setState(() {
                    _showForm = true;
                    _selectedProductId = product.id;
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPriceEntryForm(BuildContext context, List<ProductDataModel> products) {
    final selectedProduct = products.firstWhere((p) => p.id == _selectedProductId);

    return Scaffold(
      appBar: AppBar(
        title:  Text(
          'Thêm giá nhà cung cấp',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade700, Colors.teal.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _showForm = false;
              _selectedProductId = null;
              _resetForm();
            });
          },
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: _unfocus,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Sản Phẩm Đã Chọn'),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        selectedProduct.name ?? 'Không có tên',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Mã: ${selectedProduct.code ?? 'Không có'}',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  ),
                  _buildSectionTitle('Thông Tin Giá'),
                  _buildTextField(
                    controller: _priceController,
                    focusNode: _priceFocusNode,
                    label: 'Giá (VND)',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập giá';
                      }
                      if (double.tryParse(value) == null || double.parse(value) <= 0) {
                        return 'Giá phải là số hợp lệ và lớn hơn 0';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _originController,
                    focusNode: _originFocusNode,
                    label: 'Xuất xứ',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập xuất xứ';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _brandController,
                    focusNode: _brandFocusNode,
                    label: 'Thương hiệu',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập thương hiệu';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _supplierController,
                    focusNode: _supplierFocusNode,
                    label: 'Nhà cung cấp',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập nhà cung cấp';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _priceDateController,
                    focusNode: _priceDateFocusNode,
                    label: 'Ngày hỏi giá',
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng chọn ngày hỏi giá';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _askerController,
                    focusNode: _askerFocusNode,
                    label: 'Người hỏi giá',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập người hỏi giá';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _noteController,
                    focusNode: _noteFocusNode,
                    label: 'Ghi chú',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          priceEntriesBloc.add(PriceEntriesSubmitEvent(
                            productId: _selectedProductId!,
                            price: double.parse(_priceController.text),
                            origin: _originController.text,
                            brand: _brandController.text,
                            supplier: _supplierController.text,
                            priceDate: _priceDateController.text,
                            asker: _askerController.text,
                            note: _noteController.text,
                          ));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade600,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Thêm giá',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool readOnly = false,
    Function()? onTap,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).nextFocus();
        },
        validator: validator,
      ),
    );
  }
}