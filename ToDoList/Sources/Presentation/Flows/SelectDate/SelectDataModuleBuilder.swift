//
//  SelectDataModuleBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class SelectDataModuleBuilder: ModuleBuilder {

    let delegate: SelectDateDelegate?

    init(delegate: SelectDateDelegate?) {
        self.delegate = delegate
    }

    func build() -> SelectDateViewController {

        let view = AppDI.makeSelectDateScene()
        view.delegate = delegate
        return view
    }
}
