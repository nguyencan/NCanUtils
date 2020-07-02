//
//  SecondViewController.swift
//  NCanUtilsExamples
//
//  Created by Nguyen Can on 4/28/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

import UIKit
import NCanUtils

class SecondViewController: UIViewController {
    
    @IBOutlet weak var viewImage: UIImageView!
    
    @IBAction func actionChangeView(_ sender: Any) {
        UIApplication.switchRootView(identifier: "RootNavController")
    }
    
    @objc func actionImageViewer(_ sender: Any) {
        if let iv = viewImage, let image = iv.image {
            CNImageViewer.present(image: image, source: iv, target: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NSLog("SecondViewController")
        NSLog("---> Is base root view: \(UIApplication.isBaseOnMainView(withClass: FirstViewController.self))")
        NSLog("---> Is base root view: \(UIApplication.isBaseOnMainView(withClass: SecondViewController.self))")
        
        registerIVTouchUpInside(viewImage)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewImage.removeGestureRecognizers()
    }
    
    private func registerIVTouchUpInside(_ iv: UIImageView) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(actionImageViewer(_:)))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizers([gesture])
    }
}
