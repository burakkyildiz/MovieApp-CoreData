//
//  FavoriteViewController.swift
//  FilmApp
//
//  Created by Burak Yıldız on 14.01.2024.
//

import UIKit

class FavoriteViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = "Movie Name"
        content.secondaryText = "Genre Name"
        cell.contentConfiguration = content
        return cell
    }

}
