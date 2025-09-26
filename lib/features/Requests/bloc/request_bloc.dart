import 'package:bandhana/features/Home/models/home_user_model.dart';
import 'package:bandhana/features/Requests/bloc/request_event.dart';
import 'package:bandhana/features/Requests/bloc/request_state.dart';
import 'package:bandhana/features/Requests/repositories/request_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final RequestRepository repo = RequestRepository();

  RequestBloc() : super(InitialState()) {
    on<GetRecievedRequests>(_getRecievedRequests);
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
}
