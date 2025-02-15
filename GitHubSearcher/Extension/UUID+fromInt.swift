//
//  UUID+fromInt.swift
//  GitHubSearcher
//
//  Created by Дима on 11.02.2025.
//

import Foundation

extension UUID {
    static func from(int: Int) -> UUID {
        let uuidString = String(format: "%016llx", UInt64(int))
        return UUID(uuidString: uuidString) ?? UUID()
    }
}
