part of 'bot_cubit.dart';

@immutable
sealed class BotState {}

final class BotInitial extends BotState {}

final class BotLoading extends BotState {}

final class BotLoadedSuccess extends BotState {}

final class BotLoadedFailure extends BotState {
  final String error;

  BotLoadedFailure(this.error);
}
