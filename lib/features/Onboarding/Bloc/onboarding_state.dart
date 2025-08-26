import 'package:equatable/equatable.dart';
import '../model/onboarding_model.dart';

abstract class OnboardingState extends Equatable {
  final int currentIndex;
  final OnboardingModel currentPage;

  const OnboardingState({
    required this.currentIndex,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [currentIndex, currentPage];
}

// Initial State
class OnboardingInitial extends OnboardingState {
  const OnboardingInitial({
    required super.currentIndex,
    required super.currentPage,
  });
}

// Changed State
class OnboardingPageChanged extends OnboardingState {
  const OnboardingPageChanged({
    required super.currentIndex,
    required super.currentPage,
  });
}
