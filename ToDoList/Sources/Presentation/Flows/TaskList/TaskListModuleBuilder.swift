//
//  TaskListModuleBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class TaskListModuleBuilder {

    public func build(service: TaskService) -> TaskListViewController {

        let view = TaskListViewController()
        view.title = "TaskList"
        view.service = service
        return view
    }
}
