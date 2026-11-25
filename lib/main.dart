import 'package:flutter/material.dart';

import 'data/app_database.dart';
import 'screens/tareas_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GestorTareasApp(database: AppDatabase()));
}

class GestorTareasApp extends StatelessWidget {
  const GestorTareasApp({required this.database, super.key});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de tareas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: TareasPage(database: database),
    );
  }
}
