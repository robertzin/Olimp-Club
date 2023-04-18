//
//  UIView+Extension.swift
//  SportLocator
//
//  Created by Robert Zinyatullin on 07.03.2023.
//

import UIKit

extension UIView {
    
    /// Изменяет св-во cornerRadius у view
    /// - Parameters:
    ///   - radius: Радиус угла закругления
    ///   - corners: Какие углы будут закруглены
    ///   - borderWidth: Ширина границы
    ///   - borderColor: Цвет границы
    func corneredRadius(radius: CGFloat? = nil,
                        corners: CACornerMask? = nil,
                        borderWidth: CGFloat? = nil,
                        borderColor: UIColor? = nil) {
        
        layer.cornerRadius = radius == nil ? bounds.height / 2 : radius!
        clipsToBounds = true
        
        if let corners = corners {
            layer.maskedCorners = corners
        }
        
        if let borderWidth = borderWidth {
            layer.borderWidth = borderWidth
        }
        
        if let borderColor = borderColor {
            layer.borderColor = borderColor.cgColor
        }
    }
    
}
