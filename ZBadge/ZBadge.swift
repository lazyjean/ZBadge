//
//  ZBadge.swift
//  MyBadge
//
//  Created by 刘真 on 06/01/2017.
//  Copyright © 2017 刘真. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
open class ZBadge: UIView {

    //要显示的文字
    @IBInspectable public var text: String? {
        didSet {
            setNeedsLayout()
        }
    }

    //true表示显示小红点，false显示文本
    @IBInspectable public var dot:Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    //小红点的颜色
    @IBInspectable public var fillColor: UIColor = UIColor(red: 0xf2/0xff, green: 0x2b/0xff, blue: 0x0/0xff, alpha: 1.0) {
        didSet {
            setNeedsLayout()
        }
    }
    
    
    
    var font: UIFont = UIFont.systemFont(ofSize: 14)
    
    //method
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = UIFont.systemFont(ofSize: 12)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = UIFont.systemFont(ofSize: 12)
    }
    
    //设置textlayer
    var textLayer: CATextLayer!
    
    func setTextLayer() {
        //初始化textLayer
        if textLayer == nil {
            textLayer = CATextLayer.init()
            textLayer.font = CTFontCreateWithName((self.font.fontName as CFString?)!, self.font.pointSize, nil)
            textLayer.fontSize = self.font.pointSize
            textLayer.foregroundColor = UIColor.white.cgColor
            textLayer.isWrapped = false
            textLayer.alignmentMode = kCAAlignmentCenter
            textLayer.contentsScale = UIScreen.main.scale
            layer.addSublayer(textLayer)
        }
        
        //配置textLayer, 当为非小红点类型，且有设置文字时，展示带文字的提示
        if !self.dot && self.text != nil {
            
            //计算文字大小
            let textSize = self.textSize(text: self.text!, buffer: true)
            let origin = CGPoint.init(x: (self.frame.size.width - textSize.width)/2.0, y:(self.frame.size.height - textSize.height)/2.0)
            
            //update textlayer
            textLayer.string = self.text
            textLayer.frame = CGRect.init(origin: origin, size: textSize)
            textLayer.setNeedsDisplay()
        }
            //如果是小红点类型，清除方案相关内容
        else {
            self.textLayer?.string = nil
        }
    }
    
    //设置frameLayer
    var frameLayer: CAShapeLayer!

    func setFrameLayer() {
        
        //初始化frameLayer
        if frameLayer == nil {
            frameLayer = CAShapeLayer.init()
            layer.insertSublayer(frameLayer, below: textLayer)
        }
        
        frameLayer.fillColor = self.fillColor.cgColor
        
        //如果是非小红点类型，而且有设置文本，则显示文本边框
        if !self.dot && self.text != nil {
            
            let textSize = textLayer.frame.size
            let radius = textSize.height/2.0
            let dx = self.font.pointSize/2.0
            let frame = UIEdgeInsetsInsetRect(textLayer.frame, UIEdgeInsetsMake(0, -radius + dx, 0, -radius + dx))
            
            let path = CGMutablePath.init()
            path.addRoundedRect(in: frame, cornerWidth:radius, cornerHeight: radius)
            
            frameLayer.path = path
            frameLayer.frame = frame
        }
        else if self.dot {
            let path = CGMutablePath.init()
            let radius:CGFloat = 3.0
            let center = CGPoint.init(x: self.bounds.size.width/2.0, y: self.bounds.size.height/2.0)
            let origin = CGPoint.init(x: center.x - radius, y: center.y - radius)
            let frame = CGRect.init(origin: origin, size: CGSize.init(width: radius*2, height: radius*2))
            path.addRoundedRect(in: frame, cornerWidth: radius, cornerHeight: radius)
            frameLayer.path = path
            frameLayer.frame = frame
        }
        else {
            let radius:CGFloat = 3.0
            let center = CGPoint.init(x: self.bounds.size.width/2.0, y: self.bounds.size.height/2.0)
            let origin = CGPoint.init(x: center.x - radius, y: center.y - radius)
            let frame = CGRect.init(origin: origin, size: CGSize.init(width: radius*2, height: radius*2))
            frameLayer.path = nil
            frameLayer.frame = frame
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        setTextLayer()
        setFrameLayer()
        print("layoutSubviews")
    }
    
    func textSize(text:String, buffer include:Bool) -> CGSize {
        
        var widthPadding: Float?
        let roundScale = Float(1.0 / UIScreen.main.scale)
        let width = Float(font.pointSize * 0.375) / roundScale
        widthPadding = roundf(Float(width)) * roundScale
        
        let attributedString = NSAttributedString(string: text, attributes: [.font : font])
        var textSize = attributedString.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size
        
        if include {
            textSize.width = textSize.width + CGFloat(widthPadding!) * 2
        }

        textSize.width = CGFloat(roundf(Float(textSize.width) / roundScale) * roundScale)
        textSize.height = CGFloat(roundf(Float(textSize.height) / roundScale) * roundScale)
        
        return textSize
    }
    
    override open var intrinsicContentSize: CGSize {
        get {
            if self.dot {
                let radius:CGFloat = 3.0
                return CGSize.init(width: radius*2, height: radius*2)
            }
            
            let textSize = self.textSize(text: self.text!, buffer: true)
            
            let radius = textSize.height/2.0
            let dx = self.font.pointSize/2.0
            
            let w = textSize.width + 2*radius - 2*dx
            
            return CGSize.init(width: w, height: textSize.height)
        }
    }
}
