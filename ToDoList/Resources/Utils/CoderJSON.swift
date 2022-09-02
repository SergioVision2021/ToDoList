//
//  CoderJSON.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 02.09.2022.
//

import Foundation

struct CoderJSON: Codable {
    func encoderJSON<T: Encodable>(_ task: T) -> Data? {

        let encoder = JSONEncoder()
        var resp = Data()

        do {
            resp = try encoder.encode(task)
        } catch {
            print(error)
            return nil
        }

        return resp
    }

    func decoderJSON<T: Decodable>(_ data: Data) -> [T]? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        var resp = [T]()
        do {
            resp = try decoder.decode([T].self, from: data)
        } catch {
            print("error")
            return nil
        }

        return resp
    }
}
