//
//  Injection.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import Foundation

final class Injection {
    func provideMainScreenUseCase() -> MainScreenUseCaseProtocol {
        let repository = provideRepository()
        return MainScreenUseCase(repository: repository)
    }
}

extension Injection {
    func provideRepository() -> RepositoryProtocol {
        let remoteDataSource = RemoteDataSource()
        return Repository.sharedInstance(remoteDataSource)
    }
}
