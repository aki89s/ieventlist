//
//  ELPlanController.swift
//  eventlist
//
//  Created by SuzukiAkinori on 2016/05/01.
//  Copyright © 2016年 kosa. All rights reserved.
//

import Foundation
import UIKit
import KeychainAccess

class ELPlanController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    enum kSelected : Int {
        case StartDate = 0, StartTime, EndDate, EndTime
    }

    let list =  ["北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県",
                 "茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県",
                 "新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県","静岡県","愛知県",
                 "三重県","滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県",
                 "鳥取県","島根県","岡山県","広島県","山口県","徳島県","香川県","愛媛県","高知県",
                 "福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県", "未設定"]

    @IBOutlet weak var nameField: ELTextField!
    @IBOutlet weak var addressField: ELTextField!
    @IBOutlet weak var urlField: ELTextField!
    @IBOutlet weak var descField: UITextView!
    @IBOutlet weak var prefectureLabel: UILabel!

    var datePicker : UIDatePicker?
    var timePicker : UIDatePicker?
    var picker : UIPickerView?
    var selectedDateTime : Int = 0
    var txtActiveField = UITextField()
    var movedKeyboard : Bool = false

    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var startTimeButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    @IBOutlet weak var endTimeButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker = UIDatePicker(frame: CGRectMake(0, ELConst().height, self.view.frame.width, 200))
        datePicker!.datePickerMode = .Date
        datePicker!.timeZone = NSTimeZone.localTimeZone()
        datePicker!.addTarget(self, action: #selector(ELPlanController.onDidChangeDate(_:)), forControlEvents: .ValueChanged)
        timePicker = UIDatePicker(frame: CGRectMake(0, ELConst().height, self.view.frame.width, 200))
        timePicker!.datePickerMode = .Time
        timePicker!.timeZone = NSTimeZone.localTimeZone()
        timePicker!.addTarget(self, action: #selector(ELPlanController.onDidChangeDate(_:)), forControlEvents: .ValueChanged)

        picker = UIPickerView(frame: CGRectMake(0, ELConst().height, self.view.frame.width, 200))
        picker!.delegate = self
        picker!.dataSource = self
        picker!.layer.cornerRadius = 5.0
        picker!.layer.shadowOpacity = 0.5

        for x : UIView in [datePicker!, timePicker!, picker!] {
            x.backgroundColor = UIColor.whiteColor()
            x.hidden = true
            self.tabBarController?.view.addSubview(x)
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(ELPlanController.handleKeyboardWillShowNotification(_:)), name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(ELPlanController.handleKeyboardWillHideNotification(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }


    func handleKeyboardWillShowNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
        let txtLimit = txtActiveField.frame.origin.y + txtActiveField.frame.height + 8.0
        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height

        if txtLimit >= kbdLimit {
            movedKeyboard = true
            UIView.animateWithDuration(0.3, animations: {
                self.scrollView.contentOffset.y = txtLimit - kbdLimit
            })
        }
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        if movedKeyboard {
            UIView.animateWithDuration(0.3, animations: {
                self.scrollView.contentOffset.y = 0
            })
            movedKeyboard = false
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let chain = Keychain(service: ELConst().keychainBundle)
        if chain["userRegistered"] == nil {
            let alert : UIAlertController = UIAlertController(title: "", message: "プロフィールを登録すると\nイベントを企画できるようになります。\n「プロフィール」 > 「設定」 から\nプロフィールの登録が行えます", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    internal func onDidChangeDate(sender: UIDatePicker){
        let myDateFormatter: NSDateFormatter = NSDateFormatter()
        switch selectedDateTime {
        case kSelected.StartDate.rawValue:
            myDateFormatter.dateFormat = "yyyy年MM月dd日"
            let mySelectedDate: NSString = myDateFormatter.stringFromDate(sender.date)
            startDateButton.setTitle(mySelectedDate as String, forState: .Normal)
        case kSelected.EndDate.rawValue:
            myDateFormatter.dateFormat = "yyyy年MM月dd日"
            let mySelectedDate: NSString = myDateFormatter.stringFromDate(sender.date)
            endDateButton.setTitle(mySelectedDate as String, forState: .Normal)
        case kSelected.StartTime.rawValue:
            myDateFormatter.dateFormat = "HH:mm"
            let mySelectedDate: NSString = myDateFormatter.stringFromDate(sender.date)
            startTimeButton.setTitle(mySelectedDate as String, forState: .Normal)
        case kSelected.EndTime.rawValue:
            myDateFormatter.dateFormat = "HH:mm"
            let mySelectedDate: NSString = myDateFormatter.stringFromDate(sender.date)
            endTimeButton.setTitle(mySelectedDate as String, forState: .Normal)
        default:
            break
        }
    }

    @IBAction func startDatePushed(sender: AnyObject) {
        hideKeyboard()
        hidePrefecturePicker()
        hideTimePicker()
        showDatePicker()
        selectedDateTime = kSelected.StartDate.rawValue
    }


    @IBAction func startTimePushed(sender: AnyObject) {
        hideKeyboard()
        hidePrefecturePicker()
        hideDatePicker()
        showTimePicker()
        selectedDateTime = kSelected.StartTime.rawValue
    }

    @IBAction func endDatePushed(sender: AnyObject) {
        hideKeyboard()
        hidePrefecturePicker()
        hideTimePicker()
        showDatePicker()
        selectedDateTime = kSelected.EndDate.rawValue
    }

    @IBAction func endTimePushed(sender: AnyObject) {
        hideKeyboard()
        hidePrefecturePicker()
        hideDatePicker()
        showTimePicker()
        selectedDateTime = kSelected.EndTime.rawValue
    }

    @IBAction func viewTapped(sender: AnyObject) {
        hideKeyboard()
        hideDatePicker()
        hideTimePicker()
        hidePrefecturePicker()
    }

    // ******************************
    func showPrefecturePicker() {
        if picker!.hidden {
            picker!.hidden = false
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.picker!.y = ELConst().height - (self.picker!.frame.height + (self.tabBarController?.tabBar.frame.height)!)
            })
        }
    }

    func hidePrefecturePicker() {
        if (!picker!.hidden){
            picker!.resignFirstResponder()
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.picker!.y = ELConst().height
                }, completion: { (Bool) -> Void in
                    self.picker!.hidden = true
            })
        }
    }

    func hideKeyboard() {
        nameField.resignFirstResponder()
        addressField.resignFirstResponder()
        urlField.resignFirstResponder()
        descField.resignFirstResponder()
    }

    func showDatePicker() {
        if datePicker!.hidden {
            datePicker!.hidden = false
            view.bringSubviewToFront(datePicker!)
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.datePicker!.y = ELConst().height - (self.datePicker!.frame.height + (self.tabBarController?.tabBar.frame.height)!)

            })
        }
    }

    func hideDatePicker() {
        if (!datePicker!.hidden){
            datePicker!.resignFirstResponder()
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.datePicker!.y = ELConst().height
                }, completion: { (Bool) -> Void in
                    self.datePicker!.hidden = true
            })
            return
        }
    }

    func hideTimePicker() {
        if (!timePicker!.hidden){
            timePicker!.resignFirstResponder()
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.timePicker!.y = ELConst().height
                }, completion: { (Bool) -> Void in
                    self.timePicker!.hidden = true
            })
            return
        }
    }

    func showTimePicker(){
        if timePicker!.hidden {
            timePicker!.hidden = false
            view.bringSubviewToFront(timePicker!)
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.timePicker!.y = ELConst().height - (self.timePicker!.frame.height + (self.tabBarController?.tabBar.frame.height)!)
            })
        }
    }

    @IBAction func prefecturePushed(sender: AnyObject) {
        hideKeyboard()
        hideTimePicker()
        hideDatePicker()
        showPrefecturePicker()
    }

    @IBAction func registerPushed(sender: AnyObject) {
        print("くりえいと")
        let chain : Keychain = Keychain(service: ELConst().keychainBundle)
        if chain["userRegistered"] == nil {
            let alert : UIAlertController = UIAlertController(title: "",
                                                              message: "イベントの登録には\nプロフィールが必要です。\nプロフィール > 設定 から\nプロフィールの登録を\n行ってください。", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }

        if nameField.text! == "" {
            let alert : UIAlertController = UIAlertController(title: "",
                                                              message: "イベント名を入力してください。", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }

        let params : [String : AnyObject] = [
            "uuid": chain["uuid"]!,
            "name": nameField.text!,
            "desc": descField.text!,
            "url": urlField.text!,
            "prefecture": prefectureLabel.text!,
            "address": addressField.text!,
            "start_date": "\((startDateButton.titleLabel?.text!)!)\((startTimeButton.titleLabel?.text!)!)",
            "end_date": "\((endDateButton.titleLabel?.text!)!)\((endTimeButton.titleLabel?.text!)!)",
        ]

        ELRequest().post("\(ELConst().baseURLString)/events/create", param:params){ jsonDic in
            if ((jsonDic["create"] as! Bool)) {
                let alert : UIAlertController = UIAlertController(title: "",
                                                                  message: "イベントが登録されました。", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }


    // **************
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        txtActiveField = textField
        return true
    }

    // picker view
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        prefectureLabel.text = list[row]
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
}
