//
//  ResultsViewController.swift
//  PhotoTagger
//
//  Created by Matheus Pacheco Fusco on 07/03/17.
//  Copyright © 2017 Matheus Pacheco Fusco. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    //MARK: - Properties
    var tags : [String]?
    var colors : [PhotoColor]?
    var tableViewController : TagOrColorTableViewController?
    
    //MARK: - IBOutlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - IBActions
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        
    }
    
    //MARK: - Custom Methods
    func setupTableData () {
        
    }
    
    //MARK: - Memory Management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}
