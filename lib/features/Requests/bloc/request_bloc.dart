import 'package:MilanMandap/features/Home/models/home_user_model.dart';
import 'package:MilanMandap/features/Requests/bloc/request_event.dart';
import 'package:MilanMandap/features/Requests/bloc/request_state.dart';
import 'package:MilanMandap/features/Requests/repositories/request_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final RequestRepository repo = RequestRepository();

  RequestBloc() : super(InitialState()) {
    on<GetRecievedRequests>(_getRecievedRequests);
    on<GetSentRequests>(_getSentRequests);
    on<RejectRecievedRequest>(_rejectRecievedRequest);
  }

  Future<void> _getRecievedRequests(
    GetRecievedRequests event,
    Emitter<RequestState> emit,
  ) async {
    emit(RecievedRequestsLoadingState());
    try {
      var response = await repo.getRecievedRequests();
      if (response["status"] == "Success") {
        final users = (response['response'] as List)
            .map((e) => HomeUserModel.fromJson(e))
            .toList();
        emit(RecievedRequestsLoadedState(users));
      } else {
        emit(RecievedRequestsErrorState(response['response']));
      }
    } catch (e) {
      emit(RecievedRequestsErrorState(e.toString()));
    }
  }

  Future<void> _getSentRequests(
    GetSentRequests event,
    Emitter<RequestState> emit,
  ) async {
    emit(SentRequestsLoadingState());
    try {
      var response = await repo.getSentRequests();
      if (response["status"] == "Success") {
        final users = (response['response'] as List)
            .map((e) => HomeUserModel.fromJson(e))
            .toList();
        emit(SentRequestsLoadedState(users));
      } else {
        emit(SentRequestsErrorState(response['response']));
      }
    } catch (e) {
      emit(SentRequestsErrorState(e.toString()));
    }
  }

  Future<void> _rejectRecievedRequest(
    RejectRecievedRequest event,
    Emitter<RequestState> emit,
  ) async {
    emit(RejectRequestLoadingState());
    try {
      var response = await repo.rejectRecivedRequest(id: event.userId);
      if (response["status"] == "Success") {
        emit(RejectRequestSuccessState(response["response"]));
        // optional: refresh received list automatically
        add(GetRecievedRequests());
      } else {
        emit(RejectRequestErrorState(response["response"]));
      }
    } catch (e) {
      emit(RejectRequestErrorState(e.toString()));
    }
  }
}
