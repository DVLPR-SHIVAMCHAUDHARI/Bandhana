import 'package:MilanMandap/features/Subscription/bloc/subscription_event.dart';
import 'package:MilanMandap/features/Subscription/bloc/subscription_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  int selectedPlan = 0;
  SubscriptionBloc() : super(InitialState()) {
    on<SwitchPlanEvent>(switchPlan);
  }

  switchPlan(SwitchPlanEvent event, Emitter emit) {
    selectedPlan = event.selectedIndex;
    emit(SwitchPlanState(selectedPlan));
  }
}

var plans = {
  "Monthly":
      "Get personalized daily style or ritual suggestions, Access up to 30 exclusive looks/practices per month, Limited wardrobe planner (1 session/week) ,1 device login, Cancel anytime",

  "Yearly":
      "Unlimited access to your personalized wardrobe or practice calendar, 90+ color palette shades or rituals unlocked, AI-powered seasonal updates & planner, Makeup / hair / ritual tips monthly, 3 device logins, Priority chat with Banadhana Experts, One-time gift surprise 🎁",
};
