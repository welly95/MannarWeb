part of 'qna_cubit.dart';

abstract class QnaState extends Equatable {
  const QnaState();

  @override
  List<Object> get props => [];
}

class QnaInitial extends QnaState {}

class GetQNAState extends QnaState {
  final List<QNA> qnaList;
  GetQNAState(this.qnaList);
}
