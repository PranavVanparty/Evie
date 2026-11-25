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
    let rainbowColors: [Color] = [
            .red, .orange, .yellow, .green, .blue, .indigo, .purple, .red
        ]
    var body: some View {
        let iconSize: CGFloat = 20
        
        TimelineView(.animation(paused: !state.isListening)) { context in
            let seconds = context.date.timeIntervalSinceReferenceDate
            let hue = (seconds / 3).truncatingRemainder(dividingBy: 1)
            
            Image(systemName: "pointer.arrow.ipad")
                .font(.system(size: iconSize))
                .foregroundStyle(
                    state.isListening ? Color(
                        hue: hue,
                        saturation: 1,
                        brightness: 1
                    ) : .orange
                )
                .hueRotation(.degrees(hue))
        }
        .position(x: state.position.x + iconSize, y: size.height - state.position.y + iconSize)
    }
}

