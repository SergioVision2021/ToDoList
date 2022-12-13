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

        let view = SearchViewController()
        view.title = "Search"
        return view
    }
}
