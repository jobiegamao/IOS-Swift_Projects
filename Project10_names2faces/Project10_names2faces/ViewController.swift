//
//  ViewController.swift
//  Project10_names2faces
//
//  Created by may on 11/24/22.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	var people = [Person]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
		
	}
	
	@objc func addNewPerson(){
		let picker = UIImagePickerController() //to use cam and upload photos
		
		//We set the allowsEditing property to be true, which allows the user to crop the picture they select.
		picker.allowsEditing = true
		
		//When you set self as the delegate, you'll need to conform not only to the UIImagePickerControllerDelegate protocol, but also the UINavigationControllerDelegate protocol.
		picker.delegate = self
		
		
		//alert if take a photo or select one from gallery
		let alert = UIAlertController(title: "Take or Select a Photo", message: nil, preferredStyle: .alert)
		
		alert.addAction(UIAlertAction(title: "Capture Photo", style: .default,
									  handler:{ (_) in
												self.openCamera(picker: picker)}
									 ))
		
		alert.addAction(UIAlertAction(title: "Select Photo", style: .default, handler: { (UIImagePickerController) in
			self.present(picker, animated: true)
		}))
		
		alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
		
		present(alert, animated: true)
		
	}
	
	func openCamera(picker : UIImagePickerController){
		if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
			picker.sourceType = UIImagePickerController.SourceType.camera
		}
		else{
			let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
	}
	

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return people.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		// must return an object of type UICollectionViewCell. We already designed a prototype in Interface Builder, and configured the PersonCell class for it, so we need to create and return one of these.
		//must typecast as cell should be a custom collectionview "PersonCell" not the basic UIcollectionview (default)
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
			fatalError("unable to dequeue a PersonCell")
		}
		
		//every PersonCell has imageView and nameLabel
		
		//for every cell, put a data from people array
		let person = people[indexPath.item] //item for collection & row for table
		cell.nameLabel.text = person.name
		
		// get image path of person
		let path = getDocumentsDirectory().appending(component: person.image)
		
		//set image in collection view image. use path.relativePath since UIimage needs String and not URL
		cell.imageView.image = UIImage(contentsOfFile: path.relativePath)
		
		//transform image layout in collection view cell
		cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor // black + .3 of white == gray
		cell.imageView.layer.borderWidth = 2
		cell.imageView.layer.cornerRadius = 3
		
		//transform cell size
		cell.layer.cornerRadius = 7
		
		
		return cell
	}
	
	//image picker delegate method which returns when the user selected an image and it's being returned to you. This method needs to do several things:
	// Extract the image from the dictionary that is passed as a parameter. Generate a unique filename for it. Convert it to a JPEG, then write that JPEG to disk.Dismiss the view controller.
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		// have to ensure that the file is a UIImage so we typecast it first
		guard let image = info[.editedImage] as? UIImage else { return }
		
		//set unique id name for that image
		let imageName = UUID().uuidString
		
		//create a path in directory for the image
		let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
		
		//save the jpeg of image then write in data in the directory file
		if let jpegData = image.jpegData(compressionQuality: 0.8) {
			try? jpegData.write(to: imagePath)
		}
		
		// add person object
		let person = Person(name: "Unknown", image: imageName)
		people.append(person)
		collectionView.reloadData()

		dismiss(animated: true)
	}
	
	
	// to access the directory
	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
	
	//when cell is selected
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let person = people[indexPath.item]

		
		let ac = UIAlertController(title: "Choose Option", message:nil, preferredStyle: .alert)
		
		// RENAME HANDLER INSIDE
		ac.addAction(UIAlertAction(title:"Rename", style: .default, handler: { [weak person] _ in
				let ac_rename = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
				
				ac_rename.addTextField()

				ac_rename.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac_rename] _ in
					guard let newName = ac_rename?.textFields?[0].text else { return }
					person?.name = newName

					self?.collectionView.reloadData()
				})
				
				ac_rename.addAction(UIAlertAction(title: "Cancel", style: .cancel))

				self.present(ac_rename, animated: true)
				
			} ))
		
		// DELETE HANDLER AS OUTSIDE FUNCTION
		ac.addAction(UIAlertAction(title:"Delete", style: .destructive, handler: deletePerson(person: person)))
		
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(ac, animated: true)
	}

	
	
	// AS THIS IS AN ACTION HANDLER SYNTAX IS:
	func deletePerson(person: Person) -> (_:UIAlertAction) -> () {
		return { [self] _ in
			if let person_index = people.firstIndex(of: person.self){
				people.remove(at: person_index)
				self.collectionView.reloadData()
			}
			
		}
	  
	}
	
	
//	SYNTAX FOR ALERT ACTION HANDLER FUNCTION
	func renamePerson() -> (_:UIAlertAction) -> () {
		return { _ in
			//
		}
	}
	

	
	

}

