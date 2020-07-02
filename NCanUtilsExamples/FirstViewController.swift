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
        let result = "\(text.isValidMail)".uppercased()
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
        
        var double: Double = 1.0
        NSLog("---> Double: \(double) >> \(double.clean)")
        double = 1.2
        NSLog("---> Double: \(double) >> \(double.clean)")
        double = 1.02
        NSLog("---> Double: \(double) >> \(double.clean)")
        
        var float: Float = 1.0
        NSLog("---> Float: \(float) >> \(float.clean)")
        float = 1.2
        NSLog("---> Float: \(float) >> \(float.clean)")
        float = 1.02
        NSLog("---> Float: \(float) >> \(float.clean)")
        float = 1005000
        NSLog("---> Money collapse: \(float) >> \(Money.collapse(money: float))")
        float = 1050000
        NSLog("---> Money collapse: \(float) >> \(Money.collapse(money: float))")
        float = 1500000
        NSLog("---> Money collapse: \(float) >> \(Money.collapse(money: float))")
        
        let nilFloat: Float? = nil
        NSLog("---> Money collapse: \(String(describing: nilFloat)) >> \(Money.collapse(money: nilFloat))")
        NSLog("---> Money collapse: \(String(describing: nilFloat)) with default >> \(Money.collapse(money: nilFloat, default: "ABC"))")
        
        var moneyString: String = ""
        NSLog("Money String to Float: \(moneyString) >> \(Money.toFloat(money: moneyString))")
        moneyString = "1.000"
        NSLog("Money String to Float: \(moneyString) >> \(Money.toFloat(money: moneyString))")
        moneyString = "1.000,25"
        NSLog("Money String to Float: \(moneyString) >> \(Money.toFloat(money: moneyString))")
        moneyString = "1.000,00"
        NSLog("Money String to Float: \(moneyString) >> \(Money.toFloat(money: moneyString))")
        moneyString = "1,000.00"
        NSLog("Money String to Float: \(moneyString) >> \(Money.toFloat(money: moneyString, grouped: ",", decimal: "."))")
        moneyString = "1 000.00"
        NSLog("Money String to Float: \(moneyString) >> \(Money.toFloat(money: moneyString, grouped: " ", decimal: "."))")
        
        NSLog("Formatter: \(DateFormatter.string(Date(), format: .full))")
    }
}

