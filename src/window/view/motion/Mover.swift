import Cocoa

class Mover {
    var value:CGFloat = 0
    var velocity:CGFloat
    var target:NSView//TODO: change this to IPositionable in the future
    init(_ target:NSView, _ value:CGFloat, _ velocity:CGFloat = 0){
        self.target = target
        self.value = value
        self.velocity = velocity;
    }
    func updatePosition() {
        //Swift.print("\(self.)" + "updatePosition")
        value += velocity;
    }
}
