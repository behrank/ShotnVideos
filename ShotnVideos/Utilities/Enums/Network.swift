//
//  Network.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 25.05.2021.
//

import Foundation

// MARK: - Definitions
enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

enum HTTPEncode {
    case json, url
}

enum NetworkTarget {
    case fetchVideos
}

//Fetch fail reason
enum FetchResult {
    case serverError, noVideo, noConnection, unAuthorized, unexpectedError
    
    var message:String {
        switch self {
        case .noVideo:
            return "There is no video for you"
        case .noConnection:
            return "Please check your internet connection"
        default:
            return "Something went wrong."
        }
    }
}


// MARK: - Network properties
extension NetworkTarget {
    
    internal var baseURL: String {
        if let url = AppDelegate.currentApp?.getCurrentServerUrl(){
            return url
        }
        
        return ""
    }
    
    internal var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var path: String {
        switch self {
            case .fetchVideos:  return "/shots"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .fetchVideos:      return [:]
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .fetchVideos:  return .get
        }
    }
    
    var encoding: HTTPEncode {
        switch self {
            case .fetchVideos:  return .url
        }
    }
    
    var port: Int {
        return 3000
    }
}
