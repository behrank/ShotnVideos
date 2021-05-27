//
//  HTTPURLResponse.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 25.05.2021.
//

import Foundation

extension HTTPURLResponse {
    func isStatusCodeValid() -> (Bool, FetchResult?) {
        switch self.statusCode {
        case 204:
            return (false, FetchResult.noVideo)
        case 200..<400:
            return (true, nil)
        case 401:
            return (false, FetchResult.unAuthorized)
        case 426:
            return (false, nil)
        case 500:
            return (false, FetchResult.unexpectedError)
        default:
            return (false, nil)
        }
    }
}
