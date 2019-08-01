//
//  UIImage+colored.swift
//  EnvironmentSwitcher
//
//  Created by Stas on 01/08/2019.
//  Copyright © 2019 AERO. All rights reserved.
//

import UIKit

/// Wrapper for get UIImage with specific color and size
public extension UIImage {
    
    /// Generate square image with specific color and size
    /// - Parameters:
    ///     - color: Color for result image.
    ///     - size: The *y* component of the vector.
    /// - Returns: square image with specific color and size
    static func colored(_ color: UIColor = .red, size: CGFloat = 42) -> UIImage? {
        let rect = CGRect(origin: .zero, size: CGSize(width: size, height: size))
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
    
}
