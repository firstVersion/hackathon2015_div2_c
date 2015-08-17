//
//  ViewController.swift
//  StandApp
//
//  Created by PeroPeroMan on 2015/08/16.
//  Copyright (c) 2015年 Team-C. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,CameraManagerDelegate,UIScrollViewDelegate{
    var view1: UIView!
    let _cameraManager = CameraManager(preset: AVCaptureSessionPreset1920x1080)
    @IBOutlet weak var CameraPreview: UIImageView!
    let ShootResult: UIImageView! = UIImageView()
    let _accelManager = AccelManager()
    let _photoManager = PhotoManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.userInteractionEnabled = true
        
        
        _photoManager.setup(WindowSize: self.view.frame)
        
        //大きさの初期化
        ShootResult.frame = self.view.bounds
        
        //ビューに追加
        self.view.addSubview(ShootResult)
        
        //加速度判定クラスにクロージャーをセット
        _accelManager.setup(ShootMoment)
        
        //カメラマネージャーの初期化
        _cameraManager.delegate = self
        _cameraManager.setPreview(CameraPreview)
        
        
        
        /*
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
        */
        
        
        
        
        //ここからスクロールレクトの記述
        
        //UIImageに画像の名前を指定します
        let img1 = UIImage(named:"img1.jpg");
        let img2 = UIImage(named:"img2.jpg");
        let img3 = UIImage(named:"img3.jpg");
        
        //UIImageViewにUIIimageを追加
        let imageView1 = UIImageView(image:img1)
        let imageView2 = UIImageView(image:img2)
        let imageView3 = UIImageView(image:img3)
        let imageBlack = UIImageView()
        imageBlack.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(1)
        
        //UIScrollViewを作成します
        let scrView = MyScrollView()
        scrView.delegate = self
        
        //表示位置 + 1ページ分のサイズ
        scrView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        
        //全体のサイズ
        scrView.contentSize = CGSizeMake(self.view.frame.size.width*4, self.view.frame.size.height)
        
        //UIImageViewのサイズと位置を決めます
        //左右に並べる
        imageView1.frame = CGRectMake(self.view.frame.size.width * 2, 0, self.view.frame.size.width, self.view.frame.size.height)
        imageView2.frame = CGRectMake(self.view.frame.size.width * 1, 0, self.view.frame.size.width, self.view.frame.size.height)
        imageView3.frame = CGRectMake(self.view.frame.size.width * 0, 0, self.view.frame.size.width, self.view.frame.size.height)
        imageBlack.frame = CGRectMake(self.view.frame.size.width * -1, 0, self.view.frame.size.width, self.view.frame.size.height)
        
        
        //viewに追加します
        self.view.addSubview(scrView)
        scrView.addSubview(imageView1)
        scrView.addSubview(imageView2)
        scrView.addSubview(imageView3)
        scrView.addSubview(imageBlack)
        
        // １ページ単位でスクロールさせる
        scrView.pagingEnabled = true
        
        //scroll画面の初期位置
        scrView.contentOffset = CGPointMake(self.view.frame.size.width * 3, 0);
        
        
        view1 = UIView(frame: CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height))
        view1.userInteractionEnabled = false
        self.view.addSubview(view1)

        
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

    var _startFadeDate = NSDate()
    var _touchCount:Int = 0
    var touchCount:Int{
        get{
            return _touchCount
        }
        set(val) {
            let tmp = _touchCount
            _touchCount = val
            if _touchCount < 0{
                _touchCount = 0
            }
            if(tmp>0 && _touchCount == 0){
                if(_startFadeDate.timeIntervalSinceNow < FadeType.Normal.rawValue){
                    let g = CGFloat(_startFadeDate.timeIntervalSinceNow)
                    let r = CGFloat(FadeType.Normal.rawValue)
                    view1.alpha = (g/r)
                }
                view1.fadeOut(type: .Normal)
            }else if(tmp == 0 && _touchCount > 0){
                _startFadeDate = NSDate()
                view1.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(1.0)
                view1.fadeIn(type: .Slow)
            }
        }
    }
    
    var beginFlg:Bool = false
    var isScroll:Bool = false
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if(isScroll){
            return
        }
        beginFlg = true
        ++touchCount
        println("begin:\(touchCount)")
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        beginFlg = false
        --touchCount
        println("end:\(touchCount)")
    }
    override func touchesCancelled(touches: Set<NSObject>, withEvent event: UIEvent) {
        beginFlg = false
        --touchCount
        println("cancel:\(touchCount)")
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        isScroll = true
        if(!beginFlg){
            ++touchCount
            println("beginDrag:\(touchCount)")
        }
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView,willDecelerate decelerate: Bool){
        beginFlg = false
        isScroll = false
        touchCount = 0
        println("endDrag:\(touchCount)")
    }
    
    
    func ShootMoment(){
        
        var myImage = _cameraManager.rotatedVideoImage()
        var a = _cameraManager.videoOrientaion
        
        if ( a == UIDeviceOrientation.LandscapeLeft){
            myImage = UIImage(CGImage: myImage.CGImage, scale: 1.0, orientation: UIImageOrientation.Left)
            ShootResult.transform = CGAffineTransformMakeRotation(CGFloat((180.0 * M_PI)/180))
        } else
        if( a == UIDeviceOrientation.LandscapeRight ){
            myImage = UIImage(CGImage: myImage.CGImage, scale: 1.0, orientation: UIImageOrientation.Right)
            ShootResult.transform = CGAffineTransformMakeRotation(CGFloat((180.0 * M_PI)/180))
        }else{
            ShootResult.transform = CGAffineTransformMakeRotation(CGFloat((0.0 * M_PI)/180))
        }
        
        //描画する
        ShootResult.image = myImage
        ShootResult.alpha = 1
        
        // アルバムに追加.
        UIImageWriteToSavedPhotosAlbum(myImage, self, nil, nil)
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "DelayFadeOut", userInfo: nil, repeats: false)
        
        _photoManager.addPhoto()
        
    }
    
    internal func DelayFadeOut(){
        (ShootResult as UIView).fadeOut(duration: 0.5,completed: {self.ShootResult.alpha = 0})
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
                
                _photoManager.next()
                
                
                println(_photoManager.getImage())
                
                //描画する
                ShootResult.image = _photoManager.getImage()
                ShootResult.alpha = 1
                
                NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "DelayFadeOut", userInfo: nil, repeats: false)
                
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

class MyScrollView: UIScrollView {
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        superview?.touchesBegan(touches, withEvent: event)
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        superview?.touchesEnded(touches, withEvent: event)
    }
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        superview?.touchesCancelled(touches, withEvent: event)
    }
    
}

