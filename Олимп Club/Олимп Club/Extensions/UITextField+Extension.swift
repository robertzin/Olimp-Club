//
//  UITextField+Extension.swift
//  SportLocator
//
//  Created by Robert Zinyatullin on 07.03.2023.
//

import UIKit

extension UITextField {
    
    /// Добвить картинку к левой стороне TextField
    func addLeft(image: UIImage) {
        layer.masksToBounds = true
        
        let inset: CGFloat = 5
        
        let containerView = UIView(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: frame.height + inset,
                                                 height: frame.height))
        
        let imageView = UIImageView(frame: CGRect(x: inset,
                                                  y: 0,
                                                  width: 20,
                                                  height: 20))
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Constants.Colors.icon
        imageView.center = containerView.center
        containerView.addSubview(imageView)
        
        leftView = containerView
        leftViewMode = .always
    }
}
