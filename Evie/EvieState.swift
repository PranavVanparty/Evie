//
//  EvieState.swift
//  Evie
//
//  Created by Pranav Vanparty on 11/24/26.
//

import Observation
import SwiftUI

@Observable
class EvieState {
    var position: CGPoint = .zero
    var isListening: Bool = false
    var capture: CGImage? 
}
