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

enum ListItems: Hashable {
    case planets([URL])
    case people([URL])
    case films([URL])
    case species([URL])
    case starships([URL])
    case vehicles([URL])
    case homeworld(URL)
}
