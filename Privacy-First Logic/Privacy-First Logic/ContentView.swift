//
//  ContentView.swift
//  Privacy-First Logic
//
//  Created by m47145 on 01/02/2026.
//

import SwiftUI
import AppTrackingTransparency

struct ContentView: View {
    // Inyección de la lógica de decisión para consistencia.
    let analyticsAdapter: PrivacyAwareAdapter
    
    // Propiedades de estado para la reactividad de la interfaz.
    @State private var trackingStatusLabel: String = "Verificando..."
    @State private var statusColor: Color = .gray

    var body: some View {
        NavigationStack {
            List {
                // SECCIÓN 1: Gobernanza de Datos.
                // Muestra el resultado del permiso de privacidad de iOS.
                PrivacyStatusSectionView(
                    trackingStatusLabel: trackingStatusLabel,
                    statusColor: statusColor
                )

                // SECCIÓN 2: Laboratorio de Resiliencia.
                // Demuestra que el sistema es "ciego" por diseño sin permiso.
                CrashSimulatorSectionView(tintColor: statusColor)

                // SECCIÓN 3: Axiomas del Proyecto.
                ArchitectureExplanationSectionView()
            }
            .navigationTitle("Privacy")
            // DISPARADOR: Solicita permiso cuando la vista está lista.
            .task {
                await performPrivacyHandshake()
            }
        }
    }

    /// PROTOCOLO DE PRIVACIDAD:
    /// Sincroniza permiso de iOS, lógica del Actor y UI.
    private func performPrivacyHandshake() async {
        // Espera para asegurar que la interfaz esté lista antes del diálogo de permiso.
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        let status = await ATTrackingManager.requestTrackingAuthorization()
        
        // Sincroniza el Actor: Blinda la lógica de envío de datos.
        await analyticsAdapter.updateTrackingStatus(status)
        
        // Sincroniza la UI: Informa al usuario del estado.
        withAnimation {
            updateUI(with: status)
        }
    }

    /// TRADUCTOR DE ESTADOS:
    /// Convierte estados de Apple en lenguaje y colores comprensibles.
    private func updateUI(with status: ATTrackingManager.AuthorizationStatus) {
        switch status {
        case .authorized:
            trackingStatusLabel = "Modo Detallado (Autorizado)"
            statusColor = .green
        case .denied:
            trackingStatusLabel = "Privacidad Total (Denegado)"
            statusColor = .blue
        case .restricted:
            trackingStatusLabel = "Acceso Restringido"
            statusColor = .orange
        case .notDetermined:
            trackingStatusLabel = "Esperando Decisión"
            statusColor = .gray
        @unknown default:
            trackingStatusLabel = "Estado Desconocido"
            statusColor = .secondary
        }
    }
}

// --- PREVIEWS ---
// Permiten validar la UI en escenarios de Privacidad Total y Autorización.

#Preview("Escenario: Privacidad Total") {
    let mockProvider = MockAnalyticsProvider()
    // Inyecta estado denegado para validar protección de datos.
    let adapter = PrivacyAwareAdapter(provider: mockProvider, trackingStatus: .denied)
    ContentView(analyticsAdapter: adapter)
}

#Preview("Escenario: Modo Detallado") {
    let mockProvider = MockAnalyticsProvider()
    // Inyecta estado autorizado para validar recolección de métricas.
    let adapter = PrivacyAwareAdapter(provider: mockProvider, trackingStatus: .authorized)
    ContentView(analyticsAdapter: adapter)
}
