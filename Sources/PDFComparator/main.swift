import SwiftUI
import AppKit

@main
struct PDFComparatorApp: App {
    init() {
        // Activate the app when it launches
        NSApplication.shared.setActivationPolicy(.regular)
        DispatchQueue.main.async {
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandGroup(replacing: .newItem) {}

            CommandGroup(replacing: .help) {
                Button("PDF Comparator Help") {
                    if let url = Bundle.main.url(forResource: "HELP", withExtension: "md") {
                        NSWorkspace.shared.open(url)
                    }
                }
                .keyboardShortcut("?", modifiers: .command)

                Button("View on GitHub") {
                    if let url = URL(string: "https://github.com/LH/pdf-comparator") {
                        NSWorkspace.shared.open(url)
                    }
                }
            }

            CommandGroup(replacing: .appInfo) {
                Button("About PDF Comparator") {
                    showAboutPanel()
                }
            }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }

    func showAboutPanel() {
        let aboutText = """
        PDF Comparator
        Version 1.0

        A macOS application for comparing two PDF files side-by-side with overlay capabilities.

        Author: Luke Herbert
        License: MIT (Open Source)

        GitHub: https://github.com/LH/pdf-comparator
        """

        let alert = NSAlert()
        alert.messageText = "About PDF Comparator"
        alert.informativeText = aboutText
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Visit GitHub")

        let response = alert.runModal()
        if response == .alertSecondButtonReturn {
            if let url = URL(string: "https://github.com/LH/pdf-comparator") {
                NSWorkspace.shared.open(url)
            }
        }
    }
}
