//
//  RemoteDataSource.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import Foundation
import RxSwift

final class RemoteDataSource {
    private let urlMovie = Constants.baseMovieUrl + Constants.moviePath
    
    func getNowPlaying(page: Int) -> Observable<TMDBResponse?> {
        guard let url = URL(string: urlMovie + "/now_playing?page=\(page)") else { return Observable.error(URLError(.badURL)) }
        let data: Observable<TMDBResponse?> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
    
    func getPopular(page: Int) -> Observable<TMDBResponse?> {
        guard let url = URL(string: urlMovie + "/popular?page=\(page)") else { return Observable.error(URLError(.badURL)) }
        let data: Observable<TMDBResponse?> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
    
    func getTopRated(page: Int) -> Observable<TMDBResponse?> {
        guard let url = URL(string: urlMovie + "/top_rated?page=\(page)") else { return Observable.error(URLError(.badURL)) }
        let data: Observable<TMDBResponse?> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
    
    func getDetail(id: Int) -> Observable<MovieResponse?> {
        guard let url = URL(string: urlMovie + "/\(id)") else { return Observable.error(URLError(.badURL)) }
        let data: Observable<MovieResponse?> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
    
    func getCredits(id: Int) -> Observable<CreditsResponse?> {
        guard let url = URL(string: urlMovie + "/\(id)/credits") else { return Observable.error(URLError(.badURL)) }
        let data: Observable<CreditsResponse?> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
    
    func getReviews(id: Int) -> Observable<ReviewsResponse?> {
        guard let url = URL(string: urlMovie + "/\(id)/reviews") else { return Observable.error(URLError(.badURL)) }
        let data: Observable<ReviewsResponse?> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
    
    func getRecommendations(id: Int) -> Observable<RecommendationsResponse?> {
        guard let url = URL(string: urlMovie + "/\(id)/recommendations") else { return Observable.error(URLError(.badURL)) }
        let data: Observable<RecommendationsResponse?> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
    
    func getVideos(id: Int) -> Observable<VideosResponse?> {
        guard let url = URL(string: urlMovie + "/\(id)/videos") else { return Observable.error(URLError(.badURL)) }
        let data: Observable<VideosResponse?> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
}
