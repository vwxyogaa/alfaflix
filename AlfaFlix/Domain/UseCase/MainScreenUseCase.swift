//
//  MainScreenUseCase.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import Foundation
import RxSwift

protocol MainScreenUseCaseProtocol {
    func getNowPlaying(page: Int) -> Observable<TMDBResponse>
    func getPopular(page: Int) -> Observable<TMDBResponse>
    func getTopRated(page: Int) -> Observable<TMDBResponse>
}

final class MainScreenUseCase: MainScreenUseCaseProtocol {
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func getNowPlaying(page: Int) -> Observable<TMDBResponse> {
        return repository.getNowPlaying(page: page)
    }
    
    func getPopular(page: Int) -> Observable<TMDBResponse> {
        return repository.getPopular(page: page)
    }
    
    func getTopRated(page: Int) -> Observable<TMDBResponse> {
        return repository.getTopRated(page: page)
    }
}
