//
//  ShoesRepositorySpec.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 19.10.22.
//

import Foundation

protocol Repository {
    typealias FetchCompletionHandler = (Result<[Group], Error>) -> ()

    func fetch(_ completionHandler: @escaping FetchCompletionHandler)
}
