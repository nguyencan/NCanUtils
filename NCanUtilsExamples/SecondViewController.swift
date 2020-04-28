//
//  SecondViewController.swift
//  NCanUtilsExamples
//
//  Created by Nguyen Can on 4/28/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBAction func actionChangeView(_ sender: Any) {
        UIApplication.switchRootView(identifier: "RootNavController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NSLog("SecondViewController")
        NSLog("---> Is base root view: \(UIApplication.isBaseOnMainView(withClass: FirstViewController.self))")
        NSLog("---> Is base root view: \(UIApplication.isBaseOnMainView(withClass: SecondViewController.self))")
    }
}
