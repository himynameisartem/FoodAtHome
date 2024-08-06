//
//  TestView.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 25.07.2024.
//

import UIKit

class TestView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //
    //      private func commonInit() {
    //          // Load the view from the nib file
    //          let nib = UINib(nibName: "TestView", bundle: nil)
    //          let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
    //          view.frame = self.bounds
    //          self.addSubview(view)
    //
    //          // Set the image for imageView
    //          imageView.image = UIImage(named: "Alcoholic Drink")
    //      }
}
