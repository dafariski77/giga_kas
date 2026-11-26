import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'app.dart';
import 'core/database/app_database.dart';
import 'core/providers/core_providers.dart';
import 'core/services/onnx_ai_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDb = AppDatabase();
  await OnnxAiService().tryInitialize();

  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(appDb),
      ],
      child: const GigaKasApp(),
    ),
  );
}
