//
//  Int+Extension.swift
//  WhiteAndFluffy
//
//  Created by Aleksei Omelchenko on 10/28/23.
//

import UIKit

extension Int {
   var scale: CGFloat {
        let realSize = UIScreen.main.bounds.width
        let iphoneProSize: Double = 393
        return CGFloat(Double(self) * (Double(realSize) / iphoneProSize))
    }
}
