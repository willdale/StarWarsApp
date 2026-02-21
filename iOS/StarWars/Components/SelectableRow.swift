//
//  SelectableRow.swift
//  StarWars
//
//  Created by Will Dale on 17/02/2026.
//

import SwiftUI
import StarWarsLibrary

struct SelectableRow: View {
    @Environment(Navigation.self) private var naviation
    let title: String
    let icon: String
    let items: ListItems
    
    var body: some View {
        Button {
            naviation.path.append(items)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Label(title, systemImage: icon)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(.horizontal)
                .padding(.vertical, 16)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
    }
}

