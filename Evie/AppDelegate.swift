//
//  AppDelegate.swift
//  Evie
//
//  Created by Pranav Vanparty on 11/24/26.
//

import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var eviePanel: NSPanel?
    let hotKeyMonitor: HotKeyMonitor = HotKeyMonitor()
    let clock = ContinuousClock()
    let state = EvieState()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        permissionChecks()
        warmUp()
        
        let screenFrame = NSScreen.main?.frame ?? NSRect(x:0,y:0,width: 1440, height: 900)
        let eviePanel = NSPanel(
            contentRect: screenFrame,
            styleMask: [.borderless,.nonactivatingPanel],
            backing: .buffered,
            defer: true
        )
        self.eviePanel = eviePanel
        eviePanel.backgroundColor = .clear //NSColor.red.withAlphaComponent(0.3)
        eviePanel.isFloatingPanel = true
        eviePanel.ignoresMouseEvents = true
        eviePanel.collectionBehavior = [
            .canJoinAllSpaces,
            .auxiliary,
            .stationary,
            .ignoresCycle
        ]
        
        setUpMonitors()
        
        let contentview = NSHostingView(
            rootView: EvieView(state: state, size: screenFrame.size)
        )
        contentview.sizingOptions = []
        eviePanel.contentView = contentview
        
        eviePanel.orderFrontRegardless()
        
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        hotKeyMonitor.stop()
    }
    
    func permissionChecks() {
        if !CGPreflightScreenCaptureAccess() {
            CGRequestScreenCaptureAccess()
            print("asked for access")
            // ToDo: Add something that takes them to settings to change this
        }
    }
    
    func warmUp() {
        // Captrue Warm up
        Task {
            do {
                _ = try await ScreenCapture.capture(includedWindowIds: [])
            } catch {
                print("Failed to warm up capture \(error)")
            }
        }
    }
    
    func setUpMonitors() {
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
                    let ids:[Int] = []
                    let img = try await ScreenCapture.capture(includedWindowIds: ids)
                    self.state.capture = img
                    print("width \(img.width), height \(img.height)")
                    print(self.clock.now - start)
                } catch {
                    print("Failed to capture \(error)")
                }
            }
        }
    }
    
}
