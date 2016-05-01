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
