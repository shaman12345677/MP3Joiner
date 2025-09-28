import SwiftUI

@main
struct MP3JoinerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(after: .appInfo) {
                Button("Zkontrolovat aktualizace...") {
                    // Simple update check placeholder
                    DispatchQueue.main.async {
                        let alert = NSAlert()
                        alert.messageText = "Kontrola aktualizací"
                        alert.informativeText = "Funkce automatických aktualizací bude implementována v příští verzi."
                        alert.addButton(withTitle: "OK")
                        alert.runModal()
                    }
                }
                .keyboardShortcut("u", modifiers: [.command])
            }
        }
    }
}
