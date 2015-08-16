//
//  AccelManager.swift
//  StandApp
//
//  Created by PeroPeroMan on 2015/08/16.
//  Copyright (c) 2015年 Team-C. All rights reserved.
//

import Foundation
import CoreMotion

class AccelManager {
    
    let _interval:NSTimeInterval = 0.05
    let _beginMagnitude:Double = 0.5
    let _endMagnitude:Double = 0.03
    
    private enum State {
        case Wait
        case Move
        case Stop
    }
    
    init(){
        setup({})
    }
    
    private var currentState: State = State.Wait
    private let motionManager: CMMotionManager = CMMotionManager()
    
    func setup(completion: ()->Void) {
        motionManager.deviceMotionUpdateInterval = _interval
        
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler:{deviceManager, error in
            let accel: CMAcceleration = deviceManager.userAcceleration
            self.currentState = self.judgeMotion(Accel: accel)
            
            if self.currentState == State.Stop {
                // カメラのシャッター処理
                completion()
            }
        })
    }
    
    private func judgeMotion(Accel accel: CMAcceleration) -> State {
        let magnitude = accel.x*accel.x + accel.y*accel.y + accel.z*accel.z
        if currentState == State.Wait && magnitude >= _beginMagnitude {
            return State.Move
        } else if currentState == State.Move && magnitude <= _endMagnitude {
            return State.Stop
        } else if currentState == State.Stop {
            return State.Wait
        } else {
            return currentState
        }
    }
    
}