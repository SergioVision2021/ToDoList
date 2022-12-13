//
//  Model.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 12.12.22.
//

import Foundation

struct Model {
    struct Request {}

    struct Response {
        var tasks: [Task]?
        var isError: Bool
        var message: String?
    }

    struct ViewModel {
        var groups: [Group]?
        var isError: Bool
        var message: String?

        struct Group {
            var id: Int?
            var name: String?
            var tasks: [Task]?
        }

        struct Task {
            var id: Int?
            var groupId: Int?
            var name: String?
            var status: Bool?
        }
    }
}
