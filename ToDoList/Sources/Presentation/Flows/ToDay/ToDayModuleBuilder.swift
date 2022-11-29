//
//  ToDayModuleBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class ToDayModuleBuilder: ModuleBuilder {

    let service: TaskServiceLogic

    init(service: TaskServiceLogic) {
        self.service = service
    }

    public func build() -> ToDayViewController {

        let view = ToDayViewController()
        view.title = "ToDay"
        view.service = service
        return view
    }
}
