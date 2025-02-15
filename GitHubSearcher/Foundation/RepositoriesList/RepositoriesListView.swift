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
    @Environment(\.modelContext) private var modelContext
    
    @State var searchText: String = ""
    @ObservedObject var repositoriesStorage: RepositoriesStorage
    @ObservedObject var swiftDataStore: SwiftDataStoreController
    
    @State var isFavoriteTabActive: Bool = false
    
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
                    CustomSearchBar_SUI(
                        searchText: $searchText)
                    
                    //Заглушка для пустого поиска
                    
                    List(isFavoriteTabActive ? swiftDataStore.favoriteRepositories.indices :
                        repositoriesStorage.repositories.indices, id: \.self
                        //testRepoItems.indices, id: \.self
                    ) { index in
                        RepositoryCell_SUI(dataLoader: dataLoader, swiftDataStore: swiftDataStore,
                                           repository: isFavoriteTabActive ? $swiftDataStore.favoriteRepositories[index] : $repositoriesStorage.repositories[index]
                            //$testRepoItems[index]
                            , cellHeight: GlobalVars.screenWidth * 0.18)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .background(Color.clear)
                    .listStyle(.plain)
                    .padding(.top, -10)
                    
                    CustomTabBar_SUI()
                }
                //            .padding(.horizontal, GlobalVars.screenWidth * 0.025)
                
                .onAppear() {
                    swiftDataStore.loadFavoriteRepositories()
                }
            }
        }
        .onChange(of: searchText) {
            let params: [String: String] = [
                "q" : searchText,
                "sort" : "stars",
                "per_page" : "100",
                "page" : "1"
            ]
            dataLoader.fetchRepoData(with: params)
        }
    }
}

#Preview {
    //RepositoriesListView()
}
