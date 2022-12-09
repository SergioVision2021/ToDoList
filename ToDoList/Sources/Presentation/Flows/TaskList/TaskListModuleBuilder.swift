//
//  TaskListModuleBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class TaskListModuleBuilder: ModuleBuilder {

    let service: TaskServiceLogic

    init(service: TaskServiceLogic) {
        self.service = service
    }

    public func build() -> TaskListViewController {

        let view = TaskListViewController()
        view.title = "TaskList"
        view.service = service
        return view
    }
}
