//
//  ELRequest.swift
//  eventlist
//
//  Created by SuzukiAkinori on 2016/05/01.
//  Copyright © 2016年 kosa. All rights reserved.
//

import Foundation
import Alamofire
import NVActivityIndicatorView

class ELRequest: NSObject {
    func get(url:String, param:[String:AnyObject], completion:(jsonDic:NSDictionary) -> Void) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.loading { return }
        appDelegate.loading = true
        let loadingView : NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRectMake(ELConst().width/2 - 40,
            ELConst().height/2 - 40, 80, 80), type: .SquareSpin, color: ELConst().activityColor)
        ELConst().topController().view.addSubview(loadingView)
        loadingView.startAnimation()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.GET, url, parameters:param)
            .responseJSON{ response in
                switch response.result {
                case .Success(let value):
                    if let jsonDic = value as? NSDictionary {
                        completion(jsonDic: jsonDic)
                    }
                case .Failure(let error):
                    print(error)
                }
                loadingView.removeFromSuperview()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                appDelegate.loading = false
        }
    }

    func post(url:String, param:[String:AnyObject], completion:(jsonDic:NSDictionary) -> Void) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.loading { return }
        appDelegate.loading = true
        let loadingView : NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRectMake(ELConst().width/2 - 40,
            ELConst().height/2 - 40, 80, 80), type: .SquareSpin, color: ELConst().activityColor)
        ELConst().topController().view.addSubview(loadingView)
        loadingView.startAnimation()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.POST, url, parameters: param).responseJSON { response in
            switch response.result {
            case .Success(let value):
                if let jsonDic = value as? NSDictionary {
                    completion(jsonDic: jsonDic)
                }
            case .Failure(let error):
                print(error)
            }
            loadingView.removeFromSuperview()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            appDelegate.loading = false
        }
    }
}