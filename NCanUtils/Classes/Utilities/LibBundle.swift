//
//  LibBundle.swift
//  NCanUtils
//
//  Created by SG on 4/28/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

import UIKit

struct ImagesHelper {
    
    private static var podsBundle: Bundle {
        return Bundle(identifier: "ios.ncan.utils")!
    }

    private static func imageFor(name imageName: String) -> UIImage {
        return UIImage.init(named: imageName, in: podsBundle, compatibleWith: nil)!
    }

    static var blank: UIImage {
        return imageFor(name: "ic-nav-blank")
    }
    
    static var clear: UIImage {
        return imageFor(name: "ic-clear")
    }
    
    static var search: UIImage {
        return imageFor(name: "ic-search")
    }
}
