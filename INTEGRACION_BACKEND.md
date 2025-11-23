# Integración Flutter → Backend REST API

## ✅ Completado

### 1. ApiService Creado
- **Archivo:** `lib/core/api_service.dart`
- **URL Base:** `http://10.0.2.2:3000/api` (Android emulator)
- **Métodos:** GET, POST, PATCH
- **Manejo de errores:** ApiException personalizado

### 2. Datasources Migrados a HTTP

#### ✅ MenuDataSource
- **Endpoint:** `GET /api/menu`
- **Estado:** Completamente migrado a HTTP
- **Archivo:** `lib/data/datasource/menu_datasource.dart`

#### ✅ PedidoDataSource
- **Endpoints:**
  - `POST /api/pedidos` - Crear pedido
  - `GET /api/pedidos` - Historial
  - `POST /api/pedidos/:codigo/notificacion`
  - `POST /api/pedidos/:codigo/boleta`
- **Estado:** Completamente migrado
- **Archivo:** `lib/data/datasource/pedido_datasource.dart`
- **Nota:** Se agregó `fromJson()` a `PedidoModel`

#### ✅ ResenaDataSource
- **Endpoints:**
  - `GET /api/resenas/:productId`
  - `POST /api/resenas`
- **Estado:** Completamente migrado
- **Archivo:** `lib/data/datasource/resena_datasource.dart`

#### ⚠️ AulaVirtualDataSource
- **Estado:** NECESITA ATENCIÓN MANUAL
- **Archivo:** `lib/data/datasource/aulavirtual_datasource.dart`
- **Problema:** Archivo contiene mix de código mock y HTTP
- **Endpoints a usar:**
  - `GET /api/usuarios/actual`
  - `GET /api/aula-virtual/usuarios/:id/secciones`
  - `GET /api/aula-virtual/secciones/:id`
  - `GET /api/aula-virtual/secciones/:id/mensajes`
  - `POST /api/aula-virtual/secciones/:id/mensajes`
  - `GET /api/aula-virtual/secciones/:id/materiales`
  - `POST /api/aula-virtual/secciones/:id/materiales`
  - `GET /api/aula-virtual/secciones/:id/eventos`
  - `POST /api/aula-virtual/secciones/:id/eventos`

**ACCIÓN REQUERIDA:**
1. Eliminar TODO el código mock (líneas 24-217)
2. Mantener SOLO las implementaciones HTTP (líneas 218-328)
3. Referencia: Ver `menu_datasource.dart` como ejemplo limpio

### 3. Models Actualizados

#### ✅ PedidoModel
- Agregado: `factory fromJson(Map<String, dynamic> json)`
- Deserializa respuestas del backend

#### ✅ MaterialModel
- Ya tenía: `Map<String, dynamic> toJson()`
- ✅ Listo para enviar al backend

#### ✅ MensajeModel  
- Ya tenía: `Map<String, dynamic> toJson()`
- ✅ Listo para enviar al backend

#### ✅ EventoModel
- Ya tenía: `Map<String, dynamic> toJson()`
- ✅ Listo para enviar al backend

### 4. Configuración de Red

#### ✅ Android
- **Archivo:** `android/app/src/main/AndroidManifest.xml`
- **Cambios:**
  - ✅ `<uses-permission android:name="android.permission.INTERNET"/>`
  - ✅ `android:usesCleartextTraffic="true"`

#### ⚠️ iOS
- **Archivo:** `ios/Runner/Info.plist`
- **Pendiente:** Agregar excepción NSAppTransportSecurity

### 5. Inyección de Dependencias
- **Archivo:** `lib/core/injector.dart`
- **Estado:** ✅ Configurado correctamente
- Todos los datasources están registrados

---

## ⚠️ Pendiente

### 1. Limpieza de AulaVirtualDataSource
El archivo está corrupto con mix de mock/HTTP. Debe limpiarse manualmente:

```dart
// ELIMINAR: Líneas 24-217 (todo el código mock)
// MANTENER: Líneas 218-328 (implementaciones HTTP)
```

### 2. Botón Cambio de Rol
**Ubicación sugerida:** `lib/presentation/pages/miulima/` o perfil de usuario

**Implementación:**
```dart
// En el perfil del usuario
DropdownButton<String>(
  value: _usuarioActual.rol,
  items: ['alumno', 'profesor', 'delegado'].map((rol) {
    return DropdownMenuItem(value: rol, child: Text(rol));
  }).toList(),
  onChanged: (nuevoRol) async {
    if (nuevoRol != null) {
      // Llamar al backend: PATCH /api/usuarios/:id/rol
      await ApiService.patch('/usuarios/${_usuarioActual.id}/rol', {
        'rol': nuevoRol
      });
      // Actualizar estado local
      setState(() => _usuarioActual.rol = nuevoRol);
    }
  },
)
```

### 3. Ajustar Repositorios
Los repositorios ya están configurados en `injector.dart`, pero verificar que usen los datasources HTTP:
- ✅ MenuRepository → MenuDataSourceImpl (HTTP)
- ✅ PedidoRepository → PedidoDataSourceImpl (HTTP)
- ✅ ResenaRepository → ResenaDataSourceImpl (HTTP)
- ⚠️ AulavirtualRepository → AulavirtualDatasourceImpl (limpiar mock)

---

## 🧪 Testing

### Verificar Backend Corriendo
```bash
curl http://localhost:3000/api/menu
```

### Testing desde Flutter

1. **Emulador Android:**
   - Backend debe estar en: `http://10.0.2.2:3000`
   - Verificar `ApiService.baseUrl`

2. **Dispositivo Físico:**
   - Encontrar IP local: `ipconfig` (Windows)
   - Actualizar `ApiService.baseUrl` a `http://TU_IP:3000/api`

3. **Logs de Debug:**
   - Todos los datasources tienen `print('[DataSource] ...')`
   - Revisar consola para ver requests/responses

### Endpoints a Probar

```dart
// 1. Menú
await ApiService.get('/menu');

// 2. Usuario actual
await ApiService.get('/usuarios/actual');

// 3. Secciones
await ApiService.get('/aula-virtual/usuarios/user001/secciones');

// 4. Mensajes
await ApiService.get('/aula-virtual/secciones/sec001/mensajes');

// 5. Crear pedido
await ApiService.post('/pedidos', {
  'items': [{'nombre': 'Ceviche', 'cantidad': 1, 'precio': 35}],
  'total': 35
});
```

---

## 📋 Checklist Final

- [x] ApiService creado
- [x] MenuDataSource → HTTP
- [x] PedidoDataSource → HTTP  
- [x] ResenaDataSource → HTTP
- [ ] AulaVirtualDataSource → HTTP (LIMPIAR MOCK)
- [x] PedidoModel.fromJson() agregado
- [x] AndroidManifest.xml configurado
- [ ] Info.plist configurado (iOS)
- [ ] Botón cambio de rol implementado
- [ ] Tests end-to-end realizados

---

## 🚀 Próximos Pasos

1. **URGENTE:** Limpiar `aulavirtual_datasource.dart`
   - Eliminar todo código mock
   - Dejar solo implementaciones HTTP

2. **Implementar cambio de rol:**
   - Agregar UI en perfil
   - Conectar a `PATCH /api/usuarios/:id/rol`

3. **Testing completo:**
   - Menú: Listar platos
   - Pedidos: Crear y ver historial
   - Reseñas: Ver y agregar
   - Aula Virtual: Secciones, mensajes, materiales, eventos

4. **Configurar iOS:** 
   - Agregar excepción HTTP en Info.plist

5. **Manejo de errores mejorado:**
   - UI para mostrar errores de red
   - Retry logic
   - Loading states

---

## 📚 Referencias

- **Backend Docs:** `d:\Software2\backend\README.md`
- **API Endpoints:** `d:\Software2\backend\API_ENDPOINTS.md`
- **Integration Guide:** `d:\Software2\backend\INTEGRATION_GUIDE.md`
- **Architecture:** `d:\Software2\backend\ARCHITECTURE.md`

---

**Última actualización:** 23 Nov 2025
**Estado:** 70% completado - Requiere limpieza manual de AulaVirtualDataSource
