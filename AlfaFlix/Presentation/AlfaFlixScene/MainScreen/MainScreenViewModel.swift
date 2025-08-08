//
//  MainScreenViewModel.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import Foundation
import RxSwift
import RxCocoa

class MainScreenViewModel {
    // MARK: - Properties
    private var autoScrollTimer: Timer?
    private var totalItems: Int = 0
    private var currentIndex: Int = 0
    
    let autoScrollIndex = PublishSubject<Int>()
    
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
