//swiftlint:disable all
//  FileService.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.03.2022.
//

import Foundation

enum Directory {
    case documents
    case cached
}

class StorageHelper<T> {
//    func getJsonData(fromPath: String)
//    func saveJsonData(_ data: Data, byPath: String)
//    func getJsonData(fromDirectory: Directory, fileName: String)
//    func saveJsonData(_ data: Data, byPath: String)
    
//    func getJsonData(fileName: String) -> Data? {}
//    func saveJsonData(_ data: Codable, fileName: String) {}

    var folderName: String
    var fileName: String
    var fileURL: URL?

    init(folderName: String, fileName: String) {
        self.folderName = folderName
        self.fileName = fileName
    }

    func getData() -> Data? {
        fileURL = existFolderFile()

        guard let url = fileURL else { return nil }
        
        // Получить данные из файла
        guard let data = try? Data(contentsOf: url) else {
            print("Could not convert to data")
            return nil
        }

        return data
    }

    func saveToFile(_ data: Data) {

        guard let url = fileURL else { return }
        
        do {
            try data.write(to: url)
        } catch {
            print(error)
        }
    }

    func existFolderFile() -> URL {
        let manager = FileManager.default

        let paths = manager.urls(
            for: .documentDirectory,
            in: .userDomainMask)
        
        let documentsDirectory = paths[0]
        print(documentsDirectory.path)

        let newFolderUrl = documentsDirectory.appendingPathComponent(folderName)
        let fileUrl = newFolderUrl.appendingPathComponent("\(fileName).json")

        manager.fileExists(atPath: newFolderUrl.path) ? print("Folder \(folderName) found") : createFolder(fm: manager, url: newFolderUrl)
        manager.fileExists(atPath: fileUrl.path) ? print("File \(fileName) found") : createFile(fm: manager, url: fileUrl)
        
        return fileUrl
    }

    func createFolder(fm: FileManager, url: URL) {
        do {
            try fm.createDirectory(
                at: url,
                withIntermediateDirectories: true,
                attributes: [:])
            print("Created folder ToDoList")
        } catch {
                print(error)
        }
    }

    func createFile(fm: FileManager, url: URL) {
        fm.createFile(
            atPath: url.path,
            contents: nil,
            attributes: [FileAttributeKey.creationDate: Date()])

        print("Created file Data.json")
    }
}

// MARK: - JSON
extension StorageHelper {

    // [Group] -> JSON -> сохранить в файл
    func saveJsonToFile<T: Encodable>(_ source: [T]) {
        guard let data = encoderJSON(source) else {
            return print("Json encoder error")
        }

        saveToFile(data)
    }

    func decoderJSON<T: Decodable>(_ data: Data) -> [T]? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
      
        do {
            return try decoder.decode([T].self, from: data)
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }

    func encoderJSON<T: Encodable>(_ task: [T]) -> Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        guard let encodedData = try? encoder.encode(task) else {
            print("Encoder error")
            return nil
        }

        print( String(data: encodedData, encoding: .utf8) )

        return encodedData
    }
}
