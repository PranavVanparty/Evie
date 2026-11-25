//
//  EvieView.swift
//  Evie
//
//  Created by Pranav Vanparty on 11/24/26.
//

import SwiftUI

struct EvieView: View {
    let state: EvieState
    let size: CGSize
    
    var body: some View {
        let iconSize: CGFloat = 20
        Image(systemName: "pointer.arrow.ipad")
            .font(.system(size: iconSize))
            .foregroundStyle(.orange)
            .position(x: state.position.x + iconSize, y: size.height - state.position.y + iconSize)
            
    }
}

#Preview {
    EvieView(state: EvieState(),size: CGSize()).padding(100)
}
