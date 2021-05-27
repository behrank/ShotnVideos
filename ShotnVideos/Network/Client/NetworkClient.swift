//
//  NetworkClient.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 25.05.2021.
//

import Foundation

extension NetworkTarget {
    
    func call<T: Decodable>(completion:@escaping (T?) -> (), failureCompletion:@escaping (FetchResult)-> Void) {
        
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: generateUrl())
        
        if let headerKeys = self.headers {
            for (key, value) in headerKeys {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        request.httpMethod = method.rawValue
        
        if encoding == .json {
            let requestBody: Data? = try? JSONSerialization.data(withJSONObject: self.parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            if let body = requestBody {
                request.httpBody = body
            }
        }

        session.dataTask(with: request) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                failureCompletion(.noConnection)
                return
            }
            
            let (isSuccessfull, error) = httpResponse.isStatusCodeValid()
                        
            if isSuccessfull {
                do {
                    
                    guard let fetchedData = data else {
                        failureCompletion(FetchResult.unexpectedError)
                        return
                    }
                    
                    let parsedData = try JSONDecoder().decode(T.self, from: fetchedData)
                    
                    debugPrint(String(bytes: fetchedData, encoding: .utf8) ?? "")
                    
                    completion(parsedData)
                } catch let jsonError {
                    debugPrint(jsonError.localizedDescription)
                    
                    failureCompletion(FetchResult.unexpectedError)
                }
            } else {
                guard let parsedError = error else {
                    failureCompletion(FetchResult.unexpectedError)
                    return
                }
                failureCompletion(parsedError)
            }
        }.resume()
    }
    
    private func generateUrl() -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = self.baseURL
        urlComponents.path = self.path
        urlComponents.port = self.port
        
        if self.encoding == HTTPEncode.url {
            var queryItems = [URLQueryItem]()
            
            for (key, value) in self.parameters {
                if let jsonConvertedValue = try? JsonHelper.convert(object: value) {
                    queryItems.append(URLQueryItem(name: key,
                                                   value: jsonConvertedValue))
                } else {
                    queryItems.append(URLQueryItem(name: key,
                                                   value: value as? String))
                }
            }
            
            urlComponents.queryItems = queryItems
            
            if let finalUrl = urlComponents.url {
                return finalUrl
            }
        } else {
            if let finalUrl = urlComponents.url {
                return finalUrl
            }
        }
        
        return URL(string: "")!
    }
}
