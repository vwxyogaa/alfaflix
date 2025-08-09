//
//  MovieInfoScreenViewModel.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import Foundation
import RxSwift

class MovieInfoScreenViewModel: BaseViewModel {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let movieInfoScreenUseCase: MovieInfoScreenUseCaseProtocol
    
    var idMovie: Int?
    var videosResults: [VideosResponse.Result]?
    var movieResults: MovieResponse?
    var castsResults: [CreditsResponse.Cast]?
    var reviewsResults: [ReviewsResponse.Result]?
    var recommendationsResults: [RecommendationsResponse.Result]?
    
    let videos = PublishSubject<[VideosResponse.Result]?>()
    let movie = PublishSubject<MovieResponse?>()
    let casts = PublishSubject<[CreditsResponse.Cast]?>()
    let reviews = PublishSubject<[ReviewsResponse.Result]?>()
    let recommendations = PublishSubject<[RecommendationsResponse.Result]?>()
    
    // MARK: - Lifecycles
    init(movieInfoScreenUseCase: MovieInfoScreenUseCaseProtocol, idMovie: Int?) {
        self.movieInfoScreenUseCase = movieInfoScreenUseCase
        self.idMovie = idMovie
        super.init()
    }
    
    func loadAll(id: Int) {
        setLoading(loading: true)
        
        let detail = movieInfoScreenUseCase.getDetail(id: id).asSingle()
        let credits = movieInfoScreenUseCase.getCredits(id: id).asSingle()
        let reviews = movieInfoScreenUseCase.getReviews(id: id).asSingle()
        let recommendations = movieInfoScreenUseCase.getRecommendations(id: id).asSingle()
        let videos   = movieInfoScreenUseCase.getVideos(id: id).asSingle()
        
        Single.zip(detail, credits, reviews, recommendations, videos)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] detail, credits, reviews, recommendations, videos in
                guard let self else { return }
                
                self.movieResults = detail
                self.movie.onNext(detail)
                
                self.castsResults = credits?.cast
                self.casts.onNext(credits?.cast)
                
                self.reviewsResults = reviews?.results
                self.reviews.onNext(reviews?.results)
                
                self.recommendationsResults = recommendations?.results
                self.recommendations.onNext(recommendations?.results)
                
                self.videosResults = videos?.results
                self.videos.onNext(videos?.results)
                
                self.setLoading(loading: false)
            }, onFailure: { [weak self] error in
                guard let self else { return }
                self.setLoading(loading: false)
                self.setError(message: error.localizedDescription)
            }).disposed(by: disposeBag)
    }
}

// MARK: - Videos
extension MovieInfoScreenViewModel {
    func getVideos(id: Int) {
        setLoading(loading: true)
        movieInfoScreenUseCase.getVideos(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self,
                      let data = result?.results else { return }
                self.setLoading(loading: false)
                self.videosResults = data
                self.videos.onNext(data)
            } onError: { [weak self] error in
                guard let self else { return }
                self.setLoading(loading: false)
                self.setError(message: error.localizedDescription)
            }.disposed(by: disposeBag)
    }
}

// MARK: - Detail
extension MovieInfoScreenViewModel {
    func getDetail(id: Int) {
        setLoading(loading: true)
        movieInfoScreenUseCase.getDetail(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self,
                let data = result else { return }
                self.setLoading(loading: false)
                self.movieResults = data
                self.movie.onNext(data)
            } onError: { [weak self] error in
                guard let self else { return }
                self.setLoading(loading: false)
                self.setError(message: error.localizedDescription)
            }.disposed(by: disposeBag)
    }
}

// MARK: - Credit Casts
extension MovieInfoScreenViewModel {
    func getCredits(id: Int) {
        setLoading(loading: true)
        movieInfoScreenUseCase.getCredits(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self,
                      let data = result else { return }
                self.setLoading(loading: false)
                self.castsResults = data.cast
                self.casts.onNext(data.cast)
            } onError: { [weak self] error in
                guard let self else { return }
                self.setLoading(loading: false)
                self.setError(message: error.localizedDescription)
            }.disposed(by: disposeBag)
    }
}

// MARK: - Reviews
extension MovieInfoScreenViewModel {
    func getReviews(id: Int) {
        setLoading(loading: true)
        movieInfoScreenUseCase.getReviews(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self,
                      let data = result?.results else { return }
                self.setLoading(loading: false)
                self.reviewsResults = data
                self.reviews.onNext(data)
            } onError: { [weak self] error in
                guard let self else { return }
                self.setLoading(loading: false)
                self.setError(message: error.localizedDescription)
            }.disposed(by: disposeBag)
    }
}

// MARK: - Recommendations
extension MovieInfoScreenViewModel {
    func getRecommendations(id: Int) {
        setLoading(loading: true)
        movieInfoScreenUseCase.getRecommendations(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self,
                      let data = result?.results else { return }
                self.setLoading(loading: false)
                self.recommendationsResults = data
                self.recommendations.onNext(data)
            } onError: { [weak self] error in
                guard let self else { return }
                self.setLoading(loading: false)
                self.setError(message: error.localizedDescription)
            }.disposed(by: disposeBag)
    }
}
