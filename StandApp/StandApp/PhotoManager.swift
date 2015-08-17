//
//  PhotoManager.swift
//  StandApp
//
//  Created by PeroPeroMan on 2015/08/16.
//  Copyright (c) 2015年 Team-C. All rights reserved.
//

import Foundation
import Photos

class PhotoManager {
    private var assets: PHFetchResult = PHFetchResult()
    private var index: Int = 0
    private var photo_num: Int = 0
    
    private var window_size: CGRect = CGRect()
    
    internal func getCount() -> Int {
        return photo_num
    }
    
    func setup(WindowSize size: CGRect) {
        window_size = size
        
        var options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        assets = PHAsset.fetchAssetsWithMediaType(.Image, options: options)
    }
    
    func setNewerImager(refImg:UIImageView ){
        
        var options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        assets = PHAsset.fetchAssetsWithMediaType(.Image, options: options)
        
        var asset: PHAsset = assets.firstObject as! PHAsset
        let manager: PHImageManager = PHImageManager()
        manager.requestImageForAsset(asset, targetSize: CGSizeMake(window_size.width, window_size.height), contentMode: .AspectFill, options: nil) { (image, info) -> Void in
            refImg.image = image
        }

    }
    
    func getImage() -> UIImage? {
        if photo_num == 0 {
            return nil
        }
        
        var img: UIImage = UIImage()
        
        var asset: PHAsset = assets[index] as! PHAsset
        let manager: PHImageManager = PHImageManager()
        manager.requestImageForAsset(asset, targetSize: CGSizeMake(window_size.width, window_size.height), contentMode: .AspectFill, options: nil) { (image, info) -> Void in
            img = image
        }
        
        return img
    }
    
    func next() {
        index++
//        if index >= photo_num {
//            index = photo_num-1
//        }
    }
    
    func previous() {
        index--
        if index <= photo_num {
            index = 0
        }
    }
    
    func addPhoto() {
        photo_num++
    }
    
    func deleteImage() {
        if photo_num == 0 {
            return
        }
        
        let delTargetAsset = assets[index]
        if delTargetAsset != nil {
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
                PHAssetChangeRequest.deleteAssets([delTargetAsset!])
                }, completionHandler: { (success, error) -> Void in
                    
            })
        }
    }
}