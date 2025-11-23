import 'package:ulima_app/data/model/dto/evento_model.dart';
import 'package:ulima_app/data/model/dto/material_model.dart';
import 'package:ulima_app/data/model/dto/mensaje_model.dart';
import 'package:ulima_app/data/model/dto/seccion_model.dart';
import 'package:ulima_app/data/model/dto/usuario_model.dart';

abstract class AulavirtualDatasource {
  Future<List<SeccionModel>> getSeccionesUsuario(String usuarioId);
  Future<SeccionModel> getSeccionDetail(String seccionId);
  Future<List<MensajeModel>> getMensajes(String seccionId);
  Future<void> enviarMensaje(String seccionId, MensajeModel mensaje);
  Future<List<MaterialModel>> getMateriales(String seccionId);
  Future<void> subirMaterial(String seccionId, MaterialModel material);
  Future<List<EventoModel>> getEventos(String seccionId);
  Future<void> crearEvento(String seccionId, EventoModel evento);
  Future<UsuarioModel> getUsuarioActual();
}

class AulavirtualDatasourceImpl implements AulavirtualDatasource {
  // TODO: Reemplazar con datos reales de backend cuando esté disponible
  // Simulación en memoria para demo del Sprint 2

  // Usuario mock - Cambiar el rol aquí para probar diferentes permisos
  final UsuarioModel _usuarioActual = UsuarioModel(
    id: 'user001',
    nombre: 'Juan Pérez',
    email: 'juan.perez@ulima.edu.pe',
    rol: 'alumno', // Cambiar a 'profesor' o 'delegado' para probar HU03 y HU04
  );

  // Secciones mock - HU01: Espacios asignados automáticamente
  final List<Map<String, dynamic>> _seccionesData = [
    {
      'id': 'sec001',
      'nombre': 'Software 2 - Sección 01',
      'codigo': 'CS2001-01',
      'cursoNombre': 'Construcción de Software 2',
      'profesorNombre': 'Dr. Carlos Mendoza',
      'delegadoNombre': 'María García',
    },
    {
      'id': 'sec002',
      'nombre': 'Cálculo 3 - Sección 02',
      'codigo': 'MAT3001-02',
      'cursoNombre': 'Cálculo 3',
      'profesorNombre': 'Dra. Ana Torres',
      'delegadoNombre': null,
    },
    {
      'id': 'sec003',
      'nombre': 'Bases de Datos - Sección 01',
      'codigo': 'CS3002-01',
      'cursoNombre': 'Bases de Datos',
      'profesorNombre': 'Ing. Roberto Silva',
      'delegadoNombre': 'Luis Ramírez',
    },
  ];

  // Mensajes por sección - HU02: Chat grupal con historial
  final Map<String, List<MensajeModel>> _mensajesPorSeccion = {};

  // Materiales por sección - HU04, HU05: Materiales compartidos
  final Map<String, List<MaterialModel>> _materialesPorSeccion = {};

  // Eventos por sección - HU06: Calendario académico
  final Map<String, List<EventoModel>> _eventosPorSeccion = {};

  AulavirtualDatasourceImpl() {
    _inicializarDatosMock();
  }

  void _inicializarDatosMock() {
    // Mensajes iniciales para Software 2
    _mensajesPorSeccion['sec001'] = [
      MensajeModel(
        id: 'msg001',
        contenido:
            'Bienvenidos al aula virtual de Software 2. Aquí podrán encontrar todos los materiales del curso.',
        autorId: 'prof001',
        autorNombre: 'Dr. Carlos Mendoza',
        fecha: DateTime.now().subtract(Duration(days: 5)).toIso8601String(),
        esAnuncio: true, // HU03: Anuncio destacado del profesor
      ),
      MensajeModel(
        id: 'msg002',
        contenido: 'Hola a todos! Listos para el sprint 2?',
        autorId: 'user002',
        autorNombre: 'María García',
        fecha: DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
        esAnuncio: false,
      ),
      MensajeModel(
        id: 'msg003',
        contenido: 'Recuerden que la entrega del proyecto es el viernes.',
        autorId: 'user001',
        autorNombre: 'Juan Pérez',
        fecha: DateTime.now().subtract(Duration(hours: 5)).toIso8601String(),
        esAnuncio: false,
      ),
    ];

    // Mensajes iniciales para Cálculo 3
    _mensajesPorSeccion['sec002'] = [
      MensajeModel(
        id: 'msg004',
        contenido:
            'El examen parcial será el próximo lunes. Estudien los capítulos 1 al 5.',
        autorId: 'prof002',
        autorNombre: 'Dra. Ana Torres',
        fecha: DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
        esAnuncio: true,
      ),
    ];

    // Mensajes iniciales para Bases de Datos
    _mensajesPorSeccion['sec003'] = [
      MensajeModel(
        id: 'msg005',
        contenido: 'Práctica de SQL disponible en materiales.',
        autorId: 'user003',
        autorNombre: 'Luis Ramírez',
        fecha: DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
        esAnuncio: true, // HU03: Anuncio del delegado
      ),
    ];

    // Materiales para Software 2 - HU05: Ver materiales compartidos
    _materialesPorSeccion['sec001'] = [
      MaterialModel(
        id: 'mat001',
        nombre: 'Presentación Sprint 2.pdf',
        tipo: 'pdf',
        url: 'https://example.com/sprint2.pdf',
        fechaSubida: DateTime.now().subtract(Duration(days: 7)).toIso8601String(),
        autorNombre: 'Dr. Carlos Mendoza',
      ),
      MaterialModel(
        id: 'mat002',
        nombre: 'Tutorial Flutter Avanzado.mp4',
        tipo: 'video',
        url: 'https://example.com/flutter_tutorial.mp4',
        fechaSubida: DateTime.now().subtract(Duration(days: 5)).toIso8601String(),
        autorNombre: 'Dr. Carlos Mendoza',
      ),
      MaterialModel(
        id: 'mat003',
        nombre: 'Diagrama de Arquitectura.png',
        tipo: 'imagen',
        url: 'https://example.com/arquitectura.png',
        fechaSubida: DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
        autorNombre: 'María García',
      ),
    ];

    // Materiales para Cálculo 3
    _materialesPorSeccion['sec002'] = [
      MaterialModel(
        id: 'mat004',
        nombre: 'Ejercicios Resueltos Cap 3.pdf',
        tipo: 'pdf',
        url: 'https://example.com/ejercicios_cap3.pdf',
        fechaSubida: DateTime.now().subtract(Duration(days: 4)).toIso8601String(),
        autorNombre: 'Dra. Ana Torres',
      ),
    ];

    // Materiales para Bases de Datos
    _materialesPorSeccion['sec003'] = [
      MaterialModel(
        id: 'mat005',
        nombre: 'Práctica SQL.docx',
        tipo: 'documento',
        url: 'https://example.com/practica_sql.docx',
        fechaSubida: DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
        autorNombre: 'Ing. Roberto Silva',
      ),
    ];

    // Eventos para Software 2 - HU06: Calendario académico
    _eventosPorSeccion['sec001'] = [
      EventoModel(
        id: 'evt001',
        titulo: 'Entrega Sprint 2',
        descripcion: 'Fecha límite para entregar el proyecto del Sprint 2',
        fecha: DateTime.now().add(Duration(days: 5)).toIso8601String(),
        tipo: 'entrega',
      ),
      EventoModel(
        id: 'evt002',
        titulo: 'Examen Final',
        descripcion: 'Evaluación final del curso',
        fecha: DateTime.now().add(Duration(days: 20)).toIso8601String(),
        tipo: 'evaluacion',
      ),
    ];

    // Eventos para Cálculo 3
    _eventosPorSeccion['sec002'] = [
      EventoModel(
        id: 'evt003',
        titulo: 'Examen Parcial',
        descripcion: 'Capítulos 1-5',
        fecha: DateTime.now().add(Duration(days: 3)).toIso8601String(),
        tipo: 'evaluacion',
      ),
    ];

    // Eventos para Bases de Datos
    _eventosPorSeccion['sec003'] = [
      EventoModel(
        id: 'evt004',
        titulo: 'Entrega Proyecto Final',
        descripcion: 'Sistema de base de datos completo',
        fecha: DateTime.now().add(Duration(days: 15)).toIso8601String(),
        tipo: 'entrega',
      ),
    ];
  }

  @override
  Future<UsuarioModel> getUsuarioActual() async {
    await Future.delayed(Duration(milliseconds: 100));
    return _usuarioActual;
  }

  @override
  Future<List<SeccionModel>> getSeccionesUsuario(String usuarioId) async {
    // HU01: Retorna las secciones asignadas automáticamente al usuario
    await Future.delayed(Duration(milliseconds: 500));
    return _seccionesData.map((json) => SeccionModel.fromJson(json)).toList();
  }

  @override
  Future<SeccionModel> getSeccionDetail(String seccionId) async {
    await Future.delayed(Duration(milliseconds: 300));
    final seccion = _seccionesData.firstWhere((s) => s['id'] == seccionId);
    return SeccionModel.fromJson(seccion);
  }

  @override
  Future<List<MensajeModel>> getMensajes(String seccionId) async {
    // HU02: Retorna historial completo de mensajes
    await Future.delayed(Duration(milliseconds: 300));
    return _mensajesPorSeccion[seccionId] ?? [];
  }

  @override
  Future<void> enviarMensaje(String seccionId, MensajeModel mensaje) async {
    // HU02, HU03: Enviar mensaje o anuncio
    await Future.delayed(Duration(milliseconds: 200));
    if (!_mensajesPorSeccion.containsKey(seccionId)) {
      _mensajesPorSeccion[seccionId] = [];
    }
    _mensajesPorSeccion[seccionId]!.add(mensaje);
  }

  @override
  Future<List<MaterialModel>> getMateriales(String seccionId) async {
    // HU05: Retorna materiales compartidos
    await Future.delayed(Duration(milliseconds: 300));
    return _materialesPorSeccion[seccionId] ?? [];
  }

  @override
  Future<void> subirMaterial(String seccionId, MaterialModel material) async {
    // HU04: Subir material (profesor/delegado)
    await Future.delayed(Duration(milliseconds: 200));
    if (!_materialesPorSeccion.containsKey(seccionId)) {
      _materialesPorSeccion[seccionId] = [];
    }
    _materialesPorSeccion[seccionId]!.add(material);
  }

  @override
  Future<List<EventoModel>> getEventos(String seccionId) async {
    // HU06: Retorna eventos del calendario
    await Future.delayed(Duration(milliseconds: 300));
    return _eventosPorSeccion[seccionId] ?? [];
  }

  @override
  Future<void> crearEvento(String seccionId, EventoModel evento) async {
    // HU04, HU06: Crear evento (profesor/delegado)
    await Future.delayed(Duration(milliseconds: 200));
    if (!_eventosPorSeccion.containsKey(seccionId)) {
      _eventosPorSeccion[seccionId] = [];
    }
    _eventosPorSeccion[seccionId]!.add(evento);
  }
}
