//
//  DetailTaskBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation
import UIKit

final class DetailTaskModuleBuilder: ModuleBuilder {

    let task: Task
    let nameSection: String
    let repository: TaskRepository?

    init(task: Task, nameSection: String, repository: TaskRepository?) {
        self.task = task
        self.nameSection = nameSection
        self.repository = repository
    }

    func build() -> DetailTaskViewController {

        var view = AppDI.makeDetailTaskScene()
        view.task = task
        view.nameSection = nameSection
        view.repository = repository

        return view
    }
}
