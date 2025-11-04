import SwiftUI

@main
struct PDFComparatorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}
