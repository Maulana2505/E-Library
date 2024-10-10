import 'dart:async';

import 'package:elibrary/models/book.dart';
import 'package:elibrary/models/favorite.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = p.join(await getDatabasesPath(), 'elibrary.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE books(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idauthors int,
            title TEXT,
            image TEXT,
            description TEXT,
            filePath TEXT,
            isFavorite INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE usersLogin(
            id INTEGER ,
            isLoggedIn INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE favorit(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userid INTEGER,
            bookid INTEGER,
            isFavorite INTEGER
          )
        ''');
      },
    );
  }

  // BOOK
  Future insertBook(Book book) async {
    final db = await database;
    await db.insert('books', book.toMap());
  }

  Future<List<Book>> searchBooks(String query) async {
    final db = await database;
    var result = await db.query(
      'Books',
      where: 'title LIKE ?',
      whereArgs: ['%$query%'],
    );
    return result.map((map) => Book.fromMap(map)).toList();
  }

  Future<List<Book>> getBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('books');
    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  Future<List<Book>> getBooksparams(int id) async {
    final db = await database;
    final maps = await db.query(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  Future<List<Book>> getAllBooksparams(int id) async {
    final db = await database;
    final maps = await db.query(
      'books',
      where: 'idauthors = ?',
      whereArgs: [id],
    );
    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  Future updateBook(int? id, Book book) async {
    final db = await database;
    await db.update('books', where: 'id = ?', whereArgs: [id], book.toMap());
  }

  Future<void> deleteBook(int? id) async {
    final db = await database;
    await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }

  // USERS
  Future signup(String username, String password) async {
    final db = await database;
    final data = {'username': username, 'password': password};
    final result = await db.insert('users', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future updateLoginUser(int userId) async {
    final db = await database;
    var data = {
      'id': userId,
      'isLoggedIn': 1,
    };
    final result = db.insert(
      'usersLogin',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future getuser() async {
    final db = await database;
    final result = await db.query("usersLogin");
    return result.isNotEmpty ? result : null;
  }

  Future getuserbyid(int id) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? maps : null;
  }

  Future login(String username, String password) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'username = ? and password = ?',
      whereArgs: [username, password],
    );
    return maps.isNotEmpty ? maps : null;
  }

  Future<void> logout(int id) async {
    final db = await database;
    await db.delete('usersLogin', where: 'id = ?', whereArgs: [id]);
  }
  // FAVORITE

  Future addFav(int iduser, int? bookid, int isFavorite) async {
    final db = await database;
    final data = {'userid': iduser, 'bookid': bookid, 'isFavorite': isFavorite};
    final result = db.insert(
      'favorit',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future getFavparams(int id, int? bookid) async {
    final db = await database;
    final data = await db.query('favorit',
        where: 'userid = ? and bookid = ?', whereArgs: [id, bookid]);
    return data.isNotEmpty ? data : null;
  }

  Future<List<Favorit>> getAllFav(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> data =
        await db.query('favorit', where: 'userid = ?', whereArgs: [id]);
    return List.generate(data.length, (i) {
      return Favorit.fromMap(data[i]);
    });
  }

  Future deleteFav(int id) async {
    final db = await database;
    await db.delete('favorit', where: 'id = ?', whereArgs: [id]);
  }
  Future deleteFavUser(int? id) async {
    final db = await database;
    await db.delete('favorit', where: 'bookid = ?', whereArgs: [id]);
  }
}
