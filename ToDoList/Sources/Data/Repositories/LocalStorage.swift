//  swiftlint:disable all
//  CasheDataSource.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 20.10.22.
//

import Foundation

enum LocalStorageError: Error {
    case emptyData
    case saveData
}

protocol LocalStorage {
    func fetch(_ completionHandler: @escaping (Result<Data, Error>) -> ())
    func saveAll(_ data: Data, completionHandler: @escaping (Error?) -> ())
    func removeAll(_ data: Data, completionHandler: @escaping (Result<Void, Error>) -> ())
}
