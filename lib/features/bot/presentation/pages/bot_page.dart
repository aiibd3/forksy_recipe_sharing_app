import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_font_styles.dart';
import '../../../../core/widgets/default_header.dart';
import '../../../../core/widgets/my_scaffold.dart';
import '../cubit/bot_cubit.dart';

class BotPage extends StatelessWidget {
  const BotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BotCubit()..load(),
      child: const _BotPageBody(),
    );
  }
}

class _BotPageBody extends StatelessWidget {
  const _BotPageBody();

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<BotCubit>();
    return BlocBuilder<BotCubit, BotState>(
      builder: (context, state) {
        return MyScaffold(
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                DefaultHeader(title: "bot.title".tr()),
                Expanded(
                  child: Chat(
                    disableImageGallery: false,
                    dateFormat: DateFormat("HH:mm"),
                    scrollPhysics: const BouncingScrollPhysics(),
                    emptyState: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: "bot Froksy",
                          child: Lottie.asset(
                            'assets/lottie/bot2.json',
                            height: 20.h,
                            repeat: !cubit.isPlaying,
                          ),
                        ),
                        Visibility(
                          visible: cubit.isPlaying,
                          child: AnimatedTextKit(
                            repeatForever: false,
                            totalRepeatCount: 1,
                            animatedTexts: [
                              TyperAnimatedText(
                                "bot.welcome".tr(),
                                textStyle: AppFontStyles.poppins800_16,
                                textAlign: TextAlign.center,
                                speed: const Duration(milliseconds: 70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    theme: DefaultChatTheme(
                      backgroundColor: Colors.transparent,
                      inputBackgroundColor: AppColors.secondaryColor,
                      inputTextColor: Colors.white,
                      messageBorderRadius: 25,
                      attachmentButtonIcon: const Icon(
                        Icons.attach_file,
                        color: Colors.white,
                        size: 20,
                      ),
                      inputTextStyle: AppFontStyles.poppins800_16,
                      primaryColor: AppColors.secondaryColor,
                      inputTextCursorColor: AppColors.secondaryColor,
                      highlightMessageColor:
                          AppColors.secondaryColor.withOpacity(0.9),
                    ),
                    messages: BotCubit.messages.reversed.toList(),
                    isAttachmentUploading: true,
                    onSendPressed: (text) {
                      log("text");
                      cubit.sendMessage(text.text);
                    },
                    user: cubit.user,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
