import '../../models/sub_departments.dart';
import '../../repository/web_services.dart';

class SubDepartmentsRepository {
  final WebServices webServices;
  SubDepartmentsRepository(this.webServices);

  Future<List<SubDepartments>> getSubDepartmentsFromMain(int mainId) async {
    final subDepartments = await webServices.getSubDepartmentsFromMain(mainId);
    return subDepartments.map((departments) => SubDepartments.fromJson(departments)).toList();
  }

  Future<List<SubDepartments>> getSubDepartmentsFromCourt(int courtId) async {
    final subDepartments = await webServices.getSubDepartmentsFromCourt(courtId);
    return subDepartments.map((departments) => SubDepartments.fromJson(departments)).toList();
  }

  Future<List<Questions>> getQuestionsFromMain(int mainId, int index) async {
    final questions = await webServices.getQuestionsFromMain(mainId, index);
    return questions.map((questions) => Questions.fromJson(questions)).toList();
  }

  Future<List<Questions>> getQuestionsFromCourt(int courtId, int index) async {
    final questions = await webServices.getQuestionsFromCourt(courtId, index);
    return questions.map((questions) => Questions.fromJson(questions)).toList();
  }
}
