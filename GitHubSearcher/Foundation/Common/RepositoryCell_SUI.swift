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
    let repository: Repository
    var cellHeight: CGFloat = 70.0
    var onCellTap: (() -> Void)?
    
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationLink {
            RepositoryDetailView(dataLoader: dataLoader, repository: repository)
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
