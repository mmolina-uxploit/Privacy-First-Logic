//
//  CrashReporterView.swift
//  Privacy-First Logic
//
//  Created by m47145 on 01/02/2026.
//

import SwiftUI

struct CrashReporterView: View {
    var body: some View {
        Button("Crash") {
            // Simula un fallo de la aplicación (desreferencia de puntero nulo).
            // Este error será capturado por el `uncaughtExceptionHandler` global,
            // que luego lo procesará y registrará de manera que respete la privacidad.
            let nullPointer: String? = nil
            _ = nullPointer!
        }
    }
}

#Preview {
    CrashReporterView()
}
