import UIKit

var pendulum:Pendulum! = nil

class ViewController: UIViewController {
    var timer = Timer()
    @IBOutlet var p1Mass: UISlider!
    @IBOutlet var p1Length: UISlider!
    @IBOutlet var p1Speed: UISlider!
    @IBOutlet var p2Mass: UISlider!
    @IBOutlet var p2Length: UISlider!
    @IBOutlet var p2Speed: UISlider!
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var mass1Legend: UILabel!
    @IBOutlet var mass2Legend: UILabel!
    @IBOutlet var len1Legend: UILabel!
    @IBOutlet var len2Legend: UILabel!
    @IBOutlet var speed1Legend: UILabel!
    @IBOutlet var speed2Legend: UILabel!

    @IBAction func resetPressed(_ sender: UIButton) { pendulum.reset() }
    @IBAction func p1MassChange(_ sender: UISlider) { pendulum.setMass1(sender.value) }
    @IBAction func p1LengthChange(_ sender: UISlider) { pendulum.setLength1(sender.value) }
    @IBAction func p1SpeedChange(_ sender: UISlider) { pendulum.setSpeed1(sender.value) }
    @IBAction func p2MassChange(_ sender: UISlider) { pendulum.setMass2(sender.value) }
    @IBAction func p2LengthChange(_ sender: UISlider) { pendulum.setLength2(sender.value) }
    @IBAction func p2SpeedChange(_ sender: UISlider) { pendulum.setSpeed2(sender.value) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pendulum = Pendulum(view.bounds)
        timer = Timer.scheduledTimer(timeInterval:1.0/60.0, target: self, selector: #selector(timerHandler), userInfo: nil, repeats: true)
        screenRotated()
    }
    
    //MARK: -
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.screenRotated()
        }
    }
    
    @objc func screenRotated() {
        let xs:CGFloat = view.bounds.width
        let ys:CGFloat = view.bounds.height
//        let xs = scrnLandscape ? scrnSz[scrnIndex].y : scrnSz[scrnIndex].x
//        let ys = scrnLandscape ? scrnSz[scrnIndex].x : scrnSz[scrnIndex].y
        
        let fullWidth:CGFloat = 700
        let fullHeight:CGFloat = 110
        let lxs:CGFloat = 80    // legend width
        let cxs:CGFloat = 200   // slider width
        let bys:CGFloat = 35    // slider height
        var y:CGFloat = ys - 20 - fullHeight
        var x:CGFloat = (xs - fullWidth)/2
        
        mass1Legend.frame = CGRect(x:x, y:y, width:lxs, height:bys)
        p1Mass.frame = CGRect(x:x + 90, y:y, width:cxs, height:bys); y += bys + 5
        len1Legend.frame = CGRect(x:x, y:y, width:lxs, height:bys)
        p1Length.frame = CGRect(x:x + 90, y:y, width:cxs, height:bys); y += bys + 5
        speed1Legend.frame = CGRect(x:x, y:y, width:lxs, height:bys)
        p1Speed.frame = CGRect(x:x + 90, y:y, width:cxs, height:bys)
        x += 320
        y = ys - 20 - fullHeight
        mass2Legend.frame = CGRect(x:x, y:y, width:lxs, height:bys)
        p2Mass.frame = CGRect(x:x + 90, y:y, width:cxs, height:bys); y += bys + 5
        len2Legend.frame = CGRect(x:x, y:y, width:lxs, height:bys)
        p2Length.frame = CGRect(x:x + 90, y:y, width:cxs, height:bys); y += bys + 5
        speed2Legend.frame = CGRect(x:x, y:y, width:lxs, height:bys)
        p2Speed.frame = CGRect(x:x + 90, y:y, width:cxs, height:bys)
        resetButton.frame = CGRect(x:x + 320, y:y, width:lxs, height:bys)

    }
    
    @objc func timerHandler() {
        pendulum.update()
        view.setNeedsDisplay()
    }
}
