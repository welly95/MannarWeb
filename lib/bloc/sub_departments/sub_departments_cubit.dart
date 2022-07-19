import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/sub_departments.dart';
import '../../repository/sub_departments_repository.dart';

part 'sub_departments_state.dart';

class SubDepartmentsCubit extends Cubit<SubDepartmentsState> {
  final SubDepartmentsRepository subDepartmentsRepo;
  List<SubDepartments> subDepartmentsList = [];
  List<Questions> questionsList = [];
  SubDepartmentsCubit(this.subDepartmentsRepo) : super(SubDepartmentsInitial());

  Future<List<SubDepartments>> getSubDepartmentsListFromMain(int mainId) async {
    await subDepartmentsRepo.getSubDepartmentsFromMain(mainId).then((departments) {
      emit(GetSubDepartmentsFromMainState(departments));
      this.subDepartmentsList = departments;
    });
    return subDepartmentsList;
  }

  Future<List<SubDepartments>> getSubDepartmentsListFromCourt(int courtId) async {
    await subDepartmentsRepo.getSubDepartmentsFromCourt(courtId).then((departments) {
      emit(GetSubDepartmentsFromCourtState(departments));
      this.subDepartmentsList = departments;
    });
    return subDepartmentsList;
  }

  Future<List<Questions>> getQuestionsListFromMain(int mainId, int index) async {
    await subDepartmentsRepo.getQuestionsFromMain(mainId, index).then((questions) {
      emit(GetQuestionsFromMainState(questions));
      this.questionsList = questions;
    });
    return questionsList;
  }

  Future<List<Questions>> getQuestionsListFromCourt(int courtId, int index) async {
    await subDepartmentsRepo.getQuestionsFromCourt(courtId, index).then((questions) {
      emit(GetQuestionsFromCourtState(questions));
      this.questionsList = questions;
    });
    return questionsList;
  }
}
