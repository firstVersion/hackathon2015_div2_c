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
    @IBOutlet weak var ShootResult: UIImageView!
    
    let _accelManager = AccelManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.   
        
        _cameraManager.delegate = self
        _cameraManager.setPreview(CameraPreview)
        
        _accelManager.setup({ self.ShootResult.image = self._cameraManager.rotatedVideoImage()})
        
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
                view1.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.9)
            case .Ended:
                view1.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.0)
                println("UIGestureRecognizerState.Ended")
            default:
        break;
        }
    }


}

