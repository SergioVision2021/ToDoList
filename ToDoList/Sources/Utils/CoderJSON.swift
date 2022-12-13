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
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        var resp = Data()

        do {
            resp = try encoder.encode(task)
            print(String(data: resp, encoding: .utf8))
        } catch {
            print(error)
            return nil
        }

        return resp
    }

    func decoderJSON<T: Decodable>(_ data: Data) -> T? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        var resp: T

        do {
            resp = try decoder.decode(T.self, from: data)
        } catch (let error) {
            print(error)
            return nil
        }

        return resp
    }
}
