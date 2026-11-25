//
//  SettingsView.swift
//  Evie
//
//  Created by Pranav Vanparty on 11/25/26.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            Tab("General", systemImage: "gear") {
                GeneralView()
            }
            Tab("Voice", systemImage: "waveform") {
                
            }
            Tab("Provider", systemImage: "brain") {
                ProviderView()
            }
            Tab("Keybinds", systemImage: "keyboard") {
                
            }
        }.tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    SettingsView()
}
