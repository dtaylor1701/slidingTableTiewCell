//
//  ViewController.swift
//  testing
//
//  Created by David Taylor on 6/12/18.
//  Copyright © 2018 Hyper Elephant. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var showingButtonsIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ButtonHidingTableViewCell

        var showingButtons = false
        if let showingIndex = showingButtonsIndex {
            showingButtons = indexPath == showingIndex
        }
        
        cell.update(showingButtons: showingButtons, delegate: self)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}

extension ViewController: ButtonHidingTableViewCellDelegate {
    
    func didSlide(_ cell: ButtonHidingTableViewCell) {
        let slideIndex = tableView.indexPath(for: cell)
        if let previousIndex = showingButtonsIndex, let previousCell = tableView.cellForRow(at: previousIndex) as? ButtonHidingTableViewCell{
            if(slideIndex != previousIndex){
                previousCell.slideBack()
            }
        }
        showingButtonsIndex = slideIndex
    }
    
    func didSlideBack(_ cell: ButtonHidingTableViewCell) {
        let slideIndex = tableView.indexPath(for: cell)
        if let previousIndex = showingButtonsIndex {
            if(slideIndex == previousIndex){
                showingButtonsIndex = nil
            }
        }
    }
    
}

