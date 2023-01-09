//
//  TaskRepository.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 19.10.22.
//

import Foundation

protocol TaskRepository {
    typealias FetchCompletionHandler = (Result<Data, Error>) -> Void
    typealias UpdateCompletionHandler = (Error?) -> Void

    func fetch(id: Int?, type: Tables, force: Bool, _ completionHandler: @escaping FetchCompletionHandler)
    func update(type: Tables, _ operation: Operations, _ task: Task?, _ id: Int?, completionHandler: @escaping UpdateCompletionHandler)
}
