//
//  InfoRow.swift
//  StarWars
//
//  Created by Will Dale on 17/02/2026.
//

import SwiftUI

struct InfoRow: View {
    let label: String
    let value: String
    
    init(label: String, value: String) {
        self.label = label
        self.value = value
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

struct HomeworldRow: View {    
    var body: some View {
        HStack(alignment: .top) {
            Text("Homeworld")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .leading)
            
            Image(systemName: "chevron.right")
        }
    }
}
