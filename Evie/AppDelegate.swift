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
    let clock = ContinuousClock()
    let state = EvieState()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        if !CGPreflightScreenCaptureAccess() {
            CGRequestScreenCaptureAccess()
            print("asked for access")
            // ToDo: Add something that takes them to settings to change this
        }
        Task {
            do {
                _ = try await ScreenCapture.capture()
            } catch {
                print("Failed to warm up capture \(error)")
            }
        }
        
        
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
        
        let mouseMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: [.mouseMoved,.leftMouseDragged]) {event in
                self.state.position = NSEvent.mouseLocation
            }
            
        hotKeyMonitor.start()
        hotKeyMonitor.onPress = {
            self.state.isListening = true
        }
        hotKeyMonitor.onRelease = {
            let start = self.clock.now
            self.state.isListening = false
            Task { @MainActor in
                do {
                    let img = try await ScreenCapture.capture()
                    self.state.capture = img
                    print("width \(img.width), height \(img.height)")
                    print(self.clock.now - start)
                } catch {
                    print("Failed to capture \(error)")
                }
            }
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
