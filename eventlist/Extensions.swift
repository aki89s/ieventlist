//
//  Extensions.swift
//  eventlist
//
//  Created by SuzukiAkinori on 2016/04/27.
//  Copyright © 2016年 kosa. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    func setBorderIBColor(color: UIColor!) -> Void{
        self.borderColor = color.CGColor
    }
}

extension UIColor {
    public func rgb(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: configuration, delegate:nil, delegateQueue:NSOperationQueue.mainQueue())

            let task = session.dataTaskWithRequest(request, completionHandler: {
                (data, response, error) -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData)
                }
            })
            task.resume()
        }
    }
}

extension UIImage {
    public func imageFromURL(urlString: String) -> UIImage {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: configuration, delegate:nil, delegateQueue:NSOperationQueue.mainQueue())

            var image = UIImage()
            let task = session.dataTaskWithRequest(request, completionHandler: {
                (data, response, error) -> Void in
                if let imageData = data as NSData? {
                    image = UIImage(data: imageData)!
                }
            })
            task.resume()
            return image
        }
        return UIImage()
    }


    func resize(size: CGSize) -> UIImage {
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        let ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio
        let resizedSize = CGSize(width: (self.size.width * ratio), height: (self.size.height * ratio))
        UIGraphicsBeginImageContext(resizedSize)
        drawInRect(CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }

    // 比率だけ指定する場合
    func resize(ratio ratio: CGFloat) -> UIImage {
        let resizedSize = CGSize(width: Int(self.size.width * ratio), height: Int(self.size.height * ratio))
        UIGraphicsBeginImageContext(resizedSize)
        drawInRect(CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

extension UIView {
    func radius (num: CGFloat) {
        self.layer.cornerRadius = num
        self.layer.masksToBounds = true
    }
    var top : CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var frame       = self.frame
            frame.origin.y  = newValue
            self.frame      = frame
        }
    }
    var bottom : CGFloat{
        get{
            return frame.origin.y + frame.size.height
        }
        set{
            var frame       = self.frame
            frame.origin.y  = newValue - self.frame.size.height
            self.frame      = frame
        }
    }
    var right : CGFloat{
        get{
            return self.frame.origin.x + self.frame.size.width
        }
        set{
            var frame       = self.frame
            frame.origin.x  = newValue - self.frame.size.width
            self.frame      = frame
        }
    }
    var left : CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var frame       = self.frame
            frame.origin.x  = newValue
            self.frame      = frame
        }
    }
    var cent : CGPoint{
        get{
            return CGPoint(x: self.frame.origin.x + (self.frame.size.width / 2),
                           y: self.frame.origin.y + (self.frame.size.height / 2))
        }
        set{
            var frame       = self.frame
            frame.origin.x  = newValue.x - (frame.width/2)
            frame.origin.y  = newValue.y - (frame.height/2)
            self.frame      = frame
        }
    }
    var x : CGFloat {
        get{
            return self.frame.origin.x
        }
        set{
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    var y : CGFloat {
        get{
            return self.frame.origin.y
        }
        set{
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
}
