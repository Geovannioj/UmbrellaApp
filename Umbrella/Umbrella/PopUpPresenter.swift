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
    
    func prepare(view: UIView, popUpFrame: CGRect, blurFrame: CGRect?,
                 popUpColor: UIColor = UIColor(r: 27, g: 2, b: 37),
                 blurAlpha: CGFloat = 0.5) {
        if let frame = blurFrame {
            loadBlurViewIntoController(view: view, frame: frame, alpha: blurAlpha)
        }
        loadPopUpViewIntoController(view: view, frame: popUpFrame, color: popUpColor)
    }
    
    func loadBlurViewIntoController(view: UIView, frame: CGRect, alpha: CGFloat) {
        self.blurView = UIView(frame: frame)
        blurView.backgroundColor = .white
        blurView.alpha = alpha
        view.addSubview(self.blurView)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.topAnchor.constraint(equalTo: view.topAnchor, constant: frame.minY).isActive = true
        blurView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: frame.minX).isActive = true
        blurView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: frame.size.width - view.bounds.size.width).isActive = true
        blurView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: frame.size.height - view.bounds.size.height).isActive = true
        
        view.bringSubview(toFront: view.subviews.last!)
    }
    
    func loadPopUpViewIntoController(view: UIView, frame: CGRect, color: UIColor) {
        self.popUpView = UIView(frame: frame)
        popUpView.backgroundColor = color
        popUpView.layer.cornerRadius = 10
        view.addSubview(popUpView)
        
        popUpView.translatesAutoresizingMaskIntoConstraints = false
        popUpView.topAnchor.constraint(equalTo: view.topAnchor, constant: frame.minY).isActive = true
        popUpView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: frame.minX).isActive = true
        popUpView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: frame.size.width - view.bounds.size.width).isActive = true
        popUpView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: frame.size.height - view.bounds.size.height).isActive = true
        
        view.bringSubview(toFront: view.subviews.last!)
        
    }

    var isHidden: Bool = true {
        didSet {
            popUpView.isHidden = self.isHidden
            blurView.isHidden = self.isHidden
        }
    }
    
    var alpha: CGFloat = 1.0 {
        didSet {
            popUpView.alpha = self.alpha
            blurView.alpha = self.alpha
        }
    }
    
}
