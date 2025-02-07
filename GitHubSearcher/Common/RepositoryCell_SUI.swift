//
//  SwiftUIView.swift
//  GitHubSearcher
//
//  Created by Дима on 06.02.2025.
//

import SwiftUI

struct RepositoryCell_SUI: View {
    @Binding var repository: RepositoryModel
    var cellHeight: CGFloat = 70.0
    var onCellTap: (() -> Void)?

    var body: some View {
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
}

#Preview {
    //RepositoryCell_SUI()
}
