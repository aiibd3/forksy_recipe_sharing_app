import 'dart:developer';
import 'dart:io';

String basePath = Directory.current.path;

String appColorsContent = '''
static const Color primaryColor = Color(0xFF0A0E21);
''';

String appAssetsContent = '''
static const String logo = "assets/images/logo.png";
''';

String themeContent = '''
  ThemeData lightTheme = ThemeData();

  ThemeData darkTheme = ThemeData();
''';

String apiConstantsContent = '''
static const String baseUrl = "https://api.example.com";   
''';

String endpointsContent = '''
static const String login = "login";   
''';

String appRouterContent = '''
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const Scaffold());
      default:
        return MaterialPageRoute(builder: (_) => const Scaffold());
    }
  }
''';

String apiResultsContent = '''
sealed class ApiResult<T, E extends Exception> {
  const ApiResult();
}

class SuccessRequest<T, E extends Exception> extends ApiResult<T, E> {
  final T data;

  const SuccessRequest({required this.data});
}

class FailedRequest<T, E extends Exception> extends ApiResult<T, E> {
  final E exception;

  const FailedRequest({required this.exception});
}

''';

String routeNameContent = '''
  static const String login = '/login';
  static const String splash = '/';
  static const String layout = '/layout';
''';

String contextExtensionContent = '''
import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  // theme
  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  // routes
  void goBack() => Navigator.of(this).pop();

  void goToNamed(String route, {Object? arguments}) =>
      Navigator.of(this).pushNamed(
        route,
        arguments: arguments,
      );

  void goBackUntil(String untilRoute) => Navigator.of(this).popUntil(
        (route) => route.settings.name == untilRoute,
      );

  void goBackUntilAndPush(
    String pushRoute,
    String untilRoute, {
    Object? arguments,
  }) =>
      Navigator.of(this).pushNamedAndRemoveUntil(
        pushRoute,
        (route) => route.settings.name == untilRoute,
        arguments: arguments,
      );

  void removeAllAndPush(
    String pushRoute, {
    Object? arguments,
  }) =>
      Navigator.of(this).pushNamedAndRemoveUntil(
        pushRoute,
        (route) => false,
        arguments: arguments,
      );
}
''';

String diClassContent = '''
import 'di.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
''';

String blocObserverContent = '''
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log('onCreate -- \${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('onChange -- \${bloc.runtimeType}, \$change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('onError -- \${bloc.runtimeType}, \$error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    log('onClose -- \${bloc.runtimeType}');
  }
}
''';

Map<String, List<String>> folderStructure = {
  'lib': [
    'core',
    'features',
  ],
  'assets': [
    'images',
    'fonts',
    'icons',
    "translations",
  ],
  'lib/core': [
    "models",
    "services",
    "utils",
    "extensions",
    "errors",
    "cubit",
    "widgets",
    "theme",
    "constants",
    "routing",
    "di",
    "api",
  ],
};

Map<String, Map<String, String>> files = {
  "lib/core/theme": {
    "app_colors.dart": createClassStaticWithNoConstructor(
      'AppColors',
      content: appColorsContent,
    ),
    "app_assets.dart": createClassStaticWithNoConstructor(
      'AppAssets',
      content: appAssetsContent,
      addMaterialImport: false,
    ),
    "app_theme.dart": createClassStaticWithNoConstructor(
      'AppTheme',
      content: themeContent,
    ),
    "app_font_styles.dart": createClassStaticWithNoConstructor(
      'AppFontStyles',
    ),
  },
  "lib/core/constants": {
    "app_constants.dart": createClassStaticWithNoConstructor(
      'AppConstants',
      addMaterialImport: false,
    ),
    "translation_keys.dart": createClassStaticWithNoConstructor(
      'TranslationKeys',
      addMaterialImport: false,
    ),
  },
  "lib/core/api": {
    "api_constants.dart": createClassStaticWithNoConstructor(
      'ApiConstants',
      content: apiConstantsContent,
      addMaterialImport: false,
    ),
    "endpoints.dart": createClassStaticWithNoConstructor(
      'Endpoints',
      content: endpointsContent,
      addMaterialImport: false,
    ),
    "api_result.dart": apiResultsContent,
  },
  "lib/core/routing": {
    "app_router.dart": createClassStaticWithNoConstructor(
      'AppRouter',
      content: appRouterContent,
    ),
    "routes_name.dart": createClassStaticWithNoConstructor(
      'RoutesName',
      addMaterialImport: false,
      content: routeNameContent,
    ),
  },
  "lib/core/extensions": {
    "context_extension.dart": contextExtensionContent,
  },
  "lib/core/di": {
    "di.dart": diClassContent,
  },
  "assets/translations": {
    "ar.json": "{}",
    "en.json": "{}",
  },
  "lib/core/cubit": {"app_bloc_observer.dart": blocObserverContent},
};

List<String> packages = [
  "flutter_bloc",
  "easy_localization",
  "dio",
  "flutter_svg",
  "fluttertoast",
  "shared_preferences",
  "injectable",
  "get_it",
  "page_transition",
  "animate_do",
  "skeletonizer",
  "cached_network_image",
  "toastification",
];

List<String> devDependencies = [
  'build_runner',
  'injectable_generator',
  'flutter_gen_runner'
];

Future<void> main() async {
  folderStructure.forEach((parent, subfolders) {
    String parentPath = '$basePath/$parent';
    createFolder(parentPath);

    for (String subfolder in subfolders) {
      createFolder('$parentPath/$subfolder');
    }
  });

  files.forEach((parent, files) {
    String parentPath = '$basePath/$parent';
    files.forEach((subfolder, content) {
      String filePath = '$parentPath/$subfolder';
      createFile(filePath, content);
    });
  });

  updatePubspec(basePath, packages, devDependencies);

  await runPubGet();

  await runBuildRunner();
}

void createFolder(String path) {
  final directory = Directory(path);

  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  } else {}
}

void createFile(String path, String content) {
  final file = File(path);

  if (!file.existsSync()) {
    file.writeAsStringSync(content);
    log('Created file: $path');
  } else {
    log('File already exists: $path');
  }
}

String createClassStaticWithNoConstructor(
  String className, {
  String content = '',
  addMaterialImport = true,
}) {
  String import =
      addMaterialImport ? "import 'package:flutter/material.dart';" : '';
  return '''
$import
class $className {
  $className._();

  $content
}
''';
}

void updatePubspec(
  String basePath,
  List<String> dependencies,
  List<String> devDependencies,
) {
  String pubspecPath = '$basePath/pubspec.yaml';
  final pubspecFile = File(pubspecPath);

  if (pubspecFile.existsSync()) {
    String pubspecContent = pubspecFile.readAsStringSync();

    // Check and add dependencies
    if (pubspecContent.contains('dependencies:')) {
      StringBuffer newDependencies = StringBuffer();
      for (String package in dependencies) {
        if (!pubspecContent.contains(package.split(':')[0])) {
          newDependencies.writeln('  $package:');
        }
      }
      pubspecContent = pubspecContent.replaceFirst(
        RegExp(r'dependencies:\n'),
        'dependencies:\n$newDependencies',
      );
    }

    // Check and add dev_dependencies
    if (pubspecContent.contains('dev_dependencies:')) {
      StringBuffer newDevDependencies = StringBuffer();
      for (String package in devDependencies) {
        if (!pubspecContent.contains(package.split(':')[0])) {
          newDevDependencies.writeln('  $package:');
        }
      }
      pubspecContent = pubspecContent.replaceFirst(
        RegExp(r'dev_dependencies:\n'),
        'dev_dependencies:\n$newDevDependencies',
      );
    } else {
      // Add dev_dependencies if not present
      StringBuffer newDevDependencies = StringBuffer();
      for (String package in devDependencies) {
        newDevDependencies.writeln('  $package');
      }
      pubspecContent += '\ndev_dependencies:\n$newDevDependencies';
    }

    // Add the assets to the flutter section
    if (pubspecContent.contains('uses-material-design: true')) {
      StringBuffer newAssets = StringBuffer();
      var assetsSubfolders = folderStructure["assets"];

      for (String subfolder in assetsSubfolders!) {
        newAssets.writeln('    - assets/$subfolder/');
      }

      pubspecContent = pubspecContent.replaceFirst(
        // RegExp(r'uses-material-design: true'),
        "uses-material-design: true",
        'uses-material-design: true\n  assets:\n$newAssets',
      );
    }

    // Write the updated content back to the pubspec.yaml file
    pubspecFile.writeAsStringSync(pubspecContent);
    log('pubspec.yaml updated with new dependencies and dev_dependencies.');
  } else {
    log('Error: pubspec.yaml not found.');
  }
}

Future<void> runPubGet() async {
  log('Running flutter pub get...');
  final result = await Process.run('flutter', ['pub', 'get']);
  if (result.exitCode == 0) {
    log('flutter pub get completed successfully.');
  } else {
    log('flutter pub get failed with error: ${result.stderr}');
  }
}

Future<void> runBuildRunner() async {
  log('Running dart run build_runner build...');
  final result = await Process.run('dart', ['run', 'build_runner', 'build']);
  if (result.exitCode == 0) {
    log('build_runner build completed successfully.');
  } else {
    log('build_runner build failed with error: ${result.stderr}');
  }
}
