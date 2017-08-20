//
//  PopUpPresenter.swift
//  Umbrella
//
//  Created by Bruno Chagas on 18/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class PopUpPresenter {

    var popUpView: UIView!
    var blurView: UIView!
    
    init() {
        popUpView = UIView()
        blurView = UIView()
    }
    
    func prepare(view: UIView, popUpFrame: CGRect, blurFrame: CGRect,
         popUpColor: UIColor = UIColor(r: 27, g: 2, b: 37) ) {
        loadBlurViewIntoController(view: view, frame: blurFrame)
        loadPopUpViewIntoController(view: view, frame: popUpFrame, color: popUpColor)
    }
    
    func loadBlurViewIntoController(view: UIView, frame: CGRect) {
        self.blurView = UIView(frame: frame)
        blurView.backgroundColor = .white
        blurView.alpha = 0.5
        view.addSubview(self.blurView)
        view.bringSubview(toFront: view.subviews.last!)
    }
    
    func loadPopUpViewIntoController(view: UIView, frame: CGRect, color: UIColor) {
        self.popUpView = UIView(frame: frame)
        popUpView.backgroundColor = color
        popUpView.layer.cornerRadius = 10
        view.addSubview(popUpView)
        view.bringSubview(toFront: view.subviews.last!)
    }

    var isHidden: Bool = true {
        didSet {
            popUpView.isHidden = self.isHidden
            blurView.isHidden = self.isHidden
        }
    }
    
}
