//
//  ViewController.swift
//  RangeSlider
//
//  Created by Cougard on 10/22/20.
//

import UIKit

class ViewController: UIViewController {
    
    let slider = RangeSlider(frame: CGRect(x: 0, y: 200, width: UIScreen.main.bounds.width, height: 40))
    
    let oriSlider = UISlider(frame: CGRect(x: 0, y: 300, width: UIScreen.main.bounds.width, height: 40))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(slider)
        view.addSubview(oriSlider)
        oriSlider.setThumbImage(RangeSlider.defaultImage(), for: .normal)
        oriSlider.minimumTrackTintColor = UIColor.red
        slider.addTarget(self, action: #selector(sliderChange(sender:)), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    
    @objc private func sliderChange(sender: RangeSlider) {
        print("sender.lower == \(sender.lowerValue)")
        print("sender.upper == \(sender.upperValue)")
    }

}

