//
//  ToDayModuleBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class ToDayModuleBuilder {

    public func build(service: TaskService) -> ToDayViewController {

        let view = ToDayViewController()
        view.title = "ToDay"
        view.service = service
        return view
    }
}
