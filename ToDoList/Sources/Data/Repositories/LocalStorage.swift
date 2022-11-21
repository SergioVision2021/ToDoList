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
    func fetch(_ completionHandler: @escaping (Result<[Group], Error>) -> ())
    func saveAll(_ task: [Group], completionHandler: @escaping (Error?) -> ())
    func removeAll(_ task: [Group], completionHandler: @escaping (Result<Void, Error>) -> ())
}
