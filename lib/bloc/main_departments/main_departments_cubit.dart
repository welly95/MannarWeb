import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/main_departments.dart';
import '../../repository/main_departments_repository.dart';

part 'main_departments_state.dart';

class MainDepartmentsCubit extends Cubit<MainDepartmentsState> {
  final MainDepartmentsRepository mainDepartmentsRepo;
  List<MainDepartments> mainDepartmentsList = [];

  MainDepartmentsCubit(this.mainDepartmentsRepo) : super(MainDepartmentsInitial());

  Future<List<MainDepartments>> getMainDepartmentsList() async {
    await mainDepartmentsRepo.getMainDepartments().then((departments) {
      emit(GetMainDepartmentsState(departments));
      this.mainDepartmentsList = departments;
    });
    return mainDepartmentsList;
  }
}
