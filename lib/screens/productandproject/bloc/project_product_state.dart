part of 'project_product_bloc.dart';

abstract class ProjectProductState {
  const ProjectProductState();
}

abstract class ProjectProductActionState extends ProjectProductState {}

class ProjectProductInitial extends ProjectProductState {}

class ProjectProductLoadingState extends ProjectProductState {}

class ProjectProductSuccessState extends ProjectProductActionState {
  final String message;
  ProjectProductSuccessState({required this.message});
}

class ProjectProductErrorState extends ProjectProductActionState {
  final String errorMessage;
  ProjectProductErrorState({required this.errorMessage});
}

class ProjectProductProjectsLoadedState extends ProjectProductState {
  final List<InvestorInfoModel> projects;
  const ProjectProductProjectsLoadedState({
    required this.projects,
  });
}