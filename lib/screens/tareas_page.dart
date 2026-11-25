import 'package:flutter/material.dart';

import '../data/app_database.dart';

class TareasPage extends StatefulWidget {
  const TareasPage({required this.database, super.key});

  final AppDatabase database;

  @override
  State<TareasPage> createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  final _tituloController = TextEditingController();
  bool _guardando = false;

  Future<void> _agregarTarea() async {
    if (!mounted) return;
    final titulo = _tituloController.text.trim();
    if (titulo.isEmpty) {
      _mensaje('Escribe un título para la tarea.');
      return;
    }
    await _ejecutar(() async {
      await widget.database.agregarTarea(titulo);
      _tituloController.clear();
    }, 'No se pudo guardar la tarea.');
  }

  Future<void> _alternarCompletada(Tarea tarea, bool completada) async {
    await _ejecutar(
      () => widget.database.actualizarEstado(tarea.id, completada),
      'No se pudo actualizar el estado.',
    );
  }

  Future<void> _editarTarea(Tarea tarea) async {
    final nuevoTitulo = await showDialog<String>(
      context: context,
      builder: (context) => _EditarTareaDialog(titulo: tarea.titulo),
    );
    if (!mounted) return;
    if (nuevoTitulo == null) return;
    if (nuevoTitulo.trim().isEmpty) {
      _mensaje('El título no puede estar vacío.');
      return;
    }
    await _ejecutar(
      () => widget.database.actualizarTitulo(tarea.id, nuevoTitulo),
      'No se pudo editar la tarea.',
    );
  }

  Future<void> _eliminarTarea(Tarea tarea) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: Text('¿Eliminar "${tarea.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;
    await _ejecutar(
      () => widget.database.eliminarTarea(tarea.id),
      'No se pudo eliminar la tarea.',
    );
  }

  Future<void> _ejecutar(Future<void> Function() accion, String error) async {
    if (!mounted || _guardando) return;
    setState(() => _guardando = true);
    try {
      await accion();
    } catch (_) {
      if (mounted) _mensaje(error);
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  void _mensaje(String texto) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestor de tareas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Nueva tarea',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _agregarTarea(),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _guardando ? null : _agregarTarea,
              icon: const Icon(Icons.add),
              label: const Text('Agregar tarea'),
            ),
            const SizedBox(height: 12),
            const Text('Mis tareas', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<List<Tarea>>(
                stream: widget.database.watchTareas(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Ocurrió un error al cargar las tareas.'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final tareas = snapshot.data!;
                  if (tareas.isEmpty) {
                    return const Center(
                      child: Text('Todavía no hay tareas guardadas'),
                    );
                  }
                  return ListView.builder(
                    itemCount: tareas.length,
                    itemBuilder: (context, index) {
                      final tarea = tareas[index];
                      return Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: tarea.completada,
                            onChanged: _guardando
                                ? null
                                : (valor) {
                                    if (valor != null) {
                                      _alternarCompletada(tarea, valor);
                                    }
                                  },
                          ),
                          title: Text(
                            tarea.titulo,
                            style: TextStyle(
                              decoration: tarea.completada
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Text(
                            tarea.completada ? 'Completada' : 'Pendiente',
                          ),
                          trailing: Wrap(
                            spacing: 0,
                            children: [
                              IconButton(
                                tooltip: 'Editar',
                                icon: const Icon(Icons.edit),
                                onPressed: _guardando
                                    ? null
                                    : () => _editarTarea(tarea),
                              ),
                              IconButton(
                                tooltip: 'Eliminar',
                                icon: const Icon(Icons.delete_outline),
                                onPressed: _guardando
                                    ? null
                                    : () => _eliminarTarea(tarea),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditarTareaDialog extends StatefulWidget {
  const _EditarTareaDialog({required this.titulo});

  final String titulo;

  @override
  State<_EditarTareaDialog> createState() => _EditarTareaDialogState();
}

class _EditarTareaDialogState extends State<_EditarTareaDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.titulo);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar tarea'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Título'),
        onSubmitted: (value) => Navigator.pop(context, value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
