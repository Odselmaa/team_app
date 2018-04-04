//
//  KawaiiDB.swift
//  Kawaii
//
//  Created by Odselmaa Dorjsuren on 4/3/18.
//  Copyright © 2018 Odselmaa Dorjsuren. All rights reserved.
//

import Foundation

import SQLite
class KawaiiDB{
    private static let instance = KawaiiDB()
    private let db: Connection?
    private let users = Table("cards")
    private let user_id = Expression<Int64>("id")
    private let user_firstname = Expression<String>("firstname")
    private let user_lastname = Expression<String>("lastname")
    private let user_image = Expression<Blob>("image")
    private let user_group = Expression<String>("group")
    private let user_description = Expression<String>("description")
    

    private init() {
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        do {
            db = try Connection("\(path)/KawaiiDB.sqlite3")
        } catch {
            db = nil
            print ("Unable to open database")
        }
        
        createUser()

       
    }
    
    public static func getInstance() -> KawaiiDB{
        return instance
    }
    
    func createUser() {
        do {
            try db!.run(users.create(ifNotExists: true) { table in
                table.column(user_id, primaryKey: .autoincrement)
                table.column(user_lastname)
                table.column(user_firstname)
                table.column(user_image)
                table.column(user_group)
                table.column(user_description)
            })
        } catch {
            print("Unable to create table")
        }
    }
    func deleteUser(u_id:Int64){
        let user = self.users.filter(user_id == u_id)
        do {
        try db?.run(user.delete())
            print("deleting user with id: ", u_id)
        } catch {
            print("Unable to delete user with id: ", u_id)
        }
        
    }
    
    func getUsers()-> [User]{
        var users = [User]()
        var filtered:QueryType
        do {
            filtered = self.users
            for user in try db!.prepare(filtered) {
//                print(user[user_id])
                let item = User(
                    _id: user[user_id],
                    firstname: user[user_firstname],
                    lastname: user[user_lastname],
                    image: UIImage.fromDatatypeValue(user[user_image]),
                    group: user[user_group],
                    desc: user[user_description])
                users.append(item)
            }
        } catch {
            print("Select failed")
            return []
        }
        return users
    }
    
    func addUser(user: User) -> Int64? {
        do {
            let insert = users.insert(
                                      user_firstname <- user.firstname,
                                      user_lastname <- user.lastname,
                                      user_image <- user.image.datatypeValue,
                                      user_group <- user.group,
                                      user_description <- user.description)
            let id = try db!.run(insert)
            return id
        } catch {
            print("Insert failed")
            return -1
        }
    }
    func updateUser(_ user:User){
        let item = self.users.filter(user_id == user.id!)
        do{
            let result = try db?.run(item.update(
                user_firstname <-  user.firstname,
                user_lastname <- user.lastname,
                user_image <- user.image.datatypeValue,
                user_group <- user.group,
                user_description <- user.description
            ))
            print("Updated \(result!)")
        }catch{
            print("Updating card remote id is failed")
        }
    }
    func getUser(_ id: Int64) -> User{
        let query = users.filter(user_id == id).limit(1)
        var user: User?
        do{
            for item in try db!.prepare(query){
                user =  User(
                    _id: item[user_id],
                    firstname: item[user_firstname],
                    lastname: item[user_lastname],
                    image: UIImage.fromDatatypeValue(item[user_image]),
                    group: item[user_group],
                    desc: item[user_description])
                
            }
        }catch{
            print("Select failed")
        }
        return user!
    }
    
}
