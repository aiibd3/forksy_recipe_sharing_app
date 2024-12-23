part of 'layout_cubit.dart';

@immutable
sealed class LayoutState {}

final class LayoutInitial extends LayoutState {}

final class LayoutLoading extends LayoutState {}

final class LayoutLoadedSuccess extends LayoutState {}

final class LayoutLoadedFailure extends LayoutState {
  final String error;

  LayoutLoadedFailure(this.error);
}

// ? =>

class ChangeTabState extends LayoutState {}


// ? => profile
class ChangeProfileState extends LayoutState {}






//
// abstract class CategoryState {}
//
// class CategoryInitial extends CategoryState {}
//
// class CategoryLoading extends CategoryState {}
//
// class CategoryError extends CategoryState {
//   final String message;
//
//   CategoryError(this.message);
// }
//
// class CategoryLoaded extends CategoryState {
//   final List<CategoryEntity> categories;
//   final int activeIndex;
//
//   CategoryLoaded(this.categories, {this.activeIndex = 0});
//
//   CategoryLoaded copyWith({List<CategoryEntity>? categories, int? activeIndex}) {
//     return CategoryLoaded(
//       categories ?? this.categories,
//       activeIndex: activeIndex ?? this.activeIndex,
//     );
//   }
// }
