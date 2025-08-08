//
//  UIImageView+Ext.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import Foundation
import UIKit
import Kingfisher

// MARK: - Kingfisher Load Image
extension UIImageView {
    func loadImage(uri: String?, placeholder: UIImage? = nil) {
        guard let uri = uri, let uriImage = URL(string: uri) else { return }
        kf.setImage(with: uriImage, placeholder: placeholder)
    }
}
