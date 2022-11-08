//
//  InBoxModuleBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class InBoxModuleBuilder {

    public func build(service: TaskService) -> InBoxViewController {

        let view = InBoxViewController()
        view.title = "InBox"
        view.service = service
        return view
    }
}
