//
//  SearchModelBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class SearchModuleBuilder: ModuleBuilder {

    init() {}

    public func build() -> SearchViewController {

        let repository = AppDI.makeTaskRepository()

        let view = SearchViewController()
        view.repository = repository
        view.title = "Search"
        return view
    }
}
