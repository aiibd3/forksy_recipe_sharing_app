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

abstract class CategoryState {
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryEntity> categories;
  final int activeIndex;

  CategoryLoaded(this.categories, {this.activeIndex = 0});

  @override
  List<Object> get props => [categories, activeIndex];
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);

  @override
  List<Object> get props => [message];
}
