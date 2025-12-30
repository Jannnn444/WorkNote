//
//  NoteDetailView.swift
//  WorkNote
//
//  Created by Hualiteq International on 2025/12/30.
//

import Foundation
import SwiftUI

// MARK: - Note Detail View
struct NoteDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var thebody: String
    
    let note: Note
    let viewModel: NotesViewModel
    
    init(note: Note, viewModel: NotesViewModel) {
        self.note = note
        self.viewModel = viewModel
        _title = State(initialValue: note.title)
        _thebody = State(initialValue: note.body)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TextField("Title", text: $title, axis: .vertical)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                    .background(Color(.systemBackground))
                
                Divider()
                
                TextEditor(text: $thebody)
                    .font(.body)
                    .padding()
                    .scrollContentBackground(.hidden)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        saveAndDismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.toggleFavorite(note)
                    } label: {
                        Image(systemName: note.isFavorite ? "star.fill" : "star")
                            .foregroundStyle(note.isFavorite ? .yellow : .primary)
                    }
                }
            }
        }
    }
    
    private func saveAndDismiss() {
        note.title = title.isEmpty ? "Untitled" : title
        note.body = thebody
        viewModel.updateNote(note)
        dismiss()
    }
}
