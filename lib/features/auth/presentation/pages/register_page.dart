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

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          LogsManager.info("Registration successful!");
          context.goToReplace(RoutesName.layout);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("auth.registerSuccess".tr())),
          );
        } else if (state is AuthEmailAlreadyInUse) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("auth.emailAlreadyInUse".tr())),
          );
        } else if (state is AuthInvalidEmail) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("auth.invalidEmail".tr())),
          );
        } else if (state is AuthWeakPassword) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("auth.weakPassword".tr())),
          );
        } else if (state is AuthNetworkError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("auth.networkError".tr())),
          );
        } else if (state is AuthOperationNotAllowed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("auth.operationNotAllowed".tr())),
          );
        } else if (state is AuthError) {
          LogsManager.error(state.error);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return _RegisterPageBody(state: state);
      },
    );
  }
}

class _RegisterPageBody extends StatelessWidget {
  final AuthState state;
  final formKey = GlobalKey<FormState>();

  _RegisterPageBody({required this.state});

  @override
  Widget build(BuildContext context) {
    var cubit = AuthCubit.get(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text(
          "auth.register".tr().toUpperCase(),
          style: GoogleFonts.aBeeZee().copyWith(
            color: Colors.white,
            fontSize: 20.sp,
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
                MyCustomTextField(
                  suffixIcon: const Icon(
                    Icons.person,
                    color: AppColors.primaryColor,
                  ),
                  hintText: "auth.enterName".tr(),
                  validator: (text) {
                    if (text!.isEmpty) {
                      return "auth.requiredField".tr();
                    }
                    return null;
                  },
                  controller: cubit.nameController,
                ),
                SizedBox(height: 2.5.h),
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
                  validator: (text) {
                    if (text!.isEmpty) {
                      return "auth.requiredField".tr();
                    }
                    if (text.length < 6) {
                      return "auth.shortPassword".tr();
                    }
                    return null;
                  },
                  controller: cubit.passwordController,
                ),
                const SizedBox(height: 20),
                CustomLoadingButton(
                  title: "auth.register".tr(),
                  isLoading: state is AuthLoading,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await cubit.register(
                        cubit.nameController.text.trim(),
                        cubit.emailController.text.trim(),
                        cubit.passwordController.text.trim(),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "auth.alreadyHaveAccount".tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => context.goToReplace(RoutesName.auth),
                      child: Text(
                        "auth.login".tr(),
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