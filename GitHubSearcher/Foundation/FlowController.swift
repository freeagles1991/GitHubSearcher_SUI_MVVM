
//
//  FlowController.swift
//  GitHubSearcher
//
//  Created by Дима on 22.02.2025.
//

import SwiftUI

final class FlowController: ObservableObject {
    @Published var navigationPath = NavigationPath()
    
    func navigateTo(_ destination: FlowDestination) {
        navigationPath.append(destination)
    }
    
    func goBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
    
    func resetNavigation() {
        navigationPath = NavigationPath()
    }
}

enum FlowDestination: Hashable, Equatable {
    case repositoryDetail(Repository)
}
