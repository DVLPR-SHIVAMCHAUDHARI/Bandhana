import 'package:equatable/equatable.dart';

abstract class SubscriptionState extends Equatable {}

class InitialState extends SubscriptionState {
  @override
  List<Object?> get props => [];
}

class PlansLoadingState extends SubscriptionState {
  @override
  List<Object?> get props => [];
}

class PlansLoadedState extends SubscriptionState {
  @override
  List<Object?> get props => [];
}

class PlansLoadFailureState extends SubscriptionState {
  @override
  List<Object?> get props => [];
}

class SwitchPlanState extends SubscriptionState {
  int selectedIndex;
  SwitchPlanState(this.selectedIndex);
  @override
  List<Object?> get props => [selectedIndex];
}
