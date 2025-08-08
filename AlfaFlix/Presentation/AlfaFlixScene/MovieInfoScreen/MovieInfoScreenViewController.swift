//
//  MovieInfoScreenViewController.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import UIKit
import RxSwift
import AVKit
import WebKit

class MovieInfoScreenViewController: BaseViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var trailerContainerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var companiesProdLabel: UILabel!
    @IBOutlet weak var countriesProdLabel: UILabel!
    @IBOutlet weak var castStackView: UIStackView!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var reviewsStackView: UIStackView!
    @IBOutlet weak var reviewsCollectionView: UICollectionView!
    @IBOutlet weak var recommendationsStackView: UIStackView!
    @IBOutlet weak var recommendationsCollectionView: UICollectionView!
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    var viewModel: MovieInfoScreenViewModel?
    private var trailerVideoPlayer: AVPlayer?
    private var trailerPlayerLayer: AVPlayerLayer?
    private var trailerWebView: WKWebView?
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        initObserve()
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        trailerPlayerLayer?.frame = trailerContainerView.bounds
        trailerWebView?.frame = trailerContainerView.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        trailerVideoPlayer?.pause()
    }
    
    deinit {
        trailerVideoPlayer?.pause()
        trailerPlayerLayer?.removeFromSuperlayer()
        trailerWebView?.stopLoading()
        trailerWebView?.removeFromSuperview()
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
        
        viewModel.movie
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movie in
                guard let self else { return }
                self.configureContent(movie: movie)
            }).disposed(by: disposeBag)
        
        viewModel.casts
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] casts in
                guard let self else { return }
                if let cast = casts, !cast.isEmpty {
                    self.castStackView.isHidden = false
                } else {
                    self.castStackView.isHidden = true
                }
                self.castCollectionView.reloadData()
            }).disposed(by: disposeBag)
        
        viewModel.reviews
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] reviews in
                guard let self else { return }
                if let review = reviews, !review.isEmpty {
                    self.reviewsStackView.isHidden = false
                } else {
                    self.reviewsStackView.isHidden = true
                }
                self.reviewsCollectionView.reloadData()
            }).disposed(by: disposeBag)
        
        viewModel.recommendations
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] recommendations in
                guard let self else { return }
                if let recommendation = recommendations, !recommendation.isEmpty {
                    self.recommendationsStackView.isHidden = false
                } else {
                    self.recommendationsStackView.isHidden = true
                }
                self.recommendationsCollectionView.reloadData()
            }).disposed(by: disposeBag)
        
        viewModel.videos
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] videos in
                guard let self else { return }
                
                if let youtubeKey = videos?.first(where: { $0.site?.lowercased() == "youtube" && $0.type?.lowercased() == "trailer" })?.key, !youtubeKey.isEmpty {
                    self.embedYouTube(key: youtubeKey)
                    return
                }
                
                if let directVideo = videos?.first(where: { ($0.type?.lowercased() == "trailer") && ($0.site?.lowercased() != "youtube") }),
                   let videoURLString = directVideo.key,
                   let videoURL = URL(string: videoURLString) {
                    self.setupTrailerPlayer(with: videoURL)
                    return
                }
                
                self.showErrorSnackBar(message: "Trailer not found.")
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Methods
    private func configureViews() {
        configureButton()
        configureCollectionView()
    }
    
    private func configureButton() {
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        closeButton.layer.masksToBounds = true
        closeButton.setTitle("", for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    private func configureCollectionView() {
        castCollectionView.register(CastCollectionViewCell.nib, forCellWithReuseIdentifier: CastCollectionViewCell.identifier)
        castCollectionView.dataSource = self
        castCollectionView.delegate = self
        
        reviewsCollectionView.register(ReviewsCollectionViewCell.nib, forCellWithReuseIdentifier: ReviewsCollectionViewCell.identifier)
        reviewsCollectionView.dataSource = self
        reviewsCollectionView.delegate = self
        
        recommendationsCollectionView.register(CardMovieCollectionViewCell.nib, forCellWithReuseIdentifier: CardMovieCollectionViewCell.identifier)
        recommendationsCollectionView.dataSource = self
        recommendationsCollectionView.delegate = self
    }
    
    private func configureContent(movie: MovieResponse?) {
        let year = Utils.convertDateToYearOnly(movie?.releaseDate ?? "-")
        titleLabel.text = "\(movie?.title ?? "") (\(year))"
        let voteAverageDecimal = movie?.voteAverage ?? 0
        let voteAverage = (String(format: "%.1f", voteAverageDecimal))
        let releaseDate = Utils.convertDateSimple(movie?.releaseDate ?? "-")
        let runtime = Utils.minutesToHoursAndMinutes(movie?.runtime ?? 0)
        categoriesLabel.text = "\(releaseDate) • ⭐️\(voteAverage) • \(runtime.hours)h \(runtime.leftMinutes)m"
        genresLabel.text = movie?.genres?.compactMap({$0.name}).joined(separator: ", ")
        if let tagline = movie?.tagline, !tagline.isEmpty {
            taglineLabel.text = "#\(tagline)".uppercased()
        } else {
            taglineLabel.text = "-"
        }
        overviewLabel.text = movie?.overview
        companiesProdLabel.text = "Production Companies: \(movie?.productionCompanies?.compactMap({$0.name}).joined(separator: ", ") ?? "-")"
        countriesProdLabel.text = "Production Countries: \(movie?.productionCountries?.compactMap({$0.name}).joined(separator: ", ") ?? "-")"
    }
    
    private func setupTrailerPlayer(with videoURL: URL) {
        tearDownWebView()
        
        if let existingPlayer = trailerVideoPlayer {
            existingPlayer.replaceCurrentItem(with: AVPlayerItem(url: videoURL))
            existingPlayer.play()
        } else {
            let newPlayer = AVPlayer(url: videoURL)
            let newPlayerLayer = AVPlayerLayer(player: newPlayer)
            newPlayerLayer.frame = trailerContainerView.bounds
            newPlayerLayer.videoGravity = .resizeAspect
            trailerContainerView.layer.addSublayer(newPlayerLayer)
            self.trailerVideoPlayer = newPlayer
            self.trailerPlayerLayer = newPlayerLayer
            newPlayer.play()
        }
    }
    
    private func tearDownNativePlayer() {
        trailerVideoPlayer?.pause()
        trailerVideoPlayer = nil
        trailerPlayerLayer?.removeFromSuperlayer()
        trailerPlayerLayer = nil
    }
    
    private func tearDownWebView() {
        trailerWebView?.stopLoading()
        trailerWebView?.removeFromSuperview()
        trailerWebView = nil
    }
    
    private func loadData() {
        guard let viewModel else { return }
        if let id = viewModel.idMovie {
            viewModel.getDetail(id: id)
            viewModel.getCredits(id: id)
            viewModel.getReviews(id: id)
            viewModel.getRecommendations(id: id)
            viewModel.getVideos(id: id)
        }
    }
    
    private func embedYouTube(key: String) {
        tearDownNativePlayer()
        
        let youtubeWebConfig = WKWebViewConfiguration()
        youtubeWebConfig.allowsInlineMediaPlayback = true
        youtubeWebConfig.mediaTypesRequiringUserActionForPlayback = []
        youtubeWebConfig.allowsPictureInPictureMediaPlayback = true
        
        if trailerWebView == nil {
            let newTrailerWebView = WKWebView(frame: trailerContainerView.bounds, configuration: youtubeWebConfig)
            newTrailerWebView.backgroundColor = .black
            newTrailerWebView.isOpaque = false
            newTrailerWebView.scrollView.isScrollEnabled = false
            trailerContainerView.addSubview(newTrailerWebView)
            trailerWebView = newTrailerWebView
        }
        
        if let youtubeURL = URL(string: "https://www.youtube.com/embed/\(key)") {
            trailerWebView?.load(URLRequest(url: youtubeURL))
        }
    }
    
    // MARK: - Actions
    @objc
    private func closeButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension MovieInfoScreenViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel else { return 0 }
        switch collectionView {
        case castCollectionView:
            return viewModel.castsResults?.count ?? 0
        case reviewsCollectionView:
            return viewModel.reviewsResults?.count ?? 0
        case recommendationsCollectionView:
            return viewModel.recommendationsResults?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel else { return UICollectionViewCell() }
        switch collectionView {
        case castCollectionView:
            guard let cell = castCollectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.identifier, for: indexPath) as? CastCollectionViewCell else { return UICollectionViewCell() }
            let cast = viewModel.castsResults?[indexPath.row]
            cell.configureContent(casts: cast)
            return cell
        case reviewsCollectionView:
            guard let cell = reviewsCollectionView.dequeueReusableCell(withReuseIdentifier: ReviewsCollectionViewCell.identifier, for: indexPath) as? ReviewsCollectionViewCell else { return UICollectionViewCell() }
            let review = viewModel.reviewsResults?[indexPath.row]
            cell.configureContent(review: review)
            return cell
        case recommendationsCollectionView:
            guard let cell = recommendationsCollectionView.dequeueReusableCell(withReuseIdentifier: CardMovieCollectionViewCell.identifier, for: indexPath) as? CardMovieCollectionViewCell else { return UICollectionViewCell() }
            let recommendation = viewModel.recommendationsResults?[indexPath.row]
            cell.configureContentRecommendations(content: recommendation)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case recommendationsCollectionView:
            let movieInfoScreenViewController = MovieInfoScreenViewController()
            let movieInfoScreenViewModel = MovieInfoScreenViewModel(movieInfoScreenUseCase: Injection().provideMovieInfoScreenUseCase(), idMovie: viewModel?.recommendationsResults?[indexPath.row].id)
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
        case castCollectionView, recommendationsCollectionView:
            let availableWidth = collectionView.bounds.width
            let itemWidth = (availableWidth - (2 * spacing + peek)) / 3
            let itemHeight = collectionView.bounds.height
            return CGSize(width: floor(itemWidth), height: itemHeight)
        case reviewsCollectionView:
            let availableWidth = collectionView.bounds.width
            let itemWidth = availableWidth - (peek + spacing)
            return CGSize(width: floor(itemWidth), height: collectionView.bounds.height)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case castCollectionView, reviewsCollectionView, recommendationsCollectionView:
            return 8
        default:
            return 0
        }
    }
}
