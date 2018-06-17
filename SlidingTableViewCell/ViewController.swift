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
    
    // Indexpath if there is a cell showing buttons, nil if not
    var showingButtonsIndex: IndexPath?
    
}

//TableView handling
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ButtonHidingTableViewCell

        var showingButtons = false
        //If the cell which has exposed buttons comes back into view
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

//Cell delegate handling
extension ViewController: ButtonHidingTableViewCellDelegate {
    
    //Invoked by the cell after sliding
    func didSlide(_ cell: ButtonHidingTableViewCell) {
        let slideIndex = tableView.indexPath(for: cell)
        if let previousIndex = showingButtonsIndex, let previousCell = tableView.cellForRow(at: previousIndex) as? ButtonHidingTableViewCell{
            if(slideIndex != previousIndex){
                previousCell.slideBack()
            }
        }
        showingButtonsIndex = slideIndex
    }
    
    //Invoked by the cell after sliding back
    func didSlideBack(_ cell: ButtonHidingTableViewCell) {
        let slideIndex = tableView.indexPath(for: cell)
        if let previousIndex = showingButtonsIndex {
            if(slideIndex == previousIndex){
                //The previously showing cell has been slid back
                showingButtonsIndex = nil
            }
        }
    }
    
}

