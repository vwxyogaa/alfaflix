//
//  MainScreenViewController.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import UIKit

class MainScreenViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var nowPlayingCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: - Methods
    private func configureViews() {
        configureCollectionViews()
    }
    
    private func configureCollectionViews() {
        nowPlayingCollectionView.register(NowPlayingCollectionViewCell.nib, forCellWithReuseIdentifier: NowPlayingCollectionViewCell.identifier)
        nowPlayingCollectionView.decelerationRate = .fast
        nowPlayingCollectionView.dataSource = self
        nowPlayingCollectionView.delegate = self
        
        popularCollectionView.register(CardMovieCollectionViewCell.nib, forCellWithReuseIdentifier: CardMovieCollectionViewCell.identifier)
        popularCollectionView.dataSource = self
        popularCollectionView.delegate = self
        
        topRatedCollectionView.register(CardMovieCollectionViewCell.nib, forCellWithReuseIdentifier: CardMovieCollectionViewCell.identifier)
        topRatedCollectionView.dataSource = self
        topRatedCollectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension MainScreenViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case nowPlayingCollectionView:
            return 5
        case popularCollectionView:
            return 10
        case topRatedCollectionView:
            return 10
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case nowPlayingCollectionView:
            guard let cell = nowPlayingCollectionView.dequeueReusableCell(withReuseIdentifier: NowPlayingCollectionViewCell.identifier, for: indexPath) as? NowPlayingCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case popularCollectionView:
            guard let cell = popularCollectionView.dequeueReusableCell(withReuseIdentifier: CardMovieCollectionViewCell.identifier, for: indexPath) as? CardMovieCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case topRatedCollectionView:
            guard let cell = topRatedCollectionView.dequeueReusableCell(withReuseIdentifier: CardMovieCollectionViewCell.identifier, for: indexPath) as? CardMovieCollectionViewCell else { return UICollectionViewCell() }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case nowPlayingCollectionView:
            let width = nowPlayingCollectionView.frame.width * 0.9
            let height = nowPlayingCollectionView.frame.height
            return CGSize(width: width, height: height)
        case popularCollectionView:
            let width = popularCollectionView.frame.width / 3.6
            let height = popularCollectionView.frame.height
            return CGSize(width: width, height: height)
        case topRatedCollectionView:
            let width = topRatedCollectionView.frame.width / 3.6
            let height = topRatedCollectionView.frame.height
            return CGSize(width: width, height: height)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case nowPlayingCollectionView:
            return 0
        case popularCollectionView:
            return 8
        case topRatedCollectionView:
            return 8
        default:
            return 0
        }
    }
}
