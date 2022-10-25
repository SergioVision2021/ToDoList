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

    mutating func editTask(_ task: Task) {
        guard let id = findID(task) else { return }
        tasks?[id] = task
    }

    func getTask(byName name: String) -> Int? {
        tasks?.firstIndex(where: { $0.name == name })
    }

    mutating func removeTask(_ task: Task) {
        guard let id = findID(task) else { return }
        tasks?.remove(at: id)
    }

    private func findID(_ task: Task) -> Int? {
        guard let id = tasks?.firstIndex(where: { $0.name == task.name }) else { return nil }

        return id
    }
}
