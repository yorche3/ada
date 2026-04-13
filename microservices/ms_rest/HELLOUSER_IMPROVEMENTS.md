# HelloUser Microservice - Especificación y Documentación

## Descripción del Microservicio
El microservicio HelloUser expone un endpoint REST que recibe un objeto JSON con un nombre de usuario y responde con un saludo personalizado. Implementa validaciones robustas, logging profesional, y pruebas unitarias automatizadas.

## Endpoint Principal
`POST /hellouser/hello`

### Parámetros de Entrada
```json
{
  "name": "Nombre del usuario (máximo 50 caracteres)"
}
```

### Validaciones Implementadas
1. **Invalid_Format**: JSON malformado (body vacío, sintaxis incorrecta)
2. **Missing_Field**: Falta el campo "name" en el objeto JSON
3. **Empty_Value**: Campo "name" está vacío o solo contiene espacios en blanco
4. **Invalid_Length**: Nombre excede 50 caracteres
5. **Invalid_Format (tipo)**: Campo "name" no es de tipo string (ej: número, booleano)

### 2. Manejo de Errores (`error_response.ads` y `error_response.adb`)
- Mensajes de error genéricos que NO filtran lógica interna
- Mapeo de errores de validación a códigos HTTP apropiados
- Respuestas consistentes en formato JSON

### 3. Refactorización de HelloUser (`hellouser.adb`)
- Código más limpio y mantenible
- Separación de responsabilidades
- Manejo de excepciones mejorado

## Tipos de Respuesta

### Éxito (HTTP 200)
```json
{
  "message": "Hello, [nombre]!"
}
```

### Errores (sin filtrar lógica interna)

#### Invalid_Format (HTTP 400)
- JSON malformado, sintaxis incorrecta, tipo incorrecto para "name"
```json
{
  "error": "Invalid request format"
}
```

#### Missing_Field (HTTP 400)
- Falta el campo "name" en el objeto JSON
```json
{
  "error": "Required data is missing"
}
```

#### Empty_Value / Invalid_Length (HTTP 400)
- Nombre vacío, solo espacios, o excede 50 caracteres
```json
{
  "error": "Invalid input provided"
}
```

#### Server_Error (HTTP 500)
- Error interno no controlado
```json
{
  "error": "Internal server error"
}
```

## Casos de Prueba Implementados

### Peticiones Válidas

#### 1. Nombre válido simple
```bash
curl -X POST http://localhost:8080/hellouser/hello \
  -H "Content-Type: application/json" \
  -d '{"name": "Juan"}'
```

**Respuesta:** `200 OK`
```json
{
  "message": "Hello, Juan!"
}
```

#### 2. Nombre con espacios (trim automático)
```bash
curl -X POST http://localhost:8080/hellouser/hello \
  -H "Content-Type: application/json" \
  -d '{"name": "  María  "}'
```

**Respuesta:** `200 OK`
```json
{
  "message": "Hello, María!"
}
```

#### 3. Nombre con máximo de caracteres (50)
```bash
curl -X POST http://localhost:8080/hellouser/hello \
  -H "Content-Type: application/json" \
  -d '{"name": "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ"}'
```

**Respuesta:** `200 OK`
```json
{
  "message": "Hello, ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ!"
}
```

### Peticiones Inválidas

#### 4. JSON vacío/body vacío
```bash
curl -X POST http://localhost:8080/hellouser/hello \
  -H "Content-Type: application/json" \
  -d ''
```

**Respuesta:** `400 Bad Request`
```json
{
  "error": "Invalid request format"
}
```

#### 5. Falta campo "name"
```bash
curl -X POST http://localhost:8080/hellouser/hello \
  -H "Content-Type: application/json" \
  -d '{"age": 30}'
```

**Respuesta:** `400 Bad Request`
```json
{
  "error": "Required data is missing"
}
```

#### 6. Nombre vacío
```bash
curl -X POST http://localhost:8080/hellouser/hello \
  -H "Content-Type: application/json" \
  -d '{"name": ""}'
```

**Respuesta:** `400 Bad Request`
```json
{
  "error": "Invalid input provided"
}
```

#### 7. Solo espacios en blanco
```bash
curl -X POST http://localhost:8080/hellouser/hello \
  -H "Content-Type: application/json" \
  -d '{"name": "   "}'
```

**Respuesta:** `400 Bad Request`
```json
{
  "error": "Invalid input provided"
}
```

#### 8. Nombre demasiado largo (51+ caracteres)
```bash
curl -X POST http://localhost:8080/hellouser/hello \
  -H "Content-Type: application/json" \
  -d '{"name": "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZA"}'
```

**Respuesta:** `400 Bad Request`
```json
{
  "error": "Invalid input provided"
}
```

#### 9. JSON malformado
```bash
curl -X POST http://localhost:8080/hellouser/hello \
  -H "Content-Type: application/json" \
  -d 'not json at all'
```

**Respuesta:** `400 Bad Request`
```json
{
  "error": "Invalid request format"
}
```

#### 10. Tipo incorrecto para "name" (número)
```bash
curl -X POST http://localhost:8080/hellouser/hello \
  -H "Content-Type: application/json" \
  -d '{"name": 123}'
```

**Respuesta:** `400 Bad Request`
```json
{
  "error": "Invalid request format"
}
```

## Sistema de Logging Profesional

### Configuración con GNATCOLL.Traces
El microservicio implementa logging robusto usando GNATCOLL.Traces con:

1. **Archivo de configuración**: `.gnatdebug`
2. **Archivos de log**: `ms_rest.log` (por defecto)
3. **Niveles configurables**:
   - `MS_REST.DEBUG`: Depuración (desactivado por defecto)
   - `MS_REST.INFO`: Información general
   - `MS_REST.WARNING`: Advertencias
   - `MS_REST.ERROR`: Errores

### Logs generados por endpoint
```
[INFO] ms_rest starting on port 8080
[INFO] ms_rest server started, waiting for requests
[DEBUG] Incoming request: /hellouser/hello
[INFO] GET /hellouser/hello
[INFO] Valid request for user: Juan
[WARNING] Empty request body received
[WARNING] Validation error: INVALID_FORMAT
[ERROR] Unhandled exception: ...
```

## Pruebas Unitarias Implementadas

### Suite de Tests (AUnit)
Los tests se ejecutan con `alr test` y cubren los 10 casos de prueba mostrados arriba.

#### Tests implementados:
1. **Test_Valid_Name** - Nombre válido simple
2. **Test_Empty_Body** - JSON vacío
3. **Test_Missing_Name_Field** - Falta campo "name"
4. **Test_Empty_Name_Value** - Nombre vacío
5. **Test_Name_Whitespace_Only** - Solo espacios en blanco
6. **Test_Name_Too_Long** - 51+ caracteres
7. **Test_Name_Max_Length** - Exactamente 50 caracteres
8. **Test_Malformed_JSON** - JSON malformado
9. **Test_Name_Not_String** - "name" no es string
10. **Test_Get_Name_Trims_Spaces** - Trim automático
11. **Test_Is_Valid_User** - Validación de usuario

### Ejecución de Tests
```bash
# Ejecutar todos los tests
alr test

# Ejecutar manualmente
./test.sh

# Construir y ejecutar directamente
gprbuild -P ms_rest_tests.gpr && ./bin/run_tests
```

## Arquitectura y Ventajas

### Estructura de Archivos
```
src/hellouser/
├── hello_user.ads              # Interfaz principal
├── hello_user.adb              # Implementación con logging
├── user_protocols.ads          # Record User y validaciones
├── user_protocols.adb          # Implementación parsing/validation
├── error_response.ads          # Manejo de respuestas de error
└── error_response.adb          # Implementación de respuestas

config/
├── ms_rest_config.gpr          # Configuración de compilación
└── .gnatdebug                  # Configuración de logging

test/
├── run_tests.adb               # Driver principal AUnit
├── hellouser/ispec/            # Especificaciones de tests
│   ├── hellouser_suite.ads     # Suite de pruebas
│   └── user_protocols_test.ads # Tests User_Protocols
└── hellouser/impl/            # Implementaciones de tests
    ├── hellouser_suite.adb    # Registro de tests
    └── user_protocols_test.adb # Tests implementados
```

### Ventajas de la Implementación
1. **Seguridad**: Mensajes de error sin detalles internos
2. **Mantenibilidad**: Código modular y pruebas automatizadas
3. **Robustez**: Validaciones exhaustivas (11 casos de prueba)
4. **Observabilidad**: Logging profesional con GNATCOLL.Traces
5. **Escalabilidad**: Fácil extensión para nuevos campos
6. **Consistencia**: Formato uniforme de respuestas
7. **Testabilidad**: Cobertura completa de casos de uso
8. **Integración**: Ejecución automática con `alr test`

### Mapeo Validación → Error
| Validación               | Código Error     | HTTP Status | Respuesta JSON                  |
|--------------------------|------------------|-------------|---------------------------------|
| Invalid_Format          | Bad_Request      | 400         | {"error": "Invalid request format"} |
| Missing_Field           | Missing_Data     | 400         | {"error": "Required data is missing"} |
| Empty_Value             | Invalid_Input    | 400         | {"error": "Invalid input provided"} |
| Invalid_Length          | Invalid_Input    | 400         | {"error": "Invalid input provided"} |
| Error interno           | Server_Error     | 500         | {"error": "Internal server error"} |

## Dependencias del Proyecto
```toml
[[depends-on]]
aws = "^24.0.0"        # Servidor web AWS
[[depends-on]]
gnatcoll = "^24.0.0"    # Logging con GNATCOLL.Traces
[[depends-on]]
aunit = "^26.0.0"       # Framework de pruebas
```