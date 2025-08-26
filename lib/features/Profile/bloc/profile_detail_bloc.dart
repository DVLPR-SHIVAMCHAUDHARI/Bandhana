import 'package:bandhana/features/Profile/bloc/profile_detail_event.dart';
import 'package:bandhana/features/Profile/bloc/profile_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileDetailBloc extends Bloc<ProfileDetailEvent, ProfileDetailState> {
  final List<Map<String, dynamic>> _avatars = [
    {
      'top': 20.0,
      'left': 0.0,
      'right': null,
      'size': 90.h,
      'url':
          "https://i.pinimg.com/736x/ab/31/ac/ab31ac5128744c50e54fcb9323579e78.jpg",
    },
    {
      'top': 0.0,
      'left': 75.w,
      'right': null,
      'size': 90.h,
      'url':
          "https://i.pinimg.com/736x/40/97/20/4097201f5e54c08ca76bf5ba9218aa9a.jpg",
    },
    {
      'top': 0.0,
      'left': null,
      'right': 75.w,
      'size': 90.h,
      'url':
          "https://img.republicworld.com/rimages/screenshot2024-03-05at9.10.26pm-17096535564799_16.webp?q=95&fit=cover&w=900&h=1920",
    },
    {
      'top': -40.0,
      'left': 140.w,
      'right': null,
      'size': 142.h, // 👈 center big one
      'url':
          "https://i.pinimg.com/474x/4a/56/47/4a5647b703642b6b996e3bed50b3d55d.jpg",
    },
    {
      'top': 20.0,
      'left': null,
      'right': 0.0,
      'size': 90.h,
      'url':
          "https://i.pinimg.com/736x/75/96/8d/75968d4d90030e0b522addf6468b0cfd.jpg",
    },
  ];

  final int centerIndex = 3;

  ProfileDetailBloc() : super(InitialState()) {
    on<SwitchImageEvent>(_switchImage);
  }

  void _switchImage(SwitchImageEvent event, Emitter emit) {
    if (event.selectedIndex != centerIndex) {
      final newAvatars = _avatars
          .map((avatar) => Map<String, dynamic>.from(avatar))
          .toList();

      final temp = newAvatars[centerIndex]['url'];
      newAvatars[centerIndex]['url'] = newAvatars[event.selectedIndex]['url'];
      newAvatars[event.selectedIndex]['url'] = temp;

      emit(SwitchImageState(newAvatars, centerIndex));
    }
  }
}
