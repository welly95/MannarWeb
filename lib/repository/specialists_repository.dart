import '../../models/specialists_model.dart';
import '../../repository/web_services.dart';

class SpecialistsRepository {
  final WebServices webServices;
  SpecialistsRepository(this.webServices);

  Future<List<SpecialistsModel>> getSpecialists() async {
    final specialistsModel = await webServices.getSpecialists();
    return specialistsModel.map((specialists) => SpecialistsModel.fromJson(specialists)).toList();
  }
}
