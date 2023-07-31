//
//  RangeSlider.swift
//  RangeSlider
//
//  Created by Cougard on 10/22/20.
//

import Foundation
import UIKit

public class RangeSlider: UIControl {
    private let lowerThumb = RangeSliderThumbLayer()
    private let upperThumb = RangeSliderThumbLayer()
    private let trackLayer = RangeSliderTrackLayer()
    
    public var thumbImage: UIImage = defaultImage() {
        didSet {
            lowerThumb.setNeedsDisplay()
            upperThumb.setNeedsDisplay()
        }
    }
    
    public static func defaultImage(_ color: UIColor = UIColor.red) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 20, height: 20), false, UIScreen.main.scale)
        let path = UIBezierPath(roundedRect: CGRect(x: 1.5, y: 1.5, width: 17, height: 17), cornerRadius: 8.5)
        UIColor.white.setFill()
        path.fill()
        path.lineWidth = 3
        color.setStroke()
        path.stroke()
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return image
        }else {
            UIGraphicsEndImageContext()
            return UIImage()
        }
    }
    
    public var trackTintColor: UIColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    public var trackSelectedColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.2039215686, blue: 0.2196078431, alpha: 1) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    public var maxValue: Float = 99 {
        didSet {
            updateLayerFrame()
        }
    }
    
    public var minValue: Float = 18 {
        didSet {
            updateLayerFrame()
        }
    }
    
    public var lowerValue: Float = 18 {
        didSet {
            updateLayerFrame()
        }
    }
    
    public var upperValue: Float = 99 {
        didSet {
            updateLayerFrame()
        }
    }
    
    private var trackFrame: CGRect {
        get {
            return bounds.insetBy(dx: 3, dy: bounds.height / 2 - 2)
        }
    }
    
    var lowerPosition: CGFloat {
        get {
            let persent = (lowerValue - minValue) / (maxValue - minValue)
            return trackFrame.width * CGFloat(persent)
        }
    }
    
    var upperPosition: CGFloat {
        get {
            let persent = (upperValue - minValue) / (maxValue - minValue)
            return trackFrame.width * CGFloat(persent)
        }
    }
    
    private var preLocation: CGPoint = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        trackLayer.rangeSlider = self
        lowerThumb.rangeSlider = self
        upperThumb.rangeSlider = self
        
        [trackLayer, lowerThumb, upperThumb].forEach { (sub) in
            sub.contentsScale = UIScreen.main.scale
            layer.addSublayer(sub)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var frame: CGRect {
        didSet {
            updateLayerFrame()
        }
    }
    
    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        updateLayerFrame()
    }
    
    private func updateLayerFrame() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        trackLayer.frame = trackFrame
        trackLayer.setNeedsDisplay()
        
        lowerThumb.frame = CGRect(x: lowerPosition-thumbImage.size.width/2+3, y: 0, width: thumbImage.size.width, height: thumbImage.size.width)
        lowerThumb.setNeedsDisplay()

        upperThumb.frame = CGRect(x: upperPosition-thumbImage.size.width/2+3, y: 0, width: thumbImage.size.width, height: thumbImage.size.width)
        upperThumb.setNeedsDisplay()
        
        CATransaction.commit()
    }
}

extension RangeSlider {
    func calculate(_ value: Float, lower: Float, upper: Float) -> Float {
        return min(max(value, lower), upper)
    }
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        preLocation = touch.location(in: self)
        if lowerThumb.frame.contains(preLocation) && upperThumb.frame.contains(preLocation) {
            if lowerValue < (maxValue + minValue) / 2 {
                upperThumb.isHighlighted = true
            }else {
                lowerThumb.isHighlighted = true
            }
        }else {
            if upperThumb.frame.contains(preLocation) {
                upperThumb.isHighlighted = true
            }else if lowerThumb.frame.contains(preLocation) {
                lowerThumb.isHighlighted = true
            }
        }
        return lowerThumb.isHighlighted || upperThumb.isHighlighted
    }
    
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let rangeLocation = Float(location.x - preLocation.x)
        let resultValue = (maxValue - minValue) * rangeLocation / Float(bounds.width - thumbImage.size.width)
        preLocation = location
        if lowerThumb.isHighlighted {
            lowerValue = calculate(lowerValue + resultValue, lower: minValue, upper: upperValue - 1)
        }else if upperThumb.isHighlighted {
            upperValue = calculate(upperValue + resultValue, lower: lowerValue + 1, upper: maxValue)
        }
        sendActions(for: .valueChanged)
        return true
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumb.isHighlighted = false
        upperThumb.isHighlighted = false
    }
}
