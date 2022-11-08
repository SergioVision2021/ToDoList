//
//  SelectDataModuleBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class SelectDataModuleBuilder {

    func build(delegate: SelectDateDelegate?) -> SelectDateViewController {

        let view = SelectDateViewController(nibName: Constants.selectDataVCIdentifier, bundle: nil)
        view.delegate = delegate
        return view
    }
}
