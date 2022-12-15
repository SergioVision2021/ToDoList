//
//  DetailTaskBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation
import UIKit

final class DetailTaskModuleBuilder: ModuleBuilder {

    private let id: Int

    init(id: Int) {
        self.id = id
    }

    public func build() -> DetailTaskViewController {

        let repository = AppDI.makeTaskRepository()

        var view = AppDI.makeDetailTaskScene()
        view.title = "Details"
        view.id = id
        view.repository = repository

        return view
    }
}
