import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/theme/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/regex_manager.dart';
import '../../../../core/widgets/custom_loading_button.dart';
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
  const _AuthPageBody({super.key});

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
          // style: TextStyle(
          //   fontSize: 20.sp,
          //   fontWeight: FontWeight.w500,
          //   fontFamily: context.fontFamily,
          //   color: Colors.white,
          // ),
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
                Image.asset(AppAssets.onBoarding3, width: 50.w, height: 25.h),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      PhoneTextField(
                        hintText: "context.translate!.phone.capitalize()",
                        suffixIcon: const Icon(
                          Icons.phone,
                          color: AppColors.primaryColor,
                        ),
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "context.translate!.thisFieldIsRequired";
                          }
                          if (!RegexManager.isPhoneNumber(text)) {
                            return "context.translate!.pleaseEnterFieldPhoneNumber";
                          }
                          return null;
                        },
                        controller: null,
                        // controller:
                        //     "context.getCubit<LoginCubit>().phoneController",
                      ),
                      SizedBox(height: 2.5.h),
                      PasswordTextField(
                        hintText: "context.translate!.passwordTextField",
                        // controller:
                        //     "context.getCubit<LoginCubit>().passwordController",
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "context.translate!.thisFieldIsRequired";
                          }
                          return null;
                        },
                      )
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
                      "context.translate!.forgetPassword",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.sp,
                        // fontFamily: context.fontFamily,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  child: SizedBox(
                    child: CustomLoadingButton(
                      title: "context.translate!.loginButton",
                      onPressed: () async {
                        // await context.getCubit<LoginCubit>().login();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "context.translate!.donTHaveAccount",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 17.sp,
                        // fontFamily: context.fontFamily,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        // context.goToReplace(Routes.register);
                      },
                      child: Text(
                        "context.translate!.registerNewUser",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 17.sp,
                          // fontFamily: context.fontFamily,
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
