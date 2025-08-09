//
//  BaseViewController.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import Foundation
import UIKit
import Toast
import TTGSnackbar
import Network

class BaseViewController: UIViewController {
    private var snackBar: TTGSnackbar?
    
    // MARK: - Connectivity
    private var pathMonitor: NWPathMonitor?
    private let pathQueue = DispatchQueue(label: "NetworkMonitorQueue")
    var isConnected: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNetworkMonitoring()
    }
    
    deinit {
        stopNetworkMonitoring()
    }
    
    private func startNetworkMonitoring() {
        let monitor = NWPathMonitor()
        pathMonitor = monitor
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            let connected = (path.status == .satisfied)
            DispatchQueue.main.async {
                if self.isConnected != connected {
                    self.isConnected = connected
                    self.connectivityDidChange(isConnected: connected)
                }
            }
        }
        monitor.start(queue: pathQueue)
    }
    
    private func stopNetworkMonitoring() {
        pathMonitor?.cancel()
        pathMonitor = nil
    }
    
    /// Override di child utk show/hide UI saat online/offline
    @objc func connectivityDidChange(isConnected: Bool) { /* default no-op */ }
    
    /// Helper untuk aksi yang butuh internet
    @discardableResult
    func assertOnlineOrShowOffline(message: String = "No internet connection") -> Bool {
        if !isConnected {
            showErrorSnackBar(message: message)
            return false
        }
        return true
    }
    
    // MARK: - Loading
    func manageLoadingActivity(isLoading: Bool) {
        isLoading ? showLoadingActivity() : hideLoadingActivity()
    }
    
    func showLoadingActivity() {
        view.makeToastActivity(.center)
    }
    
    func hideLoadingActivity() {
        view.hideToastActivity()
    }
    
    // MARK: - Snackbar
    func showErrorSnackBar(message: String?) {
        guard let message, !message.isEmpty else { return }
        snackBar?.dismiss()
        let bar = TTGSnackbar(message: message, duration: .short)
        bar.duration = .middle
        bar.shouldDismissOnSwipe = true
        bar.backgroundColor = .red
        bar.actionTextNumberOfLines = 0
        snackBar = bar
        bar.show()
    }
    
    func showSuccessSnackBar(message: String?) {
        guard let message, !message.isEmpty else { return }
        snackBar?.dismiss()
        let bar = TTGSnackbar(message: message, duration: .short)
        bar.duration = .middle
        bar.shouldDismissOnSwipe = true
        bar.backgroundColor = .green
        bar.actionTextNumberOfLines = 0
        snackBar = bar
        bar.show()
    }
}
