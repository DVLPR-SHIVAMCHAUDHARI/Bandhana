import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/const/numberextension.dart';
import 'package:MilanMandap/features/Home/widgets/profile_card.dart';
import 'package:MilanMandap/features/master_apis/bloc/master_bloc.dart';
import 'package:MilanMandap/features/master_apis/bloc/master_event.dart';
import 'package:MilanMandap/features/master_apis/bloc/master_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:MilanMandap/core/const/app_colors.dart';
import 'package:MilanMandap/core/const/typography.dart';
import 'package:go_router/go_router.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<dynamic> favorites = [];

  @override
  void initState() {
    super.initState();
    context.read<MasterBloc>().add(GetFavoriteListEvent());
  }

  void _removeFavorite(String userId) {
    setState(() {
      favorites.removeWhere((user) => user.userId.toString() == userId);
      context.read<MasterBloc>().add(GetFavoriteListEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Favorites",
          style: TextStyle(color: Colors.white, fontFamily: Typo.bold),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: BlocConsumer<MasterBloc, MasterState>(
        listener: (context, state) {
          if (state is FetchFavoritesLoadedState) {
            setState(() {
              favorites = List.from(state.list);
            });
          }
        },
        builder: (context, state) {
          if (state is FetchFavoritesLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (favorites.isEmpty) {
            return const Center(child: Text("No favorites added yet."));
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<MasterBloc>().add(GetFavoriteListEvent());
            },
            child: ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final user = favorites[index];

                return ProfileCard(
                  viewProfile: () {
                    router.pushNamed(
                      Routes.profileDetail.name,
                      pathParameters: {
                        "mode": ProfileMode.viewOther.name,
                        "id": user.userId.toString(),
                        "match": user.matchPercentage.toString(),
                      },
                    );
                  },
                  onSkip: () {},
                  isFavorite: user.isFavorite,
                  id: user.userId.toString(),
                  image: user.profileUrl1,
                  age: user.age?.toString() ?? "-",
                  district: user.district ?? "-",
                  match: "${user.matchPercentage ?? 0}",
                  name: user.fullname ?? "Unknown",
                  profession: user.profession ?? "-",
                  hobbies: user.hobbies?.map((e) => e.hobbyName).toList(),
                  onFavoriteToggle: () {
                    _removeFavorite(user.userId.toString());

                    context.read<MasterBloc>().add(
                      ToggleFavoriteEvent(
                        userId: user.userId.toString(),
                        add: false,
                      ),
                    );
                  },
                ).margin(
                  EdgeInsets.only(
                    bottom: index == favorites.length - 1 ? 50.h : 20.h,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
