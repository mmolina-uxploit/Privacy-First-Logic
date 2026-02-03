//
//  GlobalExceptionHandler.swift
//  Privacy-First Logic
//
//  Created by m47145 on 01/02/2026.
//

import Foundation
import AppTrackingTransparency // Necesario para tipos de estados, aunque no se use directamente aquí.

/// Estructura para gestionar el encadenamiento de excepciones.
/// Actúa como el Único Punto de Verdad (SSoT) para el manejo de excepciones no capturadas,
/// asegurando que la lógica de privacidad se aplique antes de pasar el control a otros handlers.
struct GlobalExceptionHandler {
    // Puntero al handler que existía antes de que nosotros llegáramos.
    // Esto permite encadenar handlers, vital para coexistir con SDKs de terceros.
    private static var previousHandler: ( @convention(c) (NSException) -> Void)?
    
    // Almacena el adaptador de privacidad de forma estática para que el handler de C pueda acceder a él.
    private static var privacyAdapter: PrivacyAwareAdapter?

    /// Configura el manejador de excepciones global con el `PrivacyAwareAdapter`.
    /// Este método intercepta las excepciones no capturadas, las procesa para el reporte
    /// de fallos con privacidad y luego devuelve el control al manejador anterior.
    /// - Parameter adapter: La instancia del `PrivacyAwareAdapter` que se utilizará
    ///   para loggear los informes de fallos de forma segura.
    static func setup(with adapter: PrivacyAwareAdapter) {
        // Asignamos el adaptador a la propiedad estática para que el closure pueda usarlo.
        GlobalExceptionHandler.privacyAdapter = adapter
        
        // 1. Guardamos el handler actual (podría ser nil o de un SDK de terceros como Firebase).
        previousHandler = NSGetUncaughtExceptionHandler()
        
        // 2. Definimos nuestro nuevo handler "Ético" que prioriza la privacidad.
        // Ahora el closure no captura contexto porque usa una propiedad estática.
        let ethicalHandler: @convention(c) (NSException) -> Void = { exception in
            // Capturamos la excepción de forma estructurada usando CustomExceptionError.
            let customError = CustomExceptionError(
                name: exception.name.rawValue,
                reason: exception.reason,
                callStackSymbols: exception.callStackSymbols
            )
            
            // Creamos un `CrashReport` con los detalles anonimizables.
            let crashReport = CrashReport(
                error: customError,
                file: "GlobalContext", // Contexto general para excepciones no capturadas.
                line: 0,
                function: "UncaughtException"
            )

            // Como el `privacyAdapter` es un Actor, usamos `Task` para llamar a su método asíncrono `log`.
            // Es importante notar que, en un crash inminente, este es un esfuerzo "best effort"
            // para loggear el reporte antes de que la aplicación finalice.
            if let adapter = GlobalExceptionHandler.privacyAdapter {
                Task {
                    await adapter.log(crashReport)
                }
            }

            // 3. LLAMAMOS AL ANTERIOR: Devolvemos el control al manejador de excepciones previo.
            // Esto asegura que otros SDKs (si los hay) puedan realizar su propio procesamiento
            // de la excepción, sin que nuestra lógica de privacidad lo impida.
            GlobalExceptionHandler.previousHandler?(exception)
        }
        
        // 4. Establecemos nuestro `ethicalHandler` como el manejador principal de excepciones no capturadas.
        NSSetUncaughtExceptionHandler(ethicalHandler)
    }
}
