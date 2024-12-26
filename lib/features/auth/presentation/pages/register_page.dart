import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/extensions/context_extension.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/routing/routes_name.dart';
import '../../../../core/theme/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/logs_manager.dart';
import '../../../../core/utils/regex_manager.dart';
import '../../../../core/widgets/custom_loading_button.dart';
import '../../../../core/widgets/email_text_field.dart';
import '../../../../core/widgets/phone_text_field.dart';
import '../cubit/auth_cubit.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          // Navigate to home screen on successful registration
          LogsManager.info("Registration successful!");
          context.goToReplace(RoutesName.auth);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration successful!")),
          );
        } else if (state is AuthError) {
          // Show error message using SnackBar
          LogsManager.error(state.error);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return const _RegisterPageBody();
      },
    );
  }
}

class _RegisterPageBody extends StatelessWidget {
  const _RegisterPageBody();

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
            color: Colors.white,
            fontSize: 20.sp,
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
                SizedBox(height: 2.h),
                MyCustomTextField(
                  suffixIcon: const Icon(
                    Icons.person,
                    color: AppColors.primaryColor,
                  ),
                  hintText: "Enter your name",
                  validator: (text) {
                    if (text!.isEmpty) {
                      return "This field is required";
                    }
                    return null;
                  },
                  controller: cubit.nameController,
                ),
                SizedBox(height: 2.5.h),
                EmailTextField(
                  hintText: "Enter your email",
                  controller: cubit.emailController,
                  validator: (text) {
                    LogsManager.info("Validator called value: $text");
                    if (text!.isEmpty) {
                      return "This field is required";
                    }
                    if (!RegexManager.isEmail(text)) {
                      return "Please enter a valid email address";
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
                  validator: (text) {
                    if (text!.isEmpty) {
                      return "This field is required";
                    }
                    if (text.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                  controller: cubit.passwordController,
                ),
                const SizedBox(height: 20),
                CustomLoadingButton(
                  title: "Register Now",
                  onPressed: () async {
                    if (cubit.formKey.currentState!.validate()) {
                      await cubit.register(
                        cubit.nameController.text,
                        cubit.emailController.text,
                        cubit.passwordController.text,
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        context.goToReplace(RoutesName.auth);
                      },
                      child: Text(
                        "Login",
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
