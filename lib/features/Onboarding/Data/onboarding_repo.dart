import 'package:bandhana/core/const/asset_urls.dart';

import '../model/onboarding_model.dart';

class OnboardingRepo {
  static List<OnboardingModel> pages = [
    OnboardingModel(
      imagePath: Urls.igOnboarding1,
      title: "Welcome to Bandhana",
      subtitle:
          "Find your match, start your story – the best matrimony chat app to brighten your day!",
    ),
    OnboardingModel(
      imagePath: Urls.igOnboarding2,
      title: "Meaningful Connections",
      subtitle:
          "Talk, connect & bond with like-minded people. We focus on quality chats, not just swipes.",
    ),
    OnboardingModel(
      imagePath: Urls.igOnboarding3,
      title: "Private, Safe & Secure",
      subtitle:
          "Your privacy matters. We protect your journey with strong privacy and safety measures.",
    ),
  ];
}
