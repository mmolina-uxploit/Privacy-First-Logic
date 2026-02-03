//
//  CrashReport.swift
//  Privacy-First Logic
//
//  Created by m47145 on 01/02/2026.
//

import Foundation

/// `CrashReport`:
/// Una estructura que representa un informe de fallo en la aplicación. Contiene
/// detalles del error, la ubicación del código donde ocurrió y conforma a los
/// protocolos `AnalyticsEvent` y `Anonymizable`. Esto permite que los informes de fallos
/// sean tratados como eventos de análisis y que puedan ser anonimizados
/// cuando las políticas de privacidad así lo requieran.
struct CrashReport: AnalyticsEvent, Anonymizable {
    /// El objeto `Error` que describe la causa del fallo. Puede ser un `CustomExceptionError`
    /// o cualquier otro tipo de error.
    let error: Error
    /// El nombre del archivo donde ocurrió el fallo.
    let file: String
    /// El número de línea en el archivo donde se produjo el fallo.
    let line: Int
    /// El nombre de la función donde se originó el fallo.
    let function: String

    /// El nombre del evento de análisis para un informe de fallo.
    /// Siempre será "crash_report", lo que permite identificar fácilmente
    /// este tipo de evento en los sistemas de análisis.
    var name: String {
        return "crash_report"
    }

    /// Los parámetros asociados con el informe de fallo.
    /// Este diccionario incluye la ubicación del fallo y una descripción del error.
    /// La descripción del error se adapta si el error es un `CustomExceptionError`
    /// para proporcionar más detalles.
    var parameters: [String: Any] {
        var params: [String: Any] = [
            "location": "\(file):\(line) - \(function)"
        ]

        if let customError = error as? CustomExceptionError {
            params["error_description"] = customError.localizedDescription
            // Opcionalmente, se podrían añadir más detalles de customError aquí,
            // siempre considerando las implicaciones de privacidad.
        } else {
            params["error_description"] = String(describing: error)
        }

        return params
    }

    /// Devuelve una versión anonimizada del informe de fallo.
    /// Esta función es clave para la privacidad. Cuando un informe de fallo necesita
    /// ser anonimizado, se crea una nueva instancia de `CrashReport` donde el error
    /// original es reemplazado por un `AnonymizedError`. Esto asegura que los detalles
    /// específicos del fallo, que podrían contener información sensible, no sean transmitidos,
    /// mientras que la existencia de un fallo y su ubicación general aún pueden ser registrados.
    /// - Returns: Un `CrashReport` con la información del error anonimizada.
    func anonymized() -> CrashReport {
        return CrashReport(
            error: AnonymizedError(), // Reemplaza el error original con uno genérico y anonimizado.
            file: file,
            line: line,
            function: function
        )
    }
}

/// `AnonymizedError`:
/// Una estructura de error simple que se utiliza como marcador de posición
/// para representar un error que ha sido deliberadamente anonimizado.
/// Implementa el protocolo `Error` pero no contiene detalles específicos
/// que puedan comprometer la privacidad. Es un componente integral en el proceso
/// de anonimización de `CrashReport`.
struct AnonymizedError: Error {}
