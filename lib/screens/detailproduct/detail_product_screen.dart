
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quanly_sp_teca_fe/components_buttons/snackbar.dart';
import 'package:quanly_sp_teca_fe/model/product_price/product_price_model.dart';
import 'package:quanly_sp_teca_fe/screens/detailproduct/bloc/detail_bloc.dart';
import 'package:quanly_sp_teca_fe/size_config.dart';
import 'package:intl/intl.dart';

class DetailProductScreen extends StatefulWidget {
  static String routeName = '/detail-product';

  const DetailProductScreen({super.key});

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  final DetailBloc detailBloc = DetailBloc();
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _specificProductController;
  late TextEditingController _unitController;
  late TextEditingController _priceController;
  late TextEditingController _priceDateController;
  late TextEditingController _originController;
  late TextEditingController _brandController;
  late TextEditingController _supplierController;
  late TextEditingController _askerController;
  late TextEditingController _noteController;
  late FocusNode _codeFocusNode;
  late FocusNode _nameFocusNode;
  late FocusNode _specificProductFocusNode;
  late FocusNode _unitFocusNode;
  late FocusNode _priceFocusNode;
  late FocusNode _priceDateFocusNode;
  late FocusNode _originFocusNode;
  late FocusNode _brandFocusNode;
  late FocusNode _supplierFocusNode;
  late FocusNode _askerFocusNode;
  late FocusNode _noteFocusNode;
  String _tempPriceDate = '';

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
    _nameController = TextEditingController();
    _specificProductController = TextEditingController();
    _unitController = TextEditingController();
    _priceController = TextEditingController();
    _priceDateController = TextEditingController();
    _originController = TextEditingController();
    _brandController = TextEditingController();
    _supplierController = TextEditingController();
    _askerController = TextEditingController();
    _noteController = TextEditingController();
    _codeFocusNode = FocusNode();
    _nameFocusNode = FocusNode();
    _specificProductFocusNode = FocusNode();
    _unitFocusNode = FocusNode();
    _priceFocusNode = FocusNode();
    _priceDateFocusNode = FocusNode();
    _originFocusNode = FocusNode();
    _brandFocusNode = FocusNode();
    _supplierFocusNode = FocusNode();
    _askerFocusNode = FocusNode();
    _noteFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _specificProductController.dispose();
    _unitController.dispose();
    _priceController.dispose();
    _priceDateController.dispose();
    _originController.dispose();
    _brandController.dispose();
    _supplierController.dispose();
    _askerController.dispose();
    _noteController.dispose();
    _codeFocusNode.dispose();
    _nameFocusNode.dispose();
    _specificProductFocusNode.dispose();
    _unitFocusNode.dispose();
    _priceFocusNode.dispose();
    _priceDateFocusNode.dispose();
    _originFocusNode.dispose();
    _brandFocusNode.dispose();
    _supplierFocusNode.dispose();
    _askerFocusNode.dispose();
    _noteFocusNode.dispose();
    detailBloc.close();
    super.dispose();
  }

  void _unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<bool?> _showDeleteConfirmationDialog(
      BuildContext context, String productName) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Xác nhận xóa',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.teal),
        ),
        content: Text(
          'Bạn có chắc muốn xóa sản phẩm "$productName"?',
          style: TextStyle(color: Colors.grey.shade800),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy', style: TextStyle(color: Colors.teal)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      // Thử phân tích định dạng ISO 8601
      if (date.contains('T')) {
        final parsedDate = DateTime.parse(date);
        return DateFormat('dd/MM/yyyy').format(parsedDate);
      }
      // Thử phân tích định dạng YYYY-MM-DD
      if (date.contains('-')) {
        final parsedDate = DateFormat('yyyy-MM-dd').parse(date);
        return DateFormat('dd/MM/yyyy').format(parsedDate);
      }
      // Thử phân tích định dạng DD/MM/YYYY
      final parsedDate = DateFormat('dd/MM/yyyy').parse(date);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      print('Error formatting date: $date, error: $e');
      return '';
    }
  }

  String _formatPrice(int? price) {
    if (price == null) return 'N/A';
    final formatter = NumberFormat('#,##0', 'vi_VN');
    return '${formatter.format(price)} VNĐ';
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final ProductPriceModel product =
        ModalRoute.of(context)?.settings.arguments as ProductPriceModel;

    // Chỉ gán giá trị ban đầu nếu không ở chế độ chỉnh sửa hoặc _tempPriceDate rỗng
    _codeController.text = product.code ?? '';
    _nameController.text = product.name ?? '';
    _specificProductController.text = product.specificProduct ?? '';
    _unitController.text = product.unit ?? '';
    _priceController.text = product.price?.toString() ?? '';
    _priceDateController.text = _tempPriceDate.isNotEmpty ? _tempPriceDate : _formatDate(product.priceDate);
    _originController.text = product.origin ?? '';
    _brandController.text = product.brand ?? '';
    _supplierController.text = product.supplier ?? '';
    _askerController.text = product.asker ?? '';
    _noteController.text = product.note ?? '';

    print('In build - product.priceDate: ${product.priceDate}, priceDateController: ${_priceDateController.text}, tempPriceDate: $_tempPriceDate');

    return BlocConsumer<DetailBloc, DetailState>(
      bloc: detailBloc,
      listenWhen: (previous, current) => current is DetailActionState,
      buildWhen: (previous, current) => current is! DetailActionState,
      listener: (context, state) {
        if (state is EditDetailMainProductClickedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBarLoginSuccess(state.message),
          );
          setState(() {
            isEditing = false;
            product.code = _codeController.text;
            product.name = _nameController.text.isEmpty ? null : _nameController.text;
            product.specificProduct = _specificProductController.text.isEmpty ? null : _specificProductController.text;
            product.unit = _unitController.text.isEmpty ? null : _unitController.text;
            product.price = int.tryParse(_priceController.text) ?? null;
            product.priceDate = _tempPriceDate.isNotEmpty ? _tempPriceDate : _priceDateController.text.isEmpty ? null : _priceDateController.text;
            product.origin = _originController.text.isEmpty ? null : _originController.text;
            product.brand = _brandController.text.isEmpty ? null : _brandController.text;
            product.supplier = _supplierController.text;
            product.asker = _askerController.text;
            product.note = _noteController.text.isEmpty ? null : _noteController.text;
            _tempPriceDate = ''; // Reset _tempPriceDate sau khi lưu
            _priceDateController.text = _formatDate(product.priceDate);
            print('After save - product.priceDate: ${product.priceDate}, priceDateController: ${_priceDateController.text}, tempPriceDate: $_tempPriceDate');
          });
        } else if (state is DeleteProductClickedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBarLoginSuccess(state.message),
          );
          Navigator.pop(context);
        } else if (state is DetailErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text(
              'Chi tiết sản phẩm',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(isEditing ? Icons.save : Icons.edit),
                onPressed: () {
                  if (isEditing) {
                    if (_formKey.currentState!.validate()) {
                      print('Saving - tempPriceDate: $_tempPriceDate, priceDateController: ${_priceDateController.text}');
                      detailBloc.add(EditDetailMainProductClickedEvent(
                        productId: product.id ?? 0,
                        code: _codeController.text,
                        name: _nameController.text.isEmpty ? null : _nameController.text,
                        specificProduct: _specificProductController.text.isEmpty ? null : _specificProductController.text,
                        unit: _unitController.text.isEmpty ? null : _unitController.text,
                        price: int.tryParse(_priceController.text) ?? null,
                    priceDate: _tempPriceDate.isNotEmpty ? _tempPriceDate : _priceDateController.text,
                        origin: _originController.text.isEmpty ? null : _originController.text,
                        brand: _brandController.text.isEmpty ? null : _brandController.text,
                        supplier: _supplierController.text,
                        asker: _askerController.text,
                        note: _noteController.text.isEmpty ? null : _noteController.text,
                      ));
                    }
                  } else {
                    setState(() {
                      isEditing = true;
                      _tempPriceDate = _formatDate(product.priceDate);
                      _priceDateController.text = _tempPriceDate;
                      _unfocus();
                    });
                  }
                },
              ),
              if (isEditing)
                IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      isEditing = false;
                      _tempPriceDate = '';
                      _codeController.text = product.code ?? '';
                      _nameController.text = product.name ?? '';
                      _specificProductController.text = product.specificProduct ?? '';
                      _unitController.text = product.unit ?? '';
                      _priceController.text = product.price?.toString() ?? '';
                      _priceDateController.text = _formatDate(product.priceDate);
                      _originController.text = product.origin ?? '';
                      _brandController.text = product.brand ?? '';
                      _supplierController.text = product.supplier ?? '';
                      _askerController.text = product.asker ?? '';
                      _noteController.text = product.note ?? '';
                      _unfocus();
                    });
                  },
                ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final confirm = await _showDeleteConfirmationDialog(
                      context, product.name ?? 'N/A');
                  if (confirm == true) {
                    detailBloc.add(DeleteProductClickedEvent(
                      productId: product.id ?? 0,
                    ));
                  }
                },
              ),
            ],
          ),
          body: SafeArea(
            child: GestureDetector(
              onTap: _unfocus,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Thông tin sản phẩm'),
                      _buildInfoCard('Mã sản phẩm', _codeController, isEditing, _codeFocusNode),
                      _buildInfoCard('Tên sản phẩm', _nameController, isEditing, _nameFocusNode),
                      _buildInfoCard('Chi tiết sản phẩm', _specificProductController, isEditing, _specificProductFocusNode),
                      _buildCombinedInfoCard(
                        'Đơn vị',
                        _unitController,
                        _unitFocusNode,
                        'Giá',
                        _priceController,
                        _priceFocusNode,
                        isEditing,
                        isPrice: true,
                      ),
                      _buildInfoCard('Ngày hỏi giá', _priceDateController, isEditing, _priceDateFocusNode, isDate: true),
                      _buildCombinedInfoCard(
                        'Xuất xứ',
                        _originController,
                        _originFocusNode,
                        'Thương hiệu',
                        _brandController,
                        _brandFocusNode,
                        isEditing,
                      ),
                      _buildInfoCard('Nhà cung cấp', _supplierController, isEditing, _supplierFocusNode),
                      _buildInfoCard('Người hỏi giá', _askerController, isEditing, _askerFocusNode),
                      _buildInfoCard('Ghi chú', _noteController, isEditing, _noteFocusNode),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      String title, TextEditingController controller, bool isEditing, FocusNode focusNode,
      {bool isNumber = false, bool isPrice = false, bool isDate = false}) {
    bool isEmptyValue = controller.text.isEmpty || controller.text == 'N/A';
    String displayText = controller.text;

    if (!isEditing) {
      if (isPrice && !isEmptyValue) {
        displayText = _formatPrice(int.tryParse(controller.text));
      } else if (isDate && !isEmptyValue) {
        displayText = _formatDate(controller.text);
      } else if (isEmptyValue) {
        displayText = 'N/A';
      }
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 64,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.label_important_outline,
                color: Colors.teal.shade600,
                size: 28,
              ),
              SizedBox(width: getProportionateScreenWidth(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(4)),
                    isEditing
                        ? Flexible(
                            child: isDate
                                ? TextFormField(
                                    key: ValueKey(_tempPriceDate),
                                    controller: controller,
                                    focusNode: focusNode,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      isDense: true,
                                      suffixIcon: Icon(
                                        Icons.calendar_today,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    onTap: () async {
                                      DateTime initialDate = DateTime.now();
                                      if (_tempPriceDate.isNotEmpty) {
                                        try {
                                          initialDate = DateFormat('dd/MM/yyyy').parse(_tempPriceDate);
                                        } catch (e) {
                                          print('Error parsing tempPriceDate: $e');
                                        }
                                      } else if (controller.text.isNotEmpty && controller.text != 'N/A') {
                                        try {
                                          if (controller.text.contains('T')) {
                                            initialDate = DateTime.parse(controller.text);
                                          } else if (controller.text.contains('-')) {
                                            initialDate = DateFormat('yyyy-MM-dd').parse(controller.text);
                                          } else {
                                            initialDate = DateFormat('dd/MM/yyyy').parse(controller.text);
                                          }
                                        } catch (e) {
                                          print('Error parsing controller.text: $e');
                                          initialDate = DateTime.now();
                                        }
                                      }

                                      print('Opening showDatePicker with initialDate: $initialDate');
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: initialDate,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );
                                      print('Picked date: $picked');
                                      if (picked != null) {
                                        setState(() {
                                          _tempPriceDate = DateFormat('dd/MM/yyyy').format(picked);
                                          controller.text = _tempPriceDate;
                                          print('Updated tempPriceDate: $_tempPriceDate, controller.text: ${controller.text}');
                                        });
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return null; // Cho phép NULL
                                      }
                                      try {
                                        DateFormat('dd/MM/yyyy').parseStrict(value);
                                        return null;
                                      } catch (e) {
                                        return 'Định dạng ngày không hợp lệ (DD/MM/YYYY)';
                                      }
                                    },
                                  )
                                : TextFormField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      isDense: true,
                                    ),
                                    maxLines: title == 'Chi tiết sản phẩm' || title == 'Ghi chú' ? 2 : 1,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: isNumber ? TextInputType.number : TextInputType.text,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context).nextFocus();
                                    },
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        if (title == 'Mã sản phẩm' || title == 'Nhà cung cấp' || title == 'Người hỏi giá') {
                                          return 'Vui lòng nhập $title';
                                        }
                                        return null; // Cho phép NULL
                                      }
                                      if (isNumber && int.tryParse(value) == null) {
                                        return 'Vui lòng nhập số hợp lệ';
                                      }
                                      return null;
                                    },
                                  ),
                          )
                        : Flexible(
                            child: Text(
                              displayText,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: isEmptyValue
                                    ? Colors.red.shade400
                                    : Colors.grey.shade800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCombinedInfoCard(
      String title1,
      TextEditingController controller1,
      FocusNode focusNode1,
      String title2,
      TextEditingController controller2,
      FocusNode focusNode2,
      bool isEditing,
      {bool isPrice = false}) {
    bool isEmptyValue1 = controller1.text.isEmpty || controller1.text == 'N/A';
    bool isEmptyValue2 = controller2.text.isEmpty || controller2.text == 'N/A';
    String displayText1 = controller1.text;
    String displayText2 = controller2.text;

    if (!isEditing) {
      if (isPrice && !isEmptyValue2) {
        displayText2 = _formatPrice(int.tryParse(controller2.text));
      }
      if (isEmptyValue1) displayText1 = 'N/A';
      if (isEmptyValue2) displayText2 = 'N/A';
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 64,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.label_important_outline,
                color: Colors.teal.shade600,
                size: 28,
              ),
              SizedBox(width: getProportionateScreenWidth(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title1,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(4)),
                    isEditing
                        ? Flexible(
                            child: TextFormField(
                              controller: controller1,
                              focusNode: focusNode1,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                isDense: true,
                              ),
                              maxLines: 1,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(focusNode2);
                              },
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return null; // Cho phép NULL
                                }
                                return null;
                              },
                            ),
                          )
                        : Flexible(
                            child: Text(
                              displayText1,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: isEmptyValue1
                                    ? Colors.red.shade400
                                    : Colors.grey.shade800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                  ],
                ),
              ),
              VerticalDivider(
                color: Colors.grey.shade600,
                thickness: 2,
                width: getProportionateScreenWidth(12),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title2,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(4)),
                    isEditing
                        ? Flexible(
                            child: TextFormField(
                              controller: controller2,
                              focusNode: focusNode2,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                isDense: true,
                              ),
                              maxLines: 1,
                              textInputAction: TextInputAction.next,
                              keyboardType: isPrice ? TextInputType.number : TextInputType.text,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).nextFocus();
                              },
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return null; // Cho phép NULL
                                }
                                if (isPrice && int.tryParse(value) == null) {
                                  return 'Vui lòng nhập số hợp lệ';
                                }
                                return null;
                              },
                            ),
                          )
                        : Flexible(
                            child: Text(
                              displayText2,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: isEmptyValue2
                                    ? Colors.red.shade400
                                    : Colors.grey.shade800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}