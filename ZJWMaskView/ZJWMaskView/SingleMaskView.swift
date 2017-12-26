//
//  SingleMaskView.swift
//  蒙层翻译Swift
//
//  Created by 赵建卫 on 2017/12/25.
//  Copyright © 2017年 赵建卫. All rights reserved.
//

import UIKit

class SingleMaskView: UIView {
    //懒加载
    fileprivate lazy var fillLayer: CAShapeLayer = {
        let fillLayer = CAShapeLayer.init()
        fillLayer.frame = self.bounds
        self.layer.addSublayer(fillLayer)
        return fillLayer
    }()
    fileprivate lazy var overlayPath: UIBezierPath = {
        return generateOverlayPath()
    }()
    fileprivate lazy var transparentPaths = [Any]() //透明区数组
    
    //初始化
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUp() {
        backgroundColor = UIColor.clear
        maskColor = UIColor.init(white: 0, alpha: 0.5) // 默认是50%的黑色
        
        fillLayer.path = overlayPath.cgPath
        fillLayer.fillRule = kCAFillRuleEvenOdd //设置空心的遮罩
        fillLayer.fillColor = maskColor?.cgColor //设置"非交集"的颜色
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(dismissMaskView))
        addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        refreshMask()
    }
    
    fileprivate func refreshMask() {
        let overlayPath = generateOverlayPath()
        for transparentPath in transparentPaths {
            overlayPath.append(transparentPath as! UIBezierPath)
        }
        self.overlayPath = overlayPath
        
        fillLayer.frame = bounds
        fillLayer.path = self.overlayPath.cgPath
        fillLayer.fillColor = self.maskColor?.cgColor
    }
    
    fileprivate func generateOverlayPath() -> UIBezierPath {
        let overlayPath = UIBezierPath.init(rect: self.bounds)
        overlayPath.usesEvenOddFillRule = true
        return overlayPath
    }
    
    fileprivate func addTransparentPath(transparentPath:UIBezierPath) {
        overlayPath.append(transparentPath)
        
        transparentPaths.append(transparentPath)
        
        fillLayer.path = overlayPath.cgPath
    }
    
    
    /**
     *  蒙版颜色(非透明区颜色，默认黑色0.5透明度)
     */
    var maskColor:UIColor? = nil
    
    /**
     *  添加矩形透明区(位置和弧度)
     */
    func addTransparentRect(rect:CGRect,radius:CGFloat) {
        let transparentPath = UIBezierPath.init(roundedRect: rect, cornerRadius: radius)
        addTransparentPath(transparentPath: transparentPath)
    }
    /**
     *  添加圆形透明区
     */
    func addTransparentOvalRect(rect:CGRect) {
        let transparentPath = UIBezierPath.init(ovalIn: rect)
        addTransparentPath(transparentPath: transparentPath)
    }
    
    /**
     *  添加图片(图片和位置)
     */
    func addImage(image:UIImage,frame:CGRect) {
        let imageView = UIImageView.init(frame: frame)
        imageView.backgroundColor = UIColor.clear
        imageView.image = image
        addSubview(imageView)
    }
    
    
    /**   在指定view上显示蒙版（过渡动画）
     *   不调用用此方法可使用 addSubview:自己添加展示
     */
    func showMaskViewInView(view:UIView) {
        self.alpha = 0
        let window = UIApplication.shared.keyWindow
        window?.addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    /**
     *  销毁蒙版view(默认点击空白区自动销毁)
     */
    @objc func dismissMaskView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
}
