import 'package:equatable/equatable.dart';

abstract class ProfileDetailState extends Equatable {}

class InitialState extends ProfileDetailState {
  @override
  List<Object?> get props => [];
}

class SwitchImageState extends ProfileDetailState {
  final List<Map<String, dynamic>> avatars;
  final int selectedIndex;
  SwitchImageState(this.avatars, this.selectedIndex);
  @override
  List<Object?> get props => [avatars, selectedIndex];
}
