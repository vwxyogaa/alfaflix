//
//  ReviewsCollectionViewCell.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import UIKit

class ReviewsCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarPathImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    // MARK: - Identifier
    static let identifier = String(describing: ReviewsCollectionViewCell.self)
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
        
        avatarPathImageView.layer.cornerRadius = avatarPathImageView.frame.height / 2
        avatarPathImageView.layer.masksToBounds = true
    }
    
    func configureContent(review: ReviewsResponse.Result?) {
        if let avatarPathImage = review?.authorDetails?.avatarPathImage, !avatarPathImage.isEmpty {
            avatarPathImageView.loadImage(uri: avatarPathImage)
        } else {
            avatarPathImageView.backgroundColor = .alfaBlack
        }
        authorLabel.text = "A Review by \(review?.author ?? "")"
        let createdAt = Utils.convertDateValidToDesc(review?.createdAt ?? "")
        createdAtLabel.text = "Written by \(review?.author ?? "") on \(createdAt)"
        contentLabel.text = review?.content
    }
}
