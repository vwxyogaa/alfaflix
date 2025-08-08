//
//  MainScreenViewController.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import UIKit
import RxSwift

class MainScreenViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var nowPlayingCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    private let viewModel = MainScreenViewModel()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        initObserve()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startAutoScroll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopAutoScroll()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let layout = nowPlayingCollectionView.collectionViewLayout as? CenteredCollectionViewFlowLayout {
            let width  = nowPlayingCollectionView.bounds.width * 0.9
            let height = nowPlayingCollectionView.bounds.height
            layout.itemSize = CGSize(width: width, height: height)
            layout.minimumLineSpacing = 0
            layout.invalidateLayout()
        }
    }
    
    // MARK: - Observe
    private func initObserve() {
        viewModel.autoScrollIndex
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] index in
                guard let self,
                      let layout = self.nowPlayingCollectionView.collectionViewLayout as? CenteredCollectionViewFlowLayout else { return }
                layout.scrollToPage(index: index, animated: true)
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Methods
    private func configureViews() {
        configureCollectionViews()
        viewModel.setTotalItems(count: collectionView(nowPlayingCollectionView, numberOfItemsInSection: 0))
    }
    
    private func configureCollectionViews() {
        nowPlayingCollectionView.register(NowPlayingCollectionViewCell.nib, forCellWithReuseIdentifier: NowPlayingCollectionViewCell.identifier)
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

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MainScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case popularCollectionView, topRatedCollectionView:
            return 8
        default:
            return 0
        }
    }
}
