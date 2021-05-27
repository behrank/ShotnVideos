//
//  Response.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 25.05.2021.
//

import Foundation

// MARK: - ShotsFetchResponse
struct ShotsFetchResponse: Decodable {
    var success: Bool?
    var data: [ShotsData]?
}

// MARK: - Datum
struct ShotsData: Decodable {
    var user: User?
    var shots: [Shot]?
}

// MARK: - Shot
struct Shot {
    var point, segment: Int?
    var id: String?
    var inOut: Bool?
    var shotPosX, shotPosY: Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case point = "point"
        case segment = "segment"
        case inOut = "inOut"
        case shotPosX = "ShotPosX"
        case shotPosY = "ShotPosY"
    }
}

extension Shot: Decodable {
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if values.contains(.id) {
            id = try values.decode(String.self, forKey: .id)
        }
        
        if values.contains(.point) {
            point = try values.decode(Int.self, forKey: .point)
        }
        
        if values.contains(.inOut) {
            inOut = try values.decode(Bool.self, forKey: .inOut)
        }
        
        if values.contains(.segment) {
            segment = try values.decode(Int.self, forKey: .segment)
        }
        
        if values.contains(.shotPosX) {
            shotPosX = try values.decode(Double.self, forKey: .shotPosX)
        }
        
        if values.contains(.shotPosY) {
            shotPosY = try values.decode(Double.self, forKey: .shotPosY)
        }
    }
}
// MARK: - User
struct User: Decodable {
    var name, surname: String?
}
