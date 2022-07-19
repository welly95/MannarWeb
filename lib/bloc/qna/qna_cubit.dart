import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/qna.dart';
import '../../repository/qna_repository.dart';

part 'qna_state.dart';

class QnaCubit extends Cubit<QnaState> {
  final QNARepository qnaRepo;
  List<QNA> qnaList = [];
  QnaCubit(this.qnaRepo) : super(QnaInitial());

  Future<List<QNA>> getQNA() async {
    await qnaRepo.getQNA().then((qna) {
      emit(GetQNAState(qna));
      this.qnaList = qna;
    });
    return qnaList;
  }
}
