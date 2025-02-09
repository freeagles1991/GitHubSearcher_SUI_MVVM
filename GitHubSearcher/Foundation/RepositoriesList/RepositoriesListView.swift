//
//  ContentView.swift
//  GitHubSearcher
//
//  Created by Дима on 05.02.2025.
//

import SwiftUI
import CoreData

struct RepositoriesListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var searchText: String = ""
    @ObservedObject var repositoriesStorage: RepositoriesStorage
    
    let dataLoader: DataLoaderProtocol
    
    @State var testRepoItems: [RepositoryModel] = [
        RepositoryModel.defaultRepoItem,
        RepositoryModel.defaultRepoItem,
        RepositoryModel.defaultRepoItem,
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
                    
                    List(
                        repositoriesStorage.repositories.indices, id: \.self
                        //testRepoItems.indices, id: \.self
                    ) { index in
                        RepositoryCell_SUI(dataLoader: dataLoader,
                            repository: $repositoriesStorage.repositories[index]
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
                    let params: [String: String] = [
                        "q" : "SwiftUI",
                        "sort" : "stars",
                        "per_page" : "100",
                        "page" : "1"
                    ]
                    dataLoader.fetchRepoData(with: params)
                }
            }
        }
    }
}

#Preview {
    //RepositoriesListView()
}
