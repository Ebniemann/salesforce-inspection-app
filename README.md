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
- before update

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

<img width="984" height="721" alt="Captura de pantalla 2026-07-14 a la(s) 3 06 18 p  m" src="https://github.com/user-attachments/assets/a2c6d25e-82b2-4344-8d68-0dacf0e0eaab" />

<img width="1019" height="576" alt="Captura de pantalla 2026-07-14 a la(s) 3 09 09 p  m" src="https://github.com/user-attachments/assets/ab195688-4bae-4b42-8b63-8fecec91ea2a" />

<img width="478" height="620" alt="Captura de pantalla 2026-07-14 a la(s) 3 08 43 p  m" src="https://github.com/user-attachments/assets/535e1c19-1a3a-4132-aa04-7c0e62607ef4" />

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

<img width="435" height="695" alt="Captura de pantalla 2026-07-14 a la(s) 1 41 00 p  m" src="https://github.com/user-attachments/assets/b64c2389-9a3a-4cb2-b739-52295e048654" />


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

<img width="1109" height="423" alt="Captura de pantalla 2026-07-14 a la(s) 1 24 07 p  m" src="https://github.com/user-attachments/assets/92484ba8-9a57-4c77-a8a8-2c901f4f03ae" />

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



