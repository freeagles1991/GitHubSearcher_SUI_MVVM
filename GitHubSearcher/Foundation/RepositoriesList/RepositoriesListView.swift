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
    
    @State private var isFavoriteTabActive: Bool = false
    @State private var tabs: [TabModel] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.lightGray)
                    .ignoresSafeArea()
                
                VStack {
                    Text(isFavoriteTabActive ? "Favorites" : "GitHub Search")
                        .font(.largeTitle)
                    
                    if !isFavoriteTabActive {
                        CustomSearchBar_SUI(searchText: $viewModel.searchText)
                        
                        switch viewModel.searchStates {
                        case .empty:
                            Text("Ничего не найдено или поисковая строка пустая")
                                .frame(maxWidth: GlobalVars.screenWidth * 0.8, maxHeight: .infinity)
                        case .loading:
                            Text("Загрузка...")
                                .frame(maxWidth: GlobalVars.screenWidth * 0.8, maxHeight: .infinity)
                        case .loaded:
                            List(viewModel.repositories.indices, id: \.self) { index in
                                NavigationLink(destination: RepositoryDetailView(
                                    dataLoader: viewModel.dataLoader,
                                    swiftDataStore: viewModel.swiftDataStore,
                                    repository: viewModel.repositories[index]
                                )) {
                                    RepositoryCell_SUI(
                                                       repository: viewModel.repositories[index],
                                                       cellHeight: GlobalVars.screenWidth * 0.18
                                    )
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .background(Color.clear)
                            .listStyle(.plain)
                            .padding(.top)
                            .listStyle(PlainListStyle())
                        case .error:
                            Text("Ошибка при загрузке! Повторите попытку")
                                .frame(maxWidth: GlobalVars.screenWidth * 0.8, maxHeight: .infinity)
                        }
                    } else {
                        if !viewModel.favoriteRepositories.isEmpty {
                            List(viewModel.favoriteRepositories.indices, id: \.self) { index in
                                RepositoryCell_SUI(
                                    repository: viewModel.favoriteRepositories[index],
                                    cellHeight: GlobalVars.screenWidth * 0.18
                                )
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
        .onAppear {
            tabs = [
                TabModel(imageName: "magnifyingglass", action: {
                    self.isFavoriteTabActive = false
                }),
                TabModel(imageName: "star.fill", action: {
                    self.isFavoriteTabActive = true
                    viewModel.toggleFavoriteTab(isActive: true)
                })
            ]
        }
    }
}

#Preview {
    //    RepositoriesListView(
    //        viewModel: RepositoriesListViewModel(
    //            dataLoader: DataLoader(),
    //            repositoriesStorage: RepositoriesStorage(),
    //            swiftDataStore: SwiftDataStoreController(modelContext: ModelContext())
    //        )
    //    )
}
