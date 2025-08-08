//
//  CardMovieCollectionViewCell.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import UIKit

class CardMovieCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentImageView: UIImageView!
    
    // MARK: - Identifier
    static let identifier = String(describing: CardMovieCollectionViewCell.self)
    static let nib = UINib(nibName: identifier, bundle: nil)
    
    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    // MARK: - Methods
    private func configureViews() {
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
    }
    
    func configureContentDashboard(content: TMDBResponse.Results?) {
        contentImageView.loadImage(uri: content?.posterPathImage)
    }
    
    
    func configureContentRecommendations(content: RecommendationsResponse.Result?) {
        contentImageView.loadImage(uri: content?.posterPathImage)
    }
}
