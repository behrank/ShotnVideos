//
//  Objects.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 25.05.2021.
//

import Foundation
import RealmSwift

class UserObject: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var surname: String = ""
    let shots = List<ShotObject>()
    
    func getFullName() -> String {
        return self.name.appending(" ").appending(self.surname)
    }
}

class ShotObject: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var point: Int = 0
    @objc dynamic var inOut: Bool = false
    @objc dynamic var segment: Int  = 0
    @objc dynamic var shotPosX: Double = 0
    @objc dynamic var shotPosY: Double = 0
    @objc dynamic var hasVideo: Bool   = false
    
    func saveVideo() {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        let originalVideoUrl = paths[0].appendingPathComponent("output.mov")
        let newVideoUrl = paths[0].appendingPathComponent(self.id.appending(".mov"))
        
        do {
            try FileManager.default.copyItem(at: originalVideoUrl, to: newVideoUrl)
            
            let realm = try Realm()
            
            Queue.main.execute { [weak self] in
                try! realm.write {
                    self?.hasVideo = true
                }
            }
            debugPrint("Video saved to: \(newVideoUrl)")
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    func getVideoUrl() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        var videoName = "output.mov"
        
        if self.hasVideo {
            videoName = self.id.appending(".mov")
        }
        
        if FileManager.default.fileExists(atPath: videoName) {
            debugPrint("File exists")
        }
        return paths[0].appendingPathComponent(videoName)
    }
}
