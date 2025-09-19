import 'package:equatable/equatable.dart';

abstract class ProfileDetailEvent extends Equatable {}

class SwitchImageEvent extends ProfileDetailEvent {
  final int selectedIndex;
  final List<Map<String, dynamic>> avatars;

  SwitchImageEvent(this.selectedIndex, this.avatars);
  @override
  // TODO: implement props
  List<Object?> get props => [avatars, selectedIndex];
}
