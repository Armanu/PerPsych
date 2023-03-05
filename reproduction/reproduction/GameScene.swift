//
//  GameScene.swift
//  gameon
//
//  Created by Arman on 3/26/1401 AP.
//

import SpriteKit
import GameplayKit
import CryptoSwift

class GameScene: SKScene {
    let stimulant1 = SKSpriteNode(imageNamed: "iden1")
    var tstu = SKSpriteNode()
    var tstd = SKSpriteNode()
    var bigButton = SKSpriteNode()
    var smallButton = SKSpriteNode()
    var finishlabel = SKLabelNode()
    var pointlabel = SKLabelNode()
    var point:Double = 0
    var pointts:Int = 0
    var fixButton = SKSpriteNode()
    var trial:Int = 0
    let timeIntervals = [0.400, 0.500, 0.700, 1.1, 1.9]
    let c1: Double = 0.4
    let c2: Double = 0.5
    let c3: Double = 0.7
    let c4: Double = 1.1
    let c5: Double = 1.9
    var utime:Double = 0
    var timeArray: [[Double]] = []
    var ctrial : [Double] = []
    var resWidth = CGFloat()
    var resHeight = CGFloat()
    var anyAnswer:Bool = false
    var physWidth = Double()
    var physHeight = Double()
    var blockStarted = false
    var distanceFromDevice: Double = 50
    var firstWaitInterval: Double = 0.5
    var trialStartTime: Double = 0
    var trialIntervals: Double = 2
    var noAnswerWaitTime: Double = 9
    var showFramesTime: Double = 2/60
    var trialFinished: Bool = false
    var lastfixst: Bool = false
    var lastbutst: Bool = false
    var stimulantWasShown: Bool = false
    var micHintWorkItem: DispatchWorkItem?
    var micHintWorkItem1: DispatchWorkItem?
    var answers: [(Int,Double,Double,Double,Double,Double)] = []
    var filename:URL!
    var logfilename:URL!
    let defaults = UserDefaults.standard
    var firstFlashInteral: Double = 0
    var secondFlashInteral: Double = 0
    var blockInfo: String = ""
    var logs: String = ""
    var blocksStartTime: Double = 0
    
    weak var viewController: GameViewController?
    func exitFunction () {
        
        self.view?.window?.rootViewController?.navigationController?.popViewController(animated: true)
        self.view?.window?.rootViewController?.dismiss(animated: false, completion: nil)
        self.removeFromParent()
        self.view?.presentScene(nil)
        self.removeAllActions()
        self.removeAllChildren()
    }
    override func didMove(to view: SKView) {
        
        blockInfo = defaults.string(forKey: "blockname")! + "," +
        defaults.string(forKey: "blockcode")! + "," +
        defaults.string(forKey: "blocknumber")! + ","
        
        bigButton = self.childNode(withName: "big_but") as! SKSpriteNode
        smallButton = self.childNode(withName: "small_but") as! SKSpriteNode
        fixButton = self.childNode(withName: "fix_point") as! SKSpriteNode
        finishlabel = self.childNode(withName: "fin_label") as! SKLabelNode
        pointlabel = self.childNode(withName: "point_label") as! SKLabelNode
        pointlabel.text = "No answer."

        finishlabel.isHidden = false
        pointlabel.isHidden = true

        finishlabel.text = "برای شروع روی صفحه ضربه بزنید"
        smallButton.isHidden = true
        bigButton.isHidden = true
        fixButton.isHidden = true
        
        resWidth = 2388
        resHeight = 1668
        
        tstu = self.childNode(withName: "tstu") as! SKSpriteNode
        tstd = self.childNode(withName: "tstd") as! SKSpriteNode
        
        if defaults.bool(forKey: "train") == true
        {
            tstd.isHidden = false
            tstu.isHidden = false
        }
        else
        {
            tstd.isHidden = true
            tstu.isHidden = true
        }
        
        
        let width:Double = (2388 * 2.54) / 264
        let height:Double = (1668 * 2.54) / 264
        
        
        physWidth = width
        physHeight = height
        
        print( horixontalDegreeToPixel(sizeInDegree: 5))
        print(self.size.height)
        print(self.size.width)
        
        bigButton.size.height = verticalDegreeToPixel(sizeInDegree: 2)
        bigButton.size.width = horixontalDegreeToPixel(sizeInDegree: 2)
        bigButton.position = CGPoint(x: horixontalDegreeToPixel(sizeInDegree: 5), y: 0 )
        
        smallButton.size.height = verticalDegreeToPixel(sizeInDegree: 0.5)
        smallButton.size.width = horixontalDegreeToPixel(sizeInDegree: 0.5)
        smallButton.position = CGPoint(x: -horixontalDegreeToPixel(sizeInDegree: 5), y: 0)
        
        fixButton.size.height = verticalDegreeToPixel(sizeInDegree: 0.2)
        fixButton.size.width = horixontalDegreeToPixel(sizeInDegree: 0.2)
        
        //let timeShifts = [0.6, 0.12, 0.24, 0.48]
        //for timeInterval in timeIntervals
        //{
        //    for timeShift in timeShifts
        //    {
        //        timeArray.append([timeInterval,(round(60 * (timeInterval + timeInterval*timeShift)))/60])
        //        timeArray.append([timeInterval,(round(60 * (timeInterval - timeInterval*timeShift)))/60])
        //
        //    }
        //}
        
        timeArray = [[c1,c1],[c2,c2],[c3,c3],[c4,c4],[c5,c5],
                     [c1,c1],[c2,c2],[c3,c3],[c4,c4],[c5,c5],
                     [c1,c1],[c2,c2],[c3,c3],[c4,c4],[c5,c5],
                     [c1,c1],[c2,c2],[c3,c3],[c4,c4],[c5,c5],
                     [c1,c1],[c2,c2],[c3,c3],[c4,c4],[c5,c5],
                     [c1,c1],[c2,c2],[c3,c3],[c4,c4],[c5,c5],
                     [c1,c1],[c2,c2],[c3,c3],[c4,c4],[c5,c5],
                     [c1,c1],[c2,c2],[c3,c3],[c4,c4],[c5,c5]]
        print(timeArray)

        stimulant1.position = CGPoint(x: 0, y: 0)
        stimulant1.size = CGSize(width: horixontalDegreeToPixel(sizeInDegree: 2.5), height: verticalDegreeToPixel(sizeInDegree: 2.5))
        addChild(stimulant1)
        
        
        stimulant1.isHidden = true
        
        
    }
    func rad2deg(_ number: Double) -> Double {
        return number * 180 / .pi
    }
    
    func verticalDegreeToPixel(sizeInDegree:CGFloat) -> Double
    {
        let deg_per_px = rad2deg(atan2(0.5 * physHeight, distanceFromDevice)) / (0.5 * resHeight)
        let size_in_px = sizeInDegree / deg_per_px
        return size_in_px
        
    }
    func horixontalDegreeToPixel(sizeInDegree:CGFloat) -> Double
    {
        let deg_per_px = rad2deg(atan2(0.5 * physWidth, distanceFromDevice)) / (0.5 * resWidth)
        let size_in_px = sizeInDegree / deg_per_px
        return size_in_px
    }
    func encrypt(text: String) -> String?  {
        if let aes = try? AES(key: "passwordpassword", iv: "drowssapdrowssap"),
           let encrypted = try? aes.encrypt(Array(text.utf8)) {
            return encrypted.toHexString()
        }
        return nil
    }
    func decrypt(hexString: String) -> String? {
        if let aes = try? AES(key: "passwordpassword", iv: "drowssapdrowssap"),
            let decrypted = try? aes.decrypt(Array<UInt8>(hex: hexString)) {
            return String(data: Data(bytes: decrypted), encoding: .utf8)
        }
        return nil
    }
    func resetTrial()
    {
        trial = trial + 1
        if trialFinished == false {
            let waitactionm1 = SKAction.wait(forDuration: 1)
            let unhideact = SKAction.unhide()
            let hideact = SKAction.hide()

            fixButton.run(SKAction.sequence([hideact]))
            if anyAnswer == true{
            pointlabel.text = String(pointts)
            }else{
                pointlabel.text = "بدون پاسخ"
            }
            if blockStarted == true{
            pointlabel.run(SKAction.sequence([unhideact]))
            }
            let actionMovem1 = SKAction.hide()
            let waitactionm = SKAction.wait(forDuration: trialIntervals)
            var actionMovem = SKAction.unhide()
            if timeArray.count == 0
            {
                actionMovem = SKAction.hide()
                
            }

            fixButton.run(SKAction.sequence([waitactionm1,actionMovem1,waitactionm,actionMovem]))
            pointlabel.run(SKAction.sequence([waitactionm1,actionMovem1,waitactionm]))
            smallButton.run(SKAction.sequence([waitactionm1,actionMovem1,waitactionm,actionMovem]))
            bigButton.run(SKAction.sequence([waitactionm1,actionMovem1,waitactionm,actionMovem]))
            runTrial()
        }
        else
        {
            let waitactionm1 = SKAction.wait(forDuration: 1)
//            let waitactionm2 = SKAction.wait(forDuration: 1)
//
//            let colorize = SKAction.colorize(with: SKColor.white, colorBlendFactor: 1, duration: 0.1)
//            let resizeh = SKAction.resize(toHeight: verticalDegreeToPixel(sizeInDegree: 0.2), duration: 0.1)
//            let resizew = SKAction.resize(toWidth: horixontalDegreeToPixel(sizeInDegree: 0.2), duration: 0.1)
            let unhideact = SKAction.unhide()
            let hideact = SKAction.hide()

            fixButton.run(SKAction.sequence([hideact]))
            if anyAnswer == true{
            pointlabel.text = String(pointts)
            }else{
                pointlabel.text = "بدون پاسخ"
            }
            if blockStarted == true{
            pointlabel.run(SKAction.sequence([unhideact]))
            }
            let actionMovem1 = SKAction.hide()
            let waitactionm = SKAction.wait(forDuration: trialIntervals)
            var actionMovem = SKAction.unhide()
            if timeArray.count == 0
            {
                actionMovem = SKAction.hide()
                
            }
            fixButton.run(SKAction.sequence([waitactionm1,actionMovem1,waitactionm,actionMovem]))
            pointlabel.run(SKAction.sequence([waitactionm1,actionMovem1,waitactionm]))
            smallButton.run(SKAction.sequence([waitactionm1,actionMovem1,waitactionm,actionMovem]))
            bigButton.run(SKAction.sequence([waitactionm1,actionMovem1,waitactionm,actionMovem]))
            finishlabel.run(SKAction.sequence([waitactionm1,unhideact]))

        }
        anyAnswer = false

    }
    func addLog(log:String)
    {
      logs += log + "\n"
    }
    func blockFinished()
    {
        
        var str = ""
        var last = ""
        var loglast = ""
        for answer in answers
        {
            str +=
            blockInfo +
            String(answer.0) + "," +
            String(answer.1) + "," +
            String(answer.2) + "," +
            String(answer.3) + "," +
            String(answer.4) + "\n"
        }
        print(str)
        filename = getDocumentsDirectory().appendingPathComponent("output_reproduction.dipm")
        do {
            last = try String(contentsOf: filename, encoding: .utf8)
            if last != ""
            {
                last =  decrypt(hexString: last)! + str
            }
            else {
                last = str
            }
            last = encrypt(text: last)!
            print(last)
        }
        catch {
            print("Error while saving file!")
            
        }
        
        
        do {
            try last.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            print("Error while saving file!")
        }
        
        
        logfilename = getDocumentsDirectory().appendingPathComponent("log_reproduction.dipm")
        do {
            loglast = try String(contentsOf: logfilename, encoding: .utf8) + logs
        }
        catch {
            print("Error while updating log!")

        }
        
        do {
            try loglast.write(to: logfilename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            print("Error while updating log!")
        }
        
    }
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0]
    }
  
    func runTrial()
    {
        
        firstWaitInterval = 0.5 + Double((Int.random(in: 0..<13)))/60
        
        
        trialStartTime = CACurrentMediaTime();
        stimulantWasShown = false
        if timeArray.isEmpty
        {
            trialFinished = true
        resetTrial()
        }
        else{
            
            let randomInt = timeArray.indices.randomElement()
            
            ctrial = timeArray[randomInt ?? 2]
            let answerWaitTime = timeArray[randomInt ?? 2][0] + timeArray[randomInt ?? 2][1] + trialIntervals + firstWaitInterval + 1.1 + noAnswerWaitTime
            
            micHintWorkItem = DispatchWorkItem {[self] in
                if anyAnswer == false
                {
                    
                    answers.append((trial,10,firstFlashInteral,secondFlashInteral,20,firstWaitInterval))
                    pointlabel.text = "بدون پاسخ"
                    resetTrial()
                    
                }
                
            }
            
      
            DispatchQueue.main.asyncAfter(deadline: .now() + answerWaitTime,  execute:micHintWorkItem!)

            firstFlashInteral = timeArray[randomInt ?? 2][0]
            secondFlashInteral = timeArray[randomInt ?? 2][1]
            print("----------------------------------------------")
            addLog(log:"----------------------------------------------")
            addLog(log: "first wait Interval time: " + String(firstWaitInterval))
            addLog(log:"first flash Interval time: " + String(firstFlashInteral))
            addLog(log:"second flash Interval time: " + String(secondFlashInteral))
            print("first wait Interval time: " + String(firstWaitInterval))
            print("first flash Interval time: " + String(firstFlashInteral))
            print("second flash Interval time: " + String(secondFlashInteral))
            let waitaction1 = SKAction.wait(forDuration: trialIntervals + firstWaitInterval + 1)
            let actionMove = SKAction.unhide()
            let waitaction = SKAction.wait(forDuration: showFramesTime)
            let hideaction = SKAction.hide()
            
            let waitaction2 = SKAction.wait(forDuration: firstFlashInteral)
            let texture1 = SKTexture(imageNamed: "iden2")
            let changeFixationimage1 = SKAction.setTexture(texture1)
            let actionMove2 = SKAction.unhide()
            let waitaction3 = SKAction.wait(forDuration: showFramesTime)
            let hideaction2 = SKAction.hide()
            
//            let waitaction4 = SKAction.wait(forDuration:  secondFlashInteral)
//            let texture2 = SKTexture(imageNamed: "iden1")
//            let changeFixationimage2 = SKAction.setTexture(texture2)
//            let actionMove3 = SKAction.unhide()
//            let waitaction5 = SKAction.wait(forDuration: showFramesTime)
//            let hideaction3 = SKAction.hide()
            
            stimulant1.run(SKAction.sequence([ waitaction1,actionMove,waitaction,hideaction
                                               ,waitaction2,changeFixationimage1,actionMove2,waitaction3,hideaction2
                                               //,waitaction4,changeFixationimage2,actionMove3,waitaction5,hideaction3
                                             ]) ,completion: {self.stimulantWasShown = true})
            timeArray.remove(at: randomInt ?? 2)
        }
        
    }
    override func update(_ currentTime: TimeInterval) {
        
        if stimulant1.isHidden == false {
            utime = CACurrentMediaTime()-blocksStartTime
        }
        if stimulant1.isHidden != lastbutst ||   lastfixst != fixButton.isHidden
        {
            print("trial number : "+String(trial)+" "+String(CACurrentMediaTime()-blocksStartTime) + " : Stimulant -------> ," + String(!stimulant1.isHidden))
            lastbutst = stimulant1.isHidden
            print("trial number : "+String(trial)+" "+String(CACurrentMediaTime()-blocksStartTime) + " : fixation -------> ," + String(!fixButton.isHidden))
            lastfixst = fixButton.isHidden
                addLog(log:String(trial)+String(CACurrentMediaTime()-blocksStartTime) + " : Stimulant -------> ," + String(!stimulant1.isHidden))
                addLog(log: String(trial)+String(CACurrentMediaTime()-blocksStartTime) + " : fixation -------> ," + String(!fixButton.isHidden))
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let trialEndTime = CACurrentMediaTime()
        
        if blockStarted == false
        {
            finishlabel.isHidden = true
            finishlabel.text = "برای پایان روی صفحه ضربه بزنید"
            resetTrial()
            blockStarted = true
            blocksStartTime = CACurrentMediaTime()
        }
        
        if trialFinished
        {
            if defaults.bool(forKey: "train") == false
            {
                blockFinished()
            }
            exitFunction()
            
        }
        if tstd.contains(location)
        {
            if defaults.bool(forKey: "train") == true
            {
            exitFunction()
            }
        }
        //if bigButton.contains(location)
        if location.x > 0
        {
            
            if stimulantWasShown
            {
//                fixButton.size.height = verticalDegreeToPixel(sizeInDegree: 1)
//                fixButton.size.width = horixontalDegreeToPixel(sizeInDegree: 1)
                anyAnswer = true
                micHintWorkItem?.cancel()
                stimulant1.removeAllActions()
                
//                if ctrial[0]<ctrial[1]
//                {
                point = CACurrentMediaTime()-blocksStartTime - utime - ctrial[0]
                pointts = Int(1000*point)
                print("minus : "+String(CACurrentMediaTime()-blocksStartTime - utime - ctrial[0]))
                    //fixButton.color = SKColor.green
                    answers.append((trial,CACurrentMediaTime()-blocksStartTime - utime,firstFlashInteral,secondFlashInteral,(trialEndTime - trialStartTime),firstWaitInterval))

//                }else {
//                    fixButton.color = SKColor.red
//                    answers.append((false,firstFlashInteral,secondFlashInteral,(trialEndTime - trialStartTime),firstWaitInterval))
//
//                }
                resetTrial()
            }
        }
        //if smallButton.contains(location) {
//        if location.x < 0
//        {
//            if stimulantWasShown
//            {
////                fixButton.size.height = verticalDegreeToPixel(sizeInDegree: 1)
////                fixButton.size.width = horixontalDegreeToPixel(sizeInDegree: 1)
//                anyAnswer = true
//                micHintWorkItem?.cancel()
//                stimulant1.removeAllActions()
//
//                if ctrial[1]<ctrial[0]
//                {
//                    //fixButton.color = SKColor.green
//                    answers.append((true,firstWaitInterval,secondFlashInteral,(trialEndTime - trialStartTime),firstWaitInterval))
//
//                }else {
//                    fixButton.color = SKColor.red
//                    answers.append((false,firstWaitInterval,secondFlashInteral,(trialEndTime - trialStartTime),firstWaitInterval))
//
//                }
//                resetTrial()
//            }
//        }
        else {
            return
        }
        
    }
}

