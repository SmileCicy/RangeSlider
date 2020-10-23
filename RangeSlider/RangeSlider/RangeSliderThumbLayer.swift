//
//  RangeSliderThumbLayer.swift
//  RangeSlider
//
//  Created by Cougard on 10/22/20.
//

import Foundation
import UIKit

class RangeSliderThumbLayer: CALayer {
    weak var rangeSlider: RangeSlider?
    var isHighlighted: Bool = false
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        guard let img = rangeSlider?.thumbImage else { return }
        UIGraphicsPushContext(ctx)
        let rect = CGRect(x: bounds.width / 2 - 10, y: bounds.height / 2 - 10, width: 20, height: 20)
        img.draw(in: rect)
        UIGraphicsPopContext()
    }
}
