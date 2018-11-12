//
//  ViewController.swift
//  ChanelEmoji
//
//  Created by subramanya on 23/06/18.
//  Copyright © 2018 Subramanya. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var txtView:UITextView!
    @IBOutlet weak var searchTableView: UITableView!
    var searchResultsArray: [SearchResults] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    /*=================================================
     * Function Name: addNavigationRightButton
     * Function Parameter:
     * Function Return Type: UIImage
     * Function Purpose: To add share button as navigation rightbar
     ==================================================*/
    func addNavigationRightButton()
    {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 25))
        button.setImage(UIImage(named: "share"), for: UIControlState.normal)
        button.addTarget(self, action: Selector(("shareMenu:")), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    //Paste from System UIMenuController
   func paste(sender: AnyObject!) {
        
    let pasteBoard = UIPasteboard.general
        
        
    if let _ = pasteBoard.types as? [String]
        {
            
        }
        else
        {
            return
        }
        
    let itemTypeArray = pasteBoard.types as NSArray
    let attributedString = NSMutableAttributedString(string: "")
    if (itemTypeArray.contains(kUTTypePNG as NSString))
        {
            if let data = pasteBoard.data(forPasteboardType: kUTTypePNG as NSString as String)
            {
                let textAttachment = NSTextAttachment()
                textAttachment.image = UIImage(data: data)
                textAttachment.image = UIImage(cgImage: (textAttachment.image?.cgImage)!, scale: 3.0, orientation: UIImageOrientation.up)//UIImage(CGImage: textAttachment.image!.CGImage!, scale: 3, orientation: .Up)
                let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                attributedString.append(attrStringWithImage)
                let mutableString = NSMutableAttributedString(attributedString: self.txtView.attributedText)
                mutableString.append(attributedString)
                self.txtView.attributedText = mutableString
            }
        }
    else if (itemTypeArray.contains(kUTTypeJPEG as NSString))
        {
            
            if let data = pasteBoard.data(forPasteboardType: kUTTypeJPEG as NSString as String)
            {
                let textAttachment = NSTextAttachment()
                textAttachment.image = UIImage(data: data)
                textAttachment.image = UIImage(cgImage: (textAttachment.image?.cgImage)!, scale: 3.0, orientation: UIImageOrientation.up)
                let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                attributedString.append(attrStringWithImage)
                let mutableString = NSMutableAttributedString(attributedString: self.txtView.attributedText)
                mutableString.append(attributedString)
                self.txtView.attributedText = mutableString
            }
            
        }
        else
        {
            if let img = pasteBoard.image
            {
                let textAttachment = NSTextAttachment()
                textAttachment.image = img
                textAttachment.image = UIImage(cgImage: (textAttachment.image?.cgImage)!, scale: 3.0, orientation: UIImageOrientation.up)
                let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                attributedString.append(attrStringWithImage)
                let mutableString = NSMutableAttributedString(attributedString: self.txtView.attributedText)
                mutableString.append(attributedString)
                self.txtView.attributedText = mutableString;
            }
        }
    }
    
    //==================================================
    // Function Name: pasteJMoniImage
    // Function Parameter: nil
    // Function ReturnType: nil
    // Function Purpose: To paste image in textview
    //==================================================
    func pasteJMoniImage()
    {
        let pasteBoard = UIPasteboard.general
        let attributedString = NSMutableAttributedString(string: "")
        if let data = pasteBoard.data(forPasteboardType: kUTTypePNG as NSString as String)
        {
            let textAttachment = NSTextAttachment()
            textAttachment.image = UIImage(data: data)
            let image = UIImage(data: data)
            //TODO: find the CV resukt of this here
            self.getResponse(image: image!)
            
//            self.searchResultsArray = self.getResults()
//            self.searchTableView.reloadData()
            textAttachment.image = UIImage(cgImage: (textAttachment.image?.cgImage)!, scale: 3.0, orientation: UIImageOrientation.up)
            let attrStringWithImage = NSAttributedString(attachment: textAttachment)
            attributedString.append(attrStringWithImage)
            let mutableString = NSMutableAttributedString(attributedString: self.txtView.attributedText)
            mutableString.append(attributedString)
            self.txtView.attributedText = mutableString
            
        }
    }
    
    func getResponse(image: UIImage) {
        let yourHeaders: HTTPHeaders = [
            "Prediction-Key": "c40af356105947e29db74d68d4bb1d13",
            "Content-Type" : "application/octet-stream"
        ]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            if  let imageData = UIImageJPEGRepresentation(image, 0.6) {
                multipartFormData.append(imageData, withName: "image", fileName: "file.png", mimeType: "image/png")
            }
        }, to: "https://southcentralus.api.cognitive.microsoft.com/customvision/v2.0/Prediction/519f1012-968f-45f8-8ace-cc7cb71a68e6/image?iterationId=7446ff17-3b23-463c-bb73-dc9f7aaecc52", method: .post, headers : yourHeaders,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                print(upload.progress)
                
                upload.responseJSON {  response in
                    
                    if let JSON = response.result.value
                    {
                        var firstValue: NSDictionary = [:]
                        print("JSON: \n\n\n \(JSON)\n\n\n")
                        //let jsonData = response.data!
                        let json = JSON as! NSDictionary
                        let predectionArray = json["predictions"] as! [NSDictionary]
                        firstValue = predectionArray[0]
                            if (firstValue["tagName"] as! String) == "Redbags" {
                                self.searchResultsArray = self.getRedBags()
                                self.searchTableView.reloadData()
                            } else if (firstValue["tagName"] as! String) == "Blackbags" {
                                self.searchResultsArray = self.getBlackBags()
                                self.searchTableView.reloadData()
                            } else if (firstValue["tagName"] as! String) == "Lipsticks" {
                                self.searchResultsArray = self.getResults()
                                self.searchTableView.reloadData()
                            }
                    }
                }
                break
            case .failure(_):
                print("/n/nfail/n/n")
            }
        })
    }
    
    func getResults() -> [SearchResults] {
        var results: [SearchResults] = []
        //Lipstick1
        let lipstick1Name = "Lipstick1"
        let lipstick1image = #imageLiteral(resourceName: "RedLipstick1")
        let lipstick1color = "Red"
        let lipstick1Type = "Lipstick"
        
        //Lipstick2
        let lipstick2Name = "Lipstick2"
        let lipstick2image = #imageLiteral(resourceName: "RedLipstick2")
        let lipstick2color = "Red"
        let lipstick2Type = "Lipstick"
        
        //Lipstick3
        let lipstick3Name = "Lipstick3"
        let lipstick3image = #imageLiteral(resourceName: "RedLipstick3")
        let lipstick3color = "Red"
        let lipstick3Type = "Lipstick"
        
        //Lipstick4
        let lipstick4Name = "Lipstick4"
        let lipstick4image = #imageLiteral(resourceName: "PinkLipstick1")
        let lipstick4color = "Pink"
        let lipstick4Type = "Lipstick"
        
        //Lipstick5
        let lipstick5Name = "Lipstick5"
        let lipstick5image = #imageLiteral(resourceName: "PinkLipstick2")
        let lipstick5color = "Pink"
        let lipstick5Type = "Lipstick"
        
        //Lipstick5
        let lipstick6Name = "Lipstick6"
        let lipstick6image = #imageLiteral(resourceName: "PinkLipstick3")
        let lipstick6color = "Pink"
        let lipstick6Type = "Lipstick"
        
        let searchResult1 = SearchResults(name: lipstick1Name, type: lipstick1Type, image: lipstick1image, color: lipstick1color)
        let searchResult2 = SearchResults(name: lipstick2Name, type: lipstick2Type, image: lipstick2image, color: lipstick2color)
        let searchResult3 = SearchResults(name: lipstick3Name, type: lipstick3Type, image: lipstick3image, color: lipstick3color)
        let searchResult4 = SearchResults(name: lipstick4Name, type: lipstick4Type, image: lipstick4image, color: lipstick4color)
        let searchResult5 = SearchResults(name: lipstick5Name, type: lipstick5Type, image: lipstick5image, color: lipstick5color)
        let searchResult6 = SearchResults(name: lipstick6Name, type: lipstick6Type, image: lipstick6image, color: lipstick6color)
        
        results.append(searchResult1)
        results.append(searchResult2)
        results.append(searchResult3)
        results.append(searchResult4)
        results.append(searchResult5)
        results.append(searchResult6)
        
        return results
    }
    
    func getPinkLipstick() -> [SearchResults] {
        var results: [SearchResults] = []
        //Lipstick4
        let lipstick4Name = "Lipstick4"
        let lipstick4image = #imageLiteral(resourceName: "PinkLipstick1")
        let lipstick4color = "Pink"
        let lipstick4Type = "Lipstick"
        
        //Lipstick5
        let lipstick5Name = "Lipstick5"
        let lipstick5image = #imageLiteral(resourceName: "PinkLipstick2")
        let lipstick5color = "Pink"
        let lipstick5Type = "Lipstick"
        
        //Lipstick5
        let lipstick6Name = "Lipstick6"
        let lipstick6image = #imageLiteral(resourceName: "PinkLipstick3")
        let lipstick6color = "Pink"
        let lipstick6Type = "Lipstick"
        
        let searchResult4 = SearchResults(name: lipstick4Name, type: lipstick4Type, image: lipstick4image, color: lipstick4color)
        let searchResult5 = SearchResults(name: lipstick5Name, type: lipstick5Type, image: lipstick5image, color: lipstick5color)
        let searchResult6 = SearchResults(name: lipstick6Name, type: lipstick6Type, image: lipstick6image, color: lipstick6color)
        results.append(searchResult4)
        results.append(searchResult5)
        results.append(searchResult6)
        return results
    }
    
    func getRedLipstick() -> [SearchResults] {
        var results: [SearchResults] = []
        //Lipstick1
        let lipstick1Name = "Lipstick1"
        let lipstick1image = #imageLiteral(resourceName: "RedLipstick1")
        let lipstick1color = "Red"
        let lipstick1Type = "Lipstick"
        
        //Lipstick2
        let lipstick2Name = "Lipstick2"
        let lipstick2image = #imageLiteral(resourceName: "RedLipstick2")
        let lipstick2color = "Red"
        let lipstick2Type = "Lipstick"
        
        //Lipstick3
        let lipstick3Name = "Lipstick3"
        let lipstick3image = #imageLiteral(resourceName: "RedLipstick3")
        let lipstick3color = "Red"
        let lipstick3Type = "Lipstick"
        
        let searchResult1 = SearchResults(name: lipstick1Name, type: lipstick1Type, image: lipstick1image, color: lipstick1color)
        let searchResult2 = SearchResults(name: lipstick2Name, type: lipstick2Type, image: lipstick2image, color: lipstick2color)
        let searchResult3 = SearchResults(name: lipstick3Name, type: lipstick3Type, image: lipstick3image, color: lipstick3color)
        results.append(searchResult1)
        results.append(searchResult2)
        results.append(searchResult3)
        return results
    }
    
    func getBlackBags() -> [SearchResults] {
        var results: [SearchResults] = []
        let bag1 = SearchResults(name: "Bag1", type: "Bag", image: #imageLiteral(resourceName: "BlackBag1"), color: "Black")
        let bag2 = SearchResults(name: "Bag2", type: "Bag", image: #imageLiteral(resourceName: "BlackBag2"), color: "Black")
        let bag3 = SearchResults(name: "Bag3", type: "Bag", image: #imageLiteral(resourceName: "BlackBag3"), color: "Black")
        results.append(bag1)
        results.append(bag2)
        results.append(bag3)
        return results
    }
    
    func getRedBags() -> [SearchResults] {
        var results: [SearchResults] = []
        let bag1 = SearchResults(name: "BagRed1", type: "Bag", image: #imageLiteral(resourceName: "RedBags1"), color: "Red")
        let bag2 = SearchResults(name: "BagRed2", type: "Bag", image: #imageLiteral(resourceName: "RedBag2"), color: "Red")
        let bag3 = SearchResults(name: "BagRed3", type: "Bag", image: #imageLiteral(resourceName: "RedBag3"), color: "Red")
        results.append(bag1)
        results.append(bag2)
        results.append(bag3)
        return results
    }
    
    
    /*=================================================
     * Function Name: shareMenu
     * Function Parameter: sender:UIButton
     * Function Return Type:
     * Function Purpose: To open share menu
     ==================================================*/
    @IBAction func shareMenu(sender: AnyObject) {
        let myApp = NSURL(string:"https://play.google.com/apps/publish/?dev_acc=03575560666186575401#ContentRatingPlace:p=withalsolution.helptoworld")
        let img: UIImage = self.getImage()
        
        
        let shareItems = NSArray(objects:[img, myApp!])
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems as [AnyObject], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    
    /*=================================================
     * Function Name: getImage
     * Function Parameter:
     * Function Return Type: UIImage
     * Function Purpose: To take screenshot of textview
     ==================================================*/
    func getImage() -> UIImage
    {
        UIGraphicsBeginImageContext(self.txtView.frame.size)
        self.txtView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        
    }
    //textview delegate methods
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

//        if text == "\(💄)" {
//            let searchResults = SearchResults()
//            self.searchResultsArray = searchResults.getResults()
//            self.searchTableView.reloadData()
//        }
        if(text == "   ")
        {
            if textView.hasText {
                textView.text = ""
            }
            self.pasteJMoniImage()
            return false
        }
        if(text == "\n")
        {
            self.txtView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // TABLE VIEW DELEGATE AND DATASOURCE METHODS:
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultsCell") as! SearchResultsTableViewCell
        if self.searchResultsArray.count != 0 {
            let result = self.searchResultsArray[indexPath.row]
            cell.configureCell(result: result)
        }
        return cell
    }
}
