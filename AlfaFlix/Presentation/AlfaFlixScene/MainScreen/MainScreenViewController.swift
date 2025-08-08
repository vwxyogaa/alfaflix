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
            let spacing: CGFloat = 0
            let peek: CGFloat = 20
            let collectionWidth = nowPlayingCollectionView.bounds.width
            let width  = collectionWidth - 2 * (peek + spacing)
            let height = nowPlayingCollectionView.bounds.height
            layout.minimumLineSpacing = spacing
            layout.sectionInset = .zero
            layout.itemSize = CGSize(width: floor(width), height: height)
            layout.invalidateLayout()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
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

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension MainScreenViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case nowPlayingCollectionView:
            let movieInfoScreenViewController = MovieInfoScreenViewController()
            let movieInfoScreenViewModel = MovieInfoScreenViewModel(movieInfoScreenUseCase: Injection().provideMovieInfoScreenUseCase(), idMovie: viewModel?.nowPlayingResults?[indexPath.row].id)
            movieInfoScreenViewController.viewModel = movieInfoScreenViewModel
            navigationController?.pushViewController(movieInfoScreenViewController, animated: true)
        case popularCollectionView:
            let movieInfoScreenViewController = MovieInfoScreenViewController()
            let movieInfoScreenViewModel = MovieInfoScreenViewModel(movieInfoScreenUseCase: Injection().provideMovieInfoScreenUseCase(), idMovie: viewModel?.popularResults?[indexPath.row].id)
            movieInfoScreenViewController.viewModel = movieInfoScreenViewModel
            navigationController?.pushViewController(movieInfoScreenViewController, animated: true)
        case topRatedCollectionView:
            let movieInfoScreenViewController = MovieInfoScreenViewController()
            let movieInfoScreenViewModel = MovieInfoScreenViewModel(movieInfoScreenUseCase: Injection().provideMovieInfoScreenUseCase(), idMovie: viewModel?.topRatedResults?[indexPath.row].id)
            movieInfoScreenViewController.viewModel = movieInfoScreenViewModel
            navigationController?.pushViewController(movieInfoScreenViewController, animated: true)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 8
        let peek: CGFloat = 20
        switch collectionView {
        case nowPlayingCollectionView:
            return (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? .zero
        case popularCollectionView, topRatedCollectionView:
            let availableWidth = collectionView.bounds.width
            let itemWidth = (availableWidth - (2 * spacing + peek)) / 3
            let itemHeight = collectionView.bounds.height
            return CGSize(width: floor(itemWidth), height: itemHeight)
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
