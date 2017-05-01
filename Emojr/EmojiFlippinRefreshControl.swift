//
//  EmojiFlippinRefreshControl.swift
//  Emojr
//
//  Created by James Risberg on 4/22/17.
//  Copyright © 2017 Joseph Pecoraro. All rights reserved.
//

import UIKit
import QuartzCore

open class EmojiFlippinRefreshControl: UIRefreshControl {
    
    /**
     Tells if the control is currently animating
     */
    open fileprivate(set) var isRefreshControlAnimating = false
    
    fileprivate var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 40.0)
        
        label.text = Emojis().randomEmoji()
        
        return label
    }()
    
    fileprivate lazy var refreshContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true

        view.addSubview(self.emojiLabel)
        self.emojiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.emojiLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
    }()
    
    fileprivate var overlayView: UIView!
    
    fileprivate var refreshTimer: Timer?
    
    /**
     Use init(frame:) instead
     */
    required override public init() {
        fatalError("use init(frame:) instead")
    }
    
    /**
     Use init(frame:) instead
     */
    required public init(coder aDecoder: NSCoder) {
        fatalError("use init(frame:) instead")
    }
    
    /**
     Initialize the gear refresh control
     */
    required override public init(frame: CGRect) {
        super.init()
        bounds.size.width = frame.size.width
        setupRefreshControl()
    }
    
    deinit {
        refreshTimer?.invalidate()
        emojiLabel.stopRotating()
    }
    
    /**
     Scroll update
     Updates the scroll status of the gears.
     - Parameter scrollView: The scrollview being observed
     */
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var refreshBounds = self.bounds;
        
        // Distance the table has been pulled
        let pullDistance = max(0.0, -self.frame.origin.y);
        let pullRatio = min(max(pullDistance, 0.0), 140.0) / 140.0;
        
        overlayView.alpha = 1 - pullRatio
        
        refreshBounds.size.height = pullDistance;
        
        let rotation = CGFloat.pi * 2.0 * pullRatio
        emojiLabel.transform = CGAffineTransform(rotationAngle: rotation)
        
        _ = [self.refreshContainerView, self.overlayView].map({$0.frame = refreshBounds});
        
        // If we're refreshing and the animation is not playing, then play the animation
        if (isRefreshing && !isRefreshControlAnimating) {
            animateRefreshView()
        }
    }
    
    override open func endRefreshing() {
        super.endRefreshing()
        isRefreshControlAnimating = false
    }
    
    open func randomize() {
        emojiLabel.text = Emojis().randomEmoji()
    }
}

private extension EmojiFlippinRefreshControl {
    func setupRefreshControl() {
        overlayView = UIView(frame: self.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        tintColor = UIColor.clear
        
        addSubview(self.refreshContainerView)
    }
    
    func animateRefreshView() {
        isRefreshControlAnimating = true
        
        emojiLabel.startRotating()
    }
}

extension UIView {
    func startRotating(duration: Double = 1) {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = Float.pi * 2.0
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    func stopRotating() {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
}
