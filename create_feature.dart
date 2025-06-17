import 'dart:developer';
import 'dart:io';

String basePath = Directory.current.path;

void main() {
  var featureName = 'bot';
  var featurePath = '$basePath/lib/features/$featureName';

  createFolder(featurePath);
  createFolder("$featurePath/data");
  createFolder("$featurePath/domain");
  createFolder("$featurePath/presentation");

  createFolder("$featurePath/data/data_sources");
  createFolder("$featurePath/data/repos");
  createFolder("$featurePath/data/models");

  createFolder("$featurePath/domain/use_cases");
  createFolder("$featurePath/domain/repos");
  createFolder("$featurePath/domain/entities");

  createFolder("$featurePath/presentation/cubit");
  createFolder("$featurePath/presentation/pages");
  createFolder("$featurePath/presentation/widgets");

  createFile("$featurePath/presentation/cubit/${featureName}_cubit.dart",
      createCubit(featureName));
  createFile("$featurePath/presentation/cubit/${featureName}_state.dart",
      createCubitState(featureName));
  createFile("$featurePath/presentation/pages/${featureName}_page.dart",
      createPage(featureName));
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

String createPage(String featureName) {
  var featureNameAfterCapitalize =
      featureName.capitalizeAfetSplitWithDashAndRemoveDash();
  return '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/${featureName}_cubit.dart';
class ${featureNameAfterCapitalize}Page extends StatelessWidget {
  const ${featureNameAfterCapitalize}Page({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ${featureNameAfterCapitalize}Cubit(),
      child: BlocBuilder<${featureNameAfterCapitalize}Cubit,
          ${featureNameAfterCapitalize}State>(
        builder: (context, state) {
          return const _${featureNameAfterCapitalize}PageBody();
        },
      ),
    );
  }
}
class _${featureNameAfterCapitalize}PageBody extends StatelessWidget {
  const _${featureNameAfterCapitalize}PageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

''';
}

String createCubit(String featureName) {
  var featureNameAfterCapitalize =
      featureName.capitalizeAfetSplitWithDashAndRemoveDash();
  return '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part '${featureName}_state.dart';


class ${featureNameAfterCapitalize}Cubit extends Cubit<${featureNameAfterCapitalize}State> {
  ${featureNameAfterCapitalize}Cubit() : super(${featureNameAfterCapitalize}Initial());
}
''';
}

String createCubitState(String featureName) {
  var featureNameAfterCapitalize =
      featureName.capitalizeAfetSplitWithDashAndRemoveDash();
  return '''
part of '${featureName}_cubit.dart';

@immutable
sealed class ${featureNameAfterCapitalize}State {}

final class ${featureNameAfterCapitalize}Initial extends ${featureNameAfterCapitalize}State {}

final class ${featureNameAfterCapitalize}Loading extends ${featureNameAfterCapitalize}State {}

final class ${featureNameAfterCapitalize}LoadedSuccess extends ${featureNameAfterCapitalize}State {}

final class ${featureNameAfterCapitalize}LoadedFailure extends ${featureNameAfterCapitalize}State {
  final String error;

  ${featureNameAfterCapitalize}LoadedFailure(this.error);
}
''';
}

extension StringExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }

  String capitalizeAfetSplitWithDashAndRemoveDash() {
    var splits = split('_');
    return splits.map((e) => e.capitalize()).join();
  }
}
