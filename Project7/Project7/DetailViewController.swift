//
//  DetailViewController.swift
//  Project7
//
//  Created by may on 11/10/22.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
	var webView: WKWebView!
	var detailItem: Petition?

	   override func loadView() {
		   webView = WKWebView()
		   view = webView
	   }
	
    override func viewDidLoad() {
        super.viewDidLoad()

		//check if there is a petition
		guard let detailItem = detailItem else { return }

		let html = """
		<html>
		<head>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<style> body { font-size: 150%; } </style>
		</head>
		<body>
		\(detailItem.body)
		</body>
		</html>
		"""

		webView.loadHTMLString(html, baseURL: nil)
    }
    
}
