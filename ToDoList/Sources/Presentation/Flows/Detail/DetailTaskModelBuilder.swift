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
    let delegate: DetailTaskDelegate?

    init(task: Task, nameSection: String, delegate: DetailTaskDelegate?) {
        self.task = task
        self.nameSection = nameSection
        self.delegate = delegate
    }

    func build() -> DetailTaskViewController {

        var view = AppDI.makeDetailTaskScene()
        view.task = task
        view.nameSection = nameSection
        view.delegate = delegate

        return view
    }
}
