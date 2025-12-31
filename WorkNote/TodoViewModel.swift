//
//  TodoViewModel.swift
//  2025end
//
//  Created by Hualiteq International on 2025/12/31.
//
// Here design the status of done-progress

import SwiftUI

@Observable
final class TodoViewModel {
    private var noteStatus: NoteStatus
    
    init(noteStatus: NoteStatus) {
        self.noteStatus = noteStatus
    }
}

enum NoteStatus: Int {
    case begin = 1
    case something = 2
    case habit = 3
    case welldone = 4
    case awesome = 5
}

