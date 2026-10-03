# empresa-retail-admin

Configuración de seguridad (usuarios, roles y permisos) para la base de datos **`empresa-retail-db`**, dividiendo las responsabilidades entre tres perfiles de trabajo: gestión de clientes (Cajas / CRM), marketing e inventario de campañas, y gerencia / auditoría.

## Objetivo

Aplicar el **principio de mínimo privilegio** en MySQL 8: cada persona recibe únicamente los permisos que necesita para su función, usando roles en lugar de asignar privilegios usuario por usuario.

## Estructura del repositorio

```
empresa-retail-admin/
├── README.md
├── .gitignore
├── docs/
│   └── Documento_Tecnico_Empresa_Retail.docx   # Informe técnico en formato APA 7
├── modelo/
│   └── empresa-retail-bd.mwb       # Modelo entidad-relación (MySQL Workbench)
└── sql/
    ├── 00_instalar_todo.sql        # Ejecuta 01 a 04 de una sola vez
    ├── 01_esquema.sql              # Base de datos, tablas y datos de prueba
    ├── 02_roles_usuarios.sql       # Creación de roles y usuarios
    ├── 03_permisos.sql             # GRANT por rol
    ├── 04_procedimientos.sql       # Procedimientos almacenados de consulta
    └── 05_verificacion.sql         # Pruebas de permisos (SHOW GRANTS y casos)
```

## Ramas

| Rama      | Contenido                                              |
|-----------|--------------------------------------------------------|
| `main`    | Rama estable (versión final aprobada).                 |
| `develop` | Rama de trabajo donde queda la solución de la actividad. |

## Modelo de datos

El esquema se construyó a partir del modelo entidad-relación `modelo/empresa-retail-bd.mwb`. Tablas de `empresa-retail-db`:

| Tabla         | Descripción                                                              |
|---------------|--------------------------------------------------------------------------|
| `cliente`     | Datos de contacto de cada cliente.                                       |
| `canal`       | Canales de marketing (Red Social, Buscador, Email).                      |
| `campania`    | Campañas con presupuesto y fechas; pertenecen a un canal.                |
| `interaccion` | Clic, visita, comentario o descarga de un cliente en una campaña.        |
| `conversion`  | Compra, registro o suscripción de un cliente, con su valor y fecha.      |

> El nombre de la base de datos lleva guiones, por lo que en SQL se escribe entre comillas invertidas: `` `empresa-retail-db` ``.

## Usuarios, roles y permisos

| Usuario          | Rol              | Permisos                                                                                   |
|------------------|------------------|--------------------------------------------------------------------------------------------|
| `ana_crm`        | `rol_ana`        | `SELECT, INSERT, UPDATE` sobre `cliente` e `interaccion` (lectura y escritura).         |
| `pedro_mkt`      | `rol_pedro`      | `SELECT, INSERT, UPDATE` sobre `canal` y `campania`; solo `SELECT` sobre `cliente`.     |
| `marta_auditoria`| `rol_marta`      | `SELECT` sobre `conversion` y `EXECUTE` sobre procedimientos almacenados de consulta.    |

## Cómo ejecutar

Requiere MySQL 8.0 o superior y una cuenta con privilegios administrativos (por ejemplo `root`).

**Opción rápida:** ejecutar `sql/00_instalar_todo.sql` (equivale a los scripts 01 a 04). En MySQL Workbench: *File > Open SQL Script*, elegir el archivo y pulsar el rayo.

**Opción por pasos:**

```bash
mysql -u root -p < sql/01_esquema.sql
mysql -u root -p < sql/02_roles_usuarios.sql
mysql -u root -p < sql/03_permisos.sql
mysql -u root -p < sql/04_procedimientos.sql
mysql -u root -p < sql/05_verificacion.sql
```

## Nota de seguridad

Las contraseñas incluidas en `02_roles_usuarios.sql` son **de práctica académica**. En un entorno real deben generarse de forma segura, almacenarse en un gestor de secretos y no subirse al repositorio.

## Autor

Proyecto académico — administración de bases de datos (octubre de 2026).
