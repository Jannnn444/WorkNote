//
//  NotesViewModel.swift
//  WorkNote
//
//  Created by Hualiteq International on 2025/12/30.
//

import SwiftUI

// MARK: - ViewModel
@Observable
final class NotesViewModel {
    private let storageService: StorageServiceProtocol
    
    private(set) var notes: [Note] = []
    private(set) var filteredNotes: [Note] = []
    private(set) var isLoading = false
    public var errorMessage: String?
    
    var searchText = "" {
        didSet {
            filterNotes()
        }
    }
    
    var showFavoritesOnly = false {
        didSet {
            filterNotes()
        }
    }
    
    var sortOption: SortOption = .dateDescending {
        didSet {
            filterNotes()
        }
    }
    
    enum SortOption: String, CaseIterable {
        case dateDescending = "Newest First"
        case dateAscending = "Oldest First"
        case titleAscending = "Title A-Z"
        case titleDescending = "Title Z-A"
    }
    
    init(storageService: StorageServiceProtocol = StorageService()) {
        self.storageService = storageService
        loadNotes()
    }
    
    func loadNotes() {
        isLoading = true
        errorMessage = nil
        
        do {
            notes = try storageService.loadNotes()
            filterNotes()
        } catch {
            errorMessage = "Failed to load notes: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func createNote() -> Note {
        let note = Note(title: "New Note", body: "")
        notes.append(note)
        saveNotes()
        filterNotes()
        colorNotesBasedOnCountOfType() // new
        return note
    }
    
    func updateNote(_ note: Note) {
        note.updatedAt = Date()
        saveNotes()
        filterNotes()
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
        filterNotes()
    }
    
    func deleteNotes(at offsets: IndexSet) {
        let notesToDelete = offsets.map { filteredNotes[$0] }
        for note in notesToDelete {
            notes.removeAll { $0.id == note.id }
        }
        saveNotes()
        filterNotes()
    }
    
    func toggleFavorite(_ note: Note) {
        note.isFavorite.toggle()
        note.updatedAt = Date()
        saveNotes()
        filterNotes()
    }
    
    private func saveNotes() {
        do {
            try storageService.saveNotes(notes)
        } catch {
            errorMessage = "Failed to save notes: \(error.localizedDescription)"
        }
    }
    
    private func filterNotes() {
        var result = notes
        
        // Filter by favorites
        if showFavoritesOnly {
            result = result.filter { $0.isFavorite }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            result = result.filter { note in
                note.title.localizedCaseInsensitiveContains(searchText) ||
                note.body.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Sort
        switch sortOption {
        case .dateDescending:
            result.sort { $0.updatedAt > $1.updatedAt }
        case .dateAscending:
            result.sort { $0.updatedAt < $1.updatedAt }
        case .titleAscending:
            result.sort { $0.title.localizedCompare($1.title) == .orderedAscending }
        case .titleDescending:
            result.sort { $0.title.localizedCompare($1.title) == .orderedDescending }
        }
        
        filteredNotes = result
    }
    
    private func colorNotesBasedOnCountOfType() {
        var result = notes
        for note in notes {
            if note.usedCount > 1 {
                note.popularColor == Color.black
            } else if note.usedCount > 2 {
                note.popularColor == Color.blue
            } else if note.usedCount > 3 {
                note.popularColor == Color.green
            } else if note.usedCount > 4 {
                note.popularColor == Color.orange
            } else if note.usedCount > 5 {
                note.popularColor ==
            }
            
            // 1. Create Type of differnt note use -> then once they use give a color
            // 2. Based on Type given color to match  -> Guess this is better? 
        }
        
//        enum popularColor
    }
}
