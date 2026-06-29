# Salesforce Inspection App

Proyecto desarrollado con Salesforce DX para practicar desarrollo en Apex, automatizaciones con Triggers y buenas prácticas de arquitectura en la plataforma.

La aplicación simula un sistema de gestión de inspecciones, donde se asignan inspectores a distintas inspecciones, se generan tareas automáticamente y se registran auditorías cuando hay cambios.

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

---

## Lógica de negocio

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

Contiene la lógica principal del negocio:

- Asigna estado por defecto “Pending”
- Valida que la fecha de inspección no sea anterior a hoy
- Crea tareas automáticamente al asignar inspecciones
- Crea tareas cuando cambia el inspector
- Registra auditoría de cambios de inspector

---

## Reglas de negocio

- La fecha de inspección no puede ser anterior a hoy
- Si el estado está vacío, se asigna “Pending” automáticamente
- Se crea una tarea cuando se asigna una inspección
- Se crea una tarea cuando cambia el inspector
- Se registra auditoría cuando cambia el inspector
- Todo inspector debe tener un usuario de Salesforce asociado

---

## Validaciones

Se implementó una regla de validación en `Inspector__c`:

- El campo `Salesforce_User__c` es obligatorio

Esto asegura que siempre se pueda asignar correctamente la tarea a un usuario de Salesforce.

---

## Tests

El proyecto incluye tests en Apex que validan:

- Creación de inspecciones
- Generación automática de tareas
- Validación de fechas incorrectas
- Cambio de inspector
- Cobertura de lógica de negocio

Los tests siguen el patrón:

- Arrange (preparación)
- Act (ejecución)
- Assert (validación)

---

## Tecnologías utilizadas

- Apex
- Salesforce Objects
- Triggers
- Validation Rules
- Salesforce DX
- Git
- ESLint / Prettier
- Jest (configuración del proyecto)

---



