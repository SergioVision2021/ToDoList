//
//  SearchComponent.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 22.12.22.
//

import NeedleFoundation

protocol SearchBuilder {
    var sarchComponent: UIViewController { get }
}

final class SearchComponent: Component<EmptyDependency>, SearchBuilder {
    var sarchComponent: UIViewController {
        return SearchModuleBuilder().build()
    }
}
