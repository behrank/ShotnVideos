//
//  Queue.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 25.05.2021.
//

import Foundation

protocol ExecutableQueue {
    var queue: DispatchQueue { get }
}

extension ExecutableQueue {
    func execute(closure: @escaping () -> Void) {
        queue.async(execute: closure)
    }
    
    func executeAfter(delay: DelayTime, closure: @escaping () -> Void) {
        queue.asyncAfter(deadline: delay.asDispatchtime, execute: closure)
    }
}

enum Queue: ExecutableQueue {
    case main
    case userInteractive
    case userInitiated
    case utility
    case background

    var queue: DispatchQueue {
        switch self {
        case .main:            return DispatchQueue.main
        case .userInteractive: return DispatchQueue.global(qos: .userInteractive)
        case .userInitiated:   return DispatchQueue.global(qos: .userInitiated)
        case .utility:         return DispatchQueue.global(qos: .utility)
        case .background:      return DispatchQueue.global(qos: .background)
        }
    }
}

enum DelayTime {
    case halfSecond
    case oneSecond
    case twoSeconds
    case fiveSeconds
    case customSeconds(Int)
    case customMiliseconds(Int)
    
    var asDispatchtime: DispatchTime {
        switch self {
        case .halfSecond:                         return DispatchTime.now() + DispatchTimeInterval.milliseconds(500)
        case .oneSecond:                          return DispatchTime.now() + DispatchTimeInterval.seconds(1)
        case .twoSeconds:                         return DispatchTime.now() + DispatchTimeInterval.seconds(2)
        case .fiveSeconds:                        return DispatchTime.now() + DispatchTimeInterval.seconds(5)
        case .customSeconds(let seconds):         return DispatchTime.now() + DispatchTimeInterval.seconds(seconds)
        case .customMiliseconds(let miliSeconds): return DispatchTime.now() + DispatchTimeInterval.milliseconds(miliSeconds)
        }
    }
}
