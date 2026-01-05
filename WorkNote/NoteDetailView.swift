//
//  NoteDetailView.swift
//  WorkNote
//
//  Created by Hualiteq International on 2025/12/30.
//

import Foundation
import SwiftUI

//
//  NoteDetailView.swift
//  WorkNote
//
//  Created by Hualiteq International on 2025/12/30.
//


struct NoteDetailView: View {
    let note: Note
    let viewModel: NotesViewModel
    
    @State private var title: String
    @State private var bodyForState: String
    @State private var selectedColor: Color
    @State private var selectedStatus: NoteStatus
    @Environment(\.dismiss) private var dismiss
    
    init(note: Note, viewModel: NotesViewModel) {
        self.note = note
        self.viewModel = viewModel
        _title = State(initialValue: note.title)
        _bodyForState = State(initialValue: note.body)
        _selectedColor = State(initialValue: note.popularColor)
        _selectedStatus = State(initialValue: NoteStatus(rawValue: note.noteStatus) ?? .draft)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Status Picker Section
                    statusPickerSection
                    
                    // Color Picker Section
                    colorPickerSection
                    
                    // Title Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                        
                        TextField("Note title", text: $title)
                            .textFieldStyle(.roundedBorder)
                            .font(.headline)
                    }
                    
                    // Body Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Content")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                        
                        TextEditor(text: $bodyForState)
                            .frame(minHeight: 200)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(.systemGray6))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                    }
                    
                    // Metadata Section
                    metadataSection
                }
                .padding()
            }
            .navigationTitle("Edit Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button("Save") {
                        saveNote()
                    }
                    .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button {
                            viewModel.toggleFavorite(note)
                        } label: {
                            Label(
                                note.isFavorite ? "Unfavorite" : "Favorite",
                                systemImage: note.isFavorite ? "star.fill" : "star"
                            )
                            .foregroundStyle(note.isFavorite ? .yellow : .gray)
                        }
                        
                        Spacer()
                        
                        Button(role: .destructive) {
                            viewModel.deleteNote(note)
                            dismiss()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Status Picker Section
    private var statusPickerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Status")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                ForEach(NoteStatus.allCases, id: \.self) { status in
                    StatusButton(
                        status: status,
                        isSelected: selectedStatus == status
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            selectedStatus = status
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Color Picker Section
    private var colorPickerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Color")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 16) {
                ForEach([Color.black, .blue, .green, .orange, .pink], id: \.self) { color in
                    ColorButton(
                        color: color,
                        isSelected: selectedColor == color
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            selectedColor = color
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Metadata Section
    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Info")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(width: 20)
                    Text("Created")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(note.createdAt, style: .date)
                        .font(.caption)
                        .foregroundStyle(.primary)
                }
                
                HStack {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(width: 20)
                    Text("Last modified")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(note.updatedAt, style: .relative)
                        .font(.caption)
                        .foregroundStyle(.primary)
                }
                
                HStack {
                    Image(systemName: "eye")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(width: 20)
                    Text("Views")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(note.usedCount)")
                        .font(.caption)
                        .foregroundStyle(.primary)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
    }
    
    // MARK: - Save Function
    private func saveNote() {
        note.title = title
        note.body = bodyForState
        note.popularColor = selectedColor
        note.noteStatus = selectedStatus.rawValue
        note.updatedAt = Date()
        note.usedCount += 1  // Increment view count
        
        viewModel.updateNote(note)
        dismiss()
    }
}

// MARK: - Note Status Enum
enum NoteStatus: Int, CaseIterable {
    case draft = 0
    case active = 1
    case archived = 2
    case completed = 3
    
    var title: String {
        switch self {
        case .draft: return "Draft"
        case .active: return "Active"
        case .archived: return "Archived"
        case .completed: return "Completed"
        }
    }
    
    var icon: String {
        switch self {
        case .draft: return "doc.text"
        case .active: return "bolt.fill"
        case .archived: return "archivebox.fill"
        case .completed: return "checkmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .draft: return .gray
        case .active: return .blue
        case .archived: return .orange
        case .completed: return .green
        }
    }
}

// MARK: - Status Button Component
struct StatusButton: View {
    let status: NoteStatus
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: status.icon)
                    .font(.title3)
                    .foregroundStyle(isSelected ? .white : status.color)
                
                Text(status.title)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(isSelected ? .white : .primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? status.color : Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(status.color, lineWidth: isSelected ? 0 : 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Color Button Component
struct ColorButton: View {
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(color)
                .frame(width: 44, height: 44)
                .overlay(
                    Circle()
                        .stroke(.white, lineWidth: 3)
                        .opacity(isSelected ? 1 : 0)
                )
                .overlay(
                    Circle()
                        .stroke(color.opacity(0.3), lineWidth: 2)
                )
                .shadow(color: color.opacity(0.3), radius: isSelected ? 4 : 0)
        }
        .buttonStyle(.plain)
    }
}
