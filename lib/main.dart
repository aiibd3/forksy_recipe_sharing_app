import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

import 'core/cubit/app_bloc_observer.dart';
import 'core/services/fcm.dart';
import 'core/services/hive_storage.dart';
import 'core/utils/logs_manager.dart';
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

  Future<void> initializeCategories() async {
    try {
      final categoriesCollection =
          FirebaseFirestore.instance.collection('categories');
      const categories = [
        {
          'id': 'eastern',
          'title': 'eastern',
          'imageUrl': 'https://via.placeholder.com/100?text=Eastern'
        },
        {
          'id': 'western',
          'title': 'western',
          'imageUrl': 'https://via.placeholder.com/100?text=Western'
        },
        {
          'id': 'italian',
          'title': 'italian',
          'imageUrl': 'https://via.placeholder.com/100?text=Italian'
        },
        {
          'id': 'desserts',
          'title': 'desserts',
          'imageUrl': 'https://via.placeholder.com/100?text=Desserts'
        },
        {
          'id': 'asian',
          'title': 'asian',
          'imageUrl': 'https://via.placeholder.com/100?text=Asian'
        },
      ];
      for (var category in categories) {
        await categoriesCollection.doc(category['id']).set(category);
      }
      LogsManager.info('Categories initialized successfully');
    } catch (e) {
      LogsManager.error('Error initializing categories: $e');
      rethrow;
    }
  }

  if (kDebugMode) {
    await initializeCategories();
  }

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
