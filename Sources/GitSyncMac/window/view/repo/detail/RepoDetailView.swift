import Foundation
@testable import Utils
@testable import Element

class RepoDetailView:Element {
    override func resolveSkin() {
        super.resolveSkin()
        UnFoldUtils.unFold(Config.app,"repoDetailView",self)
    }
    /**
     * Modifies the dataProvider item on UI change
     * TODO: ⚠️️ enumify this method? at least use switch
     */
    override func onEvent(_ event:Event) {
        Swift.print("onEvent: type: " + "\(event.type) immediate: \(event.immediate) origin: \(event.origin)")
        let idx3d:[Int] = RepoView.selectedListItemIndex
        guard var attrib:[String:String] = RepoView.treeDP.tree[idx3d]?.props else{
            fatalError("no attribs at: \(idx3d)")
        }
        if event.type == Event.update {
            switch true{
            /*TextInput*/
            case event.isChildOf(nameText):
                attrib[RepoType.title.rawValue] = nameText?.inputText
            case event.isChildOf(localText):
                attrib[RepoType.local.rawValue] = localText?.inputText
            case event.isChildOf(remoteText):
                attrib[RepoType.remote.rawValue] = remoteText?.inputText
            case event.isChildOf(branchText):
                attrib[RepoType.branch.rawValue] = branchText?.inputText
            default:
                break;
            }
        }else if event.type == CheckEvent.check{
            switch true{
            /*CheckButtons*/
            case event.isChildOf(activeCheckBoxButton)://TODO: <---use getChecked here
                attrib[RepoType.active.rawValue] = activeCheckBoxButton?.getChecked().str
            case event.isChildOf(messageCheckBoxButton):
                attrib[RepoType.message.rawValue] = messageCheckBoxButton?.getChecked().str
            case event.isChildOf(autoCheckBoxButton):
                attrib[RepoType.auto.rawValue] = autoCheckBoxButton?.getChecked().str
            default:
                break;
            }
        }else{
            super.onEvent(event)//forward other events
        }
        if(event.type == CheckEvent.check || event.type == Event.update){
            //Swift.print("✨ Update dp with: attrib: " + "\(attrib)")
            RepoView.treeDP.tree[idx3d]!.props = attrib/*Overrides the cur attribs*///RepoView.node.setAttributeAt(i, attrib)
            if let tree:Tree = RepoView.treeDP.tree[idx3d]{
                Swift.print("title: " + "\(tree.props?[RepoType.title.rawValue])")
                //Swift.print("node.xml.xmlString: " + "\(tree.xml.xmlString)")
            }
        }
    }
}
extension RepoDetailView{
    /**
     * Populates the UI elements with data from the dp item
     * NOTE: Filters groups and items
     */
    func setRepoData(_ idx3d:[Int]){
        RepoView.selectedListItemIndex = idx3d
        //TODO: Use the RepoItem on the bellow line see AutoSync class for implementation
        if let tree:Tree = RepoView.treeDP.tree[idx3d], let repoItemDict = tree.props{//NodeParser.dataAt(treeList!.node, selectedIndex)
            var repoItem:RepoItem
            if !tree.children.isEmpty {/*Support for folders*/
                repoItem = RepoItem()
                if let title:String = repoItemDict[RepoType.title.rawValue] {repoItem.title = title}
                if let active:String = repoItemDict[RepoType.active.rawValue] {repoItem.active = active.bool}
            }else{
                repoItem = RepoUtils.repoItem(repoItemDict)
            }
            setRepoData(repoItem)
        }
    }
    /**
     * Populates the UI elements with data from the dp item
     */
    private func setRepoData(_ repoItem:RepoItem){
        /*TextInput*/
        nameText?.inputTextArea.setTextValue(repoItem.title)
        localText?.inputTextArea.setTextValue(repoItem.localPath)
        remoteText?.inputTextArea.setTextValue(repoItem.remotePath)
        branchText?.inputTextArea.setTextValue(repoItem.branch)
        /*CheckButtons*/
        autoCheckBoxButton?.setChecked(!repoItem.pullToAutoSync)
        messageCheckBoxButton?.setChecked(repoItem.autoCommitMessage)
        activeCheckBoxButton?.setChecked(repoItem.active)
    }
}
extension RepoDetailView{/*Convenience*/
    var nameText:TextInput? {return self.element(RepoType.name.rawValue)}
    var localText:TextInput? {return self.element(RepoType.local.rawValue)}
    var remoteText:TextInput? {return self.element(RepoType.remote.rawValue)}
    var branchText:TextInput? {return self.element(RepoType.branch.rawValue)}
    var autoCheckBoxButton:CheckBoxButton? {return self.element(RepoType.auto.rawValue)}
    var messageCheckBoxButton:CheckBoxButton? {return self.element(RepoType.message.rawValue)}
    var activeCheckBoxButton:CheckBoxButton? {return self.element(RepoType.active.rawValue)}
}
