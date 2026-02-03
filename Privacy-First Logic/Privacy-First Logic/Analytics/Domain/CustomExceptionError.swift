//
//  CustomExceptionError.swift
//  Privacy-First Logic
//
//  Created by m47145 on 01/02/2026.
//

import Foundation

/// `CustomExceptionError`:
/// Una estructura que conforma el protocolo `Error` y actúa como un contenedor
/// para la información clave de una `NSException`. Esto facilita la manipulación
/// y el paso de los detalles del error a través de diferentes capas de la aplicación,
/// especialmente hacia el sistema de análisis y reporte de fallos.
struct CustomExceptionError: Error, Sendable { // Se añadió `Sendable` para claridad.
    /// El nombre de la excepción (ej. "NSRangeException").
    let name: String
    /// La razón o descripción del fallo. Puede ser nula si no se proporciona.
    let reason: String?
    /// Una pila de llamadas que indica la secuencia de funciones que llevaron al error.
    let callStackSymbols: [String]

    /// Una descripción localizada y humanamente legible del error.
    /// Formatea los detalles de la excepción de una manera comprensible para el diagnóstico,
    /// lo que es útil tanto para la depuración como para la generación de reportes.
    var localizedDescription: String {
        let reasonString = reason.map { "Razón: \($0)" } ?? "No se proporcionó razón"
        return "Excepción: \(name). \(reasonString). Pila de llamadas: \(callStackSymbols.joined(separator: "\n"))"
    }
}
