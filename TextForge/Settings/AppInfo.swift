//
// AppInfo.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import SwiftUI

struct AppInfo: View {
    @AppStorage(.hasSubscribedToNewsletter) private var hasSubscribed = false
    @State private var email = ""

    private let year: Int = {
        let calendar = Calendar.current
        let year = calendar.dateComponents([.year], from: .now).year
        return year ?? 2023
    }()

    private let versionNumber: String = {
        let mainBundle = Bundle.main
        let version = mainBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        return version as? String ?? "1.0"
    }()

    private let headingGradient = LinearGradient(colors: [.blue, .pink], startPoint: .leading, endPoint: .trailing)

    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                appIcon
                appDetails
            }

            Divider()
            newsletterSignUp
        }
    }

    private var appIcon: some View {
        Image(nsImage: .init(named: "AppIcon")!)
            .resizable()
            .frame(width: 75, height: 75)
    }

    private var appDetails: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("Text Forge")
                .fontWeight(.semibold)
                .font(.title2)
                .padding(.bottom, -3)
            Text("Version \(versionNumber)")
                .font(.system(.body).smallCaps())
                .foregroundStyle(.secondary)
            Text("© \(year, format: .number.grouping(.never)) [J.P. Toro](https://jptoro.dev)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var newsletterSignUp: some View {
        HStack {
            Text("Newsletter")
                .font(.title3.smallCaps())
                .fontWeight(.bold)
                .foregroundStyle(headingGradient)

            if hasSubscribed {
                Text("Subscribed! 🎉")
            } else {
                TextField("Email", text: $email, prompt: Text("Join J.P. Toro’s Newsletter"))
                    .textFieldStyle(.roundedBorder)
                Button("Send", systemImage: "paperplane", action: subscribe)
                    .labelStyle(.iconOnly)
            }
        }
    }

    private func subscribe() {
        Task {
            let success = await ContactService.submitToSendFox(email: email)
            hasSubscribed = success
            email = ""
        }
    }
}
