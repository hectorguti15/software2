import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ulima_app/domain/entity/material_entity.dart' as entity;
import 'package:ulima_app/domain/entity/seccion_entity.dart';
import 'package:ulima_app/domain/entity/usuario_entity.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/cubit/materiales_cubit.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/cubit/materiales_state.dart';
import 'package:ulima_app/presentation/theme/colors.dart';

// HU04: Gestión del aula virtual (subir materiales - profesor/delegado)
// HU05: Ver y descargar materiales compartidos
class MaterialesTab extends StatefulWidget {
  final Seccion seccion;
  final Usuario? usuario;

  const MaterialesTab({super.key, required this.seccion, this.usuario});

  @override
  State<MaterialesTab> createState() => _MaterialesTabState();
}

class _MaterialesTabState extends State<MaterialesTab> {
  entity.TipoMaterial? _filtroTipo;

  bool _puedeSubirMateriales() {
    // HU04: Solo profesor y delegado pueden subir materiales
    return widget.usuario?.rol == RolUsuario.profesor ||
        widget.usuario?.rol == RolUsuario.delegado;
  }

  void _mostrarDialogoSubirMaterial() {
    final nombreController = TextEditingController();
    entity.TipoMaterial tipoSeleccionado = entity.TipoMaterial.pdf;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Subir Material'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del archivo',
                    hintText: 'Ej: Presentación Clase 5.pdf',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Tipo de archivo:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<entity.TipoMaterial>(
                  value: tipoSeleccionado,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: entity.TipoMaterial.values.map((tipo) {
                    return DropdownMenuItem(
                      value: tipo,
                      child: Row(
                        children: [
                          Icon(_getIconoTipo(tipo), size: 20),
                          const SizedBox(width: 8),
                          Text(_getNombreTipo(tipo)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (valor) {
                    setDialogState(() {
                      tipoSeleccionado = valor!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.amber[100],
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Colors.orange),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Simulación: En producción, aquí se seleccionaría el archivo real.',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final nombre = nombreController.text.trim();
                if (nombre.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Ingresa un nombre para el archivo')),
                  );
                  return;
                }

                // TODO: En producción, subir archivo real a servicio de storage
                final material = entity.Material(
                  id: 'mat_${DateTime.now().millisecondsSinceEpoch}',
                  nombre: nombre,
                  tipo: tipoSeleccionado,
                  url: 'https://example.com/${nombre.replaceAll(' ', '_')}',
                  fechaSubida: DateTime.now(),
                  autorNombre: widget.usuario?.nombre ?? 'Usuario',
                );

                this.context.read<MaterialesCubit>().subir(
                      widget.seccion.id,
                      material,
                    );

                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Material subido exitosamente')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: UlimaColors.orange,
              ),
              child: const Text('Subir'),
            ),
          ],
        ),
      ),
    );
  }

  List<entity.Material> _filtrarMateriales(List<entity.Material> materiales) {
    if (_filtroTipo == null) return materiales;
    return materiales.where((m) => m.tipo == _filtroTipo).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barra de filtros y botón de subir
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FiltroChip(
                        label: 'Todos',
                        isSelected: _filtroTipo == null,
                        onTap: () => setState(() => _filtroTipo = null),
                      ),
                      _FiltroChip(
                        label: 'PDF',
                        icon: Icons.picture_as_pdf,
                        isSelected: _filtroTipo == entity.TipoMaterial.pdf,
                        onTap: () =>
                            setState(() => _filtroTipo = entity.TipoMaterial.pdf),
                      ),
                      _FiltroChip(
                        label: 'Videos',
                        icon: Icons.video_library,
                        isSelected: _filtroTipo == entity.TipoMaterial.video,
                        onTap: () =>
                            setState(() => _filtroTipo = entity.TipoMaterial.video),
                      ),
                      _FiltroChip(
                        label: 'Imágenes',
                        icon: Icons.image,
                        isSelected: _filtroTipo == entity.TipoMaterial.imagen,
                        onTap: () =>
                            setState(() => _filtroTipo = entity.TipoMaterial.imagen),
                      ),
                      _FiltroChip(
                        label: 'Documentos',
                        icon: Icons.description,
                        isSelected: _filtroTipo == entity.TipoMaterial.documento,
                        onTap: () =>
                            setState(() => _filtroTipo = entity.TipoMaterial.documento),
                      ),
                    ],
                  ),
                ),
              ),
              if (_puedeSubirMateriales()) ...[
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _mostrarDialogoSubirMaterial,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Subir'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: UlimaColors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ],
          ),
        ),
        // Lista de materiales
        Expanded(
          child: BlocBuilder<MaterialesCubit, MaterialesState>(
            builder: (context, state) {
              if (state is MaterialesLoading || state is MaterialesInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is MaterialesError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(state.message),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<MaterialesCubit>()
                              .loadMateriales(widget.seccion.id);
                        },
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                );
              }

              if (state is MaterialesLoaded) {
                final materiales = _filtrarMateriales(state.materiales);

                if (materiales.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.folder_open,
                            size: 60, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          _filtroTipo == null
                              ? 'No hay materiales disponibles'
                              : 'No hay materiales de este tipo',
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        if (_puedeSubirMateriales() && _filtroTipo == null) ...[
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: _mostrarDialogoSubirMaterial,
                            icon: const Icon(Icons.add),
                            label: const Text('Subir primer material'),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: materiales.length,
                  itemBuilder: (context, index) {
                    return _MaterialItem(material: materiales[index]);
                  },
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  IconData _getIconoTipo(entity.TipoMaterial tipo) {
    switch (tipo) {
      case entity.TipoMaterial.pdf:
        return Icons.picture_as_pdf;
      case entity.TipoMaterial.video:
        return Icons.video_library;
      case entity.TipoMaterial.imagen:
        return Icons.image;
      case entity.TipoMaterial.documento:
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _getNombreTipo(entity.TipoMaterial tipo) {
    switch (tipo) {
      case entity.TipoMaterial.pdf:
        return 'PDF';
      case entity.TipoMaterial.video:
        return 'Video';
      case entity.TipoMaterial.imagen:
        return 'Imagen';
      case entity.TipoMaterial.documento:
        return 'Documento';
      default:
        return 'Otro';
    }
  }
}

class _FiltroChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FiltroChip({
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: 4),
            ],
            Text(label),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: UlimaColors.orange.withOpacity(0.3),
        checkmarkColor: UlimaColors.orange,
      ),
    );
  }
}

class _MaterialItem extends StatelessWidget {
  final entity.Material material;

  const _MaterialItem({required this.material});

  IconData _getIcono() {
    switch (material.tipo) {
      case entity.TipoMaterial.pdf:
        return Icons.picture_as_pdf;
      case entity.TipoMaterial.video:
        return Icons.video_library;
      case entity.TipoMaterial.imagen:
        return Icons.image;
      case entity.TipoMaterial.documento:
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getColor() {
    switch (material.tipo) {
      case entity.TipoMaterial.pdf:
        return Colors.red;
      case entity.TipoMaterial.video:
        return Colors.blue;
      case entity.TipoMaterial.imagen:
        return Colors.green;
      case entity.TipoMaterial.documento:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _descargarMaterial(BuildContext context) {
    // TODO: Implementar descarga real cuando esté el backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Descargando: ${material.nombre}'),
        action: SnackBarAction(
          label: 'Ver',
          onPressed: () {
            // TODO: Abrir archivo descargado
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getColor().withOpacity(0.1),
          child: Icon(_getIcono(), color: _getColor()),
        ),
        title: Text(
          material.nombre,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Subido por ${material.autorNombre}',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              DateFormat('dd/MM/yyyy HH:mm').format(material.fechaSubida),
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility),
              tooltip: 'Visualizar',
              onPressed: () {
                // TODO: Abrir preview del archivo
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Abriendo: ${material.nombre}')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.download),
              tooltip: 'Descargar',
              onPressed: () => _descargarMaterial(context),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
