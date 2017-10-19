//
//  PlaybackControlsView.swift
//  XZKit
//
//  Created by mlibai on 2017/6/23.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import XZKit

@objc(OMMediaPlayerPlaybackControlsViewDelegate)
public protocol MediaPlayerPlaybackControlsViewDelegate: class {
    
    func playbackControlsView(_ playbackControlsView: MediaPlayerPlaybackControlsView, viewForMediaPlayerToZoomOut mediaPlayer: MediaPlayer) -> UIView?
    func playbackControlsViewDidClickOnZoomButton(_ playbackControlsView: MediaPlayerPlaybackControlsView)
    func playbackControlsViewDidClickOnRetryButton(_ playbackControlsView: MediaPlayerPlaybackControlsView)
    
    func playbackControlsViewDidClickOnShareButton(_ playbackControlsView: MediaPlayerPlaybackControlsView)
}

@objc(OMMediaPlayerPlaybackControlsView)
public final class MediaPlayerPlaybackControlsView: XZKit.MediaPlayerPlaybackControlsView {
    
    public weak var delegate: MediaPlayerPlaybackControlsViewDelegate?
    
    public weak var mediaPlayer: MediaPlayer? {
        didSet {
            if let mediaPlayer = self.mediaPlayer {
                mediaPlayer.preferredPlaybackUpdatesPerSecond = 2
            }
        }
    }
    
    deinit {
        tapActionTimer?.invalidate()
        tapActionTimer = nil
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        didInitialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didInitialize()
    }
    
    public let bar        = MediaPlayerPlaybackControlsToolBar()
    public let playButton = UIButton()

    // 在非全屏模式，是否显示标题
    public var isTitleHiddenWhenNotZoomed = false {
        didSet {
            self.configurationSubviewsToFitStatus()
        }
    }
    public let titleBackgoundImageView = UIImageView()
    public let titleLabel = UILabel()
    public let backButton = UIButton()
    
    public let replayButton = MediaPlayerPlaybackControlsButton()
    public let shareButton = MediaPlayerPlaybackControlsButton()
    
    public let loadingImageView = MediaPlayerPlaybackControlsLoadingView()
    
    public let errorView: MediaPlayerPlaybackControlsErrorView = MediaPlayerPlaybackControlsErrorView()
    
    public let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    private func didInitialize() {
        backgroundColor = UIColor.clear
        
        // Bar
        bar.autoresizingMask    = [.flexibleTopMargin, .flexibleWidth]
        addSubview(bar)
        
        // 播放按钮
        playButton.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        playButton.setImage(UIImage(OMKit: "btn_player_play"), for: .normal)
        playButton.setImage(UIImage(OMKit: "btn_player_pause"), for: .selected)
        addSubview(playButton)
        
        // 标题
        titleBackgoundImageView.image = UIImage(OMKit: "bg_player_title")
        titleBackgoundImageView.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        addSubview(titleBackgoundImageView)
        
        titleLabel.numberOfLines    = 1
        titleLabel.textColor        = UIColor.white
        titleLabel.textAlignment    = .right
        titleLabel.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        titleLabel.text             = "视频标题"
        addSubview(titleLabel)
        
        // 返回按钮
        backButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        backButton.setImage(UIImage(OMKit: "btn_player_nav_back"), for: .normal)
        addSubview(backButton)
        
        // 重播、返回按钮
        replayButton.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleLeftMargin]
        replayButton.iconImageView.image = UIImage(OMKit: "btn_player_replay")
        addSubview(replayButton)
        
        shareButton.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleLeftMargin]
        shareButton.iconImageView.image = UIImage(OMKit: "btn_player_share")
        addSubview(shareButton)
        
        // loading
        loadingImageView.image = UIImage(OMKit: "img_player_loading")
        loadingImageView.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleLeftMargin]
        addSubview(loadingImageView)
        
        // error
        errorView.infoLabel.text = "加载失败"
        errorView.retryButton.setTitle("重新加载", for: .normal)
        addSubview(errorView)
        
        bar.zoomButton.addTarget(self, action: #selector(zoomButtonAction(_:)), for: .touchUpInside)
        bar.progressView.addTarget(self, action: #selector(progressViewDidChangeValue(_:)), for: .valueChanged)
        playButton.addTarget(self, action: #selector(playButtonAction(_:)), for: .touchUpInside)
        
        tapGestureRecognizer.addTarget(self, action: #selector(tapGestureAction(_:)))
        addGestureRecognizer(tapGestureRecognizer)
        
        replayButton.addTarget(self, action: #selector(replayButtonAction(_:)), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        
        shareButton.addTarget(self, action: #selector(shareButtonAction(_:)), for: .touchUpInside)
        errorView.retryButton.addTarget(self, action: #selector(retryButtonAction(_:)), for: .touchUpInside)
        
        configurationSubviewsToFitStatus()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.bounds
        
        let frame1 = CGRect(x: 0, y: bounds.maxY - 40, width: bounds.width, height: 40)
        bar.frame = frame1
        
        let frame2 = CGRect(x: bounds.midX - 30, y: bounds.midY - 30, width: 60, height: 60)
        playButton.frame = frame2
        
        let frame30 = CGRect(x: 0, y: 0, width: bounds.width, height: 60)
        titleBackgoundImageView.frame = frame30
        
        let buttonWidth: CGFloat = (isZoomed ? 60 : 16)
        
        let frame31 = CGRect(x: 16, y: 0, width: bounds.width - buttonWidth - 16, height: 60)
        titleLabel.frame = frame31
        
        let frame4 = CGRect(x: frame31.maxX, y: 0, width: buttonWidth, height: 60)
        backButton.frame = frame4
        
        let frame5 = CGRect(x: bounds.width * 0.25, y: bounds.midY - 39, width: 60, height: 78)
        replayButton.frame = frame5
        
        let frame6 = CGRect(x: bounds.width * 0.75 - 60, y: frame5.minY, width: frame5.width, height: frame5.height)
        shareButton.frame = frame6
        
        let frame7 = CGRect(x: bounds.midX - 25, y: bounds.midY - 25, width: 50, height: 50)
        loadingImageView.frame = frame7
        
        errorView.frame = bounds
        
    }
    
    // Mark: Actions
    
    @objc private func shareButtonAction(_ button: MediaPlayerPlaybackControlsButton) {
        delegate?.playbackControlsViewDidClickOnShareButton(self)
    }
    
    @objc private func retryButtonAction(_ button: UIButton) {
        delegate?.playbackControlsViewDidClickOnRetryButton(self)
    }
    
    @objc private func replayButtonAction(_ button: MediaPlayerPlaybackControlsButton) {
        mediaPlayer?.seek(to: 0, completionHandler: { (finished) in
            self.mediaPlayer?.play()
        })
    }
    
    private var tapActionTimer: Timer?
    
    @objc private func tapTimerAction(_ timer: Timer) {
        switch self.status {
        case .playing: fallthrough
        case .stalled:
            timer.fireDate = Date.distantFuture
            configurationSubviewsToFitStatus()
        default:
            break
        }
    }
    
    override public func mediaPlayerPlaybackDidUpdate(_ mediaPlayer: MediaPlayer) {
        func DurationFormatter(_ duration: TimeInterval) -> String {
            let minutes_d = duration / 60
            let minutes_i = Int64(minutes_d)
            let seconds_i = Int64((minutes_d - TimeInterval(minutes_i)) * 60)
            return String(format: "%02d:%02d", minutes_i, seconds_i)
        }
        let duration    = mediaPlayer.duration
        let currentTime = mediaPlayer.currentTime
        
        bar.playedDurationLabel.text    = DurationFormatter(currentTime)
        bar.durationLabel.text          = DurationFormatter(duration)
        
        if duration > 0 {
            bar.progressView.progress = CGFloat(currentTime / duration)
        } else {
            bar.progressView.progress = 0
        }
    }
    
    override public func mediaPlayer(_ mediaPlayer: MediaPlayer, didLoadMediaWith progress: CGFloat) {
        bar.progressView.bufferProgress = progress
    }
    
    override public func mediaPlayer(_ mediaPlayer: MediaPlayer, statusDidChange status: MediaPlayer.Status) {
        self.status = status
    }
    
    public override func mediaPlayer(_ mediaPlayer: MediaPlayer, didZoom isZoomed: Bool) {
        self.isZoomed = isZoomed
    }
    
    @objc func tapGestureAction(_ tap: UITapGestureRecognizer) -> Void {
        switch status {
        case .playing:
            self.bar.isHidden        = !self.bar.isHidden
            self.playButton.isHidden = !self.playButton.isHidden
            
            if self.bar.isHidden && self.playButton.isHidden {
                self.titleLabel.isHidden = true
                self.backButton.isHidden = true
                self.titleBackgoundImageView.isHidden = true
                self.tapActionTimer?.fireDate = Date.distantFuture
            } else if !self.bar.isHidden && !self.playButton.isHidden {
                self.titleLabel.isHidden = (!isZoomed && isTitleHiddenWhenNotZoomed)
                self.backButton.isHidden = !isZoomed
                self.titleBackgoundImageView.isHidden = false
                // 将隐藏上述控件的事件设置到 5 秒后
                if self.tapActionTimer == nil {
                    self.tapActionTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(tapTimerAction(_:)), userInfo: nil, repeats: true)
                }
                self.tapActionTimer?.fireDate = Date(timeIntervalSinceNow: 3.0)
            }
            
        default:
            return
        }
    }
    
    @objc func progressViewDidChangeValue(_ view: MediaPlayerPlaybackProgressSlider) -> Void {
        guard let mediaPlayer = self.mediaPlayer else { return }
        let time = mediaPlayer.duration * TimeInterval(view.progress)
        mediaPlayer.seek(to: time, completionHandler: nil)
    }
    
    @objc func zoomButtonAction(_ button: UIButton) {
        guard let mediaPlayer = self.mediaPlayer else { return }
        
        if self.bar.zoomButton.isSelected {
            guard let view = delegate?.playbackControlsView(self, viewForMediaPlayerToZoomOut: mediaPlayer) else {
                return
            }
            
            self.bar.zoomButton.isEnabled   = false
            self.backButton.isEnabled       = false
            mediaPlayer.zoomOut(view, completion: { (finished) in
                self.bar.zoomButton.isEnabled   = true
                self.backButton.isEnabled       = true
                
                self.bar.zoomButton.isSelected  = !finished
            })
        } else {
            self.bar.zoomButton.isEnabled   = false
            self.backButton.isEnabled       = false
            mediaPlayer.zoomIn({ (finished) in
                self.bar.zoomButton.isEnabled   = true
                self.backButton.isEnabled       = true
                
                self.bar.zoomButton.isSelected  = finished
            })
        }
        delegate?.playbackControlsViewDidClickOnZoomButton(self)
    }
    
    @objc func playButtonAction(_ button: UIButton) {
        if self.playButton.isSelected {
            self.mediaPlayer?.pause()
            self.playButton.isSelected = false
        } else {
            self.mediaPlayer?.play()
            self.playButton.isSelected = true
        }
    }
    
    @objc func backButtonAction(_ button: UIButton) {
        self.zoomButtonAction(self.bar.zoomButton)
    }
    
    var isZoomed: Bool = false {
        didSet {
            configurationSubviewsToFitStatus()
        }
    }
    
     var status: MediaPlayer.Status = .default {
        didSet {
            configurationSubviewsToFitStatus()
        }
    }
    
    private func configurationSubviewsToFitStatus() {
        
        if isZoomed {
            titleLabel.numberOfLines = 1
        } else {
            titleLabel.numberOfLines = 2
        }
        
        switch status {
        case .default:
            self.bar.isHidden           = false
            self.playButton.isHidden    = false
            self.titleLabel.isHidden    = false
            self.titleBackgoundImageView.isHidden = false
            self.backButton.isHidden    = !isZoomed
            self.shareButton.isHidden   = true
            self.replayButton.isHidden  = true
            self.errorView.isHidden     = true
            self.loadingImageView.stopAnimating()
            
            self.playButton.isSelected  = false
            self.bar.zoomButton.isSelected = isZoomed
            
        case .playing:
            self.bar.isHidden           = true
            self.playButton.isHidden    = true
            self.titleLabel.isHidden    = true
            self.titleBackgoundImageView.isHidden = true
            self.backButton.isHidden    = true
            self.shareButton.isHidden   = true
            self.replayButton.isHidden  = true
            self.errorView.isHidden     = true
            self.loadingImageView.stopAnimating()
            
            self.playButton.isSelected  = true
            self.bar.zoomButton.isSelected = isZoomed
            
        case .stalled:
            self.bar.isHidden           = false
            self.playButton.isHidden    = true
            
            self.titleLabel.isHidden    = (isTitleHiddenWhenNotZoomed && !isZoomed)
            self.titleBackgoundImageView.isHidden = false
            self.backButton.isHidden    = !isZoomed
            
            self.shareButton.isHidden   = true
            self.replayButton.isHidden  = true
            self.errorView.isHidden     = true
            self.loadingImageView.startAnimating()
            
            self.playButton.isSelected  = true
            self.bar.zoomButton.isSelected = isZoomed
            
        case .paused:
            self.bar.isHidden           = false
            self.playButton.isHidden    = false
            self.titleLabel.isHidden    = false
            self.titleBackgoundImageView.isHidden = false
            self.backButton.isHidden    = !isZoomed
            self.shareButton.isHidden   = true
            self.replayButton.isHidden  = true
            self.errorView.isHidden     = true
            self.loadingImageView.stopAnimating()
            
            self.playButton.isSelected  = false
            self.bar.zoomButton.isSelected = isZoomed
            
        case .failed:
            self.bar.isHidden           = true
            self.playButton.isHidden    = true
            self.titleLabel.isHidden    = true
            self.titleBackgoundImageView.isHidden = true
            self.backButton.isHidden    = true
            self.shareButton.isHidden   = true
            self.replayButton.isHidden  = true
            self.errorView.isHidden     = false
            self.loadingImageView.stopAnimating()
            
            self.playButton.isSelected  = false
            self.bar.zoomButton.isSelected = isZoomed
            
        case .ended:
            self.bar.isHidden           = false
            self.playButton.isHidden    = true
            self.titleLabel.isHidden    = false
            self.titleBackgoundImageView.isHidden = false
            self.backButton.isHidden    = false
            self.shareButton.isHidden   = false
            self.replayButton.isHidden  = false
            self.errorView.isHidden     = true
            self.loadingImageView.stopAnimating()
            
            self.playButton.isSelected  = false
            self.bar.zoomButton.isSelected = isZoomed

        }
    }

}







// 按钮。上面是icon，下面是文字。
@objc(OMMediaPlayerPlaybackControlsButton)
public class MediaPlayerPlaybackControlsButton: UIButton {
    
    public let iconImageView: UIImageView = UIImageView()
    public let textLabel: UILabel = UILabel()
    
    convenience public init() {
        self.init(frame: .init(x: 0, y: 0, width: 60, height: 78))
        addSubview(iconImageView)
        addSubview(textLabel)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.bounds
        
        // totalHeight: 78
        
        let frame1 = CGRect(x: bounds.midX - 25, y: bounds.midY - 39, width: 50, height: 50)
        iconImageView.frame = frame1
        
        textLabel.sizeToFit()
        let size = textLabel.frame.size
        let frame2 = CGRect(x: bounds.midX - size.width * 0.5, y: frame1.maxY + 8, width: size.width, height: size.height)
        textLabel.frame = frame2
    }
}

@objc(OMMediaPlayerPlaybackControlsNavigationBar)
public class MediaPlayerPlaybackControlsNavigationBar: UIView {
    
    let backgroundImageView: UIImageView = UIImageView()
    let titleLabel: UILabel = UILabel()
    let backButton: UIButton = UIButton()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backgroundImageView)
        addSubview(titleLabel)
        addSubview(backButton)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(backgroundImageView)
        addSubview(titleLabel)
        addSubview(backButton)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
}

// 底部控制条
@objc(OMMediaPlayerPlaybackControlsToolBar)
public class MediaPlayerPlaybackControlsToolBar: UIView {
    
    public var playedDurationLabel = UILabel()
    public var progressView        = MediaPlayerPlaybackProgressSlider()
    public var durationLabel       = UILabel()
    public var zoomButton          = UIButton()
    
    override public init(frame: CGRect) {
        super.init(frame: .init(x: frame.minX, y: frame.minY, width: max(frame.width, 200), height: 40))
        didInitialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didInitialize()
    }
    
    private func didInitialize() -> Void {
        backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        playedDurationLabel.text                = "00:00"
        playedDurationLabel.textAlignment       = .center
        playedDurationLabel.font                = UIFont.systemFont(ofSize: 12.0)
        playedDurationLabel.textColor           = UIColor.white
        playedDurationLabel.autoresizingMask    = [.flexibleRightMargin, .flexibleHeight]
        addSubview(playedDurationLabel)
        
        progressView.autoresizingMask           = [.flexibleWidth, .flexibleHeight]
        progressView.progressTintColor          = UIColor(red: 62, green: 132, blue: 224, alpha: 255)
        progressView.bufferProgressTintColor    = UIColor(red: 224, green: 224, blue: 224, alpha: 255)
        progressView.trackTintColor             = UIColor(white: 1.0, alpha: 0.3)
        addSubview(progressView)
        
        durationLabel.text              = "00:00"
        durationLabel.textAlignment     = .center
        durationLabel.font              = UIFont.systemFont(ofSize: 12.0)
        durationLabel.textColor         = UIColor.white
        durationLabel.autoresizingMask  = [.flexibleLeftMargin, .flexibleHeight]
        addSubview(durationLabel)
        
        zoomButton.autoresizingMask     = [.flexibleLeftMargin, .flexibleHeight]
        zoomButton.setImage(UIImage(OMKit: "btn_player_zoomout"), for: .selected)
        zoomButton.setImage(UIImage(OMKit: "btn_player_zoomin"), for: .normal)
        addSubview(zoomButton)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.bounds
        let frame1 = CGRect(x: 0, y: 0, width: 60, height: bounds.height)
        playedDurationLabel.frame           = frame1
        
        let frame2 = CGRect(x: frame1.maxX, y: 0, width: bounds.width - 60 - 100, height: bounds.height)
        progressView.frame                  = frame2
        
        let frame3 = CGRect(x: frame2.maxX, y: 0, width: 60, height: bounds.height)
        durationLabel.frame             = frame3
        
        let frame4 = CGRect(x: frame3.maxX, y: 0, width: 40, height: bounds.height)
        zoomButton.frame                = frame4
    }
    
}

/// 缓冲动画
@objc(OMMediaPlayerPlaybackControlsLoadingView)
public class MediaPlayerPlaybackControlsLoadingView: UIImageView {
    
    private let kAnimationkey = "LoadingView.transform"
    
    override open func startAnimating() {
        guard layer.animation(forKey: kAnimationkey) == nil else { return }
        self.isHidden = false
        // 5 秒 1 圈
        let animation = CAKeyframeAnimation()
        animation.keyPath = #keyPath(CALayer.transform)
        animation.values = [
            NSValue(caTransform3D: CATransform3DIdentity),
            NSValue(caTransform3D: CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: CGFloat.pi * 0.5))),
            NSValue(caTransform3D: CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: CGFloat.pi * 1.0))),
            NSValue(caTransform3D: CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: CGFloat.pi * 1.5))),
            NSValue(caTransform3D: CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)))
        ]
        animation.timingFunction    = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration          = 3.0
        animation.autoreverses      = false
        animation.fillMode          = kCAFillModeBoth
        animation.repeatCount       = 99999
        animation.isRemovedOnCompletion = false
        self.layer.add(animation, forKey: kAnimationkey)
    }
    
    override open func stopAnimating() {
        self.isHidden       = true
        self.layer.removeAnimation(forKey: kAnimationkey)
    }
}

/// 加载失败
@objc(OMMediaPlayerPlaybackControlsErrorView)
public class MediaPlayerPlaybackControlsErrorView: UIView {
    public let infoLabel: UILabel = UILabel()
    public let retryButton: UIButton = UIButton()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        didInitialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didInitialize()
    }
    
    private func didInitialize() {
        addSubview(infoLabel)
        infoLabel.font = UIFont.systemFont(ofSize: 16)
        infoLabel.textColor = UIColor(0xf5f5f5)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let lc1 = NSLayoutConstraint(item: infoLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        let lc2 = NSLayoutConstraint(item: infoLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -25)
        addConstraint(lc1)
        addConstraint(lc2)
        
        addSubview(retryButton)
        retryButton.setTitleColor(UIColor.white, for: .normal)
        retryButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton.contentEdgeInsets = .init(top: 5, left: 10, bottom: 5, right: 10)
        
        let lc3 = NSLayoutConstraint(item: retryButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        let lc4 = NSLayoutConstraint(item: retryButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 19)
        addConstraint(lc3)
        addConstraint(lc4)
    }
}
