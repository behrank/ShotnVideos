//
//  Dictionary.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 25.05.2021.
//

import Foundation

// MARK: - [AnyHashable: Any] to [URLQueryItem]
extension Dictionary where Value: Any {
   func toURLQueryItems() -> [URLQueryItem] { return URLQueryItem.create(from: self) }
}
