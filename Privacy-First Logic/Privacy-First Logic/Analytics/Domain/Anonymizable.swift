//
//  Anonymizable.swift
//  Privacy-First Logic
//
//  Created by m47145 on 01/02/2026.
//

import Foundation

/// Protocolo `Anonymizable`:
/// Declara la capacidad de un objeto para generar una versión de sí mismo donde la
/// información potencialmente identificable o sensible ha sido eliminada o modificada
/// de forma irreversible para proteger la identidad del usuario.
/// Al conformar un tipo a `Anonymizable`, garantizamos que siempre tendremos un método
/// estandarizado para "sanear" nuestros datos antes de su envío a servicios externos,
/// si así lo requiere la política de privacidad o el consentimiento del usuario.
protocol Anonymizable {
    /// Devuelve una versión anonimizada del tipo que conforma el protocolo.
    /// La implementación de esta función debe asegurar que cualquier dato que pueda
    /// identificar directamente a un usuario o que sea considerado sensible sea
    /// reemplazado por valores genéricos, nulos, o hashes unidireccionales,
    /// de manera que el evento o reporte resultante no pueda ser vinculado a una persona.
    /// - Returns: Una nueva instancia del mismo tipo, con los datos sensibles anonimizados.
    func anonymized() -> Self
}
