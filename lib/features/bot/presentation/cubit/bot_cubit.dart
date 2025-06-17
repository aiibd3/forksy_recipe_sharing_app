import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:flutter_chat_types/flutter_chat_types.dart" as types;
import 'package:google_generative_ai/google_generative_ai.dart';

part 'bot_state.dart';

class BotCubit extends Cubit<BotState> {
  BotCubit() : super(BotInitial());

  final player = AudioPlayer();
  final botUser = const types.User(
    id: 'bot',
    firstName: 'Flora Bot',
    // imageUrl: 'https://avatars.githubusercontent.com/u/10099900?v=4',
  );
  final user = const types.User(
    id: 'user',
    firstName: 'User',
    // imageUrl: 'https://avatars.githubusercontent.com/u/10099900?v=4',
  );

  bool isPlaying = false;
  static List<types.TextMessage> messages = [];

  void load() async {
    await Future.wait([
      player.setSourceAsset("audio/Flora Bot.wav"),
      Future.delayed(const Duration(seconds: 1))
    ]);

    if (messages.isEmpty) player.play(AssetSource("audio/Flora Bot.wav"));

    isPlaying = true;

    emit(BotLoadedSuccess());
  }

  Future<void> sendMessage(String message) async {
    messages.add(
      types.TextMessage(
        author: user,
        id: '${DateTime.now().millisecondsSinceEpoch}',
        text: message,
      ),
    );
    emit(BotLoading());

    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: "AIzaSyCa4KIqdrbpw0tLMeIJLFsEc3m6Etp4LEM",
    );
    String prompt = "";
    if (messages.length == 1) {
      log("first message");
      prompt =
          "Hi gemini i want to check this message { $message }\n and act like your name is flora bot and your model is train to answer question about plants only and please use chat history i provide you";
    } else {
      prompt =
          "check this message { $message }\n and answer if question about plants only and please use chat history i provide you";
    }

    var chat = model.startChat(
      history: messages.map((e) => Content.text(e.text)).toList(),
    );

    final response = await chat.sendMessage(Content.text(prompt));

    log(response.text ?? "");

    messages.add(
      types.TextMessage(
        author: botUser,
        id: '${DateTime.now().millisecondsSinceEpoch}',
        text: response.text ?? "",
      ),
    );

    emit(BotLoadedSuccess());
  }

  @override
  Future<void> close() {
    player.dispose();
    return super.close();
  }
}
