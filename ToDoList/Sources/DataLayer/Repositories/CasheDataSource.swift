//  swiftlint:disable all
//  CasheDataSource.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 20.10.22.
//

import Foundation

enum CasheDataSourceError: Error {
    case emptyData
    case saveData
}

protocol CasheDataSource: Repository {

    typealias CompletionHandler = (Result<Void, Error>) -> ()

    func save(_ task: [Group], completionHandler: @escaping (Error?) -> ())
    func removeAll(_ task: [Group], completionHandler: @escaping CompletionHandler)
}
