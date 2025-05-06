import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quanly_sp_teca_fe/components_buttons/snackbar.dart';
import 'package:quanly_sp_teca_fe/model/investor_info/investor_info_model.dart';
import 'package:quanly_sp_teca_fe/screens/productandproject/bloc/project_product_bloc.dart';
import 'package:quanly_sp_teca_fe/screens/projectdetail/bloc/project_detail_bloc.dart';
import 'package:quanly_sp_teca_fe/screens/projectdetail/project_detail_screen.dart';
import 'package:quanly_sp_teca_fe/size_config.dart';

class ProjectAndProductScreen extends StatefulWidget {
  static String routeName = "/project-and-product";

  const ProjectAndProductScreen({super.key});

  @override
  State<ProjectAndProductScreen> createState() =>
      _ProjectAndProductScreenState();
}

class _ProjectAndProductScreenState extends State<ProjectAndProductScreen> {
  final ProjectProductBloc projectProductBloc = ProjectProductBloc();

  @override
  void initState() {
    super.initState();
    projectProductBloc.add(ProjectProductInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocConsumer<ProjectProductBloc, ProjectProductState>(
      bloc: projectProductBloc,
      listenWhen: (previous, current) => current is ProjectProductActionState,
      buildWhen: (previous, current) => current is! ProjectProductActionState,
      listener: (context, state) {
        if (state is ProjectProductSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBarLoginSuccess(state.message),
          );
        } else if (state is ProjectProductErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ ${state.errorMessage}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ProjectProductLoadingState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Quản lý dự án & sản phẩm',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
            ),
            body: const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            ),
          );
        } else if (state is ProjectProductErrorState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Quản lý dự án & sản phẩm',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          );
        }

        List<InvestorInfoModel> projects = [];
        if (state is ProjectProductProjectsLoadedState) {
          projects = state.projects;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Quản lý dự án & sản phẩm',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddProjectDialog(context),
            backgroundColor: Colors.blue.shade700,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: projects.isEmpty
                ? const Center(
                    child: Text(
                      'Không có dự án nào',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : AnimatedList(
                    initialItemCount: projects.length,
                    itemBuilder: (context, index, animation) {
                      final project = projects[index];
                      return FadeTransition(
                        opacity: animation,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BlocProvider<ProjectDetailBloc>(
                                  create: (context) => ProjectDetailBloc()
                                    ..add(ProjectDetailInitialEvent(
                                        projectId: project.id!)),
                                  child: ProjectDetailScreen(project: project),
                                ),
                              ),
                            );
                          },
                          child: _buildProjectCard(context, project),
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  Widget _buildProjectCard(BuildContext context, InvestorInfoModel project) {
    String formattedStartDate = 'Không có';
    if (project.startDate != null) {
      try {
        final date = DateTime.parse(project.startDate!);
        formattedStartDate = DateFormat('dd/MM/yyyy').format(date);
      } catch (e) {
        formattedStartDate = project.startDate!;
      }
    }

    String formattedEndDate = 'Không có';
    if (project.endDate != null) {
      try {
        final date = DateTime.parse(project.endDate!);
        formattedEndDate = DateFormat('dd/MM/yyyy').format(date);
      } catch (e) {
        formattedEndDate = project.endDate!;
      }
    }

    Color getStatusColor(String? status) {
      switch (status?.toLowerCase()) {
        case 'đang thực hiện':
          return Colors.green;
        case 'hoàn thành':
          return Colors.grey;
        case 'tạm dừng':
          return Colors.orange;
        case 'hủy':
          return Colors.red;
        default:
          return Colors.blue.shade700;
      }
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      project.name ?? 'Không có tên',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            _showEditProjectDialog(context, project),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          minimumSize: const Size(40, 40),
                        ),
                        child: const Icon(Icons.edit,
                            color: Colors.white, size: 20),
                      ),
                      SizedBox(width: getProportionateScreenWidth(8)),
                      ElevatedButton(
                        onPressed: () =>
                            _confirmDeleteProject(context, project),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          minimumSize: const Size(40, 40),
                        ),
                        child: const Icon(Icons.delete,
                            color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(12)),
              Row(
                children: [
                  Icon(Icons.code, color: Colors.grey[600], size: 18),
                  SizedBox(width: getProportionateScreenWidth(8)),
                  Text(
                    'Mã dự án: ${project.projectCode ?? 'Không có'}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(8)),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.green, size: 18),
                  SizedBox(width: getProportionateScreenWidth(8)),
                  Text(
                    'Ngày bắt đầu: $formattedStartDate',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(8)),
              Row(
                children: [
                  Icon(Icons.event_busy, color: Colors.red, size: 18),
                  SizedBox(width: getProportionateScreenWidth(8)),
                  Text(
                    'Ngày kết thúc: $formattedEndDate',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(8)),
              Row(
                children: [
                  Icon(Icons.person, color: Colors.grey[600], size: 18),
                  SizedBox(width: getProportionateScreenWidth(8)),
                  Text(
                    'Người quản lý: ${project.supervisor ?? 'Không có'}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(8)),
              Row(
                children: [
                  Icon(Icons.info, color: Colors.grey[600], size: 18),
                  SizedBox(width: getProportionateScreenWidth(8)),
                  Chip(
                    label: Text(
                      project.status ?? 'Không có',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    backgroundColor: getStatusColor(project.status),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddProjectDialog(BuildContext context) {
    final nameController = TextEditingController();
    final codeController = TextEditingController();
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();
    final supervisorController = TextEditingController();
    String? selectedStatus;
    final List<String> statusOptions = [
      'Đang thực hiện',
      'Hoàn thành',
      'Tạm dừng',
      'Hủy',
    ];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StatefulBuilder(
                builder: (context, setState) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thêm dự án mới',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Tên dự án',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    TextField(
                      controller: codeController,
                      decoration: InputDecoration(
                        labelText: 'Mã dự án',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    TextField(
                      controller: startDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Ngày bắt đầu (DD/MM/YYYY)',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        suffixIcon:
                            Icon(Icons.calendar_today, color: Colors.grey[600]),
                      ),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          startDateController.text =
                              DateFormat('dd/MM/yyyy').format(picked);
                        }
                      },
                    ),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    TextField(
                      controller: endDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Ngày kết thúc (DD/MM/YYYY)',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        suffixIcon:
                            Icon(Icons.calendar_today, color: Colors.grey[600]),
                      ),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          endDateController.text =
                              DateFormat('dd/MM/yyyy').format(picked);
                        }
                      },
                    ),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    TextField(
                      controller: supervisorController,
                      decoration: InputDecoration(
                        labelText: 'Người quản lý',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: InputDecoration(
                        labelText: 'Trạng thái',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      items: statusOptions.map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedStatus = newValue;
                        });
                      },
                    ),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Hủy',
                              style: TextStyle(color: Colors.grey)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (nameController.text.isEmpty ||
                                codeController.text.isEmpty ||
                                startDateController.text.isEmpty ||
                                endDateController.text.isEmpty ||
                                supervisorController.text.isEmpty ||
                                selectedStatus == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Vui lòng nhập đầy đủ thông tin'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            try {
                              // Convert DD/MM/YYYY to YYYY-MM-DD for database
                              final DateTime startDate =
                                  DateFormat('dd/MM/yyyy')
                                      .parseStrict(startDateController.text);
                              final DateTime endDate = DateFormat('dd/MM/yyyy')
                                  .parseStrict(endDateController.text);
                              final String formattedStartDate =
                                  DateFormat('yyyy-MM-dd').format(startDate);
                              final String formattedEndDate =
                                  DateFormat('yyyy-MM-dd').format(endDate);

                              projectProductBloc
                                  .add(ProjectProductAddProjectEvent(
                                projectCode: codeController.text,
                                name: nameController.text,
                                startDate: formattedStartDate,
                                endDate: formattedEndDate,
                                supervisor: supervisorController.text,
                                status: selectedStatus!,
                              ));
                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Định dạng ngày không hợp lệ (DD/MM/YYYY)'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Thêm'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditProjectDialog(BuildContext context, InvestorInfoModel project) {
  final nameController = TextEditingController(text: project.name);
  final codeController = TextEditingController(text: project.projectCode);
  final startDateController = TextEditingController(
    text: project.startDate != null
        ? DateFormat('dd/MM/yyyy').format(DateTime.parse(project.startDate!))
        : '',
  );
  final endDateController = TextEditingController(
    text: project.endDate != null
        ? DateFormat('dd/MM/yyyy').format(DateTime.parse(project.endDate!))
        : '',
  );
  final supervisorController = TextEditingController(text: project.supervisor);
  String? selectedStatus = project.status;
  final List<String> statusOptions = [
    'Đang thực hiện',
    'Hoàn thành',
    'Tạm dừng',
    'Hủy',
  ];

  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StatefulBuilder(
              builder: (context, setState) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chỉnh sửa dự án',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: getProportionateScreenHeight(16)),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Tên dự án',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(16)),
                  TextField(
                    controller: codeController,
                    decoration: InputDecoration(
                      labelText: 'Mã dự án',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(16)),
                  TextField(
                    controller: startDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Ngày bắt đầu (DD/MM/YYYY)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      suffixIcon: Icon(Icons.calendar_today, color: Colors.grey[600]),
                    ),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: project.startDate != null
                            ? DateTime.parse(project.startDate!)
                            : DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        startDateController.text = DateFormat('dd/MM/yyyy').format(picked);
                      }
                    },
                  ),
                  SizedBox(height: getProportionateScreenHeight(16)),
                  TextField(
                    controller: endDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Ngày kết thúc (DD/MM/YYYY)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      suffixIcon: Icon(Icons.calendar_today, color: Colors.grey[600]),
                    ),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: project.endDate != null
                            ? DateTime.parse(project.endDate!)
                            : DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        endDateController.text = DateFormat('dd/MM/yyyy').format(picked);
                      }
                    },
                  ),
                  SizedBox(height: getProportionateScreenHeight(16)),
                  TextField(
                    controller: supervisorController,
                    decoration: InputDecoration(
                      labelText: 'Người quản lý',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(16)),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: InputDecoration(
                      labelText: 'Trạng thái',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: statusOptions.map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStatus = newValue;
                      });
                    },
                  ),
                  SizedBox(height: getProportionateScreenHeight(16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (nameController.text.isEmpty ||
                              codeController.text.isEmpty ||
                              startDateController.text.isEmpty ||
                              endDateController.text.isEmpty ||
                              supervisorController.text.isEmpty ||
                              selectedStatus == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Vui lòng nhập đầy đủ thông tin'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          try {
                            // Convert DD/MM/YYYY to YYYY-MM-DD for database
                            final DateTime startDate = DateFormat('dd/MM/yyyy').parseStrict(startDateController.text);
                            final DateTime endDate = DateFormat('dd/MM/yyyy').parseStrict(endDateController.text);
                            final String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
                            final String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

                            projectProductBloc.add(ProjectProductUpdateProjectEvent(
                              projectId: project.id!,
                              projectCode: codeController.text,
                              name: nameController.text,
                              startDate: formattedStartDate,
                              endDate: formattedEndDate,
                              supervisor: supervisorController.text,
                              status: selectedStatus!,
                            ));
                            Navigator.pop(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Định dạng ngày không hợp lệ (DD/MM/YYYY)'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cập nhật'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
  void _confirmDeleteProject(BuildContext context, InvestorInfoModel project) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
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
                  const Text('Bạn có chắc chắn muốn xóa dự án này?'),
                  SizedBox(height: getProportionateScreenHeight(16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Hủy',
                            style: TextStyle(color: Colors.grey)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          projectProductBloc
                              .add(ProjectProductDeleteProjectEvent(
                            projectId: project.id!,
                            projectName: project.name ?? '',
                            deliveryDate: project.startDate ?? '',
                          ));
                          Navigator.pop(context);
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
