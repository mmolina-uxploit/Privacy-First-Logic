//
//  AnalyticsProvider.swift
//  Privacy-First Logic
//
//  Created by m47145 on 01/02/2026.
//

import Foundation

/// Protocolo `AnalyticsProvider`:
/// Define la interfaz mínima que cualquier proveedor de análisis debe implementar.
/// Al usar un protocolo, podemos intercambiar fácilmente diferentes servicios de análisis
/// (por ejemplo, Firebase, Amplitude, un servicio personalizado) sin modificar la lógica central
/// de la aplicación, lo que es crucial para mantener la flexibilidad y la capacidad de adaptación
/// en un sistema de privacidad primero.
protocol AnalyticsProvider {
    /// Registra un evento de análisis.
    /// Este método es el punto de entrada para que el adaptador de privacidad envíe
    /// datos de eventos al proveedor de análisis subyacente. La implementación de este método
    /// en un proveedor concreto se encargará de traducir y enviar el `AnalyticsEvent`
    /// al servicio externo, después de que la capa de privacidad haya realizado su trabajo.
    /// - Parameter event: El evento de análisis a registrar, ya anonimizado o procesado por la lógica de privacidad.
    func log(_ event: AnalyticsEvent)
}
