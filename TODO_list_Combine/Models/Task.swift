//
//  Task.swift
//  TODO_list_Combine
//
//  Created by Александра Макей on 03.01.2024.
//

import Foundation
import Combine

class Task: ObservableObject, Identifiable, Encodable, Decodable {
    
    var id = UUID()
    @Published var title: String
    @Published var description: String
    @Published var isCompleted: Bool
    @Published var subtasks: [Subtask]

    init(title: String, description: String = "", isCompleted: Bool = false, subtasks: [Subtask] = []) {
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.subtasks = subtasks
    }
    func updateCompletionStatus(_ isCompleted: Bool) {
        self.isCompleted = isCompleted
        objectWillChange.send()
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        subtasks = try container.decode([Subtask].self, forKey: .subtasks)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encode(subtasks, forKey: .subtasks)
    }

    enum CodingKeys: String, CodingKey {
        case id, title, description, isCompleted, subtasks
    }
}
extension Task: Hashable {
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

