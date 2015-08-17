//
//  fadeinoutswift.swift
//  StandApp
//
//  Created by 矢野颯太 on 2015/08/16.
//  Copyright (c) 2015年 Team-C. All rights reserved.
//

enum FadeType: NSTimeInterval {
    case
    Normal = 0.2,
    Slow = 0.5
}

extension UIView {
    func fadeIn(type: FadeType = .Normal, completed: (() -> ())? = nil) {
        fadeIn(duration: type.rawValue, completed: completed)
    }
    
    /** For typical purpose, use "public func fadeIn(type: FadeType = .Normal, completed: (() -> ())? = nil)" instead of this */
    func fadeIn(duration: NSTimeInterval = FadeType.Slow.rawValue, completed: (() -> ())? = nil) {
        alpha = 0
        self.hidden = false
        UIView.animateWithDuration(duration,
            animations: {
                self.alpha = 1
            }) { finished in
                completed?()
        }
    }
    func fadeOut(type: FadeType = .Normal, completed: (() -> ())? = nil) {
        fadeOut(duration: type.rawValue, completed: completed)
    }
    /** For typical purpose, use "public func fadeOut(type: FadeType = .Normal, completed: (() -> ())? = nil)" instead of this */
    func fadeOut(duration: NSTimeInterval = FadeType.Slow.rawValue, completed: (() -> ())? = nil) {
        UIView.animateWithDuration(duration
            , animations: {
                self.alpha = 0
            }) { [weak self] finished in
                self?.hidden = false
                completed?()
        }
    }
}