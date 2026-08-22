import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';
import 'core/config/supabase_bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Supabase remains optional until a local, ignored config file is supplied.
  await SupabaseBootstrap.initialize();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
