//
//  String.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 25.05.2021.
//

import Foundation

extension String {

    // MARK: - String to [URLQueryItem]

    func toURLQueryItems() -> [URLQueryItem]? {
        guard let urlString = self.removingPercentEncoding, let url = URL(string: urlString) else { return nil }
        if let querItems = url.toQueryItems() { return querItems }
        var urlComponents = URLComponents()
        urlComponents.query = urlString
        return urlComponents.queryItems
    }

    // MARK: - attempt to cast string to correct type (int, bool...)

    func toCorrectType() -> Any {
        let types: [LosslessStringConvertible.Type] = [Bool.self, Int.self, Double.self]
        func cast<T>(to: T) -> Any? { return (to.self as? LosslessStringConvertible.Type)?.init(self) }
        for type in types { if let value = cast(to: type) { return value } }
        return self
    }
}
