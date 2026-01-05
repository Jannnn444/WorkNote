//
//  Note.swift
//  WorkNote
//
//  Created by Hualiteq International on 2025/12/29.
//

import SwiftUI

// MARK: - Model Layer
@Observable
final class Note: Identifiable, Codable {
    let id: UUID
    var title: String
    var body: String
    var createdAt: Date
    var updatedAt: Date
    var isFavorite: Bool
    var popularColor: Color = .black // Add this property
    var usedCount: Int
    var noteStatus: Int
    
    init(id: UUID = UUID(), title: String, body: String, createdAt: Date = Date(), updatedAt: Date = Date(), isFavorite: Bool = false, popularColor: Color = .black , usedCount: Int = 0, noteStatus: Int = 0) {
        self.id = id
        self.title = title
        self.body = body
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isFavorite = isFavorite
        self.popularColor = popularColor
        self.usedCount = usedCount
        self.noteStatus = noteStatus
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, body, createdAt, updatedAt, isFavorite, popularColor, usedCount, noteStatus
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        body = try container.decode(String.self, forKey: .body)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        usedCount = try container.decode(Int.self, forKey: .usedCount)
        noteStatus = try container.decode(Int.self, forKey: .noteStatus)
        
        // Decode color from string
               let colorString = try container.decode(String.self, forKey: .popularColor)
               popularColor = stringToColor(colorString)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(body, forKey: .body)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(isFavorite, forKey: .isFavorite)
        try container.encode(usedCount, forKey: .usedCount)
        try container.encode(noteStatus, forKey: .noteStatus)
        
        // Encode color as string
        let colorString = colorToString(popularColor)
        try container.encode(colorString, forKey: .popularColor)
    }
    
    private func colorToString(_ color: Color) -> String {
        switch color {
        case .black: return "black"
        case .blue: return "blue"
        case .green: return "green"
        case .orange: return "orange"
        case .pink: return "pink"
        default: return "black"
        }
    }
    
    private func stringToColor(_ string: String) -> Color {
        switch string {
        case "black": return .black
        case "blue": return .blue
        case "green": return .green
        case "orange": return .orange
        case "pink": return .pink
        default: return .black
        }
    }
  }



protocol StorageServiceProtocol {
    func saveNotes(_ notes: [Note]) throws
    func loadNotes() throws -> [Note]
}

final class StorageService: StorageServiceProtocol {
    
    private let fileURL: URL
    
    init() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = documentsDirectory.appendingPathComponent("notes.json", conformingTo: .json)
    }
    
    func saveNotes(_ notes: [Note]) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(notes)
        try data.write(to: fileURL)
    }
    
    func loadNotes() throws -> [Note] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }
        
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([Note].self, from: data)
    }
}
 
