//
//  CapitalWebViewController.swift
//  Project16_mapKit
//
//  Created by may on 12/16/22.
//

import UIKit
import WebKit

class CapitalWebViewController: UIViewController {
	
	
	@IBOutlet var webView: WKWebView!
	var url: String!
	
	
	override func loadView() {
		webView = WKWebView()
		view = webView
	}
    override func viewDidLoad() {
        super.viewDidLoad()

		var wikiURL: URL!
		url = url?.replacingOccurrences(of: " ", with: "_")
		wikiURL = URL(string: "https://en.wikipedia.org/wiki/\(url ?? "")")
		webView.load(URLRequest(url: wikiURL!))
		webView.allowsBackForwardNavigationGestures = true
    }
    


}
