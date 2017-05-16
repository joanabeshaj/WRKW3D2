DROP TABLE if exists users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(100) NOT NULL, 
  lname VARCHAR(100) NOT NULL
);

INSERT INTO
  users (fname, lname)
VALUES
  ("Blaise", "Pascal"), ("Enrico", "Fermi"), ("Max", "Planck"), ("Stephen", "Hawking");


DROP TABLE if exists questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY, 
  title TEXT NOT NULL,
  body  TEXT, 
  author_id INTEGER NOT NULL,
  
  FOREIGN KEY (author_id) REFERENCES users(id)
);

INSERT INTO 
  questions (title, body, author_id)
SELECT
  "Blaise's question", "Lorem ipsum dolor sit amet?", users.id
FROM
  users
WHERE
  users.fname = "Blaise" AND users.lname = "Pascal";
  
INSERT INTO 
  questions (title, body, author_id)
SELECT
  "Enrico's question", "Ad diam etiam cetero mel?", users.id
FROM
  users
WHERE
  users.fname = "Enrico" AND users.lname = "Fermi";

INSERT INTO 
  questions (title, body, author_id)
SELECT
  "Max's question", "Suavitate deterruisset ea nec?", users.id
FROM
  users
WHERE
  users.fname = "Max" AND users.lname = "Planck";

INSERT INTO 
  questions (title, body, author_id)
SELECT
  "Stephen's question", "Ei est salutandi posidonium?", users.id
FROM
  users
WHERE
  users.fname = "Stephen" AND users.lname = "Hawking";

DROP TABLE if exists question_follows;

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = "Blaise" AND lname = "Pascal"),
  (SELECT id FROM questions WHERE title = "Enrico's question")),

  ((SELECT id FROM users WHERE fname = "Stephen" AND lname = "Hawking"),
  (SELECT id FROM questions WHERE title = "Enrico's question")
);

DROP TABLE if exists replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
  replies (question_id, body, user_id, parent_reply_id)
VALUES
  ((SELECT id FROM questions WHERE title = "Enrico's question"),
   "What does that mean?",
  (SELECT id FROM users WHERE fname = "Blaise" AND lname = "Pascal"),
  NULL );

INSERT INTO
  replies (question_id, body, user_id, parent_reply_id)
VALUES
  ((SELECT id FROM questions WHERE title = "Enrico's question"),
   "I have no idea!!",
  (SELECT id FROM users WHERE fname = "Stephen" AND lname = "Hawking"),
  (SELECT id FROM replies WHERE body = "What does that mean?")
);

DROP TABLE if exists question_likes;

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL, 
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = "Stephen" AND lname = "Hawking"),
  (SELECT id FROM questions WHERE title = "Enrico's question")
);

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = "Max" AND lname = "Planck"),
  (SELECT id FROM questions WHERE title = "Enrico's question")
);

-- cat import_db.sql | sqlite3 questions.db
-- Now go into your shiny, new sqlite database and try making some basic queries
-- to ensure that seeding proceeded as planned. Use sqlite3 questions.db to open 
-- the sqlite3 console with questions.db loaded.
