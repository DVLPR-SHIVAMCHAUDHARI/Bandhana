import 'package:bandhana/features/Registration/repositories/family_details_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'family_detail_event.dart';
import 'family_detail_state.dart';

class FamilyDetailBloc extends Bloc<FamilyDetailEvent, FamilyDetailState> {
  final FamilyDetailRepository repo = FamilyDetailRepository();

  FamilyDetailBloc() : super(FamilyDetailInitial()) {
    on<SubmitFamilyDetailEvent>(submitFamilyDetail);
  }

  Future<void> submitFamilyDetail(
    SubmitFamilyDetailEvent event,
    Emitter<FamilyDetailState> emit,
  ) async {
    emit(FamilyDetailLoading());
    try {
      final response = await repo.submitFamilyDetail(
        fathersName: event.fathersName,
        fathersOccupation: event.fathersOccupation,
        fathersContact: event.fathersContact,
        mothersName: event.mothersName,
        mothersOccupation: event.mothersOccupation,
        mothersContact: event.mothersContact,
        noOfBrothers: event.noOfBrothers,
        noOfSisters: event.noOfSisters,
        familyType: event.familyType,
        familyStatus: event.familyStatus,
        familyValues: event.familyValues,
        maternalUncleMamasName: event.maternalUncleMamasName,
        maternalUncleMamasVillage: event.maternalUncleMamasVillage,
        mamasKulClan: event.mamasKulClan,
        relativesFamilySurnames: event.relativesFamilySurnames,
      );

      if (response['status'] == "success") {
        emit(FamilyDetailSuccess(response['message']));
      } else {
        emit(FamilyDetailFailure(response['message']));
      }
    } catch (e) {
      emit(FamilyDetailFailure("Failed: $e"));
    }
  }
}
