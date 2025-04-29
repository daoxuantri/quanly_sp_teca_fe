part of 'investor_info_bloc.dart';

abstract class InvestorInfoEvent {
  const InvestorInfoEvent();
}

class InvestorInfoInitialEvent extends InvestorInfoEvent {}

class InvestorInfoAddProjectEvent extends InvestorInfoEvent {
  final String projectName;
  final String deliveryDate;
  const InvestorInfoAddProjectEvent({
    required this.projectName,
    required this.deliveryDate,
  });
}

class InvestorInfoUpdateProjectEvent extends InvestorInfoEvent {
  final int projectId;
  final String projectName;
  final String deliveryDate;
  const InvestorInfoUpdateProjectEvent({
    required this.projectId,
    required this.projectName,
    required this.deliveryDate,
  });
}

class InvestorInfoDeleteProjectEvent extends InvestorInfoEvent {
  final int projectId;
  final String projectName;
  final String deliveryDate;
  const InvestorInfoDeleteProjectEvent({
    required this.projectId,
    required this.projectName,
    required this.deliveryDate,
  });
}