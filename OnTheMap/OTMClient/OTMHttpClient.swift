//
//  OTMHttpClient.swift
//  OnTheMap
//
//  Created by João Ponte on 21/06/2023.
//

import Foundation

class OTMHttpClient {

    class func taskForGetRequest<ResponseType: Decodable>(udacityAPI: Bool, url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            var newData = Data()
            if udacityAPI {
                let range = 5..<data.count
                newData = data.subdata(in: range)
            } else {
                newData = data
            }
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                    print(responseObject)
                }
            } catch {
                completion(nil, error)
                print(error)
            }
        }
        task.resume()
    }

    class func taskForPostRequest<RequestType: Codable, ResponseType: Decodable>(udacityAPI: Bool, url: URL,
                                                                                 responseType: ResponseType.Type,
                                                                                 body: RequestType,
                                                                                 completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = body
        request.httpBody = try? JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            var newData = Data()
            if udacityAPI {
                let range = 5..<data.count
                newData = data.subdata(in: range)
            } else {
                newData = data
            }
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }

}
