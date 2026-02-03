//
//  MockAnalyticsProvider.swift
//  Privacy-First Logic
//
//  Created by m47145 on 01/02/2026.
//

import Foundation

/// `MockAnalyticsProvider`:
/// Una implementación de ejemplo del `AnalyticsProvider` que simplemente imprime
/// los eventos recibidos en la consola de depuración. Esto es útil para:
/// - **Desarrollo:** Ver inmediatamente qué eventos se están registrando y con qué parámetros.
/// - **Pruebas:** Asegurar que la lógica de la aplicación envía los eventos correctos
///   después de pasar por el `PrivacyAwareAdapter`.
/// - **Demostración:** Ilustrar el flujo de datos sin necesidad de configurar un backend
///   de análisis real.
class MockAnalyticsProvider: AnalyticsProvider {
    /// Simula el registro de un evento de análisis.
    /// En lugar de enviar el evento a un servicio externo, esta función imprime
    /// el nombre y los parámetros del evento en la consola. Esto nos permite
    /// observar el resultado de la anonimización y el formato del evento
    /// sin transmitir información sensible.
    /// - Parameter event: El evento de análisis (ya procesado por la lógica de privacidad) a "registrar".
    func log(_ event: AnalyticsEvent) {
        print("Evento registrado (Mock): \(event.name) con parámetros: \(event.parameters)")
    }
}
