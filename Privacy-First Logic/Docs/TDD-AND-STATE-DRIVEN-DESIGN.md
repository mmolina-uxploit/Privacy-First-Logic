# TDD-AND-STATE-DRIVEN-DESIGN · Privacy-First Logic

> Este documento define cómo TDD y el diseño guiado por estado actúan como mecanismos estructurales en Privacy-First Logic.
>
> Los tests no validan solo comportamiento: codifican contratos e invariantes de privacidad.

---

## Rol del Test en el Sistema

Un test funciona como documentación ejecutable del sistema.

- define comportamientos aceptables,
- establece límites explícitos al cambio,
- previene regresiones en el manejo de datos,
- convierte decisiones de privacidad en contratos verificables.

Los tests describen qué no puede romperse, no cómo se implementa.

---

## Tests como contratos de privacidad

El sistema modela reglas de circulación de datos, no interfaces visuales.

Por lo tanto, los tests:

- no prueban layouts,
- no prueban estilos,
- no prueban frameworks.

Prueban que:

- los datos sensibles no se envían sin consentimiento,
- la anonimización ocurre cuando corresponde,
- ningún flujo ignora el estado de consentimiento,
- las decisiones de privacidad son verificables.

---

## Ejemplo central: PrivacyAwareAdapter como contrato

El siguiente test define un contrato mínimo: los eventos deben anonimizarse cuando el seguimiento no está autorizado.

```swift
import XCTest
@testable import Privacy_First_Logic

final class PrivacyAwareAdapterTests: XCTestCase {

    func test_eventsAreAnonymizedWhenTrackingDenied() async {
        let provider = MockAnalyticsProvider()
        let adapter = PrivacyAwareAdapter(provider: provider)

        await adapter.updateTrackingStatus(.denied)

        let crashReport = CrashReport(
            error: TestError(),
            file: "Test",
            line: 1,
            function: "test"
        )

        await adapter.log(crashReport)

        let description = provider.loggedEvent?
            .parameters?["error_description"] as? String

        XCTAssertEqual(description, "AnonymizedError()")
    }
}
```

## Este contrato asegura

- los datos no autorizados se anonimizan,
- el flujo de envío es verificable,
- la decisión depende únicamente del consentimiento.

---

## Diseño Guiado por Estado

El comportamiento del sistema depende únicamente del estado de consentimiento.

Este estado determina:

- si los datos pueden procesarse,
- si pueden enviarse,
- si deben anonimizarse,
- o si deben bloquearse.

No se permite lógica implícita fuera de este control.

---

## Estado y concurrencia

El estado debe:

- actualizarse mediante transiciones explícitas,
- permanecer consistente bajo concurrencia,
- evitar comportamientos no deterministas en el manejo de datos.

---

## Tests como gobernanza del cambio

Cada corrección o mejora en privacidad debe introducir un test.

Las garantías del sistema permanecen estables mientras la implementación evoluciona.

---

## Conclusión

En Privacy-First Logic, TDD y el diseño guiado por estado son mecanismos que aseguran:

- comportamiento predecible,
- circulación controlada de datos,
- preservación de garantías de privacidad a largo plazo.
