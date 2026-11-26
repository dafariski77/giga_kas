import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:giga_kas/core/database/app_database.dart';
import 'package:giga_kas/core/services/onnx_ai_service.dart';
import 'package:material_ui/material_ui.dart';

import 'app.dart';

late final AppDatabase appDb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  appDb = AppDatabase();
  await OnnxAiService().initialize();

  runApp(const ProviderScope(child: GigaKasApp()));
}
