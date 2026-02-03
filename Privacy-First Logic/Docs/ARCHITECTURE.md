# ARCHITECTURE · Privacy-First Logic

> Este documento describe las **decisiones arquitectónicas fundamentales** del sistema **Privacy-First Logic**.

---

## Contexto del problema

Privacy-First Logic es un sistema construido para demostrar cómo integrar analíticas y servicios externos sin comprometer la privacidad del usuario.

El proyecto aborda problemas recurrentes en aplicaciones modernas:

- integración progresiva de SDKs externos,
- dispersión de lógica de consentimiento,
- exposición innecesaria de datos,
- crecimiento de superficie de ataque,
- acumulación de deuda de privacidad.

Aunque el sistema puede comenzar siendo simple, la arquitectura asume desde el inicio que:

- nuevos servicios externos serán integrados,
- el número de eventos y flujos crecerá,
- la lógica de tracking tenderá a dispersarse,
- equipos y responsables cambiarán,
- decisiones de privacidad se degradarán sin control explícito.

La arquitectura existe para **proteger la privacidad frente al cambio**.

---

## Principios arquitectónicos

### 1. Gestión del cambio

La arquitectura asume que nuevas integraciones y requisitos aparecerán.

No intenta impedir cambios, sino **limitar su impacto sobre la privacidad**.

Decisiones centrales:

- centralizar decisiones de privacidad,
- encapsular acceso a datos sensibles,
- definir contratos explícitos,
- impedir bypass locales de consentimiento.

El cambio solo es válido cuando es **consciente y gobernado**.

---

### 2. Privacidad como invariante estructural

La privacidad no es opcional ni configurable por implementación local.

Reglas estructurales:

- la lógica de negocio no accede directamente a PII,
- el consentimiento controla el envío de datos,
- solo se recolecta información necesaria,
- la anonimización ocurre antes de abandonar el dispositivo.

Romper estas reglas introduce deuda de privacidad.

---

### 3. Fronteras explícitas

Las fronteras existen únicamente si están codificadas.

En Privacy-First Logic se expresan mediante:

- adaptadores entre dominio y SDKs,
- encapsulación del tracking,
- centralización del manejo de excepciones,
- separación entre lógica de negocio y servicios externos.

Si un módulo puede enviar datos sin pasar por estas fronteras, la arquitectura falla.

---

## Separación de intención y ejecución

La arquitectura separa:

- **Intención de negocio:** eventos, acciones y flujos del sistema.
- **Ejecución técnica:** envío, anonimización o bloqueo de datos.

Esto permite que:

- la lógica de aplicación permanezca independiente,
- la implementación de analíticas pueda cambiar,
- nuevas regulaciones no requieran reescribir el dominio.

La ejecución técnica implementa la intención, no la redefine.

---

## Capas del sistema

### Dominio

Capa más estable del sistema.

Responsabilidades:

- definir eventos y casos de uso,
- establecer contratos de tracking,
- modelar políticas de privacidad,
- permanecer independiente de SDKs externos.

Restricciones:

- no conoce proveedores de analíticas,
- no accede a APIs externas,
- no gestiona consentimiento directamente.

Un cambio aquí es estructural.

---

### Infrastructure Layer

Implementa contratos definidos por el dominio.

Responsabilidades:

- integrar SDKs externos,
- aplicar anonimización,
- gestionar almacenamiento y red,
- consultar estado de consentimiento.

Componentes típicos:

- `PrivacyAwareAdapter`
- proveedores de analytics
- servicios de persistencia

Esta capa puede cambiar sin afectar al dominio.

---

### Application Layer

Orquesta flujos y casos de uso.

Responsabilidades:

- coordinar interacción entre UI y dominio,
- ejecutar eventos de negocio,
- activar tracking sin conocer detalles de privacidad.

Restricción clave:

- no implementa lógica de anonimización ni consentimiento.

---

### Governance Layer

Capa transversal de control.

Responsabilidades:

- impedir integraciones que ignoren privacidad,
- centralizar decisiones estructurales,
- facilitar auditoría técnica.

Incluye:

- revisión de integraciones,
- validaciones de consentimiento,
- control de manejo de excepciones.

La gobernanza evita degradación silenciosa.

---

## Componentes estructurales

### PrivacyAwareAdapter

Contrato entre aplicación y proveedores externos.

Responsabilidades:

- verificar consentimiento,
- anonimizar datos cuando es necesario,
- bloquear envío cuando no hay autorización,
- serializar accesos concurrentes.

Actúa como frontera obligatoria para tracking.

---

### GlobalExceptionHandler

Fuente única de manejo de errores no capturados.

Responsabilidades:

- interceptar fallos,
- anonimizar datos sensibles,
- delegar reporte a servicios externos.

Evita fuga accidental de datos en reportes de crash.

---

### Protocolo Anonymizable

Define cómo anonimizar datos sensibles.

Garantiza que cualquier estructura enviada fuera del sistema pueda limpiarse antes del envío.

---

## Invariantes arquitectónicas

Estas condiciones no deben romperse:

- ningún módulo envía datos sin pasar por adaptadores,
- la lógica de negocio no accede a datos personales,
- el consentimiento controla tracking y envío,
- servicios externos están encapsulados,
- anonimización ocurre antes del envío.

Si estas reglas se rompen, el sistema pierde garantías de privacidad.

---

## Relación con la implementación

SwiftUI, SDKs de analytics o frameworks de red son **detalles de implementación**.

La arquitectura no depende de ellos; ellos deben adaptarse a la arquitectura.

Cuando existe tensión entre rapidez de integración y claridad estructural,  
la claridad estructural tiene prioridad.

---

## Decisiones reversibles y protegidas

### Reversibles

- proveedor de analytics,
- implementación concreta de adaptadores,
- detalles de concurrencia,
- frameworks UI o de red.

### Protegidas

- contratos de privacidad,
- encapsulación de tracking,
- invariantes de consentimiento,
- separación dominio-infraestructura.

La arquitectura protege lo costoso de cambiar.

---

## Síntesis

La arquitectura de Privacy-First Logic no busca simplificar la integración inicial de servicios externos.

Busca **preservar privacidad y coherencia a largo plazo**.

Si cambian los SDKs, la privacidad permanece.  
Si cambia la implementación, el control del usuario permanece.

El sistema cumple su objetivo cuando puede evolucionar  
sin introducir fugas de datos ni deuda de privacidad silenciosa.

