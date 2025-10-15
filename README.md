# Todo App

Una aplicación de gestión de tareas desarrollada en Flutter con integración de Supabase para almacenamiento de datos.

## Características

- ✅ Gestión completa de tareas (CRUD)
- 📅 Selector de fechas interactivo
- 🔄 Botón de recarga para sincronizar datos
- 🎨 Interfaz moderna y atractiva
- ☁️ Almacenamiento en la nube con Supabase
- 📱 Diseño responsivo

## Tecnologías Utilizadas

- **Flutter**: Framework de desarrollo multiplataforma
- **GetX**: Gestión de estado y navegación
- **Supabase**: Base de datos y backend como servicio
- **Dart**: Lenguaje de programación

## Configuración de la Base de Datos

### Estructura de la Tabla `tasks`

Para configurar la base de datos en Supabase, ejecuta el siguiente SQL:

```sql
-- Crear la tabla tasks
CREATE TABLE tasks (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  date DATE NOT NULL,
  start_time TIMESTAMP WITH TIME ZONE NOT NULL,
  end_time TIMESTAMP WITH TIME ZONE NOT NULL,
  is_completed BOOLEAN DEFAULT FALSE,
  image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Crear índices para mejorar el rendimiento
CREATE INDEX idx_tasks_start_time ON tasks(start_time);
CREATE INDEX idx_tasks_is_completed ON tasks(is_completed);

-- Habilitar Row Level Security (RLS)
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

-- Política para permitir todas las operaciones (ajustar según necesidades de seguridad)
CREATE POLICY "Allow all operations on tasks" ON tasks
  FOR ALL USING (true);
```

### Campos de la Tabla

| Campo          | Tipo                     | Descripción                                           |
| -------------- | ------------------------ | ----------------------------------------------------- |
| `id`           | UUID                     | Identificador único de la tarea (clave primaria)      |
| `title`        | TEXT                     | Título de la tarea (requerido)                        |
| `description`  | TEXT                     | Descripción detallada de la tarea (opcional)          |
| `date`         | DATE                     | Fecha de creación de la tarea (opcional)              |
| `start_time`   | TIMESTAMP WITH TIME ZONE | Fecha y hora de inicio de la tarea                    |
| `end_time`     | TIMESTAMP WITH TIME ZONE | Fecha y hora de finalización de la tarea              |
| `is_completed` | BOOLEAN                  | Estado de completado de la tarea (por defecto: false) |
| `image_url`    | TEXT                     | URL de la imagen asociada a la tarea (opcional)       |
| `created_at`   | TIMESTAMP WITH TIME ZONE | Fecha de creación del registro                        |
| `updated_at`   | TIMESTAMP WITH TIME ZONE | Fecha de última actualización                         |

## Configuración de políticas para `storage`

```sql
-- Permitir subidas para usuarios autenticados:
CREATE POLICY "Authenticated uploads to task-images" ON storage.objects FOR INSERT TO authenticated WITH CHECK ( bucket_id = 'task-images' AND owner = auth.uid() );

-- Permitir lectura pública
CREATE POLICY "Public read for task-images" ON storage.objects FOR SELECT USING ( bucket_id = 'task-images' );
```

## Configuración del Proyecto

### 1. Configurar Variables de Entorno

Crea un archivo `.env` en la raíz del proyecto con tus credenciales de Supabase:

```env
SUPABASE_URL=tu_supabase_url_aqui
SUPABASE_ANON_KEY=tu_supabase_anon_key_aqui
```

### 2. Instalar Dependencias

```bash
flutter pub get
```

### 3. Ejecutar la Aplicación

```bash
flutter run
```

## Arquitectura del Proyecto

El proyecto sigue una arquitectura limpia con separación de responsabilidades:

```
lib/
├── core/
│   ├── config/          # Configuración de Supabase
│   ├── constants/       # Constantes de la aplicación
│   └── utils/          # Utilidades generales
├── data/
│   ├── models/         # Modelos de datos
│   └── repositories/   # Implementación de repositorios
├── domain/
│   ├── entities/       # Entidades del dominio
│   ├── repositories/   # Interfaces de repositorios
│   └── usecases/      # Casos de uso
└── presentation/
    ├── controllers/    # Controladores GetX
    ├── pages/         # Páginas de la aplicación
    └── widgets/       # Widgets reutilizables
```

## Funcionalidades Principales

### Gestión de Tareas

- **Crear**: Agregar nuevas tareas con título, descripción y horarios
- **Leer**: Visualizar tareas organizadas por fecha
- **Actualizar**: Modificar tareas existentes y marcar como completadas
- **Eliminar**: Remover tareas no deseadas

### Navegación por Fechas

- Selector de fechas intuitivo
- Carga automática de tareas por fecha seleccionada
- Indicadores visuales de días con tareas

### Sincronización

- Botón de recarga manual para sincronizar datos
- Indicadores de carga durante las operaciones
- Manejo de errores y estados de carga

## Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.
