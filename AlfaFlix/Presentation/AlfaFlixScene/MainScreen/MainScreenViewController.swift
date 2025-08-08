//
//  MainScreenViewController.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import UIKit
import RxSwift

class MainScreenViewController: BaseViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var nowPlayingCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    var viewModel: MainScreenViewModel?
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        initObserve()
        loadData()
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
        guard let viewModel else { return }
        
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                guard let self else { return }
                self.manageLoadingActivity(isLoading: isLoading)
            }).disposed(by: disposeBag)
        
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] errorMessage in
                guard let self else { return }
                self.showErrorSnackBar(message: errorMessage)
            }).disposed(by: disposeBag)
        
        viewModel.autoScrollIndex
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] index in
                guard let self,
                      let layout = self.nowPlayingCollectionView.collectionViewLayout as? CenteredCollectionViewFlowLayout else { return }
                layout.scrollToPage(index: index, animated: true)
            }).disposed(by: disposeBag)
        
        viewModel.nowPlayings
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] nowPlayings in
                guard let self,
                      let viewModel = self.viewModel else { return }
                self.nowPlayingCollectionView.reloadData()
                let count = nowPlayings?.count ?? 0
                viewModel.setTotalItems(count: count)
                
                if count > 0 {
                    viewModel.startAutoScroll()
                } else {
                    viewModel.stopAutoScroll()
                }
            }).disposed(by: disposeBag)
        
        viewModel.populars
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                self.popularCollectionView.reloadData()
            }).disposed(by: disposeBag)
        
        viewModel.topRateds
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                self.topRatedCollectionView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Methods
    private func configureViews() {
        configureCollectionViews()
    }
    
    private func loadData() {
        guard let viewModel else { return }
        viewModel.getNowPlaying()
        viewModel.getPopular()
        viewModel.getTopRated()
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
        guard let viewModel else { return 0 }
        switch collectionView {
        case nowPlayingCollectionView:
            return viewModel.nowPlayingResults?.count ?? 0
        case popularCollectionView:
            return viewModel.popularResults?.count ?? 0
        case topRatedCollectionView:
            return viewModel.topRatedResults?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel else { return UICollectionViewCell() }
        switch collectionView {
        case nowPlayingCollectionView:
            guard let cell = nowPlayingCollectionView.dequeueReusableCell(withReuseIdentifier: NowPlayingCollectionViewCell.identifier, for: indexPath) as? NowPlayingCollectionViewCell else { return UICollectionViewCell() }
            let nowPlaying = viewModel.nowPlayingResults?[indexPath.row]
            cell.configureContent(nowPlaying: nowPlaying)
            return cell
        case popularCollectionView:
            guard let cell = popularCollectionView.dequeueReusableCell(withReuseIdentifier: CardMovieCollectionViewCell.identifier, for: indexPath) as? CardMovieCollectionViewCell else { return UICollectionViewCell() }
            let popular = viewModel.popularResults?[indexPath.row]
            cell.configureContentDashboard(content: popular)
            return cell
        case topRatedCollectionView:
            guard let cell = topRatedCollectionView.dequeueReusableCell(withReuseIdentifier: CardMovieCollectionViewCell.identifier, for: indexPath) as? CardMovieCollectionViewCell else { return UICollectionViewCell() }
            let topRated = viewModel.topRatedResults?[indexPath.row]
            cell.configureContentDashboard(content: topRated)
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
