import Cocoa
@testable import Utils
@testable import Element
@testable import GitSyncMac
/**
 * This is the main class for the application
 * Not one error in a million keystrokes
 */
@NSApplicationMain
class AppDelegate:NSObject, NSApplicationDelegate {
    weak var window:NSWindow!
    var win:NSWindow?/*<--The window must be a class variable, local variables doesn't work*/
    //var fileWatcher:FileWatcher?
    
    func applicationDidFinishLaunching(_ aNotification:Notification) {
        Swift.print("GitSync - Automates git")//Simple git automation for macOS, The autonomouse git client,The future is automated
        //NSApp.windows[0].close()/*<--Close the initial non-optional default window*/
        test()
        //initApp()
        //initTestWin()//🚧👷
        //initMinimalWin()
        //hitTesting()
        
        
        //let a:String = "<item title=\"New folder\" isOpen=\"false\" hasChildren=\"true\"></item>"
        //treeList.node.addAt(newIdx(idx), a.xml)//"<item title=\"New folder\"/>"
        //let tree = TreeConverter.tree(a.xml)
        
        
        //work on const to enum? and more structs 🏀
            //clean up some of the git classes 👈
            //Move the RepoDetail view into RepoView. find the print screen with aligned UI elements 👈
            //start on Graph3
                //do prototype that has a interpolates the graph points nicly as you scroll
                //store the commit count for all projects in a DataProvider 
                    //must also allow adding/removal of repos
        
        
        
    }
    /**
     *
     */
    func test(){
        window.contentView = InteractiveView2()
        /*Styles*/
       
        /*Rect*/
        let rect = RectGraphic(0,0,200,200,FillStyle(.blue),nil)
        _ = window.contentView?.addSubView(rect.graphic)
        rect.draw()
        
        let a0 = CustomTree("a0")
        let b0 = CustomTree("b0")
        let b1 = CustomTree("b1")
        let c0 = CustomTree("c0")
        b0.children = [c0]
        a0.children = [b0,b1]
        let deepestDepth:Int = CustomTree.depth(a0)
        Swift.print("deepestDepth: " + "\(deepestDepth)")
    }
    /**
     *
     */
    func hitTesting(){
        window.contentView = InteractiveView2()
        StyleManager.addStyle("Button{fill:blue;}")

        let btn = Button(50,50)
        let container = window.contentView!.addSubView(Container(0,0,nil))
         
         container.addSubview(btn)
         /*container.layer?.position.x = 100
         container.layer?.position.y = 100*/
         container.layer?.position = CGPoint(40,20)
         //container.frame.origin = CGPoint(100,100)
         Swift.print("container.layer?.position: " + "\(container.layer?.position)")
         Swift.print("container.frame.origin: " + "\(container.frame.origin)")
         
         btn.layer?.position = CGPoint(40,20)
         //btn.frame
         Swift.print("btn.layer?.position: " + "\(btn.layer?.position)")
         Swift.print("btn.frame.origin: " + "\(btn.frame.origin)")
         btn.event = { event in
            if(event.type == ButtonEvent.upInside){Swift.print("hello world")}
         }
    }
    func initApp(){
         StyleManager.addStylesByURL("~/Desktop/ElCapitan/gitsync.css",false)//<--toggle this bool for live refresh
         win = MainWin(MainView.w,MainView.h)
         //win = VibrantMainWin(MainView.w,MainView.h)
         //win = ConflictDialogWin(380,400)
         //win = CommitDialogWin(400,356)
         //StyleWatcher.watch("~/Desktop/ElCapitan/","~/Desktop/ElCapitan/gitsync.css", self.win!.contentView!)
    }
    func initTestWin(){
        //StyleManager.addStylesByURL("~/Desktop/ElCapitan/explorer.css",false)
        StyleManager.addStylesByURL("~/Desktop/ElCapitan/test.css",false)
        win = TestWin(500,400)/*Debugging Different List components*/
        
        /*fileWatcher = */
        //StyleWatcher.watch("~/Desktop/ElCapitan/","~/Desktop/ElCapitan/gitsync.css", self.win!.contentView!)
    }
    func initMinimalWin(){
        StyleManager.addStylesByURL("~/Desktop/ElCapitan/minimal.css",true)
        //Swift.print("StyleManager.styles.count: " + "\(StyleManager.styles.count)")
        //Swift.print("StyleManager.styles: " + "\(StyleManager.styles)")
        win = MinimalWin(500,400)
    }
    func applicationWillTerminate(_ aNotification:Notification) {
        /*Stores the app prefs*/
        if(PrefsView.keychainUserName != nil){//make sure the data has been read and written to first
            _ = FileModifier.write("~/Desktop/gitsyncprefs.xml".tildePath, PrefsView.xml.xmlString)
            Swift.print("💾 Write PrefsView to: prefs.xml")
        }
        Swift.print("💾 Write RepoList to: repo.xml")
        _ = FileModifier.write(RepoView.repoListFilePath.tildePath, RepoView.treeDP.tree.xml.xmlString)/*store the repo xml*/
        print("Good-bye")
    }
}

class CustomTree{
    var shape:NSView?
    var parent:CustomTree?
    var children:[CustomTree] = []
    var title:String
    init(_ title:String){
        self.title = title
    }
    /*return siblings on same level*/
    static func sibling(_ tree:CustomTree,_ level:Int, _ curLevel:Int = 0) -> [CustomTree] {//4
        return tree.children.reduce([]){
            if curLevel == level {//correct level
                return $0 + $1.children
            };return $0 + sibling($1,level,level + 1)/*not correct level, keep diving*/
        }
    }
    static func deepest(_ tree:CustomTree, _ depth:Int = 0) -> Int{
        //Swift.print("depth: curDepth: \(depth) ")
        /*num of levels on the deepest node from root*/
        var deepest = deepest
        for child in tree.children {
            //print($1.title)
            if !child.children.isEmpty {
                if ((curDepth+1) > deepest) {
                    deepest = curDepth
                }
                return deepest(child, )//keep diving
            }
        }
        return deepest
    }
}
