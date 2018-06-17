//
//  ButtonHidingTableViewCell.swift
//  testing
//
//  Created by David Taylor on 6/13/18.
//  Copyright © 2018 Hyper Elephant. All rights reserved.
//

import UIKit

class ButtonHidingTableViewCell: UITableViewCell {

    @IBOutlet weak var slidingView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var exButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    var originalCenter = CGPoint()
    var slideDistance: CGFloat!
    weak var delegate: ButtonHidingTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        checkButton.setImage(StyleKit.imageOfCheckButton, for: .normal)
        exButton.setImage(StyleKit.imageOfExButton, for: .normal)
        moreButton.setImage(StyleKit.imageOfMoreButton, for: .normal)
        
        slidingView.backgroundColor = .purple
        slidingView.layer.cornerRadius = 10
        slidingView.layer.shadowColor = UIColor.gray.cgColor
        slidingView.layer.shadowOpacity = 1
        slidingView.layer.shadowOffset = CGSize(width: 0, height: 8)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(swiped(gesture:)))
        slidingView.addGestureRecognizer(gesture)
        gesture.delegate = self
        
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        originalCenter = self.center
        slideDistance = self.frame.width / 2
    }
    
    @objc func swiped(gesture: UIPanGestureRecognizer){
        
        guard let view = gesture.view else {
            return
        }
        let translation = gesture.translation(in: self.contentView)
        
        if gesture.state != .cancelled {
            if originalCenter.x - slidingView.center.x > slideDistance || slidingView.center.x > originalCenter.x {
                slidingView.center.x += translation.x / 2
            }
            else {
                slidingView.center.x += translation.x
            }
            
        } else {
            view.center = originalCenter
        }
        
        if gesture.state == .ended {

            if gesture.velocity(in: view.superview).x < CGFloat(-500) {
                slideOver()
            }
            else if gesture.velocity(in: view.superview).x > CGFloat(500) {
                slideBack()
            }
            else if originalCenter.x - slidingView.center.x < slideDistance / 4 {
                slideBack()
            }
            else if originalCenter.x - slidingView.center.x > slideDistance / 4 {
                slideOver()
            }
        }
        
        gesture.setTranslation(CGPoint.zero, in: self.contentView)
    }
    
    func update(showingButtons: Bool, delegate: ButtonHidingTableViewCellDelegate) {
        self.delegate = delegate
        if showingButtons {
            self.slidingView.center.x = self.originalCenter.x - self.slideDistance
        } else{
            self.slidingView.center.x = self.originalCenter.x
        }
    }
    
    func slideOver() {
        delegate?.didSlide(self)
        UIView.animate(withDuration: 0.3) {
            self.slidingView.center.x = self.originalCenter.x - self.slideDistance
        }
    }
    
    func slideBack() {
        delegate?.didSlideBack(self)
        UIView.animate(withDuration: 0.3) {
            self.slidingView.center.x = self.originalCenter.x
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGesture.translation(in: self.contentView)
            if abs(translation.x) > abs(translation.y) {
                return true
            }
            else {
                return false
            }
        }
        else {
            return true
        }
    }

}


protocol ButtonHidingTableViewCellDelegate: class {
    func didSlide(_ cell:ButtonHidingTableViewCell)
    func didSlideBack(_ cell:ButtonHidingTableViewCell)
}
