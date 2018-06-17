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
    
    //Centered position of the slidingView
    var originalCenter = CGPoint()
    //Distance to slide over
    var slideDistance = CGFloat()
    
    //Delegate for handling sliding and unsliding events
    weak var delegate: ButtonHidingTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Styling the buttons
        checkButton.setImage(StyleKit.imageOfCheckButton, for: .normal)
        exButton.setImage(StyleKit.imageOfExButton, for: .normal)
        moreButton.setImage(StyleKit.imageOfMoreButton, for: .normal)
        
        //Styling the slidingView
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
    
    //Update the sliding distance and center point after auto layout occurs
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
        
        //The slidingView should move with respect to the getures x translation
        if gesture.state != .cancelled {
            //If the slidingView is past half way or has been translated from left to right, "resistance" is added to the translation
            if originalCenter.x - slidingView.center.x > slideDistance || slidingView.center.x > originalCenter.x {
                slidingView.center.x += translation.x / 2
            }
            else {
                slidingView.center.x += translation.x
            }
        } else {
            view.center = originalCenter
        }
        
        //Determine the final position of the slidingView once the geture is over
        if gesture.state == .ended {

            //Gesture is a quick swipe from right to left
            if gesture.velocity(in: view.superview).x < CGFloat(-500) {
                slideOver()
            }
            //Gesture is a quick swipe from left to right
            else if gesture.velocity(in: view.superview).x > CGFloat(500) {
                slideBack()
            }
            //Gesture has ended near the initial position
            else if originalCenter.x - slidingView.center.x < slideDistance / 4 {
                slideBack()
            }
            //Gesture has ended with the buttons exposed
            else if originalCenter.x - slidingView.center.x > slideDistance / 4 {
                slideOver()
            }
        }
        
        gesture.setTranslation(CGPoint.zero, in: self.contentView)
    }
    
    //To be used on setting up a dequeued cell
    func update(showingButtons: Bool, delegate: ButtonHidingTableViewCellDelegate) {
        self.delegate = delegate
        if showingButtons {
            self.slidingView.center.x = self.originalCenter.x - self.slideDistance
        } else{
            self.slidingView.center.x = self.originalCenter.x
        }
    }
    
    //Animate to expose buttons
    func slideOver() {
        delegate?.didSlide(self)
        UIView.animate(withDuration: 0.3) {
            self.slidingView.center.x = self.originalCenter.x - self.slideDistance
        }
    }
    
    //Animate to hide buttons
    func slideBack() {
        delegate?.didSlideBack(self)
        UIView.animate(withDuration: 0.3) {
            self.slidingView.center.x = self.originalCenter.x
        }
    }
    
    //To allow vertical scroll in the parent tableView when the slidingView is not sliding
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGesture.translation(in: self.contentView)
            //Only begin the gesture if it is mostly horizontal
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

//A Protocol defing a delegate for handling sliding information
protocol ButtonHidingTableViewCellDelegate: class {
    func didSlide(_ cell:ButtonHidingTableViewCell)
    func didSlideBack(_ cell:ButtonHidingTableViewCell)
}
