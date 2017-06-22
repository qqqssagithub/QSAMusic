//
//  PlayPointView.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/5/4.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit
import pop

//主屏幕上的圆点
class PlayPointView: QSAKitBaseView {
    
    static let shared = PlayPointView(frame: CGRect(x: 24, y: SwiftMacro().ScreenHeight - 24 - 50, width: 50, height: 50))
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.backgroundColor = UIColor.lightGray
        self.layer.cornerRadius = 25
        self.layer.masksToBounds = true
        
        self.addAnimationAndGesture()
    }
    
    private init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let animation = UIDynamicAnimator(referenceView: SwiftMacro().KeyWindow)
    
    private func addAnimationAndGesture() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.addGestureRecognizer(tapGR)
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(pan))
        self.addGestureRecognizer(panGR)
    }
    
    func tap(tapGR: UITapGestureRecognizer) {
        self.open(isList: false)
    }
    
    var tempPoint = CGPoint(x: 24 + 25, y: SwiftMacro().ScreenHeight - 24 - 50 + 25)
    var isOpen = false
    
    var isList: Bool = false
    
    //展开
    func open(isList: Bool) {
        self.isList = isList
        self.isUserInteractionEnabled = false
        self.superVC.view.isUserInteractionEnabled = false
        isOpen = true
        tempPoint = self.center
        UIView.animate(withDuration: 0.3, animations: {
            self.center = SwiftMacro().KeyWindow.center
        }, completion: { (finished) in
            self.performTransactionAnimation()
        })
    }
    
    //收缩
    func shrink() {
        isOpen = false
        self.performTransactionAnimation()
    }
    
    var openCallClosure: QSACallback!
    
    //展开收缩动画
    private func performTransactionAnimation() {
        self.pop_removeAllAnimations()
        let boundsAnimation: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerBounds)
        boundsAnimation.springBounciness = 0;
        boundsAnimation.springSpeed = 10;
        self.layer.pop_add(boundsAnimation, forKey: "AnimateBounds")
        if isOpen {
            self.layer.cornerRadius = 0;
            boundsAnimation.toValue = NSValue(cgRect: SwiftMacro().ScreenRect)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                let playView = PlayView.shared()
                playView?.contractionBlock = {
                    playView?.removeFromSuperview()
                    self.shrink()
                }
                UIApplication.shared.keyWindow?.addSubview(playView!)
                playView?.displayAnimation()
                if self.openCallClosure != nil && self.isList {
                    self.openCallClosure()
                }
            })
        } else {
            self.layer.cornerRadius = 25;
            boundsAnimation.toValue = NSValue(cgRect: CGRect(x: SwiftMacro().KeyWindow.center.x - 25, y: SwiftMacro().KeyWindow.center.y - 25, width: 50, height: 50))
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                UIView.animate(withDuration: 0.3, animations: { 
                    self.center = self.tempPoint
                }, completion: { (fi) in
                    self.isUserInteractionEnabled = true
                    self.superVC.view.isUserInteractionEnabled = true
                })
            })
        }
    }
    
    func pan(panGR: UIPanGestureRecognizer) {
        if (panGR.state == UIGestureRecognizerState.began) {
            animation.removeAllBehaviors()
        } else if (panGR.state == UIGestureRecognizerState.changed) {
            //触摸点在屏幕上的偏移
            let offset: CGPoint = panGR.translation(in: SwiftMacro().KeyWindow)
            //创建一个变量, 记录圆点的中心
            var center: CGPoint = self.center
            //变量的中心x坐标 = 屏幕上的偏移x坐标
            center.x += offset.x;
            //判断变量中心x坐标小于25(圆点半径就是25)或是大于(屏幕宽度 - 25), 这样做的目的是防止圆点移出屏幕范围
            if center.x < 25 {
                center.x = 25
            } else if center.x > SwiftMacro().ScreenWidth - 25 {
                center.x = SwiftMacro().ScreenWidth - 25
            }
            //同上, 判断变量中心y坐标
            center.y += offset.y;
            if center.y < 97 + 25 {
                center.y = 97 + 25
            } else if center.y > SwiftMacro().ScreenHeight - 25 {
                center.y = SwiftMacro().ScreenHeight - 25
            }
            //圆点的中心 = 经过上面修正过的变量
            self.center = center;
            //将触摸点在屏幕上的偏移重置为0
            panGR.setTranslation(CGPoint.zero, in: SwiftMacro().KeyWindow)
        }
    }
    
}
