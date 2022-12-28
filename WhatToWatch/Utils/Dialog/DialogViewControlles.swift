//
//  DialogViewControlles.swift
//  WhatToWatch
//
//  Created by Francisco on 13/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import UIKit

class DialogViewController: UIViewController {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageTextView: UITextView!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet weak var cancelButtonCenterConstraint: NSLayoutConstraint!
    private var cancelAction: (() -> Void)?
    private var action: (() -> Void)?
    private var isVisibleActionButton: Bool?
    private var cancelTitle: String?
    private var actionTitle: String?
    private var dialogTitle: String?
    private var dialogMessage: String?
    
    class func create() -> DialogViewController {
        let className = String(describing: self)
        let storyboard = UIStoryboard(name: className, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: className) as! DialogViewController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = .mainColor
        cancelButton.addTarget(self, action: #selector(self.cancelDialog), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(self.actionDialog), for: .touchUpInside)
        titleLabel.text = self.dialogTitle
        messageTextView.text = self.dialogMessage
        cancelButton.setTitle(self.cancelTitle, for: .normal)
        if isVisibleActionButton! {
            actionButton.isHidden = false
            actionButton.setTitle(self.actionTitle, for: .normal)
        } else {
            cancelButtonCenterConstraint.constant = 0
            actionButton.isHidden = true
        }
    }
    
    func presentDialogViewController(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        viewControllerToPresent.definesPresentationContext = true
        viewControllerToPresent.providesPresentationContextTransitionStyle = true
        viewControllerToPresent.modalPresentationStyle = .overCurrentContext
        viewControllerToPresent.modalTransitionStyle = .crossDissolve
        
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            if let rootVC = window.rootViewController {
                rootVC.present(viewControllerToPresent, animated: flag, completion: completion)
            }
        }
    }
    
    @objc func cancelDialog() {
        cancelAction?()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func actionDialog() {
        action?()
        dismiss(animated: true, completion: nil)
    }
    
    class func dialogWithTitle(title: String, message: String) -> DialogViewController {
        let dialog = create()
        dialog.isVisibleActionButton = false
        dialog.cancelTitle = "Cancel"
        dialog.actionTitle = "OK"
        dialog.dialogTitle = title
        dialog.dialogMessage = message
        return dialog
    }
    
    class func dialogWithTitle(title: String, message: String, cancelTitle: String) -> DialogViewController {
        let dialog = self.dialogWithTitle(title: title, message: message)
        dialog.cancelTitle = cancelTitle
        return dialog
    }
    
    class func dialogWithTitle(title: String, message: String, cancelTitle: String, cancelAction: @escaping () -> Void) -> DialogViewController {
        let dialog = self.dialogWithTitle(title: title, message: message, cancelTitle: cancelTitle)
        dialog.cancelAction = cancelAction
        return dialog
    }
    
    func show() {
        presentDialogViewController(self, animated: true, completion: nil)
    }
    
    func setActionTitle(title: String, action: @escaping () -> Void) {
        self.isVisibleActionButton = true
        self.actionTitle = title
        self.action = action
    }
}
