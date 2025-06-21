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
    firstName: 'Froksy Bot',
  );
  final user = const types.User(
    id: 'user',
    firstName: 'User',
  );

  bool isPlaying = false;
  static List<types.TextMessage> messages = [];

  void load() async {
    await Future.wait([
      player.setSourceAsset("audio/froksy Bot.wav"),
      Future.delayed(const Duration(seconds: 1))
    ]);

    if (messages.isEmpty) player.play(AssetSource("audio/froksy Bot.wav"));

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
      apiKey: "AIzaSyCwBFnrRnBhpw--wz1hYv7zhkP-bpWfTaE",
    );

    String prompt = "";
    if (messages.length == 1) {
      prompt =
          '''Hi Gemini, you are a cooking assistant bot called "Forksy Bot".
      You ONLY respond to questions about food, recipes, ingredients, or cooking tips.
      Please analyze the following user message: "$message"And respond in the following structured format in English only:
      Title: [Recipe Name or Answer Title]
      Ingredients: 
      - [Ingredient 1] 
      - [Ingredient 2]
      Steps:
      1. [Step 1]
      2. [Step 2]
      
      If the message is NOT related to food or cooking, respond with:
      "I'm a cooking assistant and I can only help with recipes or food-related questions."
      ''';
    } else {
      prompt = '''
      A new cooking-related question was asked: "$message"
      Use the chat history provided to make your answer smarter.
      
      Respond only if it's food-related, and use this format:
      
      Title: [Recipe Name or Answer Title]
      
      Ingredients: 
      - [Ingredient 1]
      - [Ingredient 2]
      
      Steps:
      1. [Step 1]
      2. [Step 2]
      
      If the question is not about cooking or food, say:
      "I'm a cooking assistant and I can only help with recipes or food-related questions."
      ''';
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
