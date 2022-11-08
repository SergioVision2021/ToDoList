//
//  ShoesRepositorySpec.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 19.10.22.
//

import Foundation

protocol Repository {
    typealias FetchCompletionHandler = (Result<[Group], Error>) -> Void
    func fetch(_ completionHandler: @escaping FetchCompletionHandler)
    func update(_ operation: Operations, _ task: Task, _ data: [Group], completionHandler: @escaping (Error?) -> Void)
}
