//
//  OTMClient.swift
//  OnTheMap
//
//  Created by João Ponte on 06/06/2023.
//

import Foundation

class OTMClient {
    
    enum EndPoints {
        
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getStudents(Int)
        
        var stringValue: String {
            switch self {
                
            case .getStudents(let totalStudents):
                return EndPoints.base + "/StudentLocation?limit=\(totalStudents)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    class func taskForGetRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func getStudents(completion: @escaping ([Student], Error?) -> Void) {
        taskForGetRequest(url: EndPoints.getStudents(100).url, response: StudentsResult.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
                print(response.results)
            } else {
                completion([], error)
            }
        }
    }

}
