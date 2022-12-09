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

    init(task: Task, nameSection: String) {
        self.task = task
        self.nameSection = nameSection
    }

    func build() -> DetailTaskViewController {

        var view = AppDI.makeDetailTaskScene()
        view.task = task
        view.nameSection = nameSection

        return view
    }
}
