//
//  ViewController.swift
//  Donate
//
//  Created by Guillermo Moraleda on 02.07.19.
//  Copyright © 2019 Guillermo Moraleda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let reservations = ["one", "two", "three"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { fatalError() }
        cell.textLabel?.text = reservations[indexPath.row]
        return cell
    }
}
