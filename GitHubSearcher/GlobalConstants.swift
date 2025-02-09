//
//  GlobalConstantys.swift
//  GitHubSearcher
//
//  Created by Дима on 05.02.2025.
//

import UIKit

enum GlobalConstants: String {
    case baseRepoUrl = "https://api.github.com/search/repositories"
    case baseUsersUrl = "https://api.github.com/users"
}

struct GlobalVars {
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
}
