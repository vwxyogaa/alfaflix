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
    
    func getNowPlaying(page: Int) -> Observable<TMDBResponse> {
        let url = URL(string: urlMovie + "/now_playing?page=\(page)")!
        let data: Observable<TMDBResponse> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
    
    func getPopular(page: Int) -> Observable<TMDBResponse> {
        let url = URL(string: urlMovie + "/popular?page=\(page)")!
        let data: Observable<TMDBResponse> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
    
    func getTopRated(page: Int) -> Observable<TMDBResponse> {
        let url = URL(string: urlMovie + "/top_rated?page=\(page)")!
        let data: Observable<TMDBResponse> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
}
