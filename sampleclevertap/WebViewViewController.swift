//
//  WebViewViewController.swift
//  sampleclevertap
//
//  Created by Vishal More on 26/06/23.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let url = NSURL (string: "https://samplewebintegration.000webhostapp.com/");
        let request = NSURLRequest(url: url! as URL);
        webView.load(request as URLRequest);
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
