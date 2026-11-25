# Gestor de tareas con SQLite y Flutter

Aplicación local para crear, consultar, editar y eliminar tareas. Utiliza Drift sobre SQLite y ofrece una interfaz desarrollada con Flutter.

## Funcionalidades

- Crear tareas con validación de título.
- Mostrar las tareas mediante consultas reactivas.
- Marcar tareas como completadas o pendientes.
- Editar títulos y eliminar tareas.
- Conservar los datos localmente entre ejecuciones.
- Ejecutar pruebas de datos y de interfaz.

## Tecnologías

- Flutter y Dart
- Drift
- SQLite
- drift_flutter
- Pruebas con SQLite en memoria

## Estructura

- `lib/`: código fuente de la aplicación.
- `lib/data/`: acceso a datos y configuración de la base.
- `test/`: pruebas automatizadas.
- `web/`: recursos necesarios para ejecutar la aplicación en navegadores.
- `pubspec.yaml`: dependencias y configuración del proyecto.

## Requisitos previos

- Flutter SDK instalado.
- Dart incluido con Flutter.
- Git opcional para trabajar con el repositorio.
- Navegador Chrome para ejecutar la versión web.

## Preparación

Después de generar o descargar el proyecto:

```powershell
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

El archivo `lib/data/app_database.g.dart` se genera automáticamente y no debe modificarse manualmente.

## Ejecutar la aplicación

### Web

Coloca en `web/` los archivos `sqlite3.wasm` y `drift_worker.js`, usando una versión compatible con la versión de Drift del proyecto.

```powershell
flutter run -d chrome
```

El servidor web debe entregar `sqlite3.wasm` con el tipo de contenido `application/wasm`.

### Escritorio o móvil

Consulta los dispositivos disponibles y ejecuta la aplicación en uno:

```powershell
flutter devices
flutter run -d <id-del-dispositivo>
```

## Persistencia

En plataformas nativas, la base se guarda en el directorio privado de documentos de la aplicación. En Web, los datos se almacenan en el navegador asociado al origen y perfil utilizados.

El cierre o reinicio de la aplicación no elimina los datos.

## Arquitectura

La interfaz presenta las tareas y delega las operaciones a la capa de datos. `AppDatabase` define el esquema, las consultas y las acciones sobre SQLite.

Las consultas reactivas permiten que la interfaz se actualice automáticamente al crear, modificar o eliminar registros.

## Pruebas manuales sugeridas

1. Crear una tarea y reiniciar la aplicación.
2. Marcar una tarea como completada y reiniciar.
3. Editar el título de una tarea y reiniciar.
4. Eliminar una tarea y reiniciar.
5. Intentar crear una tarea vacía o con solo espacios.
6. Recargar la aplicación web y comprobar que los datos continúan disponibles.

Los resultados deben indicar qué plataformas se probaron realmente y cuáles fueron solo previstas.

## Referencias

- [Documentación de Drift](https://drift.simonbinder.eu/)
- [Drift en la Web](https://drift.simonbinder.eu/platforms/web/)
- [Paquete drift_flutter](https://pub.dev/packages/drift_flutter)
- [Pruebas en Flutter](https://docs.flutter.dev/testing/overview)
