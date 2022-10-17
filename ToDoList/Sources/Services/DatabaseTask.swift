//swiftlint:disable all
//  BackendService.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 01.04.2022.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

class NetworkDispatcher {

    func prepareRequest(_ apiPath: URLComponents, _ httpMethod: HTTPMethod, _ data: Data?) -> URLRequest? {

        guard let url = apiPath.url else { return nil}
        
        // Create the url request
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        switch httpMethod {
        case .GET:
            break
        case .DELETE:
            break
        case .POST:
            // the request is JSON
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            // the response expected to be in JSON format
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = data
            break
        case .PUT:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            break
        }
        
        return request
    }

    func sendRequest(_ urlRequest: URLRequest, callback: @escaping (Result<Data, Error>) -> Void) {

        // Create URL session data task
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in

            if let error = error {
                print("Error: error calling \(String(describing: urlRequest.httpMethod))")
                callback(.failure(error))
                return
            }

            guard let data = data else {
                print("Error: Did not receive data")
                return
            }

            guard let json = response as? HTTPURLResponse, (200 ..< 299) ~= json.statusCode else {
                print("Error: HTTP request failed")
                return
            }

            callback(.success(data))
        }.resume()
    }
}
