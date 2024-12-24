import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';
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
import '../../data/repos/auth_repo.dart';
import '../cubit/auth_cubit.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(authRepo: FirebaseAuthRepo()),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return const _RegisterPageBody();
        },
      ),
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
          "Register",
          style: GoogleFonts.aBeeZee().copyWith(
            color: Colors.white,
            fontSize: 20.sp,
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
          child: Column(
            children: [
              Image.asset(AppAssets.logoForksy, width: 50.w, height: 25.h),
              Container(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      MyCustomTextField(
                        suffixIcon: const Icon(
                          Icons.person,
                          color: AppColors.primaryColor,
                        ),
                        hintText: "Enter your name",
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "pleaseEnterName";
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
                        hintText: "Enter You Password",
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "this Field Is Required";
                          }
                          return null;
                        },
                        controller: cubit.passwordController,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                child: CustomLoadingButton(
                  title: "Register Now",
                  onPressed: () async {
                    // await context.getCubit<RegisterCubit>().register();
                    // await Future.delayed(const Duration(seconds: 1));
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "already Have Account !",
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
                      "login",
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
    );
  }
}
