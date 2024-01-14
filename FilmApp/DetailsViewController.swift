//
//  DetailsViewController.swift
//  FilmApp
//
//  Created by Burak Yıldız on 14.01.2024.
//

import UIKit
import CoreData
class DetailsViewController: UIViewController {

    @IBOutlet weak var imbdLabel: UILabel!
    @IBOutlet weak var genreNameLabel: UILabel!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var gelenId : UUID?
    override func viewDidLoad() {
        super.viewDidLoad()

        getMovieData()
    }
    
    func getMovieData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        let idString = gelenId?.uuidString
        fetch.predicate = NSPredicate(format: "id = %@", idString!)
        fetch.returnsObjectsAsFaults = false

        do{
            let results = try context.fetch(fetch)
            for result in results as! [NSManagedObject]{
                if let movieName = result.value(forKey: "movieName") as? String{
                    movieNameLabel.text = movieName
                }
                if let genreName = result.value(forKey: "genreName") as? String{
                    genreNameLabel.text = genreName
                }
                if let imdb = result.value(forKey: "imdb") as? Double{
                    imbdLabel.text = String(imdb)
                }
                if let imageData = result.value(forKey: "image") as? Data{
                    let image = UIImage(data: imageData)
                    imageView.image = image
                }
                
            }
        }catch{
            print("error")
        }
    }

   

}
