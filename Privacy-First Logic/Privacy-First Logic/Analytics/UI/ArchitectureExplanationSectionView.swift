//
//  ArchitectureExplanationSectionView.swift
//  Privacy-First Logic
//
//  Created by m47145 on 01/02/2026.
//

import SwiftUI

///Componente de UI que explica la filosofía de diseño y arquitectura "Ciega" del proyecto.
struct ArchitectureExplanationSectionView: View {
    @State private var showDetailInfo: Bool = false
    
    var body: some View {
        Section {
            Button {
                withAnimation { showDetailInfo.toggle() }
            } label: {
                Label("¿Qué es la Arquitectura Ciega?", systemImage: "shield.lefthalf.filled")
                    .font(.subheadline)
            }
            
            if showDetailInfo {
                Text("Es un diseño donde el código es incapaz de filtrar datos privados. El 'PrivacyAwareAdapter' intercepta el error y, si no hay permiso, usa el protocolo 'Anonymizable' para destruir cualquier rastro de identidad.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .transition(.opacity)
            }
        } header: {
            Text("Arquitectura")
        }
    }
}

#Preview {
    List {
        ArchitectureExplanationSectionView()
    }
}
