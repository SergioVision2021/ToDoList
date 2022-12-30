//
//  ToDayComponent.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 22.12.22.
//

import NeedleFoundation

protocol ToDayBuilder {
    var toDayComponent: UIViewController { get }
}

final class ToDayComponent: Component<EmptyDependency>, ToDayBuilder {
    var toDayComponent: UIViewController {
        return ToDayModuleBuilder().build()
    }
}
