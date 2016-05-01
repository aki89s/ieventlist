//
//  ELEditProfileController.swift
//  eventlist
//
//  Created by SuzukiAkinori on 2016/05/01.
//  Copyright © 2016年 kosa. All rights reserved.
//

import Foundation
import UIKit

class ELEditProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descField: UITextView!
    @IBOutlet weak var webField: UITextField!

    var actionSheet : UIAlertController?
    var imagePicker : UIImagePickerController?
    var changed : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker?.allowsEditing = true
        imagePicker!.delegate = self

        actionSheet = UIAlertController(title:nil, message: "プロフィール写真", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let actionCancel = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
        let actionNormal1 = UIAlertAction(title: "アルバムから選択", style: .Default, handler: {action in
            self.imagePicker!.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker!, animated: true, completion: nil)
        })
        let actionNormal2 = UIAlertAction(title: "写真を撮る", style: .Default, handler: {action in
            self.imagePicker!.sourceType = .Camera
            self.presentViewController(self.imagePicker!, animated: true, completion: nil)
        })
        let actionNormal3 = UIAlertAction(title: "写真を消去", style: .Default, handler: {
            action in
            /*
            let def : NSUserDefaults = NSUserDefaults.standardUserDefaults()
            let thumbnail = self.selectedImageView == self.thumbImageView
            let params : [String : AnyObject] = ["uuid": def.objectForKey("uuid") as! String,
                "thumbnail" : thumbnail,
                "index": self.selectedSubIndex!
            ]
             */
            /*
            ERequest().post("\(DeviceConst().baseURLString)/users/remove_photos", param: params){ jsonDic in
                def.removeObjectForKey("user_image")
                self.imagesUpdate(jsonDic)
            }
             */
        })
        for x in [actionCancel, actionNormal1, actionNormal2, actionNormal3] { actionSheet!.addAction(x) }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func viewTapped(sender: AnyObject) {
        nameField.resignFirstResponder()
        descField.resignFirstResponder()
        webField.resignFirstResponder()
    }

    @IBAction func thumbTapped(sender: AnyObject) {
        presentViewController(actionSheet!, animated: true, completion: nil)
    }

    @IBAction func saveTapped(sender: AnyObject) {
        if changed {
            let def : NSUserDefaults = NSUserDefaults.standardUserDefaults()
            let deviceToken = def.objectForKey("deviceToken") != nil ? def.objectForKey("deviceToken")! : ""
            let params : [String : AnyObject] = [
                "uuid": def.objectForKey("uuid") as! String,
                "name": def.objectForKey("user_name") as! String,
                "desc": descField.text!,
                "device_token": deviceToken
            ]

            /*
            let def : NSUserDefaults = NSUserDefaults.standardUserDefaults()
            let deviceToken = def.objectForKey("deviceToken") != nil ? def.objectForKey("deviceToken")! : ""
            let params : [String : AnyObject] = ["uuid": def.objectForKey("uuid") as! String,
                                                 "name": def.objectForKey("user_name") as! String,
                                                 "sex": sexSegment.selectedSegmentIndex,
                                                 "birth": dateLabel.text!,
                                                 "prefecture": prefectureLabel.text!,
                                                 "desc": textView.text!,
                                                 "publish": publishControl.selectedSegmentIndex,
                                                 "device_token": deviceToken
            ]

            ERequest().post("\(DeviceConst().baseURLString)/users/update", param:params){ jsonDic in
                def.setObject(jsonDic["user"]!["name"], forKey: "user_name")
                def.setObject(jsonDic["user"]!["id"], forKey: "user_id")
                def.setObject(jsonDic["user"]!["birthday"], forKey: "user_birthday")
                def.setObject(jsonDic["user"]!["desc"], forKey: "user_desc")
                def.setObject(jsonDic["user"]!["prefecture"], forKey: "user_prefecture")
                def.setObject(jsonDic["user"]!["sex"], forKey: "user_sex")
                def.setObject(jsonDic["user"]!["publish"], forKey: "user_publish")
                def.setBool(true, forKey: "didTutorial")
                def.synchronize()
                self.setProfile()
                changed = false
            }
            */
        }
    }






    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if (info.indexForKey(UIImagePickerControllerEditedImage) != nil) {
            let tookImage: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
            let resizedImage = tookImage.resize(CGSizeMake(414, 414))
            var imagePath = NSHomeDirectory() as NSString
            let date:NSDate = NSDate()
            let unixTimeStamp:NSTimeInterval = date.timeIntervalSince1970
            let unixTimeStampString:String = String(format:"%d", NSInteger(unixTimeStamp))
            imagePath = imagePath.stringByAppendingPathComponent("Documents/\(unixTimeStampString).png")
            let imageData: NSData = UIImagePNGRepresentation(resizedImage)!
            let isSuccess = imageData.writeToFile(imagePath as String, atomically: true)
            if isSuccess {
                let def : NSUserDefaults = NSUserDefaults.standardUserDefaults()
                def.setObject(imageData, forKey: "user_image")
                let fileUrl: NSURL = NSURL(fileURLWithPath: imagePath as String)
                uploadToS3(fileUrl)
            }
            return
        }
    }

    func uploadToS3(fileUrl:NSURL){
        /*
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.loading { return }
        appDelegate.loading = true
        let loadingView : NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRectMake(DeviceConst().width/2 - 40,
            DeviceConst().height/2 - 40, 80, 80), type: .BallSpinFadeLoader, color: DeviceConst().activityColor)
        DeviceConst().topController().view.addSubview(loadingView)
        loadingView.startAnimation()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        let thumbnail : Bool = selectedImageView == thumbImageView
        let def : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        Alamofire.upload(.POST, "\(DeviceConst().baseURLString)/users/change_avatar", multipartFormData: { (multi) -> Void in
            multi.appendBodyPart(fileURL: fileUrl, name: "image")
            if (thumbnail) {
                multi.appendBodyPart(data: "1".dataUsingEncoding(NSUTF8StringEncoding)!, name: "category")
            }else{
                multi.appendBodyPart(data: "2".dataUsingEncoding(NSUTF8StringEncoding)!, name: "category")
                multi.appendBodyPart(data: "\(self.selectedSubIndex!)".dataUsingEncoding(NSUTF8StringEncoding)!, name: "index")
            }

            if let data = def.objectForKey("uuid")!.dataUsingEncoding(NSUTF8StringEncoding) {
                multi.appendBodyPart(data: data, name: "uuid")
            }
        }) { (encodingResult) -> Void in
            switch encodingResult {
            case .Success(let upload, _, _):
                upload.responseJSON {response in
                    switch response.result {
                    case .Success(let value):
                        if let jsonDic = value as? NSDictionary { self.imagesUpdate(jsonDic) }
                    case .Failure(let error):
                        print(error)
                    }
                }
            case .Failure(let encodingError):
                print(encodingError)
            }
            loadingView.removeFromSuperview()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            appDelegate.loading = false
        }
         */
    }
}