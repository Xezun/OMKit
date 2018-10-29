//
//  TextInputView.swift
//  InputView
//
//  Created by mlibai on 2017/11/10.
//  Copyright © 2017年 mlibai. All rights reserved.
//

import UIKit
import XZKit



public class TextInputView: UIView {

    public let textView: UITextView                = TextInputViewTextView()
    public let textViewBackgroundImageView         = UIImageView()
    
    public let confirmButton: UIButton             = UIButton()
    
    public let placeholderLabel: UILabel           = UILabel()
    
    public let wrapperView: UIView                 = UIView()
    public let numberOfCharactersLabel: UILabel    = UILabel()
    public let backgroundImageView: UIImageView    = UIImageView()
    
    var minimumNumberOfCharacters: Int = 1;
    var maximumNumberOfCharacters: Int = Int.max;
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        didInitialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didInitialize()
    }
    
    private func didInitialize() {
        // 背景
        do {
            backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
            backgroundImageView.isUserInteractionEnabled = true;
            addSubview(backgroundImageView)
            
            let lcs1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundImageView]|", options: .alignAllLeading, metrics: nil, views: ["backgroundImageView": backgroundImageView])
            let lcs2 = NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundImageView]|", options: .alignAllLeading, metrics: nil, views: ["backgroundImageView": backgroundImageView])
            addConstraints(lcs1)
            addConstraints(lcs2)
        }
        
        // 完成按钮、已输入字数
        do {
            wrapperView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(wrapperView)
            
            confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            confirmButton.translatesAutoresizingMaskIntoConstraints = false
            wrapperView.addSubview(confirmButton)
            
            numberOfCharactersLabel.font                         = UIFont.systemFont(ofSize: 12)
            numberOfCharactersLabel.textAlignment                = .center
            numberOfCharactersLabel.adjustsFontSizeToFitWidth    = true
            numberOfCharactersLabel.numberOfLines                = 1
            numberOfCharactersLabel.translatesAutoresizingMaskIntoConstraints = false
            wrapperView.addSubview(numberOfCharactersLabel)
            
            let lcs1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|[completeButton(==60)]|", options: .alignAllLeading, metrics: nil, views: ["completeButton": confirmButton])
            let lcs2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|[numberOfWordsLabel]|", options: .alignAllLeading, metrics: nil, views: ["numberOfWordsLabel": numberOfCharactersLabel])
            let lcs3 = NSLayoutConstraint.constraints(withVisualFormat: "V:|[completeButton(==30)]-5-[numberOfWordsLabel(>=12)]|", options: .directionLeadingToTrailing, metrics: nil, views: ["completeButton": confirmButton, "numberOfWordsLabel": numberOfCharactersLabel])
            wrapperView.addConstraints(lcs1)
            wrapperView.addConstraints(lcs2)
            wrapperView.addConstraints(lcs3)
        }
        
        // 输入表单
        do {
            textViewBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false;
            textViewBackgroundImageView.isUserInteractionEnabled = true;
            addSubview(textViewBackgroundImageView);
            
            (textView as! TextInputViewTextView).placeholderLabel = placeholderLabel;
            textView.translatesAutoresizingMaskIntoConstraints = false;
            textViewBackgroundImageView.addSubview(textView);
            
            let lcs1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|[textView]|", options: .alignAllLeading, metrics: nil, views: ["textView": textView]);
            let lcs2 = NSLayoutConstraint.constraints(withVisualFormat: "V:|[textView]|", options: .alignAllLeading, metrics: nil, views: ["textView": textView]);
            textViewBackgroundImageView.addConstraints(lcs1);
            textViewBackgroundImageView.addConstraints(lcs2);
            
            let lcs3 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[textViewBackgroundImageView]-16-[wrapperView]-16-|", options: .directionLeadingToTrailing, metrics: nil, views: ["textViewBackgroundImageView": textViewBackgroundImageView, "wrapperView": wrapperView]);
            let lcs4 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[textViewBackgroundImageView]-|", options: .alignAllLeading, metrics: nil, views: ["textViewBackgroundImageView": textViewBackgroundImageView]);
            addConstraints(lcs3);
            addConstraints(lcs4);
            
            let lcs5 = NSLayoutConstraint.constraints(withVisualFormat: "V:[wrapperView]-8-|", options: .directionLeadingToTrailing, metrics: nil, views: ["wrapperView": wrapperView])
            addConstraints(lcs5)

            placeholderLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize); // UIFont.preferredFont(forTextStyle: .body);
            placeholderLabel.translatesAutoresizingMaskIntoConstraints = false;
            textViewBackgroundImageView.addSubview(placeholderLabel);
            
            let lcs6 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[placeholderLabel]-4-|", options: .alignAllLeading, metrics: nil, views: ["placeholderLabel": placeholderLabel]);
            let lcs7 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[placeholderLabel]-(>=0)-|", options: .alignAllLeading, metrics: nil, views: ["placeholderLabel": placeholderLabel]);
            textViewBackgroundImageView.addConstraints(lcs6);
            textViewBackgroundImageView.addConstraints(lcs7);
        }
        textViewBackgroundImageView.image = UIImage.init(filled: .white, borderColor: UIColor(0xcbcbcbff), cornerRadius: 4)
        
        backgroundImageView.backgroundColor = UIColor(0xf3f4f5ff)
        confirmButton.setBackgroundImage(UIImage.init(filled: UIColor(0xec764dff), cornerRadius: 15), for: .normal)
        numberOfCharactersLabel.textColor = UIColor(0x999999ff)
        numberOfCharactersLabel.text = "0"
        
        placeholderLabel.textColor = UIColor.lightGray;
        confirmButton.isEnabled = false;

        NotificationCenter.default.addObserver(self, selector: #selector(textViewTextDidChange(_:)), name: UITextView.textDidChangeNotification, object: textView);
    }
    
    @objc private func textViewTextDidChange(_ notification: Notification) {
        let numberOfWords = textView.text.endIndex.encodedOffset;
        placeholderLabel.isHidden = (numberOfWords > 0);
        numberOfCharactersLabel.text = "\(numberOfWords)";
        confirmButton.isEnabled = (numberOfWords >= minimumNumberOfCharacters && numberOfWords <= maximumNumberOfCharacters);
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: textView);
    }
    
    

}


fileprivate class TextInputViewTextView: UITextView {
    
    weak var placeholderLabel: UILabel? = nil {
        didSet {
            //UIFont.preferredFont(forTextStyle: .body)
            placeholderLabel?.font = font ?? UIFont.systemFont(ofSize: UIFont.smallSystemFontSize);
            placeholderLabel?.textAlignment = textAlignment;
        }
    }
    
    override var text: String! {
        didSet {
            NotificationCenter.default.post(name: UITextView.textDidChangeNotification, object: self);
        }
    }
    
    override var font: UIFont? {
        didSet {
            placeholderLabel?.font = font;
        }
    }
    
    override var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel?.textAlignment = textAlignment;
        }
    }
    
}
