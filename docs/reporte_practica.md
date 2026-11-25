# Práctica: Gestor de tareas con SQLite

**Estudiante:** [Nombre] · **Materia:** Programación de Dispositivos Móviles  
**Repositorio:** [URL de GitHub]

## Implementación

Se desarrolló una aplicación Flutter para administrar tareas sin servidor. La persistencia se implementó con Drift y drift_flutter. La capa `AppDatabase` define la tabla `tareas(id INTEGER PRIMARY KEY AUTOINCREMENT, titulo TEXT NOT NULL, completada INTEGER NOT NULL DEFAULT 0)` y encapsula las operaciones de alta, consulta, edición, cambio de estado y eliminación. La pantalla consume `watchTareas()` como flujo reactivo, por lo que no ejecuta consultas dentro de `build()`. Los títulos vacíos o formados por espacios se rechazan.

Drift se eligió por ofrecer consultas tipadas y reactivas sobre SQLite, con soporte para Android, iOS, Windows, Linux, macOS y Web. En Web requiere el módulo `sqlite3.wasm` y el worker compatible con la versión resuelta en `pubspec.lock`; en nativo `drift_flutter` gestiona la ubicación del archivo local. Los datos web quedan asociados al origen y perfil del navegador.

## Dificultad técnica y verificación

**Completar después de ejecutar:** describe aquí un problema concreto observado (por ejemplo, configuración del worker/WASM o generación de `app_database.g.dart`), qué documentación consultaste, qué cambio realizaste y qué comando/prueba confirmó la corrección. No afirmes un problema que no hayas experimentado.

**Resultados P1–P6:** completar con resultados reales.  
- Plataforma nativa probada: [Android/Windows/Linux/macOS/iOS + dispositivo/versión].  
- Web probada: [navegador y versión].  
- P1 [resultado] · P2 [resultado] · P3 [resultado] · P4 [resultado] · P5 [resultado] · P6 [resultado].  
- Plataformas solo previstas (no ejecutadas): [indicar].

Las pruebas automatizadas incluidas verifican el inicio de la pantalla, el rechazo de un título vacío y la escritura/cambio de estado usando SQLite en memoria. Comandos: `flutter analyze` y `flutter test`. **Anotar aquí sus resultados reales.**

## Fuentes consultadas

- [Drift](https://drift.simonbinder.eu/): definición de tablas, consultas y streams reactivos.
- [Drift Web](https://drift.simonbinder.eu/platforms/web/): requisitos de WebAssembly, worker y persistencia en navegador.
- [drift_flutter](https://pub.dev/packages/drift_flutter): apertura de bases en plataformas nativas y Web.
- [Flutter testing](https://docs.flutter.dev/testing/overview): tipos de pruebas y uso de pruebas de widgets.

## Uso de IA

Se utilizó ChatGPT como apoyo para estructurar la capa Drift, proponer operaciones CRUD y preparar pruebas y documentación. Se debe indicar qué partes se revisaron/ejecutaron personalmente y qué errores se corrigieron durante la comprobación: [completar con tu experiencia real].
