//
//  Task.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import Foundation

struct Task {
    var id: Int?
    var name: String?
    var taskDeadline: Date?           // Дата когда выполнил задачу
    var taskScheduledDate: Date?      // Дата когда должна быть выполнена задача
    var notes: String?
    var status: Bool?
}
