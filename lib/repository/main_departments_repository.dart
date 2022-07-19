import '../../models/main_departments.dart';
import '../../repository/web_services.dart';

class MainDepartmentsRepository {
  final WebServices webServices;
  MainDepartmentsRepository(this.webServices);

  Future<List<MainDepartments>> getMainDepartments() async {
    final mainDepartments = await webServices.getMainDepartments();
    return mainDepartments.map((departments) => MainDepartments.fromJson(departments)).toList();
  }
}
