import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/onboarding_repo.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc()
    : super(
        OnboardingInitial(
          currentIndex: 0,
          currentPage: OnboardingRepo.pages[0],
        ),
      ) {
    on<NextPageEvent>(_onNextPage);
    on<SkipEvent>(_onSkip);
  }

  void _onNextPage(NextPageEvent event, Emitter<OnboardingState> emit) {
    final nextIndex = state.currentIndex + 1;
    if (nextIndex < OnboardingRepo.pages.length) {
      emit(
        OnboardingPageChanged(
          currentIndex: nextIndex,
          currentPage: OnboardingRepo.pages[nextIndex],
        ),
      );
    }
  }

  void _onSkip(SkipEvent event, Emitter<OnboardingState> emit) {
    emit(
      OnboardingPageChanged(
        currentIndex: OnboardingRepo.pages.length - 1,
        currentPage: OnboardingRepo.pages.last,
      ),
    );
  }
}
