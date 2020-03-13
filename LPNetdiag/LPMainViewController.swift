//
//  LPMainViewController.swift
//  LPNetdiagDemo
//
//  Created by pengli on 2019/11/26.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit

class LPMainViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func stopButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func ocButtonClicked(_ sender: Any) {
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
