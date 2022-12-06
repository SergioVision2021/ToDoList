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

    func build() -> UIViewController & SelectDateRouting {

        let view = AppDI.makeSelectDateScene()
        return view
    }
}
