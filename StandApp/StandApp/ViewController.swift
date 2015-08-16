//
//  ViewController.swift
//  StandApp
//
//  Created by PeroPeroMan on 2015/08/16.
//  Copyright (c) 2015年 Team-C. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,CameraManagerDelegate{
    var view1: UIView!
    let _cameraManager = CameraManager(preset: AVCaptureSessionPreset1920x1080)
    @IBOutlet weak var CameraPreview: UIImageView!
    let ShootResult: UIImageView! = UIImageView()
    let _accelManager = AccelManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //大きさの初期化
        ShootResult.frame = self.view.bounds

        //ビューに追加
        self.view.addSubview(ShootResult)
        
        //加速度判定クラスにクロージャーをセット
        _accelManager.setup(ShootMoment)
        
        //カメラマネージャーの初期化
        _cameraManager.delegate = self
        _cameraManager.setPreview(CameraPreview)
        
        
        view1 = UIView(frame: CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height))
        
        
        // ジェスチャーの生成
        var aSelector = Selector("handleLongPress:")
        var LongPressRecognizer = UILongPressGestureRecognizer(target: self, action: aSelector)
        LongPressRecognizer.allowableMovement = 20
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Left
        
        // ジェスチャーの追加
        view1.addGestureRecognizer(LongPressRecognizer)
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)

        
        self.view.addSubview(view1)
        _accelManager.setup(ShootMoment)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOrientationChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func onOrientationChange(notification: NSNotification){
        // 現在のデバイスの向きを取得.
        let deviceOrientation: UIDeviceOrientation!  = UIDevice.currentDevice().orientation
        
        // 向きの判定.
        if UIDeviceOrientationIsLandscape(deviceOrientation) {
            println(deviceOrientation.rawValue)
            if deviceOrientation == .LandscapeRight {
                ShootResult.transform = CGAffineTransformMakeRotation(-(CGFloat)(M_PI_2))
            } else if deviceOrientation == .LandscapeLeft {
                ShootResult.transform = CGAffineTransformMakeRotation((CGFloat)(M_PI_2))
            }
            
        } else if UIDeviceOrientationIsPortrait(deviceOrientation){
            ShootResult.transform = CGAffineTransformIdentity
        }
    }
    
    func ShootMoment(){
        
        let myImage = _cameraManager.rotatedVideoImage()
        
        //描画する
        ShootResult.image = myImage
        ShootResult.alpha = 1
        
        // アルバムに追加.
        UIImageWriteToSavedPhotosAlbum(myImage, self, nil, nil)

        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "DelayFadeOut", userInfo: nil, repeats: false)
        
    }
    
    internal func DelayFadeOut(){
        (ShootResult as UIView).fadeOut(duration: 0.5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer)
    {
        switch gestureRecognizer.state
        {
        case .Began:
            println("UIGestureRecognizerState.Began")
            view1.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(1.0)
            view1.fadeIn(type: .Slow)
        case .Ended:
            view1.fadeOut(type: .Normal)
            println("UIGestureRecognizerState.Ended")
        default:
            break;
        }
    }
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
    
            switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.Right:
                println("Right")
                case UISwipeGestureRecognizerDirection.Left:
                println("Left")
                default:
                break
                }
            }
    }
    
    override func shouldAutorotate() -> Bool{
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    
    
}

