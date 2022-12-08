//
//  InBoxRouter.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 21.11.22.
//

import Foundation
import UIKit

protocol InBoxRouter {
    func navigationToAddTask(repository: TaskRepository)
    func navigationToDetailTask(task: Task, nameSection: String, repository: TaskRepository, sender: InBoxViewController)
}
