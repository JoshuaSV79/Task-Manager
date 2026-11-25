import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_tareas_local/data/app_database.dart';
import 'package:gestor_tareas_local/main.dart';
import 'package:drift/native.dart';

void main() {
  late AppDatabase database;

  Future<void> limpiarPrueba(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 2));
  }

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  testWidgets('La pantalla inicial se muestra sin errores', (tester) async {
    await tester.pumpWidget(GestorTareasApp(database: database));
    await tester.pump();

    expect(find.text('Gestor de tareas'), findsOneWidget);
    expect(find.text('Agregar tarea'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    await limpiarPrueba(tester);
  });

  testWidgets('No permite registrar un título vacío', (tester) async {
    await tester.pumpWidget(GestorTareasApp(database: database));
    await tester.tap(find.text('Agregar tarea'));
    await tester.pump();

    expect(find.text('Escribe un título para la tarea.'), findsOneWidget);
    expect(await database.select(database.tareas).get(), isEmpty);
    await limpiarPrueba(tester);
  });

  testWidgets('Guarda una tarea en SQLite y permite cambiar su estado', (
    tester,
  ) async {
    await tester.pumpWidget(GestorTareasApp(database: database));
    await tester.enterText(find.byType(TextField), 'Estudiar Flutter');
    await tester.tap(find.text('Agregar tarea'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    var registros = await database.select(database.tareas).get();
    expect(registros, hasLength(1));
    expect(registros.single.titulo, 'Estudiar Flutter');
    expect(find.text('Estudiar Flutter'), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    registros = await database.select(database.tareas).get();
    expect(registros.single.completada, isTrue);
    await limpiarPrueba(tester);
  });

  testWidgets('Edita una tarea sin disponer el controller antes del cierre', (
    tester,
  ) async {
    await tester.pumpWidget(GestorTareasApp(database: database));
    await tester.enterText(find.byType(TextField), 'Tarea original');
    await tester.tap(find.text('Agregar tarea'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Editar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Tarea editada');
    await tester.tap(find.text('Guardar'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final registros = await database.select(database.tareas).get();
    expect(registros.single.titulo, 'Tarea editada');
    await limpiarPrueba(tester);
  });
}
