//
//  AnalyticsEvent.swift
//  Privacy-First Logic
//
//  Created by m47145 on 01/02/2026.
//

import Foundation

/// Protocolo `AnalyticsEvent`:
/// Sirve como un contrato para cualquier tipo que represente un evento de análisis.
/// Asegura que cada evento tenga un nombre identificativo y un diccionario de parámetros
/// asociados, lo cual es esencial para una recolección de datos coherente y procesable.
/// Los tipos que conforman este protocolo pueden ser pasados al `PrivacyAwareAdapter`
/// para ser loggeados, potencialmente después de un proceso de anonimización.
protocol AnalyticsEvent {
    /// El nombre del evento.
    /// Debe ser una cadena descriptiva que identifique de forma única el tipo de acción
    /// o suceso que el evento representa (ej. "usuario_registro", "articulo_visto").
    var name: String { get }

    /// Los parámetros asociados con el evento.
    /// Un diccionario clave-valor que contiene datos contextuales relevantes para el evento
    /// (ej. ["userId": "abc", "itemId": "123", "screenName": "ProductDetail"]).
    /// Estos parámetros son los que pueden contener información sensible y, por lo tanto,
    /// son el objetivo de la anonimización.
    var parameters: [String: Any] { get }
}
