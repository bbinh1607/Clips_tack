import 'package:clips_tack/app/app.dart';
import 'package:clips_tack/core/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  final dir = await getApplicationDocumentsDirectory();

  final storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(dir.path), // 👈 FIX
  );

  HydratedBloc.storage = storage;
  runApp(const ClipStackApp());
}
