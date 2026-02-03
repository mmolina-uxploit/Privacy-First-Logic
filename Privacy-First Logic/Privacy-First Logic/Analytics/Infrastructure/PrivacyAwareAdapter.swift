//
//  PrivacyAwareAdapter.swift
//  Privacy-First Logic
//
//  Created by m47145 on 01/02/2026.
//

import Foundation
import AppTrackingTransparency

/// `PrivacyAwareAdapter`: Ahora implementado como un Actor para garantizar
/// aislamiento de datos y seguridad de hilos nativa en Swift 6.
actor PrivacyAwareAdapter {
    private let provider: AnalyticsProvider
    private var trackingStatus: ATTrackingManager.AuthorizationStatus = .notDetermined

    /// Propiedad pública que expone el estado actual de seguimiento.
    public var currentTrackingStatus: ATTrackingManager.AuthorizationStatus {
        trackingStatus
    }

    /// 1. INICIALIZADOR DE PRODUCCIÓN
    init(provider: AnalyticsProvider) {
        self.provider = provider
    }

    /// 2. INICIALIZADOR DE INYECCIÓN (Necesario para Previews y Tests)
    /// Este resuelve el error "Extra argument 'trackingStatus' in call"
    init(provider: AnalyticsProvider, trackingStatus: ATTrackingManager.AuthorizationStatus) {
        self.provider = provider
        self.trackingStatus = trackingStatus
    }

    /// Actualiza el estado de seguimiento de forma segura.
    func updateTrackingStatus(_ status: ATTrackingManager.AuthorizationStatus) {
        self.trackingStatus = status
        print("Estado de seguimiento ATT actualizado a: \(status.description)")
    }

    /// Registra un evento aplicando la lógica de "Privacidad Primero".
    func log(_ event: AnalyticsEvent & Anonymizable) {
        switch trackingStatus {
        case .authorized:
            provider.log(event)
        default:
            // Aplicamos anonimización preventiva si no hay permiso explícito.
            provider.log(event.anonymized())
        }
    }
}

// Extensión para imprimir estados legibles en consola.
extension ATTrackingManager.AuthorizationStatus: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
        case .notDetermined: return "No Determinado"
        case .restricted: return "Restringido"
        case .denied: return "Denegado"
        case .authorized: return "Autorizado"
        @unknown default: return "Desconocido"
        }
    }
}
