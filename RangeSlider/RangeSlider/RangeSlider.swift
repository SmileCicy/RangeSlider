//
//  RangeSlider.swift
//  RangeSlider
//
//  Created by Cougard on 10/22/20.
//

import Foundation
import UIKit

class RangeSlider: UIControl {
    private let lowerThumb = RangeSliderThumbLayer()
    private let upperThumb = RangeSliderThumbLayer()
    private let trackLayer = RangeSliderTrackLayer()
    
    var thumbImage: UIImage = #imageLiteral(resourceName: "icon_thumb") {
        didSet {
            lowerThumb.setNeedsDisplay()
            upperThumb.setNeedsDisplay()
        }
    }
    
    var trackTintColor: UIColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    var trackSelectedColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.2039215686, blue: 0.2196078431, alpha: 1) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    var maxValue: Float = 99 {
        didSet {
            updateLayerFrame()
        }
    }
    
    var minValue: Float = 18 {
        didSet {
            updateLayerFrame()
        }
    }
    
    var lowerValue: Float = 18 {
        didSet {
            updateLayerFrame()
        }
    }
    
    var upperValue: Float = 99 {
        didSet {
            updateLayerFrame()
        }
    }
    
    private var trackFrame: CGRect {
        get {
            return bounds.insetBy(dx: 10, dy: bounds.height / 2 - 1.5)
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
    
    override var frame: CGRect {
        didSet {
            updateLayerFrame()
        }
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        updateLayerFrame()
    }
    
    private func updateLayerFrame() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        trackLayer.frame = trackFrame
        trackLayer.setNeedsDisplay()
        
        print(lowerPosition)
        lowerThumb.frame = CGRect(x: lowerPosition + 10 - bounds.height / 2, y: 0, width: bounds.height, height: bounds.height)
        lowerThumb.setNeedsDisplay()
        
        print(upperPosition)
        upperThumb.frame = CGRect(x: upperPosition + 10 - bounds.height / 2, y: 0, width: bounds.height, height: bounds.height)
        upperThumb.setNeedsDisplay()
        
        CATransaction.commit()
    }
}

extension RangeSlider {
    func calculate(_ value: Float, lower: Float, upper: Float) -> Float {
        return min(max(value, lower), upper)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
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
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let rangeLocation = Float(location.x - preLocation.x)
        let resultValue = (maxValue - minValue) * rangeLocation / Float(bounds.width - 20)
        preLocation = location
        if lowerThumb.isHighlighted {
            lowerValue = calculate(lowerValue + resultValue, lower: minValue, upper: upperValue - 1)
        }else if upperThumb.isHighlighted {
            upperValue = calculate(upperValue + resultValue, lower: lowerValue + 1, upper: maxValue)
        }
        sendActions(for: .valueChanged)
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumb.isHighlighted = false
        upperThumb.isHighlighted = false
    }
}
