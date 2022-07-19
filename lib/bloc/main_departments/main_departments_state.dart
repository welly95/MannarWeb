part of 'main_departments_cubit.dart';

abstract class MainDepartmentsState extends Equatable {
  const MainDepartmentsState();

  @override
  List<Object> get props => [];
}

class MainDepartmentsInitial extends MainDepartmentsState {}

class GetMainDepartmentsState extends MainDepartmentsState {
  final List<MainDepartments> mainDepartments;
  GetMainDepartmentsState(this.mainDepartments);
}
