//
//  SearchModelBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class SearchModuleBuilder {

    public func build(service: TaskService) -> SearchViewController {

        let view = SearchViewController()
        view.title = "Search"
        view.service = service
        return view
    }
}
