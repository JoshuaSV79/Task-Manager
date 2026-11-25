# Recursos de Drift para Flutter Web

La versión exacta de Drift se conoce después de `flutter pub get`; consulta `pubspec.lock`. La documentación oficial indica descargar `sqlite3.wasm` y el worker desde la misma release de Drift y colocarlos en `web/`. Esta plantilla configura las rutas `sqlite3.wasm` y `drift_worker.dart.js` en `DriftWebOptions`.

Consulta y sigue la guía oficial, que mantiene los nombres y pasos de compilación actualizados:
https://drift.simonbinder.eu/platforms/web/

No se incluyen binarios de otra versión para evitar una incompatibilidad silenciosa. Tras descargar los archivos, confirma que el worker corresponde a la versión de Drift resuelta y prueba recarga/cierre/reapertura en el mismo origen.
