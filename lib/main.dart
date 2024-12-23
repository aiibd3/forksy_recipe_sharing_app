import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/cubit/app_bloc_observer.dart';
import 'core/services/hive_storage.dart';
import 'firebase_options.dart';
import 'forksy_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    await HiveStorage.init();
  } catch (e) {
    debugPrint("Error initializing Hive: $e");
  }
  Bloc.observer = AppBlocObserver();

  runApp(const ForksyApp());
}
