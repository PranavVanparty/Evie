//
//  ProviderView.swift
//  Evie
//
//  Created by Pranav Vanparty on 11/25/26.
//

import SwiftUI

struct ProviderView: View {
    @State var provider = Provider.onDevice
    
    var body: some View {
        Picker("Select a Provider", selection: $provider) {
            Text("On Device").tag(Provider.onDevice)
            Text("Cloud").tag(Provider.cloud)
        }
    }
}

enum Provider{
    case onDevice
    case cloud
}

#Preview {
    ProviderView()
}
