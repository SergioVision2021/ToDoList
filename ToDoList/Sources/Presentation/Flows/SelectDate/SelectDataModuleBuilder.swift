//
//  SelectDataModuleBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class SelectDataModuleBuilder: ModuleBuilder {

    init() {}

    func build() -> SelectDateViewController {

        let view = AppDI.makeSelectDateScene()
        return view
    }
}
