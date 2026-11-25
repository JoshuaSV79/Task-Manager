# Gestor de tareas con SQLite y Flutter

Implementación de la práctica usando **Drift + drift_flutter**. La base es local; no hay servidor, API REST ni sincronización entre dispositivos.

## Qué incluye

- Tabla `tareas`: `id` (INTEGER autoincremental), `titulo` (TEXT) y `completada` (INTEGER/booleano de SQLite).
- Altas con validación de título no vacío.
- Consulta reactiva con `StreamBuilder` y `watch()`.
- Edición del título, cambio de estado y eliminación por ID.
- Manejo básico de errores y liberación del controlador de texto.
- Pruebas con SQLite en memoria: inicio de pantalla, rechazo de título vacío y persistencia/actualización de datos en la base durante la prueba.

## Preparación desde la base entregada

El ZIP de la consigna no es un proyecto Flutter completo: no incluye `pubspec.yaml` ni las carpetas de plataforma. Crea el esqueleto con Flutter y después copia/sustituye `lib/`, `test/`, `pubspec.yaml` y `analysis_options.yaml` de este proyecto:

```powershell
flutter create gestor_tareas_local
cd gestor_tareas_local
# Copia aquí los archivos de este entregable, sustituyendo lib/ y test/.
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

El archivo `lib/data/app_database.g.dart` es generado por `build_runner`; no se edita manualmente.

## Configuración de Flutter Web (obligatoria)

La configuración Dart apunta a estos dos archivos dentro de `web/`:

- `sqlite3.wasm`
- `drift_worker.js`

Deben obtenerse de una **misma versión/release compatible con la versión de `drift` resuelta en `pubspec.lock`**. La documentación oficial de Drift explica la descarga/compilación y el worker. No reutilices archivos de una versión distinta.

Después de crear el proyecto Flutter, coloca ambos archivos en `web/`. El directorio tendrá, entre otros, `index.html`, `manifest.json`, `sqlite3.wasm` y `drift_worker.js`.

Para probar:

```powershell
flutter run -d chrome
```

Drift requiere que el servidor entregue `sqlite3.wasm` con `Content-Type: application/wasm`. `flutter run` lo configura por defecto. En despliegue, verifica ese encabezado. Los encabezados COOP/COEP pueden habilitar el almacenamiento OPFS de mejor rendimiento, pero no son imprescindibles: sin ellos Drift puede usar una alternativa compatible. Revisa la documentación antes de configurar esos encabezados.

## Ejecución y verificación

```powershell
flutter devices
flutter run -d chrome
# En otra plataforma nativa disponible:
flutter run -d <id-del-dispositivo>

flutter analyze
flutter test
```

Pruebas manuales requeridas por la práctica:
1. Crear tres tareas; cerrar por completo y abrir de nuevo (P1).
2. Cambiar una a completada; reiniciar (P2).
3. Editar título; reiniciar (P3).
4. Eliminar una; reiniciar (P4).
5. Intentar título vacío o con espacios (P5).
6. En Web, recargar y reabrir en el mismo origen y perfil (P6).

**No declares una plataforma como probada hasta ejecutar esas comprobaciones.** En el reporte indica por separado plataformas ejecutadas y plataformas solo previstas. iOS/macOS requieren macOS; Windows y Linux requieren sus respectivos sistemas para compilar.

## Diseño

`TareasPage` solo presenta la interfaz y llama a la capa de datos. `AppDatabase` contiene el esquema y las operaciones Drift. Las consultas reactivas notifican a la interfaz cuando cambia la tabla, evitando consultas dentro de `build()`.

En plataformas nativas, `drift_flutter` guarda `gestor_tareas.sqlite` en el directorio de documentos de la aplicación. En Web, Drift utiliza WebAssembly y almacenamiento del navegador asociado al origen/perfil; el modo privado o borrar datos del sitio puede eliminar o impedir conservar esos datos.

## Fuentes técnicas

- https://drift.simonbinder.eu/ — tablas, consultas tipadas, generación y consultas reactivas.
- https://drift.simonbinder.eu/platforms/web/ — SQLite compilado a WASM, worker y almacenamiento web.
- https://pub.dev/packages/drift_flutter — apertura multiplataforma de la base.
- https://docs.flutter.dev/testing/overview — diferencias entre pruebas unitarias, de widgets e integración.

## Antes de entregar

- Ejecuta los comandos de análisis y pruebas; corrige cualquier error.
- Descarga los recursos Web compatibles y comprueba P1–P6 en Web y al menos una plataforma nativa.
- Completa `docs/reporte_practica.md` con el problema técnico que realmente encontraste y los resultados observados.
- Crea un repositorio individual, realiza commits auténticos durante tu trabajo y sube `pubspec.lock`, código, pruebas, README y configuración Web. No subas `build/`.
