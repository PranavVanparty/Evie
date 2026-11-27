//
//  ScreenCapture.swift
//  Evie
//
//  Created by Pranav Vanparty on 11/25/26.
//

import Foundation
import ScreenCaptureKit

enum ScreenCapture {
    static func capture(includedWindowIds: [Int]) async throws -> CGImage {
        let content = try await SCShareableContent
            .excludingDesktopWindows(false, onScreenWindowsOnly: true)
        
        guard let display = content.displays.first else {
            throw NSError(domain: "ScreenshotError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No display found"])
        }
        
        let excludeApps = content.applications.filter { app in
            Bundle.main.bundleIdentifier == app.bundleIdentifier
        }
        
        let windows = content.windows.filter { scWindow in
            includedWindowIds.contains(Int(scWindow.windowID))
        }
        
        let filter = SCContentFilter(
            display: display,
            excludingApplications: excludeApps,
            exceptingWindows: windows
        )
        
        let scale = CGFloat(filter.pointPixelScale)
        let config = SCStreamConfiguration()
        config.width = Int(filter.contentRect.width * scale)
        config.height = Int(filter.contentRect.height * scale)
        
        return try await SCScreenshotManager
            .captureImage(contentFilter: filter, configuration: config)
    }
}
