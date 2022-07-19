import '../../models/lawyers.dart';
import '../../repository/web_services.dart';

class LawyerRepository {
  final WebServices webServices;
  LawyerRepository(this.webServices);

  Future<List<Lawyer>> getLawyers(String lawyerName) async {
    final lawyers = await webServices.getLawyers(lawyerName);
    return lawyers.map((lawyers) => Lawyer.fromJson(lawyers)).toList();
  }

  Future<List<Lawyer>> getSuggetionsLawyers(int subId) async {
    final suggetionLawyers = await webServices.getLawyersBySubDepartments(subId);
    return suggetionLawyers.map((suggetions) => Lawyer.fromJson(suggetions)).toList();
  }

  Future<List<Lawyer>> getSuggetionsLawyersByCourts(int subId) async {
    final suggetionLawyers = await webServices.getLawyersByCourts(subId);
    return suggetionLawyers.map((suggetions) => Lawyer.fromJson(suggetions)).toList();
  }

  Future<List<Lawyer>> filteredLawyers(
      String country, String city, String type, List<int> mainDepartments, List<int> specialists) async {
    final filterLawyers = await webServices.filteredLawyers(country, city, type, mainDepartments, specialists);
    return filterLawyers.map((lawyers) => Lawyer.fromJson(lawyers)).toList();
  }
}
