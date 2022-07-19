import '../../models/qna.dart';
import '../../repository/web_services.dart';

class QNARepository {
  final WebServices webServices;
  QNARepository(this.webServices);

  Future<List<QNA>> getQNA() async {
    final qna = await webServices.getQNA();
    return qna.map((qna) => QNA.fromJson(qna)).toList();
  }
}
