//
//  NowPlayingCollectionViewCell.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import UIKit

class NowPlayingCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nowPlayingImageView: UIImageView!
    
    // MARK: - Identifier
    static let identifier = String(describing: NowPlayingCollectionViewCell.self)
    static let nib = UINib(nibName: identifier, bundle: nil)
    
    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    // MARK: Methods
    private func configureViews() {
        containerView.layer.cornerRadius = 16
        nowPlayingImageView.layer.cornerRadius = 16
        
        containerView.layer.masksToBounds = true
        nowPlayingImageView.layer.masksToBounds = true
    }
    
    func configureContent(nowPlaying: TMDBResponse.Results?) {
        nowPlayingImageView.loadImage(uri: nowPlaying?.posterPathImage)
    }
}
