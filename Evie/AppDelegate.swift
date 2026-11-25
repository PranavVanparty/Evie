//
//  AppDelegate.swift
//  Evie
//
//  Created by Pranav Vanparty on 11/24/26.
//

import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var panel: NSPanel?
    let hotKeyMonitor: HotKeyMonitor = HotKeyMonitor()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let screenFrame = NSScreen.main?.frame ?? NSRect(x:0,y:0,width: 1440, height: 900)
        let panel = NSPanel(
            contentRect: screenFrame,
            styleMask: [.borderless,.nonactivatingPanel],
            backing: .buffered,
            defer: true
        )
        self.panel = panel
        panel.backgroundColor = .clear //NSColor.red.withAlphaComponent(0.3)
        panel.isFloatingPanel = true
        panel.ignoresMouseEvents = true
        panel.collectionBehavior = [
            .canJoinAllSpaces,
            .auxiliary,
            .stationary,
            .ignoresCycle
        ]
        
        let state = EvieState()
        let mouseMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: [.mouseMoved,.leftMouseDragged]) {event in
                state.position = NSEvent.mouseLocation
            }
            
        hotKeyMonitor.start()
        hotKeyMonitor.onPress = {
            state.isListening = true
        }
        hotKeyMonitor.onRelease = {
            state.isListening = false
        }
        
        let contentview = NSHostingView(
            rootView: EvieView(state: state, size: screenFrame.size)
        )
        contentview.sizingOptions = []
        panel.contentView = contentview
        
        panel.orderFrontRegardless()
        
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        hotKeyMonitor.stop()
    }
    
}
