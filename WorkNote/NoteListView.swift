//
//  NoteListView.swift
//  WorkNote
//
//  Created by Hualiteq International on 2025/12/30.
//

import Foundation
import SwiftUI

// MARK: - Main View
struct NotesListView: View {
    @State private var viewModel = NotesViewModel()
    @State private var selectedNote: Note?
    @State private var showingSortOptions = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading notes...")
                } else if viewModel.filteredNotes.isEmpty {
                    emptyStateView
                } else {
                    notesList
                }
            }
            .navigationTitle("Notes")
            .searchable(text: $viewModel.searchText, prompt: "Search notes")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button {
                            viewModel.showFavoritesOnly.toggle()
                        } label: {
                            Label(
                                viewModel.showFavoritesOnly ? "Show All" : "Show Favorites",
                                systemImage: viewModel.showFavoritesOnly ? "star.slash" : "star.fill"
                            )
                        }
                        
                        Divider()
                        
                        Picker("Sort By", selection: $viewModel.sortOption) {
                            ForEach(NotesViewModel.SortOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(.gray)
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        let newNote = viewModel.createNote()
                        selectedNote = newNote
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .sheet(item: $selectedNote) { note in
                NoteDetailView(note: note, viewModel: viewModel)
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = ""
                }
            } message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
        }
    }
    
    private var notesList: some View {
        List {
            ForEach(viewModel.filteredNotes) { note in
                NoteRowView(note: note) {
                    selectedNote = note
                } onToggleFavorite: {
                    viewModel.toggleFavorite(note)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        viewModel.deleteNote(note)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .swipeActions(edge: .leading) {
                    Button {
                        viewModel.toggleFavorite(note)
                    } label: {
                        Label(
                            note.isFavorite ? "Unfavorite" : "Favorite",
                            systemImage: note.isFavorite ? "star.slash" : "star.fill"
                        )
                    }
                    .tint(.yellow)
                }
            }
            .onDelete(perform: viewModel.deleteNotes)
        }
        .listStyle(.plain)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "note.text")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text(viewModel.searchText.isEmpty ? "No Notes Yet" : "No Results Found")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(viewModel.searchText.isEmpty ? "Tap the button above to create your first note" : "Try a different search term")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}
