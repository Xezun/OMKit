//
//  TextEditor.swift
//  InputView
//
//  Created by mlibai on 2017/11/10.
//  Copyright © 2017年 mlibai. All rights reserved.
//

import UIKit

protocol TextEditorDelegate: NSObjectProtocol {
    
    func textEditor(_ textEditor: TextEditor, didCancelEdting content: String)
    func textEditor(_ textEditor: TextEditor, didFinishEditing content: String)
    
}

class TextEditor: UIViewController {
    
    /// 转场代理已被设置为控制器自己。
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        super.transitioningDelegate = self;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        super.transitioningDelegate = self;
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil);
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidShow, object: nil);
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil);
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidHide, object: nil);
    }
    
    weak var delegate: TextEditorDelegate?
    
    let textInputView: TextInputView = TextInputView.init(frame: .init(x: 0, y: UIScreen.main.bounds.maxY - 88, width: UIScreen.main.bounds.width, height: 88));
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(white: 0.0, alpha: 0.6);
        view.addSubview(textInputView);
        
        textInputView.placeholderLabel.text = "ABCD";
        textInputView.confirmButton.setTitle("OK", for: .normal)
        textInputView.numberOfCharactersLabel.text = "323"
        textInputView.textView.text = "ABCD";
        
        textInputView.textView.delegate = self;
        
        textInputView.confirmButton.addTarget(self, action: #selector(confirmButtonAction), for: .touchUpInside);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: .UIKeyboardDidShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: .UIKeyboardDidHide, object: nil);
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: .UIKeyboardWillChangeFrame, object: nil);
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)));
        view.addGestureRecognizer(tap);
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        // Note: 第一次显示时，输入框动画会被键盘慢，这个问题似乎无解。
        textInputView.textView.becomeFirstResponder();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    }
    
    @objc func tapAction(_ tap: UITapGestureRecognizer) {
        guard !textInputView.frame.contains(tap.location(in: view)) else {
            return;
        }
        view.endEditing(true);
        dismiss(animated: true, completion: {
            self.delegate?.textEditor(self, didCancelEdting: self.textInputView.textView.text);
        });
    }
    
    @objc private func confirmButtonAction() {
        self.view.endEditing(true);
        
        view.endEditing(true);
        dismiss(animated: true, completion: {
            self.delegate?.textEditor(self, didFinishEditing: self.textInputView.textView.text);
        });
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        let frame1 = notification.userInfo!["UIKeyboardFrameBeginUserInfoKey"] as! CGRect;
        let frame2 = notification.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! CGRect;
        let duration = notification.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! TimeInterval;
        
        textInputView.frame = CGRect(x: frame1.minX, y: frame1.minY - 88, width: frame1.width, height: 88);
        UIView.animate(withDuration: duration, animations: {
            self.textInputView.frame = CGRect(x: frame2.minX, y: frame2.minY - 88, width: frame2.width, height: 88);
        });
    }
    
    @objc private func keyboardDidShow(_ notification: Notification) {
        
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let frame1 = notification.userInfo!["UIKeyboardFrameBeginUserInfoKey"] as! CGRect;
        let frame2 = notification.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! CGRect;
        let duration = notification.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! TimeInterval;
        
        textInputView.frame = CGRect(x: frame1.minX, y: frame1.minY - 88, width: frame1.width, height: 88);
        UIView.animate(withDuration: duration, animations: {
            self.textInputView.frame = CGRect(x: frame2.minX, y: frame2.minY - 88, width: frame2.width, height: 88);
        });
    }
    
    @objc private func keyboardDidHide(_ notification: Notification) {
        
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        
    }
    
    @objc private func keyboardDidChangeFrame(_ notification: Notification) {
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension TextEditor: UITextViewDelegate {
    
}

extension TextEditor: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionAnimator.init(for: .present);
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionAnimator.init(for: .dismiss);
    }
    
    
    class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
        
        enum TransitionEvent {
            case present;
            case dismiss;
        }
        
        let event: TransitionEvent;
        
        init(for event: TransitionEvent) {
            self.event = event;
            super.init();
        }
        
        let duration: TimeInterval = 0.5;
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return duration;
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            switch self.event {
            case .dismiss:
                animateToDismiss(using: transitionContext);
            case .present:
                animateToPresent(using: transitionContext);
            }
        }
        
        func animateToPresent(using transitionContext: UIViewControllerContextTransitioning) {
            guard let toView = transitionContext.view(forKey: .to) else { return; }
            let containerView = transitionContext.containerView;
            toView.alpha = 0;
            toView.frame = containerView.bounds;
            transitionContext.containerView.addSubview(toView)
            UIView.animate(withDuration: duration, animations: {
                toView.alpha = 1.0;
            }, completion: { (_) in
                transitionContext.completeTransition(true);
            });
        }
        
        func animateToDismiss(using transitionContext: UIViewControllerContextTransitioning) {
            guard let fromView = transitionContext.view(forKey: .from) else { return; }
            transitionContext.containerView.addSubview(fromView);
            UIView.animate(withDuration: duration, animations: {
                fromView.alpha = 0.0;
            }, completion: { (_) in
                transitionContext.completeTransition(true);
            });
        }
        
    }
    
    
    
}
