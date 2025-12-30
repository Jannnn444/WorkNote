//
//  NoteRowView.swift
//  WorkNote
//
//  Created by Hualiteq International on 2025/12/30.
//

import Foundation
import SwiftUI

// MARK: - Note Row View
struct NoteRowView: View {
    let note: Note
    let onTap: () -> Void
    let onToggleFavorite: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                   
                    ZStack {
                        Rectangle()
                            .foregroundColor(.black)
                            .frame(width: 300, height: 100)
                            .cornerRadius(12)
                        
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(width: 290, height: 80)
                            .cornerRadius(10)
                        
                        HStack {
                            Text(note.title.isEmpty ? "Untitled" : note.title)
                                .font(.headline)
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                            
                            if note.isFavorite {
                                Image(systemName: "star.fill")
                                    .font(.caption)
                                    .foregroundStyle(.yellow)
                            }
                        }
                    }
                    
                    if !note.body.isEmpty {
                        Text(note.body)
                            .font(.custom("smallfont", size: 12))
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    
                    Text(note.updatedAt, style: .relative)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}






