//
//  String+Ext.swift
//  iNotch
//
//  Created by Civitasv on 2025/4/19.
//

import Foundation

extension String {
    var asURL: URL? {
        .init(string: self)
    }

    var withLeadingZeroes: String {
        guard let int = Int(self) else { return self }
        return String(format: "%02d", int)
    }
}
