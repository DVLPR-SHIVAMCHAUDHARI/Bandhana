import 'package:bandhana/features/Profile/bloc/profile_detail_event.dart';
import 'package:bandhana/features/Profile/bloc/profile_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileDetailBloc extends Bloc<ProfileDetailEvent, ProfileDetailState> {
  final int centerIndex = 3;

  ProfileDetailBloc() : super(InitialState()) {
    on<SwitchImageEvent>(_switchImage);
  }

  void _switchImage(SwitchImageEvent event, Emitter emit) {
    // Make a copy of the avatars list
    final newAvatars = event.avatars
        .map((avatar) => Map<String, dynamic>.from(avatar))
        .toList();

    // Swap the selected avatar with the center avatar
    if (event.selectedIndex != centerIndex) {
      final temp = newAvatars[centerIndex]['url'];
      newAvatars[centerIndex]['url'] = newAvatars[event.selectedIndex]['url'];
      newAvatars[event.selectedIndex]['url'] = temp;
    }

    emit(SwitchImageState(newAvatars, centerIndex));
  }
}
