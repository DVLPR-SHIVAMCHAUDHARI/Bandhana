import 'package:equatable/equatable.dart';

abstract class ProfileDetailEvent extends Equatable {}

class SwitchImageEvent extends ProfileDetailEvent {
  final int selectedIndex;
  SwitchImageEvent(this.selectedIndex);
  @override
  List<Object?> get props => [selectedIndex];
}
