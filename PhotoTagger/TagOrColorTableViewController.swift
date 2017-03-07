//
//  TagOrColorTableViewController.swift
//  PhotoTagger
//
//  Created by Matheus Pacheco Fusco on 07/03/17.
//  Copyright © 2017 Matheus Pacheco Fusco. All rights reserved.
//

import UIKit

class TagOrColorTableViewController: UITableViewController {

    // MARK: - Properties
    var data : [TagOrColorTableData] = []
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Memory Management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

// MARK: - Table view Data Source
extension TagOrColorTableViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellInformation = data[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagOrColorCell", for: indexPath)
        cell.textLabel?.text = cellInformation.label
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
}

// MARK: - Table view Delegate
extension TagOrColorTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellInformation = data[indexPath.row]
        
        guard let color = cellInformation.color else {
            cell.textLabel?.textColor = .black
            cell.textLabel?.backgroundColor = .white
            return
        }
        
        //Calculating cell background color
        var red = CGFloat(0.0)
        var green = CGFloat(0.0)
        var blue = CGFloat(0.0)
        var alpha = CGFloat(0.0)
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        cell.backgroundColor = color
        
        
        //Calculating cell text color based on background color
        let threshold = CGFloat(105)
        let bgDelta = ((red * 0.299) + (green * 0.587) + (blue * 0.114));
        let textColor: UIColor = (255 - bgDelta < threshold) ? .black : .white;
        cell.textLabel?.textColor = textColor
        
    }
    
}
