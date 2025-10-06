import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/about_info_repo.dart';
import 'about_event.dart';
import 'about_state.dart';
import '../model/about_model.dart';

class AboutBloc extends Bloc<AboutEvent, AboutState> {
  final AboutInfoRepo repository;

  AboutBloc(this.repository) : super(AboutInitial()) {
    on<FetchAboutEvent>((event, emit) async {
      emit(AboutLoading());
      try {
        final res = await repository.getUserList();
        if (res['status'] == 'Success') {
          final about = AboutModel.fromJson(res['response']);
          emit(AboutLoaded(about));
        } else {
          emit(AboutError(res['response'] ?? "Failed to fetch about info"));
        }
      } catch (e) {
        emit(AboutError(e.toString()));
      }
    });
  }
}
