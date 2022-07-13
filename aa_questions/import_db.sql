DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;
PRAGMA foreign_keys = ON;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions (id),
    FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    parent_id INTEGER,
    user_id INTEGER NOT NULL,
    body TEXT NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions (id),
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (parent_id) REFERENCES replies (id)    
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions (id),
    FOREIGN KEY (user_id) REFERENCES users (id)
);

INSERT INTO 
    users (fname, lname)
VALUES
    ('Truong', 'Nguyen'),
    ('Ari', 'Moshe');

INSERT INTO 
    questions(title, body, user_id)
VALUES
    ('Test questions', 'How many points do we need', (SELECT id FROM users WHERE fname = 'Truong' AND lname = 'Nguyen')),
    ('SQL', 'What is a FOREIGN KEY?', (SELECT id FROM users WHERE fname = 'Ari' AND lname = 'Moshe'));

INSERT INTO
    question_follows (question_id, user_id)
VALUES
    ((SELECT id FROM questions WHERE body = 'How many points do we need'), (SELECT id FROM users WHERE fname = 'Truong' AND lname = 'Nguyen')),
    ((SELECT id FROM questions WHERE body = 'What is a FOREIGN KEY?'), (SELECT id FROM users WHERE fname = 'Ari' AND lname = 'Moshe'));

INSERT INTO
    replies (question_id, parent_id, user_id, body)
VALUES 
    ((SELECT id FROM questions WHERE body = 'How many points do we need'), NULL, (SELECT id FROM users WHERE fname = 'Truong' AND lname = 'Nguyen'), '80 points'),
    ((SELECT id FROM questions WHERE body = 'What is a FOREIGN KEY?'), NULL, (SELECT id FROM users WHERE fname = 'Ari' AND lname = 'Moshe'), 'It''s foreign'),
     ((SELECT id FROM questions WHERE body = 'What is a FOREIGN KEY?'), 1, (SELECT id FROM users WHERE fname = 'Ari' AND lname = 'Moshe'), 'No i think it''s 50'),
     ((SELECT id FROM questions WHERE body = 'How many points do we need'), 2, (SELECT id FROM users WHERE fname = 'Truong' AND lname = 'Nguyen'), 'That makes no sense'),
      ((SELECT id FROM questions WHERE body = 'What is a FOREIGN KEY?'), 3, (SELECT id FROM users WHERE fname = 'Truong' AND lname = 'Nguyen'), 'No way it''s 50, it has to be 80'),
      ((SELECT id FROM questions WHERE body = 'How many points do we need'), 4, (SELECT id FROM users WHERE fname = 'Ari' AND lname = 'Moshe'), 'Which part don''t you understand?');

INSERT INTO
    question_likes (question_id, user_id)
VALUES
    ((SELECT id FROM questions WHERE body = 'How many points do we need'), (SELECT id FROM users WHERE fname = 'Ari' AND lname = 'Moshe')),
    ((SELECT id FROM questions WHERE body = 'What is a FOREIGN KEY?'), (SELECT id FROM users WHERE fname = 'Truong' AND lname = 'Nguyen'));
