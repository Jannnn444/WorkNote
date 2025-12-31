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
    private var totalCount: Int = 0
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
        colorNotesBasedOnCountOfType()
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
        colorNotesBasedOnCountOfType() // Update colors after creating
        totalCount += 1
        filterNotes()
        
        return note
    }
    
    func updateNote(_ note: Note) {
        note.updatedAt = Date()
        saveNotes()
        filterNotes()
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        colorNotesBasedOnCountOfType() // Update colors after delete
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
        totalCount = notes.count // Update total count
        
        for note in notes {
            if totalCount <= 1 {
                note.popularColor = .black
            } else if totalCount == 2 {
                note.popularColor = .blue
            } else if totalCount == 3 {
                note.popularColor = .green
            } else if totalCount == 4 {
                note.popularColor = .orange
            } else if totalCount >= 5 {
                note.popularColor = .pink
            }
        }
        
        saveNotes() // Save after updating colors
    }
    
    enum popularColorRank: Int {
        case black = 1
        case blue = 2
        case green = 3
        case orange = 4
        case pink = 5
    }
}
