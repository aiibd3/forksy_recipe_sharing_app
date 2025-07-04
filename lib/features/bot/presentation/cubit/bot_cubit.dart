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
    firstName: 'BiteCraft Bot',
  );
  final user = const types.User(
    id: 'user',
    firstName: 'User',
  );

  bool isPlaying = false;
  static List<types.TextMessage> messages = [];

  void load() async {
    await Future.wait([
      player.setSourceAsset("audio/BiteCraft.wav"),
      Future.delayed(const Duration(seconds: 1))
    ]);

    if (messages.isEmpty) player.play(AssetSource("audio/BiteCraft.wav"));

    isPlaying = true;

    emit(BotLoadedSuccess());
  }

  bool isArabic(String input) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(input);
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

    final bool isAr = isArabic(message);

    String prompt;
    if (isAr) {
      prompt = '''
مرحبًا Gemini، أنت بوت مساعد للطبخ اسمه "Forksy Bot".
ترد فقط على الأسئلة المتعلقة بالأكل والوصفات والمكونات ونصائح الطهي.

حلل هذه الرسالة: "$message"

ورد على الشكل التالي **باللغة العربية فقط**:

العنوان: [اسم الوصفة أو الموضوع]

المكونات:
- [مكون 1]
- [مكون 2]

الخطوات:
1. [خطوة 1]
2. [خطوة 2]

السعرات الحرارية: [عدد السعرات]

لو كانت الرسالة غير متعلقة بالأكل، قل:
"أنا مساعد طبخ ولا يمكنني الرد إلا على الأسئلة المتعلقة بالوصفات أو الطعام فقط."
''';
    } else {
      prompt = '''
Hi Gemini, you are a cooking assistant bot called "Forksy Bot".
You ONLY respond to questions about food, recipes, ingredients, or cooking tips.

Analyze this message: "$message"

Respond in this format in English only:

Title: [Recipe Name or Answer Title]

Ingredients: 
- [Ingredient 1]
- [Ingredient 2]

Steps:
1. [Step 1]
2. [Step 2]

Calories: [Number of calories]

If the message is NOT related to food or cooking, respond with:
"I'm a cooking assistant and I can only help with recipes or food-related questions."
''';
    }

    var chat = model.startChat(
      history: messages.map((e) => Content.text(e.text)).toList(),
    );

    final response = await chat.sendMessage(Content.text(prompt));

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
