//
//  ViewController.swift
//  Project13_InstaFilter
//
//  Created by may on 12/4/22.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBOutlet var filterBtn: UIButton!
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var intensity: UISlider!
	var currentImage: UIImage!
	
	
	var context: CIContext! // CoreImage for rendering
	var currentFilter: CIFilter! // CoreImage for filter
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "InstaFilter"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
		
		context = CIContext()
		currentFilter = CIFilter(name: "CISepiaTone")
		
		
	}
	
	@objc func importPicture() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		present(picker, animated: true)
		
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else {return}
		dismiss(animated: true)
		currentImage = image
		
		let beginImage = CIImage(image: currentImage) //chnge the uiimage to coreimage
		currentFilter.setValue(beginImage, forKey: kCIInputImageKey) // apply filter to the coreimgae

		applyProcessing()
	}

	@IBAction func changeFilter(_ sender: UIButton) {
		let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
		ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		
		// for ipad as we .actionsheet for style of popover
		if let popover = ac.popoverPresentationController {
			popover.sourceView = sender //tell the source is a btn
			popover.sourceRect = sender.bounds // the size of sender
		}
		present(ac, animated: true)
	}
	
	func setFilter(action: UIAlertAction) {
		// make sure we have a valid image before continuing!
		guard currentImage != nil else { return }

		// safely read the alert action's title
		guard let actionTitle = action.title else { return }

		currentFilter = CIFilter(name: actionTitle)
		filterBtn.titleLabel?.text = actionTitle
		

		let beginImage = CIImage(image: currentImage)
		currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

		applyProcessing()
	}
	
	@IBAction func save(_ sender: Any) {
		if let image = imageView?.image{
			UIImageWriteToSavedPhotosAlbum(image, self,#selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
			
		}else{
			let ac = UIAlertController(title: "No Image", message: "Add an image first", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default))
			present(ac, animated: true)
		}
	}
	
	@IBAction func intensityChange(_ sender: Any) {
		applyProcessing()
	}
	
	func applyProcessing() {
		
		// not all filter we added have intensity input, set slider to whats their input should be
		let inputKeys = currentFilter.inputKeys
		
		if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)}
		if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey) }
		if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey) }
		if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
		
		// checker if empty
		guard let image = currentFilter.outputImage else { return }
		
		//processing image
		// transform the image to CGIimage, use the CIContext fro rendering, using all of the image (.extent)
		// then tranform back to UIimage and set the imageView
		if let cgimg = context.createCGImage(image, from: image.extent) {
			let processedImage = UIImage(cgImage: cgimg)
			imageView.image = processedImage
		}
	}
	
	
	
	@objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
		if let error = error {
			// we got back an error!
			let ac = UIAlertController(title: "Error while Saving!", message: error.localizedDescription, preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default))
			present(ac, animated: true)
		} else {
			let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default))
			present(ac, animated: true)
		}
	}
	
}

