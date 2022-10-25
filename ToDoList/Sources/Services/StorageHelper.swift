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

enum StorageHelperError: Error {
    case encoderJSON
}

class StorageHelper<T> {
//    func getJsonData(fromPath: String)
//    func saveJsonData(_ data: Data, byPath: String)
//    func getJsonData(fromDirectory: Directory, fileName: String)
//    func saveJsonData(_ data: Data, byPath: String)

//    func getJsonData(fileName: String) -> Data? {}
//    func saveJsonData(_ data: Codable, fileName: String) {}

    private var folderName: String
    private var fileName: String
    private var fileURL: URL?

    init(folderName: String, fileName: String) {
        self.folderName = folderName
        self.fileName = fileName
    }

    func getData<T: Codable>() -> [T]? {

        fileURL = existFolderFile()

        guard let url = fileURL else { return nil }

        // Получить данные из файла
        guard let data = try? Data(contentsOf: url) else {
            print("Could not convert to data")
            return nil
        }

        return getModel(data)
    }

    private func saveToFile(_ data: Data) {

        guard let url = fileURL else { return }

        do {
            try data.write(to: url)
        } catch {
            print(error)
        }
    }

    public func existFolderFile() -> URL {
        let manager = FileManager.default

        let paths = manager.urls(
            for: .documentDirectory,
            in: .userDomainMask)

        let documentsDirectory = paths[0]
        print(documentsDirectory.path)

        let newFolderUrl = documentsDirectory.appendingPathComponent(folderName)
        let fileUrl = newFolderUrl.appendingPathComponent("\(fileName).json")

        manager.fileExists(atPath: newFolderUrl.path)
            ? print("Folder \(folderName) found")
            : createFolder(fm: manager, url: newFolderUrl)

        manager.fileExists(atPath: fileUrl.path)
            ? print("File \(fileName) found")
            : createFile(fm: manager, url: fileUrl)

        return fileUrl
    }

    private func createFolder(fm: FileManager, url: URL) {
        do {
            try fm.createDirectory(
                at: url,
                withIntermediateDirectories: true,
                attributes: [:])
            print("Created folder \(folderName)")
        } catch {
                print(error)
        }
    }

    private func createFile(fm: FileManager, url: URL) {
        fm.createFile(
            atPath: url.path,
            contents: nil,
            attributes: [FileAttributeKey.creationDate: Date()])

        print("Created file \(fileName).json")
    }
}

// MARK: - JSON
extension StorageHelper {

    // [Group] -> JSON -> сохранить в файл
    func saveJsonToFile<T: Encodable>(_ source: [T], _ callback: @escaping (Error?) -> Void) {
        guard let data = CoderJSON().encoderJSON(source) else {
            return callback(StorageHelperError.encoderJSON)
        }

        saveToFile(data)

        callback(nil)
    }

    private func getModel<T: Decodable>(_ data: Data) -> [T]? {
        guard !data.isEmpty else {
            print("Data empty")
            return nil
        }

        return CoderJSON().decoderJSON(data)
    }
}
