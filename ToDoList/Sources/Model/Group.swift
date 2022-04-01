//
//  Group.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import Foundation

struct Group: Codable {
    var id: Int?
    var name: String?
    var dateCreated: Date?      // Дата создания группы
    var list: [Task]?
}

extension Group {
    mutating func addTask(_ task: Task) {
        list?.append(task)
    }

    func getTask(byName name: String) -> Int? {
        list?.firstIndex(where: { $0.name == name })
    }

    mutating func removeTask(byName: String) {
        guard let id = list?.firstIndex(where: { $0.name == byName }) else { return }
        list?.remove(at: id)
    }
}
