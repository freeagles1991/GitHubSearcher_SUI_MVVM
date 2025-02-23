//
//  ContentView.swift
//  GitHubSearcher
//
//  Created by Дима on 05.02.2025.
//

import SwiftUI
import CoreData
import SwiftData

struct RepositoriesListView: View {
    @StateObject var viewModel: RepositoriesListViewModel
    @EnvironmentObject var flowController: FlowController
    
    @State private var isFavoriteTabActive: Bool = false
    @State private var tabs: [TabModel] = []
    
    enum Constants {
        enum Texts: String {
            case titleFavorites = "Favorites"
            case titleMain = "GitHub Search"
            case emptySearchText = "Nothing found or the search bar is empty"
            case loadingText = "Loading..."
            case errorText = "Error loading! Please try again"
            case emptyFavoriteText = "Nothing has been added to favorites yet"
        }
        
        enum ImageNames: String {
            case searchTabIcon = "magnifyingglass"
            case favoritesTabIcon = "star.fill"
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.lightGray)
                    .ignoresSafeArea()
                
                VStack {
                    Text(isFavoriteTabActive ? Constants.Texts.titleFavorites.rawValue : Constants.Texts.titleMain.rawValue)
                        .font(.largeTitle)
                    
                    if !isFavoriteTabActive {
                        CustomSearchBar_SUI(searchText: $viewModel.searchText)
                        
                        switch viewModel.searchStates {
                        case .empty:
                            Text(Constants.Texts.emptySearchText.rawValue)
                                .frame(maxWidth: GlobalVars.screenWidth * 0.8, maxHeight: .infinity)
                        case .loading:
                            Text(Constants.Texts.loadingText.rawValue)
                                .frame(maxWidth: GlobalVars.screenWidth * 0.8, maxHeight: .infinity)
                        case .loaded:
                            List(viewModel.repositories.indices, id: \.self) { index in
                                Button {
                                    flowController.navigateTo(.repositoryDetail(viewModel.repositories[index]))
                                } label: {
                                    RepositoryCell_SUI(
                                        repository: viewModel.repositories[index],
                                        cellHeight: GlobalVars.screenWidth * 0.18
                                    )
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                            .listStyle(.plain)
                            .background(Color.clear)
                            .padding(.top)
                        case .error:
                            Text(Constants.Texts.errorText.rawValue)
                                .frame(maxWidth: GlobalVars.screenWidth * 0.8, maxHeight: .infinity)
                        }
                    } else {
                        if !viewModel.swiftDataStore.favoriteRepositories.isEmpty {
                            List(viewModel.swiftDataStore.favoriteRepositories.indices, id: \.self) { index in
                                Button {
                                    flowController.navigateTo(.repositoryDetail(viewModel.swiftDataStore.favoriteRepositories[index]))
                                } label: {
                                    RepositoryCell_SUI(
                                        repository: viewModel.swiftDataStore.favoriteRepositories[index],
                                        cellHeight: GlobalVars.screenWidth * 0.18
                                    )
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                            .listStyle(.plain)
                            .background(Color.clear)
                            .padding(.top)
                        } else {
                            Text(Constants.Texts.emptyFavoriteText.rawValue)
                                .frame(maxWidth: GlobalVars.screenWidth * 0.8, maxHeight: .infinity)
                        }
                    }
                    
                    CustomTabBar_SUI(tabs: tabs)
                }
            }
        }
        .onAppear {
            tabs = [
                TabModel(imageName: Constants.ImageNames.searchTabIcon.rawValue, action: {
                    self.isFavoriteTabActive = false
                }),
                TabModel(imageName: Constants.ImageNames.favoritesTabIcon.rawValue, action: {
                    self.isFavoriteTabActive = true
                })
            ]
        }
    }
}

#Preview {

}
