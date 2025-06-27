import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/features/profile/presentation/widgets/user_tile.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../posts/presentation/widgets/post_tile.dart';
import '../cubit/search_cubit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  late final SearchCubit searchCubit;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    searchCubit = context.read<SearchCubit>();
    _tabController = TabController(length: 2, vsync: this);
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = searchController.text;
    if (_tabController.index == 0) {
      searchCubit.searchUsers(query);
    } else {
      searchCubit.searchPosts(query);
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: TextField(
          style: const TextStyle(color: AppColors.blackColor),
          cursorColor: AppColors.primaryColor,
          autofocus: true,
          onChanged: (value) => _onSearchChanged(),
          onSubmitted: (value) => _onSearchChanged(),
          textInputAction: TextInputAction.search,

          controller: searchController,
          decoration: InputDecoration(
            hintText: "search.search".tr(),
            border: InputBorder.none,
          ),
        ),
        bottom: TabBar(
          indicatorColor: AppColors.primaryColor,
          dividerColor: AppColors.secondaryColor,
          labelColor: AppColors.secondaryColor,
          unselectedLabelColor: AppColors.grayColor,
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _tabController,
          tabs: [
            Tab(text: "search.users".tr()),
            Tab(text: "search.posts".tr()),
          ],
          onTap: (index) {
            if (searchController.text.isNotEmpty) {
              _onSearchChanged();
            }
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Users Tab
          BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SearchUsersLoaded) {
                if (state.users.isEmpty) {
                  return Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/emtpy.json',
                        height: 20.h,
                      ),
                      Text("search.noResults".tr()),

                    ],
                  ),);
                }
                return ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    final user = state.users[index];
                    return UserTile(user: user!);
                  },
                );
              } else if (state is SearchError) {
                return Center(child: Text(state.error));
              }
              return Container();
            },
          ),
          // Posts Tab
          BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SearchPostsLoaded) {
                if (state.posts.isEmpty) {
                  //
                  return Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/emtpy.json',
                        height: 20.h,
                      ),
                      Text("search.noResults".tr()),

                    ],
                  ),);
                }
                return ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (context, index) {
                    final post = state.posts[index];
                    return PostTile(post: post!);
                  },
                );
              } else if (state is SearchError) {
                return Center(child: Text(state.error));
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
