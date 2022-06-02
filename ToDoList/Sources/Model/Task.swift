//
//  Task.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import Foundation

struct Task: Codable {
    var id: Int?
    var groupId: Int?
    var name: String?
    var taskDeadline: Date?           // Дата когда выполнил задачу
    var taskScheduledDate: Date?      // Дата когда должна быть выполнена задача
    var notes: String?
    var status: Bool?
}

extension Task {
    mutating func setDeadline(_ deadline: Date) -> Task {
        taskDeadline = deadline
        status = true
        return self
    }
}
