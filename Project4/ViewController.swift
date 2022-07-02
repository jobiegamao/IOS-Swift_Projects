//
//  ViewController.swift
//  Project4
//
//  Created by may on 6/28/22.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

	// MARK: properties
	var webView: WKWebView!
	var progressView: UIProgressView! //will show how far the page is through loading
	var websites = ["apple.com", "hackingwithswift.com"]
	
//	for webView (app with/to websites)
	override func loadView() {
		webView = WKWebView()
		webView.navigationDelegate = self
		view = webView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		navbar
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
		
//		toolbar
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //takes space auto
		let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload)) //reload btn
		let back = UIBarButtonItem(title: "Back" , style: .plain, target: webView, action: #selector(webView.goBack))
		let forward = UIBarButtonItem(title: "Forward", style: .plain , target: webView, action: #selector(webView.goForward))
		
		progressView = UIProgressView(progressViewStyle: .default)
		progressView.sizeToFit() //layout size so that it fits its contents fully
		let progressButton = UIBarButtonItem(customView: progressView) //put in btn to add in toolbarItems
		
		toolbarItems = [progressButton, spacer, refresh, back, forward]
		navigationController?.isToolbarHidden = false
		
		// apple's listener, listen to webViews progress
		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

		
		let url = URL(string: "https://www." + websites[0])!
		webView.load(URLRequest(url: url))
		webView.allowsBackForwardNavigationGestures = true
	}
	
	@objc func openTapped() {
		let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)
		
		for website in websites {
			ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
		}
		ac.addAction(UIAlertAction(title: "not included site", style: .default, handler: openPage))
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
		present(ac, animated: true)
	}
	
	func openPage(action: UIAlertAction) {
		guard let actionTitle = action.title else { return }
		guard let url = URL(string: "https://" + actionTitle) else { return }
		if websites.contains(actionTitle) {
			webView.load(URLRequest(url: url))
		}
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		title = webView.title
	}
	
//	for progressbar
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress" {
			progressView.progress = Float(webView.estimatedProgress)
		}
	}

//	decide whether we want to allow navigation to happen or not every time something happens.
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		let url = navigationAction.request.url

		if let host = url?.host {
			for website in websites {
				if host.contains(website) {
					decisionHandler(.allow)
					return
				}else{
					let ac = UIAlertController(title: "It's Blocked", message: "The url is isn't allowed.", preferredStyle: .alert)
					ac.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: nil))
					present(ac, animated: true)
				}
			}
		}

		decisionHandler(.cancel)
	}
	

}

