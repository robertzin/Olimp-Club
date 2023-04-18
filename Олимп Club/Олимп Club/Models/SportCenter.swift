//
//  SportCenter.swift
//  SportLocator
//
//  Created by Robert Zinyatullin on 08.03.2023.
//

import UIKit

enum Sports {
    case football
    case basketball
    case volleyball
    case hockey
}

struct SportCenter {
    var name: String
    var address: String
    var workingHours: (String, String)
    var mobile: String
    var webSite: String
    var image: UIImage
    var sport: Sports
}
