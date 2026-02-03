//
//  CrashSimulatorSectionView.swift
//  Privacy-First Logic
//
//  Created by m47145 on 01/02/2026.
//

import SwiftUI

struct CrashSimulatorSectionView: View {
    let tintColor: Color
    
    var body: some View {
        Section {
            VStack(spacing: 16) {
                Text("Simulador de Fallos")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                CrashReporterView()
                    .buttonStyle(.borderedProminent)
                    .tint(tintColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
        } header: {
            Text("Pruebas de Campo")
        } footer: {
            Text("Nota: Si la luz es azul (Denegado), el reporte se 'limpia' dentro del iPhone antes de ser enviado.")
        }
    }
}

#Preview {
    List {
        CrashSimulatorSectionView(tintColor: .green)
        CrashSimulatorSectionView(tintColor: .blue)
    }
}
