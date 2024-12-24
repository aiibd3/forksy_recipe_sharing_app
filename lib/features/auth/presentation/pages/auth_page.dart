import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/utils/logs_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/theme/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/regex_manager.dart';
import '../../../../core/widgets/custom_loading_button.dart';
import '../../../../core/widgets/email_text_field.dart';
import '../../../../core/widgets/phone_text_field.dart';
import '../../data/repos/auth_repo.dart';
import '../cubit/auth_cubit.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(authRepo: FirebaseAuthRepo()),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return const _AuthPageBody();
        },
      ),
    );
  }
}

class _AuthPageBody extends StatelessWidget {
  const _AuthPageBody();

  @override
  Widget build(BuildContext context) {
    var cubit = AuthCubit.get(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text(
          "Login".toUpperCase(),
          style: GoogleFonts.aBeeZee().copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: cubit.formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset(AppAssets.logoForksy, width: 50.w, height: 25.h),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      EmailTextField(
                        hintText: "Enter your email",
                        controller: cubit.emailController,
                        validator: (text) {
                          LogsManager.info("Validator called value: $text");
                          if (text!.isEmpty) {
                            return "this field is required";
                          }
                          if (!RegexManager.isEmail(text)) {
                            return "please Enter Field Correctly";
                          }
                          return null;
                        },
                        suffixIcon: const Icon(
                          Icons.email,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(height: 2.5.h),
                      PasswordTextField(
                        hintText: "Enter your password",
                        controller: cubit.passwordController,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "this field is required";
                          }
                          if (text.length < 6) {
                            return "password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      // context.goTo(Routes.forgotPassword);
                    },
                    child: Text(
                      "forget password?",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  child: SizedBox(
                    child: CustomLoadingButton(
                      title: "login",
                      onPressed: () async {
                        if (cubit.formKey.currentState!.validate()) {
                          // ?? Proceed with login logic
                          await cubit.login(
                            cubit.emailController.text,
                            cubit.passwordController.text,
                          );
                        } else {
                          // ??
                          // Validation failed, do nothing
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "don't have an account?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 17.sp,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        // context.goToReplace(Routes.register);
                      },
                      child: Text(
                        "register",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 17.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
