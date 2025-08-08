//
//  MovieInfoScreenUseCase.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import Foundation
import RxSwift

protocol MovieInfoScreenUseCaseProtocol {
    // MARK: - Remote
    func getDetail(id: Int) -> Observable<MovieResponse?>
    func getCredits(id: Int) -> Observable<CreditsResponse?>
    func getReviews(id: Int) -> Observable<ReviewsResponse?>
    func getRecommendations(id: Int) -> Observable<RecommendationsResponse?>
    func getVideos(id: Int) -> Observable<VideosResponse?>
}

final class MovieInfoScreenUseCase: MovieInfoScreenUseCaseProtocol {
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Remote
    func getDetail(id: Int) -> Observable<MovieResponse?> {
        return self.repository.getDetail(id: id)
    }
    
    func getCredits(id: Int) -> Observable<CreditsResponse?> {
        return self.repository.getCredits(id: id)
    }
    
    func getReviews(id: Int) -> Observable<ReviewsResponse?> {
        return self.repository.getReviews(id: id)
    }
    
    func getRecommendations(id: Int) -> Observable<RecommendationsResponse?> {
        return self.repository.getRecommendations(id: id)
    }
    
    func getVideos(id: Int) -> Observable<VideosResponse?> {
        return self.repository.getVideos(id: id)
    }
}
