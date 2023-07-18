// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation


    var resolution : VideoInfoElement.Resolution = .fullHD

func fetchShowAndSave(showID : Int) {
        if showID > 0 {
            let folderULR = FileManager.default.urls(for: .moviesDirectory, in: .userDomainMask)[0].appendingPathComponent("Cinemana", isDirectory: true)
            print(folderULR)
            let cinemanaShowProcessor =  CinemanaShowProcessor(showID: showID,resolution: resolution ,renameFile: true , folderURL: folderULR) {  result in
                DispatchQueue.main.async {
                    
                print(result)
             
                }
               
            }
            cinemanaShowProcessor.startProcess()
        }
        else {
           // enter valid number
        }
    }
    
    
   



print("Hello, world!")

let theWitchershowID: Int = 327584
fetchShowAndSave( showID:theWitchershowID)
dispatchMain()