//
//  NoteRowView.swift
//  WorkNote
//
//  Created by Hualiteq International on 2025/12/30.
//

import Foundation
import SwiftUI

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
                // Left colored indicator bar
                RoundedRectangle(cornerRadius: 4)
                    .fill(note.popularColor)
                    .frame(width: 4)
                
                VStack(alignment: .leading, spacing: 8) {
                    // Title row with favorite and status
                    HStack(alignment: .top, spacing: 8) {
                        Text(note.title.isEmpty ? "Untitled" : note.title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                        
                        if note.isFavorite {
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundStyle(.yellow)
                        }
                        
                        Spacer()
                        
                        // Status badge
                        if note.noteStatus > 0 {
                            StatusBadge(status: note.noteStatus)
                        }
                    }
                    
                    // Body preview
                    if !note.body.isEmpty {
                        Text(note.body)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                    
                    // Bottom info row
                    HStack(spacing: 12) {
                        // Last updated
                        Label {
                            Text(note.updatedAt, style: .relative)
                                .font(.caption)
                        } icon: {
                            Image(systemName: "clock")
                                .font(.caption2)
                        }
                        .foregroundStyle(.tertiary)
                        
                        // Usage count
                        if note.usedCount > 0 {
                            Label {
                                Text("\(note.usedCount)")
                                    .font(.caption)
                            } icon: {
                                Image(systemName: "eye")
                                    .font(.caption2)
                            }
                            .foregroundStyle(.tertiary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
                .padding(.vertical, 8)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Status Badge
struct StatusBadge: View {
    let status: Int
    
    private var statusInfo: (text: String, color: Color) {
        switch status {
        case 0:
            return ("Draft", .gray)
        case 1:
            return ("Active", .blue)
        case 2:
            return ("Archived", .orange)
        case 3:
            return ("Completed", .green)
        default:
            return ("Unknown", .gray)
        }
    }
    
    var body: some View {
        Text(statusInfo.text)
            .font(.caption2)
            .fontWeight(.medium)
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(statusInfo.color)
            )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        NoteRowView(
            note: Note(
                title: "Shopping List",
                body: "Buy groceries: milk, eggs, bread, and vegetables for the week",
                isFavorite: true,
                popularColor: .blue,
                usedCount: 5,
                noteStatus: 1
            ),
            onTap: {},
            onToggleFavorite: {}
        )
        
        NoteRowView(
            note: Note(
                title: "Meeting Notes",
                body: "Discussed project timeline and deliverables",
                isFavorite: false,
                popularColor: .green,
                usedCount: 12,
                noteStatus: 3
            ),
            onTap: {},
            onToggleFavorite: {}
        )
        
        NoteRowView(
            note: Note(
                title: "Ideas",
                body: "",
                isFavorite: false,
                popularColor: .orange,
                usedCount: 0,
                noteStatus: 0
            ),
            onTap: {},
            onToggleFavorite: {}
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
