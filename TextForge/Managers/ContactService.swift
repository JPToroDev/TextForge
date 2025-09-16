//
// SettingsManager.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import Foundation

enum ContactService {
    static let mastodonURL = URL(string: "https://mastodon.social/")!

    static let emailURL: URL = {
        let recipient = "johnny.appleseed@example.com"
        let subject = "Text Forge Support Request"
        let encodedParams = "subject=\(subject)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlString = "mailto:\(recipient)?\(encodedParams)"
        return URL(string: urlString)!
    }()

    static func submitToSendFox(email: String) async -> Bool {
        let token = "myToken"
        let listID = 000000

        let url = String(format: "https://api.sendfox.com/contacts")
        guard let serviceURL = URL(string: url) else { return false }
        let parameters: [String: Any] = ["email": email, "lists": listID]

        var request = URLRequest(url: serviceURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        guard let httpBody else { return false }
        request.httpBody = httpBody
        request.timeoutInterval = 20
        let session = URLSession.shared

        do {
            let (data, _) = try await session.data(for: request)
            _ = try JSONSerialization.jsonObject(with: data, options: [])
            return true
        } catch {
            return false
        }
    }
}
