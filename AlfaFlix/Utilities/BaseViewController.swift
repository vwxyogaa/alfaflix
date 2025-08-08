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

class BaseViewController: UIViewController {
    private var snackBar: TTGSnackbar?
    
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
