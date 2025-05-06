part of 'project_product_bloc.dart';

abstract class ProjectProductEvent {
  const ProjectProductEvent();
}

class ProjectProductInitialEvent extends ProjectProductEvent {}

class ProjectProductAddProjectEvent extends ProjectProductEvent {
  final String projectCode;
  final String name;
  final String startDate;
  final String endDate;
  final String supervisor;
  final String status;
  const ProjectProductAddProjectEvent({
    required this.projectCode,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.supervisor,
    required this.status,
  });
}

class ProjectProductUpdateProjectEvent extends ProjectProductEvent {
  final int projectId;
  final String projectCode;
  final String name;
  final String startDate;
  final String endDate;
  final String supervisor;
  final String status;
  const ProjectProductUpdateProjectEvent({
    required this.projectId,
    required this.projectCode,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.supervisor,
    required this.status,
  });
}

class ProjectProductDeleteProjectEvent extends ProjectProductEvent {
  final int projectId;
  final String projectName;
  final String deliveryDate;
  const ProjectProductDeleteProjectEvent({
    required this.projectId,
    required this.projectName,
    required this.deliveryDate,
  });
}