<p align="center">
  <img width="250" height="250" alt="text-forge-app-icon" src="https://github.com/user-attachments/assets/7b760495-4920-4780-8793-8751d2ce2a49" />
</p>


<h1 align="center">Text Forge</h1>

<p align="center">
  <strong>A simple, production-ready SwiftUI text expander for macOS</strong>
</p>

<p align="center">
  <a href="https://swift.org">
	<img src="https://img.shields.io/badge/Swift-6.0-orange.svg?style=flat" alt="Swift 6.0">
  </a>
  <a href="https://developer.apple.com/macos/">
	<img src="https://img.shields.io/badge/macOS-13.3+-blue.svg?style=flat" alt="macOS 13.3+">
  </a>
  <a href="https://opensource.org/licenses/MIT">
	<img src="https://img.shields.io/badge/License-MIT-yellow.svg?style=flat" alt="MIT License">
  </a>
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#installation">Installation</a> •
  <a href="#architecture">Architecture</a> •
  <a href="#resources">Resources</a>
</p>

---

## 🛠️ Overview

**Text Forge** is a SwiftUI text expander that showcases how to build modern macOS apps while maintaining excellent backwards compatibility (macOS 13.3). Built with Swift 6’s strict concurrency, it’s both a working app and a practical reference for developers.

Whether you’re figuring out Core Data with CloudKit sync, building custom inspectors for older macOS versions, or bridging `NSTextView` into SwiftUI, Text Forge demonstrates patterns you can use with ease in your own projects.

## ✨ Features

### Core Functionality
- **📝 Rich Text Editing** — Full-featured text editor with tokenized input using NSTextView
- **☁️ iCloud Sync** — Seamless document synchronization via Core Data + CloudKit
- **🎨 Markdown Support** — Native markdown styling with AttributedString formatting
- **💰 In-App Purchases** — Complete StoreKit 2 integration for tips and premium features
- **🔤 System Font Picker** — Native font selection through NSFontManager

### Developer Highlights
- **Swift 6 Strict Concurrency** — Built with default isolation on the `@MainActor`
- **Backwards Compatibility** — Supports macOS 13.3+ while leveraging modern APIs where available
- **Best Practices** — Simple, tested solutions for common macOS development challenges

## 📸 Screenshots

<p align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://github.com/user-attachments/assets/42c93fb5-22f6-49bc-94d1-83894a4c2f56">
  <source media="(prefers-color-scheme: light)" srcset="https://github.com/user-attachments/assets/dcfaf961-6f7c-49b3-a6be-2d166559ac42">
  <img alt="Text builder interface" src="https://github.com/user-attachments/assets/dcfaf961-6f7c-49b3-a6be-2d166559ac42">
</picture>
   <br>
 <em>Text builder interface</em>
</p>

<p align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://github.com/user-attachments/assets/8f8c9c71-cd3b-4694-ade5-59452d177370">
  <source media="(prefers-color-scheme: light)" srcset="https://github.com/user-attachments/assets/95ba15b3-0d0a-4fd2-aeda-06674be71c8f">
  <img alt="template builder interface with text tokens and custom inspector" src="https://github.com/user-attachments/assets/95ba15b3-0d0a-4fd2-aeda-06674be71c8f">
</picture>
   <br>
 <em>Template builder interface with text tokens and custom inspector</em>
</p>

<p align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://github.com/user-attachments/assets/27610258-0a92-4781-bfae-af2809691691">
  <source media="(prefers-color-scheme: light)" srcset="https://github.com/user-attachments/assets/4f7533eb-e612-456b-a6f0-06ede79a583b">
  <img alt="settings screens" src="https://github.com/user-attachments/assets/4f7533eb-e612-456b-a6f0-06ede79a583b">
</picture>
   <br>
 <em>Settings screens</em>
</p>

## 🚀 Installation

### Requirements
- macOS 13.3 or later
- Xcode 26.0 or later
- Swift 6.0 or later

### Building from Source

Before building, set:
1. `DEVELOPMENT_TEAM` — your Apple Team ID
2. `BUNDLE_ID_PREFIX` — your reverse‑domain prefix (e.g. `com.example`)

Open the project in Xcode 26 or later and run on "My Mac".

## 🏗 Architecture

Here are some of the techniques you’ll encounter in Text Forge:

### 📱 Core Data with CloudKit Sync
The entity hierarchy is decoupled from the class hierarchy, so you get model inheritance without creating massive database tables. Great for offline-first apps that need cloud sync.

### 🎛️ Custom Inspector using `HSplitView`
Since `.inspector()` works only on macOS 14+, Text Forge demonstrates how to build the same experience using `HSplitView` for older systems. Works all the way back to macOS 13.3.

### ⌘ Menu Commands with `@FocusedObject`
Learn how to wire up menu commands without passing bindings through every view. Uses SwiftUI’s focus property wrappers to keep things clean.

### 🪟 Floating Panels using `NSPanel`
Need floating utility windows but can’t require macOS 15? See how to bridge AppKit’s `NSPanel` into your SwiftUI app.

### ✏️ Advanced Text Editor
Bridges `NSTextView` into SwiftUI with all the good stuff:
- Interactive inline tokens via `NSTextAttachmentCell`
- Keyboard navigation and selection

### 💳 StoreKit 2 Integration
Complete in-app purchase implementation with:
- Product loading and caching
- Purchase restoration
- Error handling and user feedback
- Example Tip Jar implementation

## 📚 Resources

- [Core Data Models and Model Objects](https://www.objc.io/issues/4-core-data/core-data-models-and-model-objects/) — Advanced Core Data patterns
- [Pill](https://github.com/chriszielinski/Pill) — Tokenized text field inspiration
- [Floating Panel](https://cindori.com/developer/floating-panel) — Floating window inspiration

For projects targeting newer macOS versions:
- [SwiftUI Inspectors](https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-an-inspector-to-any-view) — macOS 14+ inspectors
- [SwiftUI Mac Windows](https://troz.net/post/2024/swiftui-mac-2024/#windows) — macOS 15+ window management

## 📄 License

Text Forge is available under the MIT License. See [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

App icon by the exceptionally talented [Matthew Skiles](https://matthewskiles.com)

<!-- SEO Keywords: SwiftUI macOS app, Swift 6 strict concurrency, Core Data CloudKit sync, macOS 13.3 backward compatibility, NSTextView SwiftUI integration, HSplitView inspector pattern, @FocusedObject menu commands, NSViewRepresentable, StoreKit 2 in-app purchases, NSFontManager font picker, AttributedString markdown styling, floating panel macOS, SwiftUI production patterns, macOS development best practices, Swift open source -->
