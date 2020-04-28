//
//  FirstViewController.swift
//  NCanUtilsExamples
//
//  Created by Nguyen Can on 4/26/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

import UIKit
import NCanUtils

class FirstViewController: UIViewController {

    @IBOutlet weak var mScrollView: UIScrollView!
    @IBOutlet weak var mBottomBar: UIView!
    @IBOutlet weak var mInputView: UITextField!
    @IBOutlet weak var mResultLabel: UILabel!
    
    @IBAction func actionPhoneNumber(_ sender: Any) {
        let text = mInputView?.text ?? ""
        let result = "\(text.isPhone)".uppercased()
        mResultLabel?.text = "Phone number: \(result)"
    }
    
    @IBAction func actionVietnamPhone(_ sender: Any) {
        let text = mInputView?.text ?? ""
        let result = "\(text.isVietnamPhone)".uppercased()
        mResultLabel?.text = "Phone number (VN): \(result)"
    }
    
    @IBAction func actionEmail(_ sender: Any) {
        let text = mInputView?.text ?? ""
        let result = "\(text.isMail)".uppercased()
        mResultLabel?.text = "Email: \(result)"
    }
    
    @IBAction func actionAllDigits(_ sender: Any) {
        let text = mInputView?.text ?? ""
        let result = "\(text.isAllDigits)".uppercased()
        mResultLabel?.text = "All Digits: \(result)"
    }
    
    @IBAction func actionNumberic(_ sender: Any) {
        let text = mInputView?.text ?? ""
        let result = "\(text.isNumberic)".uppercased()
        mResultLabel?.text = "Numberic: \(result)"
    }
    
    @IBAction func actionChangeView(_ sender: Any) {
        UIApplication.switchRootView(withClass: SecondViewController.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.showTwoLineTitle(title: "NCanUtils", subtitle: "This is the swift library", alignment: .center) {
            NSLog("---> Click on title")
        }
        // Set up keyboard event
        registerKeyboardEvent(mScrollView, bottomBar: (mBottomBar, 68))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Remove keyboard event
        removeKeyboardEvent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NSLog("FirstViewController")
        NSLog("---> Is base root view: \(UIApplication.isBaseOnMainView(withClass: FirstViewController.self))")
        NSLog("---> Is base root view: \(UIApplication.isBaseOnMainView(withClass: SecondViewController.self))")
    }
}

