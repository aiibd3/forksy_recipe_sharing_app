import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

import 'core/cubit/app_bloc_observer.dart';
import 'core/services/fcm.dart';
import 'core/services/hive_storage.dart';
import 'features/auth/data/repos/auth_repo.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/posts/data/repos/post_repo.dart';
import 'features/posts/presentation/cubit/post_cubit.dart';
import 'features/profile/data/repos/profile_repo.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';
import 'features/search/data/repos/search_repo.dart';
import 'features/search/presentation/cubit/search_cubit.dart';
import 'features/storage/data/repos/firebase_storage_repo.dart';
import 'firebase_options.dart';
import 'forksy_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();

  await EasyLocalization.ensureInitialized();

  await Fcm.fcmInit();

  try {
    await HiveStorage.init();
  } catch (e) {
    debugPrint("Error initializing Hive: $e");
  }

  Bloc.observer = AppBlocObserver();

  final authRepo = FirebaseAuthRepo();
  final profileRepo = FirebaseProfileRepo();
  final storageRepo = FirebaseStorageRepo();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthCubit(authRepo: authRepo)..checkUserIsLogged(),
        ),
        BlocProvider(
          create: (_) => ProfileCubit(
            profileRepo: profileRepo,
            storageRepo: storageRepo,
          ),
        ),
        BlocProvider(
          create: (_) => PostCubit(
            postRepo: FirebasePostRepo(),
            storageRepo: FirebaseStorageRepo(),
          ),
        ),
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(
            searchRepo: FirebaseSearchRepo(),
          ),
        ),
        // Provide SearchCubit
      ],
      child: EasyLocalization(
          supportedLocales: [
            Locale('ar'),
            Locale('en'),
          ],
          path: 'assets/translations',
          fallbackLocale: Locale('ar'),
          saveLocale: true,
          startLocale: Locale('ar'),
          child: const ForksyApp()),
    ),
  );
}
