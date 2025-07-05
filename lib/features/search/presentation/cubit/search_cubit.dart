import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/features/profile/domain/entities/profile_user.dart';
import '../../../posts/domain/entities/post.dart';
import '../../data/repos/search_repo.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final FirebaseSearchRepo searchRepo;

  SearchCubit({required this.searchRepo}) : super(SearchInitial());

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    try {
      emit(SearchLoading());
      final users = await searchRepo.searchUsers(query);
      emit(SearchUsersLoaded(users));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> searchPosts(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    try {
      emit(SearchLoading());
      final posts = await searchRepo.searchPosts(query);
      emit(SearchPostsLoaded(posts));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
