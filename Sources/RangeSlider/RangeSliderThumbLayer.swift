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
        let size = img.size
        let rect = CGRect(x: (bounds.width - size.width) / 2, y: (bounds.height - size.height) / 2 , width: size.width, height: size.height)
        img.draw(in: rect)
        UIGraphicsPopContext()
    }
}
