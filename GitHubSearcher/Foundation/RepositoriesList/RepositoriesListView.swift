//
//  ContentView.swift
//  GitHubSearcher
//
//  Created by Дима on 05.02.2025.
//

import SwiftUI
import CoreData
import SwiftData

enum SearchStates {
    case empty
    case loading
    case loaded
    case error
}

struct RepositoriesListView: View {
    @ObservedObject var repositoriesStorage: RepositoriesStorage
    @EnvironmentObject var swiftDataStore: SwiftDataStoreController
    
    @State var searchStates: SearchStates = .empty
    @State var searchText: String = ""

    
    @State private var isFavoriteTabActive: Bool = false
    @State private var tabs: [TabModel] = []
    
    let dataLoader: DataLoaderProtocol
    
    @State var testRepoItems: [Repository] = [
        Repository.defaultRepoItem,
        Repository.defaultRepoItem,
        Repository.defaultRepoItem,
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.lightGray)
                    .ignoresSafeArea()
                
                VStack {
                    Text(isFavoriteTabActive ? "Favorites" : "GitHub Search")
                        .font(.largeTitle)
                    
                    if !isFavoriteTabActive {
                        CustomSearchBar_SUI(
                            searchText: $searchText)
                        
                        switch searchStates {
                        case .empty:
                            Text("Ничего не найдено или поисковая строка пустая")
                                .frame(maxWidth: GlobalVars.screenWidth * 0.8, maxHeight: .infinity)
                        case .loading:
                            Text("Загрузка...")
                                .frame(maxWidth: GlobalVars.screenWidth * 0.8, maxHeight: .infinity)
                        case .loaded:
                            List(repositoriesStorage.repositories.indices, id: \.self
                            ) { index in
                                RepositoryCell_SUI(
                                    dataLoader: dataLoader,
                                    swiftDataStore: swiftDataStore,
                                    repository: repositoriesStorage.repositories[index],
                                    cellHeight: GlobalVars.screenWidth * 0.18)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                            .background(Color.clear)
                            .listStyle(.plain)
                            .padding(.top)
                        case .error:
                            Text("Ошибка при загрузке! Повторите попытку")
                                .frame(maxWidth: GlobalVars.screenWidth * 0.8, maxHeight: .infinity)
                        }
                    } else {
                        if !swiftDataStore.favoriteRepositories.isEmpty {
                            List(swiftDataStore.favoriteRepositories.indices, id: \.self) { index in
                                RepositoryCell_SUI(
                                    dataLoader: dataLoader,
                                    swiftDataStore: swiftDataStore,
                                    repository: swiftDataStore.favoriteRepositories[index],
                                    cellHeight: GlobalVars.screenWidth * 0.18)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                            .background(Color.clear)
                            .listStyle(.plain)
                            .padding(.top)
                        } else {
                            Text("В избранное пока ничего не добавлено")
                                .frame(maxWidth: GlobalVars.screenWidth * 0.8, maxHeight: .infinity)
                        }
                    }
                    
                    CustomTabBar_SUI(tabs: tabs)
                }
            }
        }
        
        .onAppear() {
            tabs = [
                TabModel(imageName: "magnifyingglass", action: {
                    self.isFavoriteTabActive = false
                }),
                TabModel(imageName: "star.fill", action: {
                    self.isFavoriteTabActive = true
                })
            ]
        }
        
        .onChange(of: searchText) {
            if !searchText.isEmpty || searchText != "" {
                let params: [String: String] = [
                    "q" : searchText,
                    "sort" : "stars",
                    "per_page" : "100",
                    "page" : "1"
                ]
                searchStates = .loading
                
                dataLoader.fetchRepoData(with: params) {result in
                    switch result {
                    case .success(_):
                        searchStates = .loaded
                    case .failure(_):
                        searchStates = .error
                    }
                }
            } else {
                searchStates = .empty
                dataLoader.cancelCurrentTask()
                repositoriesStorage.clearStorage()
            }
        }
        
        .onChange(of: isFavoriteTabActive) {
            print("isFavoriteTabActive changed \(isFavoriteTabActive)")
        }
    }
}

#Preview {
//    RepositoriesListView(
//        repositoriesStorage: <#T##RepositoriesStorage#>,
//        dataLoader: <#T##any DataLoaderProtocol#>)
}
