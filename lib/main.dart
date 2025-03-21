import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/core/services/notification_service.dart';
import 'package:task_manager_app/core/utils/theme.dart';
import 'package:task_manager_app/data/repositories/task_repository.dart';
import 'package:task_manager_app/presentation/providers/theme_provider.dart';

import 'presentation/providers/task_provider.dart';
import 'presentation/screens/home_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => TaskProvider(TaskRepository())..loadTasks(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Task Manager',
          localizationsDelegates: [
            FlutterI18nDelegate(
              translationLoader: FileTranslationLoader(
                basePath: "assets/translations",
                forcedLocale: const Locale("en"),
              ),
            ),
          ],
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          home: const HomeScreen(),
        );
      },
    );
  }
}
