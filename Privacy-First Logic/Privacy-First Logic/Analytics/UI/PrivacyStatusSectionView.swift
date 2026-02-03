//
//  PrivacyStatusSectionView.swift
//  Privacy-First Logic
//
//  Created by m47145 on 01/02/2026.
//

/// Componente de UI para mostrar el estado de gobernanza de datos, basado en el permiso de App Tracking Transparency (ATT).
import SwiftUI

struct PrivacyStatusSectionView: View {
    let trackingStatusLabel: String
    let statusColor: Color
    
    var body: some View {
        Section {
            HStack(spacing: 15) {
                Circle()
                    .fill(statusColor)
                    .frame(width: 14, height: 14)
                    .shadow(color: statusColor.opacity(0.4), radius: 4)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(trackingStatusLabel)
                        .font(.headline)
                    Text("Estado del App Tracking Transparency")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 8)
        } header: {
            Text("Gobernanza de Datos")
        }
    }
}

#Preview {
    List {
        PrivacyStatusSectionView(trackingStatusLabel: "Modo Detallado (Autorizado)", statusColor: .green)
        PrivacyStatusSectionView(trackingStatusLabel: "Privacidad Total (Denegado)", statusColor: .blue)
    }
}
