import SwiftUI

@main struct MyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var meaning:String = "Even vunurable I'm Ecstatic"
    var body: some Scene {
        MenuBarExtra("Evie", systemImage: "cursorarrow.rays"){
            MenuContentView()
        }
    }
}

struct MenuContentView: View {
    var body: some View {
        Text("Hello from the menu bar")
        Divider()
        Button("Quit") { NSApplication.shared.terminate(nil) }
    }
}

#Preview {
    MenuContentView()
}
