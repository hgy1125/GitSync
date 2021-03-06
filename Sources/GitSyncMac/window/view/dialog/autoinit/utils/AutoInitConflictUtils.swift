import Foundation
@testable import Utils

class AutoInitConflictUtils {
    typealias State = (pathExists:Bool,hasPathContent:Bool,isGitRepo:Bool,areRemotesEqual:Bool)
    typealias TextData = (issue:String,proposal:String)
    /**
     * Creates the text for the AutoInitPrompt
     */
    static func text(_ conflict:AutoInitConflict)->TextData{//TODO: ⚠️️ Move to AutoInitUtils
        Swift.print("AutoInitConflict.text")
        let repoItem = conflict.repoItem
        var issue:String = ""
        var proposal:String = ""
        let state:State = (conflict.pathExists,conflict.hasPathContent,conflict.isGitRepo,conflict.areRemotesEqual)
        Swift.print("state: " + "\(state)")
        switch state {/*pathExists,hasPathContent,isGitRepo,areRemotesEqual*/
        case (true,true,true,false):
            issue = "There is already a git project in the folder: \(repoItem.local) with a different remote URL"
            proposal = "Do you want to replace the remote URL with the new URL?"
        case (true,true,false,_):
            issue = "The folder \(repoItem.localPath) is not a git repo but there are pre-exisiting files"
            proposal = "Do you want to delete the repo, download from remote?"
        case (true,false,_,_):
            issue = "The folder in path: " + "\(repoItem.localPath) is empty"
            proposal = "Do you want to download the remote git repository into this path?"
        case (false,_,_,_):
            issue = "The path \(repoItem.localPath) doesn't exist"
            proposal = "Do you want to download the remote git repository into this path?"//\(repoItem.remotePath)
        default:
            fatalError("Has no strategy for this scenario \(state)")
        }
        return (issue,proposal)
    }
    /**
     * NOTE: after this you often want to : MergeUtils.manualMerge(repoItem,{})
     * TODO: ⚠️️ Make this try do design pattern
     */
    static func process(_ conflict:AutoInitConflict){//TODO: ⚠️️ Move to AutoInitUtils
        let state:State = (conflict.pathExists,conflict.hasPathContent,conflict.isGitRepo,conflict.areRemotesEqual)
        let repoItem = conflict.repoItem
        Swift.print("AutoInitConflic.process() state: \(state)")
        switch state {/*pathExists,hasPathContent,isGitRepo,areRemotesEqual*/
        case (true,true,true,false):
            Swift.print("a")
//            let gitURL:String = (repoItem.localPath+"/.git").tildePath
//            Swift.print("gitURL: " + "\(gitURL)")
//            FileModifier.delete(repoItem.localPath.tildePath)
//            FileModifier.createDir(repoItem.localPath.tildePath)
//            _ = GitModifier.clone(repoItem.remotePath, repoItem.localPath.tildePath)
//            GitUtils.manualClone(repoItem.localPath.tildePath, repoItem.remotePath, repoItem.branch)
//            _ = GitModifier.initialize(repoItem.localPath)
//            _ = GitModifier.attachRemoteRepo(repoItem.localPath,repoItem.remotePath)//--add new remote origin
            //git remote set-url origin https://github.com/username/repo
            _ = GitModifier.replaceRemote(localRepoPath: repoItem.localPath.tildePath, replacementRepoRemote: repoItem.remotePath)
        case (true,true,false,_):
            Swift.print("b")
//            GitUtils.manualClone(repoItem.localPath.tildePath, repoItem.remotePath, repoItem.branch)
            FileModifier.delete(repoItem.localPath.tildePath)
            FileModifier.createDir(repoItem.localPath.tildePath)
            _ = GitModifier.clone(repoItem.remotePath, repoItem.localPath.tildePath)
            //Continue here: 
                //Try the process manually in appdelegate, something isnt working
                    //sync normally then use appdelegate after 
                    //never mind, just delete the path and use normal clone 👈
//            _ = GitModifier.initialize(repoItem.localPath)
//            _ = GitModifier.attachRemoteRepo(repoItem.localPath,repoItem.remotePath)//--add new remote origin
        case (true,false,_,_):
            Swift.print("c")
            
//            FileModifier.delete(repoItem.localPath.tildePath)
            
                        let status = GitModifier.clone(repoItem.remotePath,repoItem.localPath.tildePath)
                  Swift.print("status: " + "\(status)")
        case (false,_,_,_):
            Swift.print("d")
//            FileModifier.delete(repoItem.localPath.tildePath)
            FileModifier.createDir(repoItem.localPath.tildePath)
            let result = GitModifier.clone(repoItem.remotePath,repoItem.localPath.tildePath)//--this will create the folders if they dont exist, even nested
            Swift.print("result: " + "\(result)")
        default:
            fatalError("Has no strategy for this scenario: \(state) ")
        }
    }
}
