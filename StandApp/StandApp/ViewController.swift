//
//  ViewController.swift
//  StandApp
//
//  Created by PeroPeroMan on 2015/08/16.
//  Copyright (c) 2015年 Team-C. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

var view1: UIView!

    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Playground - noun: a place where people can play
        self.view.backgroundColor = .whiteColor()

        // ビューの生成
        view1 = UIView(frame: CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height))
        view1.backgroundColor = UIColor.purpleColor().colorWithAlphaComponent(0.5)

        // ジェスチャーの生成
        var aSelector = Selector("handleLongPress:")
        var LongPressRecognizer = UILongPressGestureRecognizer(target: self, action: aSelector)
        LongPressRecognizer.allowableMovement = 20
        // ジェスチャーの追加
        view1.addGestureRecognizer(LongPressRecognizer)
        self.view.addSubview(view1)
    }


    func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer)
    {
        switch gestureRecognizer.state
        {
            case .Began:
                println("UIGestureRecognizerState.Began")
                view1.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.9)
            case .Ended:
                view1.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.0)
                println("UIGestureRecognizerState.Ended")
            default:
        break;
        }
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

