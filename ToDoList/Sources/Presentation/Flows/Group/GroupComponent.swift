//
//  GroupComponent.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 22.12.22.
//

import NeedleFoundation

protocol GroupBuilder {
    var groupComponent: UIViewController { get }
}

final class GroupComponent: Component<EmptyDependency>, GroupBuilder {
    var groupComponent: UIViewController {
        return GroupModuleBuilder().build()
    }
}
