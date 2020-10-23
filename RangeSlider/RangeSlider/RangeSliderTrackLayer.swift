//
//  RangeSliderTrackLayer.swift
//  RangeSlider
//
//  Created by Cougard on 10/22/20.
//

import Foundation
import UIKit

class RangeSliderTrackLayer: CALayer {
    weak var rangeSlider: RangeSlider?
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        guard let slider = rangeSlider else { return }
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2)
        ctx.addPath(path.cgPath)
        
        ctx.setFillColor(slider.trackTintColor.cgColor)
        ctx.addPath(path.cgPath)
        ctx.fillPath()
        
        ctx.setFillColor(slider.trackSelectedColor.cgColor)
        let rect = CGRect(x: slider.lowerPosition, y: 0, width: slider.upperPosition - slider.lowerPosition, height: bounds.height)
        ctx.fill(rect)
    }
}
