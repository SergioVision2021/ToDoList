//  swiftlint:disable all
//  RemoteShoesRepository.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 19.10.22.
//

import Foundation

enum RemoteDataSourceError: Error {
    case requestFailed
}

protocol RemoteDataSource: Repository {

    typealias CompletionHandler = (Result<Void, Error>) -> ()

    func update(operation: Operations, _ task: Task, _ completionHandler: @escaping (Error?) -> ())
}
