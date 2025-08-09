//
//  Repository.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import Foundation
import RxSwift

protocol RepositoryProtocol {
    // MARK: - Remote
    func getNowPlaying(page: Int) -> Observable<TMDBResponse?>
    func getPopular(page: Int) -> Observable<TMDBResponse?>
    func getTopRated(page: Int) -> Observable<TMDBResponse?>
    func getDetail(id: Int) -> Observable<MovieResponse?>
    func getCredits(id: Int) -> Observable<CreditsResponse?>
    func getReviews(id: Int) -> Observable<ReviewsResponse?>
    func getRecommendations(id: Int) -> Observable<RecommendationsResponse?>
    func getVideos(id: Int) -> Observable<VideosResponse?>
}

final class Repository: NSObject {
    typealias MovieInstance = (RemoteDataSource) -> Repository
    fileprivate let remote: RemoteDataSource
    
    init(remote: RemoteDataSource) {
        self.remote = remote
    }
    
    static let sharedInstance: MovieInstance = { remote in
        return Repository(remote: remote)
    }
}

extension Repository: RepositoryProtocol {
    // MARK: - Remote
    func getNowPlaying(page: Int) -> Observable<TMDBResponse?> {
        return remote.getNowPlaying(page: page)
    }
    
    func getPopular(page: Int) -> Observable<TMDBResponse?> {
        return remote.getPopular(page: page)
    }
    
    func getTopRated(page: Int) -> Observable<TMDBResponse?> {
        return remote.getTopRated(page: page)
    }
    
    func getDetail(id: Int) -> Observable<MovieResponse?> {
        return remote.getDetail(id: id)
    }
    
    func getCredits(id: Int) -> Observable<CreditsResponse?> {
        return remote.getCredits(id: id)
    }
    
    func getReviews(id: Int) -> Observable<ReviewsResponse?> {
        return remote.getReviews(id: id)
    }
    
    func getRecommendations(id: Int) -> Observable<RecommendationsResponse?> {
        return remote.getRecommendations(id: id)
    }
    
    func getVideos(id: Int) -> Observable<VideosResponse?> {
        return remote.getVideos(id: id)
    }
}
