// 
// StoreError.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import Foundation

enum StoreError: LocalizedError {
    case failedVerification
    case other(String)

    var errorDescription: String? {
        switch self {
        case .failedVerification:
            "Your purchase could not be verified by the App Store."
        case .other(let errorMessage):
            errorMessage
        }
    }
}
