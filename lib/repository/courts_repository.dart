import '../../models/courts.dart';
import '../../repository/web_services.dart';

class CourtsRepository {
  final WebServices webServices;
  CourtsRepository(this.webServices);

  Future<List<Courts>> getCourts(int mainId) async {
    final courts = await webServices.getCourts(mainId);
    return courts.map((courts) => Courts.fromJson(courts)).toList();
  }
}
