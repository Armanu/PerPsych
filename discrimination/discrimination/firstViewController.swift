//
//  firstViewController.swift
//  gameon
//
//  Created by Arman on 4/3/1401 AP.
//

import UIKit
import SpriteKit
import Foundation

class firstViewController: UIViewController {

    let defaults = UserDefaults.standard
    var filename:URL!
    var logfilename:URL!

    @IBOutlet var mainView: UIView!
    @IBAction func share(_ sender: UIBarButtonItem) {
        let fileURL = NSURL(fileURLWithPath: filename.path)
        let logfileURL = NSURL(fileURLWithPath: logfilename.path)

        let activity = UIActivityViewController(
            activityItems: [logfileURL, fileURL],
            applicationActivities: nil
          )
        activity.popoverPresentationController?.barButtonItem = sender     // 3
          present(activity, animated: true, completion: nil)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func train(_ sender: UIBarButtonItem) {
        
        defaults.set(nameBox.text, forKey: "blockname")
        defaults.set(codeBox.text, forKey: "blockcode")
        defaults.set(blockBox.text, forKey: "blocknumber")
        defaults.set("no", forKey: "istf")
        defaults.set(true, forKey: "train")

        let vc = storyboard?.instantiateViewController(withIdentifier: "game_vc") as! GameViewController
        present(vc, animated: false)
    }
    
    @IBAction func startBut(_ sender: Any) {
    
                defaults.set(nameBox.text, forKey: "blockname")
                defaults.set(codeBox.text, forKey: "blockcode")
                defaults.set(blockBox.text, forKey: "blocknumber")
                defaults.set("no", forKey: "istf")
                defaults.set(false, forKey: "train")


        let vc = storyboard?.instantiateViewController(withIdentifier: "game_vc") as! GameViewController
        present(vc, animated: false)
        
    }
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    @IBOutlet weak var blockBox: UITextField!
    @IBOutlet weak var codeBox: UITextField!
    @IBOutlet weak var nameBox: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        filename = getDocumentsDirectory().appendingPathComponent("output_discrimination.dipm")
        logfilename = getDocumentsDirectory().appendingPathComponent("log_discrimination.dipm")

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

}
