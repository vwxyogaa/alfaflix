//
//  MainScreenViewModel.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import Foundation
import RxSwift

class MainScreenViewModel: BaseViewModel {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let mainScreenUseCase: MainScreenUseCaseProtocol
    
    private var autoScrollTimer: Timer?
    private var totalItems: Int = 0
    private var currentIndex: Int = 0
    var nowPlayingResults: [TMDBResponse.Results] = []
    var popularResults: [TMDBResponse.Results] = []
    var topRatedResults: [TMDBResponse.Results] = []
    
    let autoScrollIndex = PublishSubject<Int>()
    let nowPlayings = PublishSubject<[TMDBResponse.Results]?>()
    let populars = PublishSubject<[TMDBResponse.Results]?>()
    let topRateds = PublishSubject<[TMDBResponse.Results]?>()
    
    private var page: [MovieFeed: Int] = [.nowPlaying: 1, .popular: 1, .topRated: 1]
    private var isLoadingPage: [MovieFeed: Bool] = [.nowPlaying: false, .popular: false, .topRated: false]
    private var hasMoreData: [MovieFeed: Bool] = [.nowPlaying: true, .popular: true, .topRated: true]
    
    // MARK: - Lifecycles
    init(mainScreenUseCase: MainScreenUseCaseProtocol) {
        self.mainScreenUseCase = mainScreenUseCase
        super.init()
    }
    
    // MARK: - Methods
    func setTotalItems(count: Int) {
        totalItems = count
    }
    
    func resetAndLoadFirstPages() {
        nowPlayingResults.removeAll()
        popularResults.removeAll()
        topRatedResults.removeAll()
        
        page = [.nowPlaying: 1, .popular: 1, .topRated: 1]
        hasMoreData = [.nowPlaying: true, .popular: true, .topRated: true]
        isLoadingPage = [.nowPlaying: false, .popular: false, .topRated: false]
        
        loadNext(feed: .nowPlaying)
        loadNext(feed: .popular)
        loadNext(feed: .topRated)
    }
    
    func loadNext(feed: MovieFeed) {
        if isLoadingPage[feed] == true || hasMoreData[feed] == false { return }
        
        let nextPage = page[feed] ?? 1
        isLoadingPage[feed] = true
        setLoading(loading: true)
        
        let source: Observable<TMDBResponse?>
        switch feed {
        case .nowPlaying:
            source = mainScreenUseCase.getNowPlaying(page: nextPage)
        case .popular:
            source = mainScreenUseCase.getPopular(page: nextPage)
        case .topRated:
            source = mainScreenUseCase.getTopRated(page: nextPage)
        }
        
        source
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self else { return }
                self.setLoading(loading: false)
                self.isLoadingPage[feed] = false
                
                let newItems = response?.results ?? []
                if newItems.isEmpty {
                    self.hasMoreData[feed] = false
                    return
                }
                
                switch feed {
                case .nowPlaying:
                    self.nowPlayingResults.append(contentsOf: newItems)
                    self.totalItems = self.nowPlayingResults.count
                    self.nowPlayings.onNext(self.nowPlayingResults)
                case .popular:
                    self.popularResults.append(contentsOf: newItems)
                    self.populars.onNext(self.popularResults)
                case .topRated:
                    self.topRatedResults.append(contentsOf: newItems)
                    self.topRateds.onNext(self.topRatedResults)
                }
                
                self.page[feed] = nextPage + 1
            }, onError: { [weak self] error in
                guard let self else { return }
                self.setLoading(loading: false)
                self.isLoadingPage[feed] = false
                self.setError(message: error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    func startAutoScroll(interval: TimeInterval = 3.0) {
        stopAutoScroll()
        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.currentIndex = (self.currentIndex + 1) % max(self.totalItems, 1)
            self.autoScrollIndex.onNext(self.currentIndex)
        }
        if let timer = autoScrollTimer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    func stopAutoScroll() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
}

// MARK: - Now Playing
extension MainScreenViewModel {
    func getNowPlaying() {
        setLoading(loading: true)
        mainScreenUseCase.getNowPlaying(page: 1)
            .subscribe { [weak self] result in
                guard let self,
                      let data = result?.results else { return }
                self.setLoading(loading: false)
                self.nowPlayingResults = data
                self.nowPlayings.onNext(data)
            } onError: { [weak self] error in
                guard let self else { return }
                self.setLoading(loading: false)
                self.setError(message: error.localizedDescription)
            }.disposed(by: disposeBag)
    }
}

// MARK: - Popular
extension MainScreenViewModel {
    func getPopular() {
        setLoading(loading: true)
        mainScreenUseCase.getPopular(page: 1)
            .subscribe { [weak self] result in
                guard let self,
                      let data = result?.results else { return }
                self.setLoading(loading: false)
                self.popularResults = data
                self.populars.onNext(data)
            } onError: { [weak self] error in
                guard let self else { return }
                self.setLoading(loading: false)
                self.setError(message: error.localizedDescription)
            }.disposed(by: disposeBag)
    }
}

// MARK: - Top Rated
extension MainScreenViewModel {
    func getTopRated() {
        setLoading(loading: true)
        mainScreenUseCase.getTopRated(page: 1)
            .subscribe { [weak self] result in
                guard let self,
                      let data = result?.results else { return }
                self.setLoading(loading: false)
                self.topRatedResults = data
                self.topRateds.onNext(data)
            } onError: { [weak self] error in
                guard let self else { return }
                self.setLoading(loading: false)
                self.setError(message: error.localizedDescription)
            }.disposed(by: disposeBag)
    }
}
