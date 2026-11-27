import SwiftUI

@main struct MyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var meaning:String = "Even vunurable I'm Ecstatic"
    var body: some Scene {
        
        MenuBarExtra("Evie", systemImage: "pointer.arrow.ipad.square.fill"){
            MenuPanelView(state: appDelegate.state)
                .frame(width: 400, height: 360, alignment: .top)
        }.menuBarExtraStyle(.window)
    }
}

struct MenuPanelView: View {
    let state: EvieState

    var body: some View {
        VStack(spacing: 12) {
            if let image = state.capture {
                Image(image, scale: 2.0, label: Text("Captured Image"))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 360).padding()
            }
            MenuContentView()
        }
        .padding()
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
    MenuPanelView(state: EvieState())
}
