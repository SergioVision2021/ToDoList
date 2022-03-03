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
