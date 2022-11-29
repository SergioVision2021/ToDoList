//
//  TaskRepository.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 19.10.22.
//

import Foundation

protocol TaskRepository {
    typealias FetchCompletionHandler = (Result<[Group], Error>) -> Void
    typealias UpdateCompletionHandler = (Error?) -> Void

    func fetch(force: Bool, _ completionHandler: @escaping FetchCompletionHandler)
    func update(_ operation: Operations, _ task: Task, completionHandler: @escaping UpdateCompletionHandler)
}
