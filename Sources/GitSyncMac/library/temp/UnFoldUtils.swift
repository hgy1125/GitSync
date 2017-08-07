import Cocoa
@testable import Element
@testable import Utils

class UnFoldUtils{
    /**
     * New
     * TODO: ⚠️️ In the future you will use a json method that can take an [Any] that contains str and int for the path. so you can do path:["app",0,"repoView"] etc
     */
    static func unFold(_ fileURL:String, _ path:String, _ parent:Element){
        Swift.print("UnFoldUtils.unFold()")
        JSONParser.dictArr(JSONParser.dict(fileURL.content?.json)?[path])?.forEach{ dict in
            guard let element:Element = UnFoldUtils.unFold(dict,parent) else{fatalError("unFold failed")}
            parent.addSubview(element)
        }
        Swift.print("after unFold fileUrl")
    }
    /**
     * Initiates and returns a UI Component
     */
    static func unFold(_ dict:[String:Any], _ parent:ElementKind? = nil) -> Element?{
        Swift.print("UnFoldUtils.unFold")
        guard let type:String = dict["type"] as? String else {fatalError("type must be string")}
        Swift.print("type: " + "\(type)")
        switch true{
            case type == "\(TextInput.self)":
                return TextInput.unfold(dict,parent)
            case type == "\(RadioButton.self)":
                return RadioButton.unfold(radioButtonUnfoldDict:dict,parent)
            case type == "\(CheckBoxButton.self)":
                return CheckBoxButton.unfold(dict,parent)
            case type == "\(TextButton.self)":
                return TextButton.unfold(dict,parent)
            case type == "\(Text.self)":
                return Text.unfold(dict,parent)
            default:
                fatalError("Type is not unFoldable: \(type)")
                //return nil/*we return nil here instead of fatalError, as this method could be wrapped in a custom method to add other types etc*/
        }
    }
    /**
     * String
     */
    static func string(_ dict:[String:Any],_ key:String) -> String?{
        if let value:Any = dict[key] {
            if let str = value as? String {return str}
            else {fatalError("type not supported: \(value)")}
        };return nil
    }
    /**
     * cgFloat
     */
    static func cgFloat(_ dict:[String:Any],_ key:String) -> CGFloat{
        if let value:Any = dict[key] {
            if let str = value as? String {return str.cgFloat}
            else if let int = value as? Int {return int.cgFloat}
            else {fatalError("type not supported: \(value)")}
        };return NaN
    }
    /**
     * Apply data to unfoldable items to all subviews in an Element
     * TODO:    ⚠️️  probably do .first instead
     */
    static func applyData(_ view:Element, _ data:[String:[String:Any]]){
        Swift.print("applyData")
        view.subviews.forEach{ subView in
//            Swift.print("subView: " + "\((subView))")
            if (subView as? ElementKind != nil){
                 Swift.print("(subview as! ElementKind).id: " + "\((subView as! ElementKind).id!)")
                let isUnfoldable = subView as? UnFoldable != nil
                Swift.print("isUnfoldable: " + "\(isUnfoldable)")
            }
            if var unFoldable:UnFoldable = subView as? UnFoldable,
                let element = subView as? ElementKind,
                let id:String = element.id,
                let value:[String:Any] = data[id] {
                    Swift.print("set data to unfoldable")
                    unFoldable.data = value
            }
        }
    }
    /**
     * Similar to apply data but retrives data instead of applying
     */
    static func retrieveData(_ view:Element, _ id:String) -> [String:Any]?{
        for subView in view.subviews {
            if let unFoldable:UnFoldable = subView as? UnFoldable,
                let element = subView as? IElement,
                id == element.id {
                    return unFoldable.data
            }
        }
        return nil
    }
    /**
     *
     */
    /*static func applyData(_ dict:[String:Any]){
     guard let type:String = dict["type"] as? String else {fatalError("type must be string")}
     switch true{
     case type == "\(TextInput.self)":
     return TextInput.unFold(dict,parent)
     case type == "\(CheckBoxButton.self)":
     return CheckBoxButton.unFold(dict,parent)
     case type == "\(TextButton.self)":
     return TextButton.unFold(dict,parent)
     case type == "\(Text.self)":
     return Text.unFold(dict,parent)
     default:
     fatalError("Type is not unFoldable: \(type)")
     //return nil/*we return nil here instead of fatalError, as this method could be wrapped in a custom method to add other types etc*/
     }
     }*/
}
