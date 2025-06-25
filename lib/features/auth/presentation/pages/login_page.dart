import 'package:easy_localization/easy_localization.dart';
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

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.goToReplace(RoutesName.layout);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("auth.loginSuccess".tr())),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return _LoginPageBody(state: state);
      },
    );
  }
}

class _LoginPageBody extends StatelessWidget {
  final AuthState state;
  final formKey = GlobalKey<FormState>();

  _LoginPageBody({required this.state});

  @override
  Widget build(BuildContext context) {
    var cubit = AuthCubit.get(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text(
          "auth.login".tr().toUpperCase(),
          style: GoogleFonts.aBeeZee().copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset(AppAssets.logoForksy, width: 50.w, height: 25.h),
                SizedBox(height: 2.h),
                EmailTextField(
                  hintText: "auth.enterEmail".tr(),
                  controller: cubit.emailController,
                  validator: (text) {
                    LogsManager.info("Validator called value: $text");
                    if (text!.isEmpty) {
                      return "auth.requiredField".tr();
                    }
                    if (!RegexManager.isEmail(text)) {
                      return "auth.invalidEmail".tr();
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
                  hintText: "auth.enterPassword".tr(),
                  controller: cubit.passwordController,
                  validator: (text) {
                    if (text!.isEmpty) {
                      return "auth.requiredField".tr();
                    }
                    if (text.length < 6) {
                      return "auth.shortPassword".tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomLoadingButton(
                  title: "auth.login".tr(),
                  isLoading: state is AuthLoading,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await cubit.login(
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
                      "auth.dontHaveAccount".tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 17.sp,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => context.goToReplace(RoutesName.register),
                      child: Text(
                        "auth.registerNow".tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 17.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}