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
    @Environment(\.modelContext) private var modelContext
    @Environment(SwiftDataStoreController.self) private var dataStore
    
    @State var searchStates: SearchStates = .empty
    @State var searchText: String = ""
    @ObservedObject var repositoriesStorage: RepositoriesStorage
    
    @State private var isFavoriteTabActive: Bool = false
    @State private var tabs: [TabModel] = []
    
    let dataLoader: DataLoaderProtocol
    
    @State var testRepoItems: [Repository] = [
        Repository.defaultRepoItem,
        Repository.defaultRepoItem,
        Repository.defaultRepoItem,
    ]
    
    var body: some View {
        let swiftDataStore = SwiftDataStoreController(modelContext: modelContext)
        
        
        NavigationStack {
            ZStack {
                Color(.lightGray)
                    .ignoresSafeArea()
                
                VStack {
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
                                 //testRepoItems.indices, id: \.self
                            ) { index in
                                RepositoryCell_SUI(dataLoader: dataLoader, swiftDataStore: swiftDataStore,
                                                   repository: repositoriesStorage.repositories[index]
                                                   //$testRepoItems[index]
                                                   , cellHeight: GlobalVars.screenWidth * 0.18)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                            .background(Color.clear)
                            .listStyle(.plain)
                            .padding(.top, -10)
                        case .error:
                            Text("Ошибка при загрузке! Повторите попытку")
                                .frame(maxWidth: GlobalVars.screenWidth * 0.8, maxHeight: .infinity)
                        }
                    } else {
                        List(swiftDataStore.favoriteRepositories, id: \.id) { repository in
                            RepositoryCell_SUI(
                                dataLoader: dataLoader,
                                swiftDataStore: swiftDataStore,
                                repository: repository,
                                cellHeight: GlobalVars.screenWidth * 0.18)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .environment(\.modelContext, modelContext)
                        }
                        .background(Color.clear)
                        .listStyle(.plain)
                        .padding(.top, -10)
                    }
                    
                    CustomTabBar_SUI(tabs: tabs)
                }
                //            .padding(.horizontal, GlobalVars.screenWidth * 0.025)
                
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
                dataLoader.fetchRepoData(with: params) {
                    searchStates = .loaded
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
    
    private func switchTabs() {
        
    }
}

#Preview {
    //RepositoriesListView()
}
