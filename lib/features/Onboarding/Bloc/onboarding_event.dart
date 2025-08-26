import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class NextPageEvent extends OnboardingEvent {
  const NextPageEvent();
}

class SkipEvent extends OnboardingEvent {
  const SkipEvent();
}
