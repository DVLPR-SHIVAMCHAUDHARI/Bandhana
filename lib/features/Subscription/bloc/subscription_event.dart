import 'package:equatable/equatable.dart';

abstract class SubscriptionEvent extends Equatable {}

class SwitchPlanEvent extends SubscriptionEvent {
  int selectedIndex;
  @override
  SwitchPlanEvent(this.selectedIndex);
  List<Object?> get props => [selectedIndex];
}
