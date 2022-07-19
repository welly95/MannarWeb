import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/courts.dart';
import '../../repository/courts_repository.dart';

part 'courts_state.dart';

class CourtsCubit extends Cubit<CourtsState> {
  final CourtsRepository courtsRepo;
  List<Courts> courtsList = [];
  CourtsCubit(this.courtsRepo) : super(CourtsInitial());

  Future<List<Courts>> getCourtsList(int mainId) async {
    await courtsRepo.getCourts(mainId).then((courts) {
      emit(GetCourtsState(courts));
      this.courtsList = courts;
    });
    return courtsList;
  }
}
