//
// Privacy_First_LogicApp.swift
//
//  Created by m47145 on 01/02/2026.
//

import SwiftUI
import AppTrackingTransparency

@main
struct Privacy_First_LogicApp: App {
    // Instancia protegida por el modelo de actores de Swift.
    // Inicializa el adaptador con MockAnalyticsProvider para demostración.
    private var analyticsAdapter = PrivacyAwareAdapter(provider: MockAnalyticsProvider())

    init() {
        // Configura el manejador global de excepciones.
        // `GlobalExceptionHandler` intercepta excepciones no capturadas, aplica lógica de privacidad y las pasa a manejadores previos.
        GlobalExceptionHandler.setup(with: analyticsAdapter)
        
        // Solicita permiso de rastreo de AppTrackingTransparency de forma asíncrona.
        // Actualiza el estado de seguimiento del `analyticsAdapter` de forma segura.
        Task { [analyticsAdapter] in
            // Espera para asegurar que el sistema operativo muestre el diálogo.
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            let status = await ATTrackingManager.requestTrackingAuthorization()
            await analyticsAdapter.updateTrackingStatus(status)
        }
    }

    var body: some Scene {
        // `WindowGroup` es el punto de entrada principal para la UI, presentando el `ContentView`.
        WindowGroup {
            ContentView(analyticsAdapter: analyticsAdapter)
        }
    }
}
