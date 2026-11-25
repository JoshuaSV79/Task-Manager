# Recursos requeridos para Drift Web

Coloca en esta carpeta `sqlite3.wasm` y `drift_worker.js` de la misma release compatible con la versión de `drift` fijada en `pubspec.lock`. Sigue https://drift.simonbinder.eu/platforms/web/ para identificar y obtener los binarios correctos.

La aplicación configura estas rutas en `DriftWebOptions`. Sin los dos archivos el target Web no estará listo para ejecutarse.
