//
//  CastCollectionViewCell.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profilePathImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    
    // MARK: - Identifier
    static let identifier = String(describing: CastCollectionViewCell.self)
    static let nib = UINib(nibName: identifier, bundle: nil)
    
    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    // MARK: - Methods
    private func configureViews() {
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.alfaGrayDark.cgColor
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
    }
    
    func configureContent(casts: CreditsResponse.Cast?) {
        if let profilePathImage = casts?.profilePathImage, !profilePathImage.isEmpty {
            profilePathImageView.loadImage(uri: profilePathImage)
        } else {
            profilePathImageView.backgroundColor = .alfaBlack
        }
        nameLabel.text = casts?.name
        characterLabel.text = casts?.character
    }
}
