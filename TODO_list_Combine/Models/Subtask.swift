//
//  Subtask.swift
//  TODO_list_Combine
//
//  Created by Александра Макей on 04.01.2024.
//

import SwiftUI
import Combine

class Subtask: ObservableObject, Identifiable, Encodable, Decodable {
    var id = UUID()
    @Published var title: String
    @Published var isCompleted: Bool = false

    init(title: String) {
        self.title = title
    }

    enum CodingKeys: String, CodingKey {
        case id, title, isCompleted
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(isCompleted, forKey: .isCompleted)
    }
}
