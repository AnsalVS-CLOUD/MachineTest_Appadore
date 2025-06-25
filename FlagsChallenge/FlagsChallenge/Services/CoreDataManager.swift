//
//  CoreDataManager.swift
//  FlagsChallenge
//
//  Created by Ansal V S on 23/06/25.
//
import Foundation
import CoreData

class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FlagsChallenge")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data error: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print("Save error: \(error)")
        }
    }
}

//
extension CoreDataManager {
    
    private var sessionURL: URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docs.appendingPathComponent("gamesession.json")
    }
    
    func saveSession(_ session: GameSession) {
        do {
            let data = try JSONEncoder().encode(session)
            try data.write(to: sessionURL)
        } catch {
            print("Error saving session: \(error)")
        }
    }
    
    func loadSession() -> GameSession? {
        do {
            let data = try Data(contentsOf: sessionURL)
            let session = try JSONDecoder().decode(GameSession.self, from: data)
            return session
        } catch {
            print("Error loading session: \(error)")
            return nil
        }
    }
}

