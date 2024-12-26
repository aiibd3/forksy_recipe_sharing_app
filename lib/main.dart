import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/cubit/app_bloc_observer.dart';
import 'core/services/fcm.dart';
import 'core/services/hive_storage.dart';
import 'features/auth/data/repos/auth_repo.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'firebase_options.dart';
import 'forksy_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Fcm.fcmInit();

  try {
    await HiveStorage.init();
  } catch (e) {
    debugPrint("Error initializing Hive: $e");
  }

  Bloc.observer = AppBlocObserver();

  final authRepo = FirebaseAuthRepo();






  runApp(
    BlocProvider(
      create: (_) => AuthCubit(authRepo: authRepo)..checkUserIsLogged(),
      child: const ForksyApp(),
    ),
  );
}
