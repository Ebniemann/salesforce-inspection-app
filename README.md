# Salesforce Inspection App

Este proyecto de Salesforce se desarrolló para practicar el desarrollo con Apex, la automatización de Salesforce y las mejores prácticas de la plataforma. Esta aplicación simula un sistema de gestión de inspecciones donde las inspecciones se asignan a los inspectores, las reglas de negocio se aplican automáticamente, se generan registros de auditoría cuando cambian las asignaciones y los clientes se actualizan mediante un flujo activado por registro.

---

## Descripción del negocio

El sistema permite gestionar inspecciones realizadas a clientes.

Cada inspección:

- Se asigna a un inspector
- Puede generar tareas automáticamente
- Registra cambios de asignación para auditoría

Relaciones principales:

- Inspection__c → Customer__c
- Inspection__c → Inspector__c
- Inspection_Audit__c → Inspection__c


### Arquitectura utilizada

Se implementó una arquitectura basada en capas:

Trigger → Handler → Service

### InspectionTrigger

Dispara la lógica en eventos de `Inspection__c`.

### InspectionHandler

Centraliza la lógica según el contexto del trigger:

- before insert
- after insert
- after update

### InspectionService

El servicio contiene toda la lógica de negocio. 
Las responsabilidades incluyen: 
- Asignar estado predeterminado. 
- Validar fechas de inspección. 
- Crear tareas. 
- Crear registros de auditoría. 
- Admitir operaciones masivas mediante colecciones.

---

## Reglas de negocio

- La fecha de inspección no puede ser anterior a hoy
- Si el estado está vacío, se asigna “Pending” automáticamente
- Se crea una tarea cuando se asigna una inspección
- Se crea una tarea cuando cambia el inspector
- Se registra auditoría cuando cambia el inspector
- Todo inspector debe tener un usuario de Salesforce asociado
- Cuando se completa una inspección, la fecha de la última inspección del cliente se actualiza automáticamente mediante un flujo activado por registro.

---

## Automatización
Apex

Las siguientes funcionalidades fueron implementadas mediante Apex:

- Trigger
- Handler
- Service Layer
- Validaciones de negocio
- Creación automática de tareas
- Registro de auditorías

Flow

Se implementó un Record-Triggered Flow que actualiza el campo Last Inspection Date del cliente cuando una inspección cambia su estado a Completed.

Esta funcionalidad fue implementada intencionalmente mediante Flow para demostrar el uso combinado de herramientas declarativas y desarrollo en Apex.

## Validación

Una regla de validación garantiza que cada registro de Inspector__c tenga un usuario de Salesforce asociado antes de poder guardarlo. Esto garantiza que las tareas creadas automáticamente siempre tengan un propietario válido.

---

## Tests

El proyecto incluye tests en Apex que validan:

- Asignación del estado por defecto.
- Generación automática de tareas
- Validación de fechas incorrectas
- Cambio de inspector
- Registro de auditorías
- Inserciones masivas (Bulk Insert)

Las pruebas utilizan:

@TestSetup
Test.startTest()
Test.stopTest()
Patrón Arrange / Act / Assert

---

## Tecnologías utilizadas

- Salesforce DX
- Apex
- Triggers
- SOQL
- Record-Triggered Flow
- Validation Rules
- Custom Objects
- Git

---



