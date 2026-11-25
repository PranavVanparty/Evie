//
//  HotKeyMonitor.swift
//  Evie
//
//  Created by Pranav Vanparty on 11/25/26.
//

import AppKit

final class HotKeyMonitor {
    // Callbacks: You could do HotKeyMonitor.onpress = {} which assigns the function a function
    // () -> Void just tells it its a function that takes nothing and returns nothing initially
    var onPress: (() -> Void)?
    var onRelease: (() -> Void)?
    
    private let requiredFlags: NSEvent.ModifierFlags = [.control, .option]
    private var isHeld: Bool = false
    
    private var globalMonitor: Any?
    private var localMonitor: Any?
    
    /*
     * macOS holds the closure passed to addGlobalMonitorForEvents, and that closure would hold self strongly.
     * So macOS would keep HotKeyMonitor alive until removeMonitor is called.
     * But removeMonitor is called from deinit, and deinit only runs once nothing keeps the object alive. It would never run.
     * [weak self] breaks that loop, which is why deinit { stop() } can work at all.
     * i.e., Memory Leak would happen
     */
    
    func start() {
        stop() // To prevent multiple monitors from poping up for some reason
        globalMonitor = NSEvent
            .addGlobalMonitorForEvents(matching: .flagsChanged) {[weak self] event in
                self?.handleIt(event: event)
            }
        localMonitor = NSEvent
            .addLocalMonitorForEvents(matching: .flagsChanged) { [weak self] event in
                self?.handleIt(event: event)
                return event // Because this is within the app we need to allow the app to continue on after it gives us the event
            }
    }
    
    func stop() {
        // Doing this to make sure it doesn't crash if I force unwrap it bu doing globalMonitor!
        if let globalMonitor { NSEvent.removeMonitor(globalMonitor) }
        globalMonitor = nil
        
        if let localMonitor { NSEvent.removeMonitor(localMonitor) }
        localMonitor = nil
    }
    
    private func handleIt(event: NSEvent) {
        let held = event.modifierFlags.contains(requiredFlags)
        
        guard held != isHeld else {return} // Return if nothing changed
        isHeld = held
        if held {
            onPress?()
        } else {
            onRelease?()
        }
        
    }
    
    deinit {stop()}
}
