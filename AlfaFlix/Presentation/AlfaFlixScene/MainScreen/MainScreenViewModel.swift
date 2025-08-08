//
//  MainScreenViewModel.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import Foundation
import RxSwift
import RxCocoa

class MainScreenViewModel: BaseViewModel {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let mainScreenUseCase: MainScreenUseCaseProtocol
    
    private var autoScrollTimer: Timer?
    private var totalItems: Int = 0
    private var currentIndex: Int = 0
    var nowPlayingResults: [TMDBResponse.Results]?
    var popularResults: [TMDBResponse.Results]?
    var topRatedResults: [TMDBResponse.Results]?
    
    let autoScrollIndex = PublishSubject<Int>()
    let nowPlayings = PublishSubject<[TMDBResponse.Results]?>()
    let populars = PublishSubject<[TMDBResponse.Results]?>()
    let topRateds = PublishSubject<[TMDBResponse.Results]?>()
    
    // MARK: - Lifecycles
    init(mainScreenUseCase: MainScreenUseCaseProtocol) {
        self.mainScreenUseCase = mainScreenUseCase
        super.init()
    }
    
    // MARK: - Methods
    func setTotalItems(count: Int) {
        totalItems = count
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
                      let data = result.results else { return }
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
                      let data = result.results else { return }
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
                      let data = result.results else { return }
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
