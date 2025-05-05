//
//  ProcessInfo+Ext.swift
//  iNotch
//
//  Created by Civitasv on 2025/4/20.
//

import Foundation

public extension ProcessInfo {
    var isSwiftUIPreview: Bool {
        environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}

protocol SwiftPreviewInspector {
    var isSwiftUIPreview: Bool { get }
}

extension ProcessInfo: SwiftPreviewInspector {}
