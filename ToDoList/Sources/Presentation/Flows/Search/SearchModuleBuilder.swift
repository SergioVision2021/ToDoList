//
//  SearchModelBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class SearchModuleBuilder: ModuleBuilder {

    let service: TaskServiceLogic

    init(service: TaskServiceLogic) {
        self.service = service
    }

    public func build() -> SearchViewController {

        let view = SearchViewController()
        view.title = "Search"
        view.service = service
        return view
    }
}
