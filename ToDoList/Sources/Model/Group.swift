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
    var tasks: [Task]?
}

extension Group {
    mutating func addTask(_ task: Task) {
        tasks?.append(task)
    }

    func getTask(byName name: String) -> Int? {
        tasks?.firstIndex(where: { $0.name == name })
    }

    mutating func removeTask(byName: String) {
        guard let id = tasks?.firstIndex(where: { $0.name == byName }) else { return }
        tasks?.remove(at: id)
    }
}
