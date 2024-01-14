//
//  DetailsViewController.swift
//  FilmApp
//
//  Created by Burak Yıldız on 14.01.2024.
//

import UIKit
import CoreData

class AddViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @IBOutlet weak var genresText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imdbText: UITextField!
    @IBOutlet weak var movieNameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(selectImageClicked))
        imageView.addGestureRecognizer(imageGesture)
        let keyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(keyboardGesture)
        
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    @objc func selectImageClicked(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        //picker.allowsEditing = true
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
 
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newMovie = NSEntityDescription.insertNewObject(forEntityName: "Movies", into: context)
        
        newMovie.setValue(movieNameText.text, forKey: "movieName")
        newMovie.setValue(genresText.text, forKey: "genreName")
        
        if let imdb = Double(imdbText.text!){
            newMovie.setValue(imdb, forKey: "imdb")
        }
        newMovie.setValue(UUID(), forKey: "id")
        
        let imageData = imageView.image?.jpegData(compressionQuality: 0.5)
        newMovie.setValue(imageData, forKey: "image")
        
        do{
            try context.save()
            print("save success")
        }catch{
            print("error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("setMovie"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
