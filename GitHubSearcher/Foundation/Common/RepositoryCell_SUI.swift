//
//  SwiftUIView.swift
//  GitHubSearcher
//
//  Created by Дима on 06.02.2025.
//

import SwiftUI

struct RepositoryCell_SUI: View {
    let dataLoader: DataLoaderProtocol
    let swiftDataStore: SwiftDataStoreController
    @Binding var repository: Repository
    var cellHeight: CGFloat = 70.0
    var onCellTap: (() -> Void)?

    var body: some View {
        NavigationLink {
            RepositoryDetailView(swiftDataStore: swiftDataStore, dataLoader: dataLoader, repositoryModel: repository)
        } label: {
            ZStack {
                let title = repository.fullName
                
                Color.white
                    .cornerRadius(20)
                    .frame(height: cellHeight)
                    .opacity(0.5)
                
                HStack {
                    Text(title)
                        .font(.custom("Gilroy-Regular", size: 16))
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: cellHeight)
                .padding(.horizontal)
            }
            .padding(.vertical, -(cellHeight * 0.05))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    //RepositoryCell_SUI()
}
