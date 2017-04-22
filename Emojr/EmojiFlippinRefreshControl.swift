//
//  EmojiFlippinRefreshControl.swift
//  Emojr
//
//  Created by James Risberg on 4/22/17.
//  Copyright © 2017 Joseph Pecoraro. All rights reserved.
//

import UIKit

open class EmojiFlippinRefreshControl: UIRefreshControl {
    
    /**
     Tells if the control is currently animating
     */
    open fileprivate(set) var isRefreshControlAnimating = false
    
    var refreshCheckTimer: Timer?
    
    fileprivate var refreshContainerView: PTRAnimationView!
    fileprivate var overlayView: UIView!
    fileprivate var shadowView: ShadowView = {
        let view = ShadowView()
        view.shadowPercentage = 0.2
        return view
    }()
    
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
        refreshCheckTimer?.invalidate()
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
        shadowView.frame = self.bounds
        
        refreshBounds.size.height = pullDistance;
        
        _ = [self.refreshContainerView, self.overlayView].map({$0.frame = refreshBounds});
        
        // If we're refreshing and the animation is not playing, then play the animation
        if (isRefreshing && !isRefreshControlAnimating) {
            animateRefreshView()
        }
    }
    
}

private extension EmojiFlippinRefreshControl {
    func setupRefreshControl() {
        
        refreshContainerView = PTRAnimationView(frame: self.bounds)
        
        overlayView = UIView(frame: self.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        shadowView.frame = self.bounds
        
        refreshContainerView.clipsToBounds = true
        tintColor = UIColor.clear
        
        addSubview(self.refreshContainerView)
    }
    
    func animateRefreshView() {
        isRefreshControlAnimating = true
        
        refreshCheckTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(checkRefreshing), userInfo: nil, repeats: false)
        
        refreshContainerView.start()
    }
    
    @objc func checkRefreshing() {
        if (!self.isRefreshing) {
            refreshContainerView.stop()
            isRefreshControlAnimating = false
        }
    }
}

private class ShadowView: UIView {
    var gradient: CAGradientLayer!
    var shadowPercentage = 0.0
    
    override func layoutSubviews() {
        clipsToBounds = true
        var frame = self.frame
        let offset = frame.size.height * CGFloat(shadowPercentage)
        frame.size.height = offset
        if (gradient == nil) {
            gradient = CAGradientLayer()
            gradient.frame = frame
            gradient.colors = [
                UIColor.black.withAlphaComponent(0.6).cgColor,
                UIColor.black.withAlphaComponent(0.15).cgColor,
                UIColor.clear.cgColor]
            self.layer.insertSublayer(self.gradient, at:0)
        } else {
            gradient.frame = frame
        }
    }
}
