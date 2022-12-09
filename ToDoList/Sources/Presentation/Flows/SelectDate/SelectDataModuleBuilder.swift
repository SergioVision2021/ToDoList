//
//  SelectDataModuleBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation
import UIKit

final class SelectDataModuleBuilder: ModuleBuilder {

    init() {}

    public func build() -> UIViewController & SelectDateRouting {

        let view = AppDI.makeSelectDateScene()
        view.title = "Select date"
        return view
    }
}
