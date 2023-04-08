//
//  ViewController.swift
//  Project27_CoreGraphics
//
//  Created by may on 4/8/23.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet var redrawButton: UIButton!
	@IBOutlet var imageView: UIImageView!
	
	var currentDrawType = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		drawTwin()
	}

	@IBAction func didTapRedrawBtn(_ sender: Any) {
		currentDrawType += 1
		if currentDrawType > 6 {
			currentDrawType = 0
		}
		
		switch currentDrawType {
			case 0:
				drawTwin()
			case 1:
				drawCircle()
			case 2:
				drawCheckboard()
			case 3:
				drawRotatedSquares()
			case 4:
				drawLines()
			case 5:
				drawImagesAndText()
			case 6:
				drawRectangle()
				
			default:
				break
		}
	}
	
	func drawTwin(){
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
		
		let img = renderer.image { context in
			let cgx = context.cgContext
			cgx.setStrokeColor(UIColor.black.cgColor)

			// T
			cgx.move(to: CGPoint(x: 10, y: 100))
			cgx.addLine(to: CGPoint(x: 100, y: 100))
			cgx.move(to: CGPoint(x: 55, y: 100))
			cgx.addLine(to: CGPoint(x: 55, y: 190))
			
			// W
			cgx.move(to: CGPoint(x: 110, y: 100))
			cgx.addLine(to: CGPoint(x: 120, y: 190))
			cgx.move(to: CGPoint(x: 120, y: 190))
			cgx.addLine(to: CGPoint(x: 130, y: 100))
			cgx.move(to: CGPoint(x: 130, y: 100))
			cgx.addLine(to: CGPoint(x: 140, y: 190))
			cgx.move(to: CGPoint(x: 140, y: 190))
			cgx.addLine(to: CGPoint(x: 150, y: 100))
			
			// I
			cgx.move(to: CGPoint(x: 160, y: 100))
			cgx.addLine(to: CGPoint(x: 160, y: 190))
			
			// N
			cgx.move(to: CGPoint(x: 170, y: 190))
			cgx.addLine(to: CGPoint(x: 170, y: 100))
			cgx.addLine(to: CGPoint(x: 200, y: 190))
			cgx.addLine(to: CGPoint(x: 200, y: 100))
			
			cgx.strokePath()
		}
		
		imageView.image = img
	}
	
	func drawImagesAndText() {
		// 1
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

		let img = renderer.image { context in
			// 2
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.alignment = .center

			// 3 attribute dict of string
			let attrs: [NSAttributedString.Key: Any] = [
				.font: UIFont.systemFont(ofSize: 36),
				.paragraphStyle: paragraphStyle
			]

			// 4
			let string = "This is a mice,\nmickey mice"
			let attributedString = NSAttributedString(string: string, attributes: attrs)

			// 5 add the attributedString
			attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)

			// 5 add the mouse
			let mouse = UIImage(named: "mouse")
			mouse?.draw(at: CGPoint(x: 250, y: 150))
		}

		// 6
		imageView.image = img
	}
	
	func drawLines() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

		let img = renderer.image { context in
			context.cgContext.translateBy(x: 256, y: 256)

			var length = 256.0

			for idx in 0 ..< 256 {
				// rotate by 90 degrees
				context.cgContext.rotate(by: .pi / 2)

				if idx == 0 {
					context.cgContext.move(to: CGPoint(x: length, y: 50))
				} else {
					context.cgContext.addLine(to: CGPoint(x: length, y: 50))
				}

				// increase length every line
				length *= 0.99
			}

			context.cgContext.setStrokeColor(UIColor.black.cgColor)
			context.cgContext.strokePath()
		}

		imageView.image = img
	}
	
	func drawRotatedSquares() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

		let img = renderer.image { context in
			
			let rectangle = CGRect(x: -128, y: -128, width: 256, height: 256)
			
			// move to
			context.cgContext.translateBy(x: 256, y: 256)

			let rotations = 16
			let amount = Double.pi / Double(rotations)

			for _ in 0 ..< rotations {
				context.cgContext.rotate(by: CGFloat(amount))
				context.cgContext.addRect(rectangle)
			}

			context.cgContext.setStrokeColor(UIColor.black.cgColor)
			context.cgContext.drawPath(using: .stroke)
		}

		imageView.image = img
	}
	
	func drawRectangle(){
		// uiKit Canvas
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

		let img = renderer.image { context in
			// creater a CGRECT shape that the context will use as path
			let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 15, dy: 15)
			
			context.cgContext.setFillColor(UIColor.red.cgColor)
			context.cgContext.setStrokeColor(UIColor.black.cgColor)
			context.cgContext.setLineWidth(10)
			
			context.cgContext.addRect(rectangle)
			context.cgContext.drawPath(using: .fillStroke)
		}

		imageView.image = img
	}
	
	func drawCircle(){
		// uiKit Canvas
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

		let img = renderer.image { context in
			// creater a CGRECT shape that the context will use as path
			// .insetBy, move the shape by 5 at x and 5 at y
			let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 15, dy: 15)
			
			context.cgContext.setFillColor(UIColor.red.cgColor)
			context.cgContext.setStrokeColor(UIColor.black.cgColor)
			context.cgContext.setLineWidth(10)
			
			// ellipse makes the CGRECT circle/ellipse
			context.cgContext.addEllipse(in: rectangle)
			context.cgContext.drawPath(using: .fillStroke)
		}

		imageView.image = img
	}
	
	func drawCheckboard(){
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

		let img = renderer.image { context in
			context.cgContext.setFillColor(UIColor.black.cgColor)
			
			for row in 0 ..< 8 {
				for col in 0 ..< 8 {
					if (row + col).isMultiple(of: 2){
						//BLACK square
						context.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
					}
				}
			}
			
			
		}

		imageView.image = img
	}
}

