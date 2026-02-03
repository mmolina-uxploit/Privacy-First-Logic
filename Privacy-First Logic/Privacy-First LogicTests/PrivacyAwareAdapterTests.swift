//
//  PrivacyAwareAdapterTests.swift
//  Privacy-First LogicTests
//
//  Created by m47145 on 01/02/2026.
//

import XCTest
@testable import Privacy_First_Logic

/// `PrivacyAwareAdapterTests`:
/// Suite de pruebas dedicada a validar el comportamiento del `PrivacyAwareAdapter`.
/// Se utilizan mocks (`MockAnalyticsProvider`) para aislar la lógica del adaptador de las dependencias externas y simular diferentes escenarios de consentimiento de usuario.
class PrivacyAwareAdapterTests: XCTestCase {

    /// Prueba que el `PrivacyAwareAdapter` anonimiza un evento cuando el seguimiento es denegado.
    /// Este es un escenario crítico para la privacidad: si el usuario no da su consentimiento,
    /// el adaptador debe asegurar que los datos sensibles sean eliminados del evento antes de ser loggeados.
    func test_log_anonymizesEventWhenTrackingIsDenied() async { // Marcado como async
        // Given:
        // 1. Se configura un `MockAnalyticsProvider` para capturar el evento que el adaptador intentará loggear.
        let mockProvider = MockAnalyticsProvider()
        // 2. Se inicializa `PrivacyAwareAdapter` con el `mockProvider`.
        let adapter = PrivacyAwareAdapter(provider: mockProvider)
        // 3. Se simula que el usuario ha denegado el seguimiento.
        await adapter.updateTrackingStatus(.denied)
        // 4. Se crea un `CrashReport` de prueba que contiene información de un error simulado.
        let crashReport = CrashReport(error: TestError(), file: "TestFile", line: 123, function: "testFunction")

        // When:
        // Se le pide al adaptador que registre el `crashReport`.
        await adapter.log(crashReport) // Llamada asíncrona

        // Then:
        // 1. Se verifica que el nombre del evento loggeado por el mock es el esperado ("crash_report").
        XCTAssertEqual(mockProvider.loggedEvent?.name, "crash_report")
        // 2. Se extraen los parámetros del evento loggeado.
        let parameters = mockProvider.loggedEvent?.parameters
        XCTAssertNotNil(parameters)
        // 3. Se verifica que la descripción del error dentro de los parámetros
        //    es "AnonymizedError()", lo que confirma que el adaptador
        //    realizó la anonimización correctamente.
        let errorDescription = parameters?["error_description"] as? String
        XCTAssertEqual(errorDescription, "AnonymizedError()", "El error debería haber sido anonimizado a 'AnonymizedError()'.")
    }
    
    /// Prueba que el `PrivacyAwareAdapter` NO anonimiza un evento cuando el seguimiento es autorizado.
    /// Si el usuario ha dado su consentimiento, el evento debe ser loggeado tal cual, sin modificaciones.
    func test_log_doesNotAnonymizeEventWhenTrackingIsAuthorized() async { // Marcado como async
        // Given:
        let mockProvider = MockAnalyticsProvider()
        let adapter = PrivacyAwareAdapter(provider: mockProvider)
        // Se simula que el usuario ha autorizado el seguimiento.
        await adapter.updateTrackingStatus(.authorized)
        let originalError = CustomExceptionError(name: "TestException", reason: "Something went wrong", callStackSymbols: [])
        let crashReport = CrashReport(error: originalError, file: "AuthTestFile", line: 456, function: "authorizedTestFunction")

        // When:
        await adapter.log(crashReport) // Llamada asíncrona

        // Then:
        XCTAssertEqual(mockProvider.loggedEvent?.name, "crash_report")
        let parameters = mockProvider.loggedEvent?.parameters
        XCTAssertNotNil(parameters)
        // Se verifica que la descripción del error NO es `AnonymizedError`,
        // sino que contiene la descripción original del error.
        let errorDescription = parameters?["error_description"] as? String
        XCTAssertEqual(errorDescription, originalError.localizedDescription, "El error no debería haber sido anonimizado.")
    }

    /// Prueba que el `PrivacyAwareAdapter` se inicializa en un estado `.notDetermined`
    /// y actualiza correctamente su estado a `.authorized` después de una llamada.
    /// Esta prueba sigue el ciclo TDD, representando la fase "Verde" después de haber sido
    /// diseñada inicialmente para fallar y verificar la correcta actualización del estado.
    func test_adapter_startsInNotDetermined_and_updatesToAuthorized() async {
        // Given:
        let mockProvider = MockAnalyticsProvider()
        let adapter = PrivacyAwareAdapter(provider: mockProvider)

        // Then (Verificación inicial):
        // Verificamos que el estado inicial del adaptador es `.notDetermined`.
        let initialStatus = await adapter.currentTrackingStatus
        XCTAssertEqual(initialStatus, .notDetermined, "El estado inicial debería ser .notDetermined.")

        // When:
        // Se llama al método para actualizar el estado de seguimiento a `.authorized`.
        await adapter.updateTrackingStatus(.authorized)

        // Then (Verificación después de la actualización):
        // Verificamos que el estado interno del adaptador ha cambiado correctamente a `.authorized`.
        let updatedStatus = await adapter.currentTrackingStatus
        XCTAssertEqual(updatedStatus, .authorized, "El estado de seguimiento debería ser .authorized después de la actualización.")
    }
}

/// `TestError`:
/// Una estructura de error simple y privada utilizada exclusivamente para fines de prueba.
/// Implementa el protocolo `Error` y se usa para crear `CrashReport`s de prueba.
private struct TestError: Error {}

/// `MockAnalyticsProvider`:
/// Una implementación simulada del `AnalyticsProvider` utilizada en las pruebas.
/// Actúa como un "espía" (spy), capturando el último evento que se intentó loggear,
/// permitiendo a las pruebas inspeccionar el contenido del evento después de que
/// haya pasado por el `PrivacyAwareAdapter`.
private class MockAnalyticsProvider: AnalyticsProvider {
    /// Almacena el último evento que fue "loggeado" por este mock.
    var loggedEvent: AnalyticsEvent?

    /// Implementación mock del método `log`.
    /// Simplemente guarda el evento recibido en `loggedEvent` para futuras aserciones.
    /// - Parameter event: El evento de análisis recibido.
    func log(_ event: AnalyticsEvent) {
        loggedEvent = event
    }
}
