import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Tareas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get titulo => text()();
  BoolColumn get completada => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Tareas])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Constructor para pruebas: permite usar SQLite en memoria.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  Stream<List<Tarea>> watchTareas() {
    return (select(tareas)..orderBy([(t) => OrderingTerm.desc(t.id)])).watch();
  }

  Future<int> agregarTarea(String titulo) {
    return into(tareas).insert(TareasCompanion.insert(titulo: titulo.trim()));
  }

  Future<bool> actualizarTitulo(int id, String titulo) {
    return (update(tareas)..where((t) => t.id.equals(id)))
        .write(TareasCompanion(titulo: Value(titulo.trim())))
        .then((filas) => filas > 0);
  }

  Future<bool> actualizarEstado(int id, bool completada) {
    return (update(tareas)..where((t) => t.id.equals(id)))
        .write(TareasCompanion(completada: Value(completada)))
        .then((filas) => filas > 0);
  }

  Future<int> eliminarTarea(int id) {
    return (delete(tareas)..where((t) => t.id.equals(id))).go();
  }
}

_openConnection() {
  return driftDatabase(
    name: 'gestor_tareas',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}
