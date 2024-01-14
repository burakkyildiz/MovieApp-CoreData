//
//  ViewController.swift
//  FilmApp
//
//  Created by Burak Yıldız on 13.01.2024.
//

import UIKit
import CoreData
class ViewController: UIViewController  , UITableViewDataSource , UITableViewDelegate{
   
    

    @IBOutlet weak var tableView: UITableView!
    var moviesNameArray = [String]()
    var genreNameArray = [String]()
    var idArray = [UUID]()
    
    var gonderilenMoviesId : UUID?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(favoriteClicked))
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.systemGray6
        
        getData()
    }
    
    @objc func favoriteClicked(){
        performSegue(withIdentifier: "toFavoriteVC", sender: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("setMovie"), object: nil)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.white
        
    }
    @objc func getData(){
        moviesNameArray.removeAll(keepingCapacity: false)
        genreNameArray.removeAll(keepingCapacity: false)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
         
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        
        fetch.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(fetch)
            for result in results as! [NSManagedObject]{
                if let movieName = result.value(forKey: "movieName") as? String{
                    moviesNameArray.append(movieName)
                }
                if let genreName = result.value(forKey: "genreName") as? String{
                    genreNameArray.append(genreName)
                }
                if let id = result.value(forKey: "id") as? UUID{
                    idArray.append(id)
                }
                self.tableView.reloadData()
            }
        }catch{
            print("error")
        }
        
        
    }
    
    
    @objc func addClicked(){
        performSegue(withIdentifier: "toAddVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = moviesNameArray[indexPath.row]
        content.secondaryText = genreNameArray[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC"{
            let destination = segue.destination as? DetailsViewController
            destination?.gelenId = gonderilenMoviesId
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gonderilenMoviesId = idArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
            fetch.returnsObjectsAsFaults = false
            let idString = idArray[indexPath.row].uuidString
            fetch.predicate = NSPredicate(format: "id = %@", idString)
            do{
                let results = try context.fetch(fetch)
                for result in results as! [NSManagedObject]{
                    if result.value(forKey: "id") != nil{

                        context.delete(result)
                        moviesNameArray.remove(at: indexPath.row)
                        genreNameArray.remove(at: indexPath.row)
                        idArray.remove(at: indexPath.row)
                        self.tableView.reloadData()
                        
                        do{
                            try context.save()
                        }catch{
                            print("error")
                        }
                        break
                    }
                }
            }catch{
                print("error")
            }
        }
       
    }
    
    
    
}

