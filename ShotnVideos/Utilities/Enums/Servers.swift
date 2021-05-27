//
//  Servers.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 23.05.2021.
//

import Foundation

enum ServerType {
    case production
    case test
    case mock
    
    mutating func serverUrl() -> String {
        switch self {
            case .production:   return "ec2-18-188-69-79.us-east-2.compute.amazonaws.com"
            case .test:         return "ec2-18-188-69-79.us-east-2.compute.amazonaws.com"
            case .mock:         return ""
        }
    }
}
