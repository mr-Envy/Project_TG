CREATE TABLE subjects (
    subject_id INTEGER PRIMARY KEY AUTOINCREMENT,
    subject_name TEXT NOT NULL UNIQUE
);

CREATE TABLE topics (
    topic_id INTEGER PRIMARY KEY AUTOINCREMENT,
    subject_id INTEGER NOT NULL,
    topic_name TEXT NOT NULL,

    FOREIGN KEY (subject_id)
        REFERENCES subjects(subject_id),

    UNIQUE (subject_id, topic_name)
);

CREATE TABLE questions (
    question_id INTEGER PRIMARY KEY AUTOINCREMENT,
    question_text TEXT NOT NULL,
    topic_id INTEGER NOT NULL,
    difficulty TEXT NOT NULL,
    correct_option TEXT NOT NULL,

    FOREIGN KEY (topic_id)
        REFERENCES topics(topic_id)
);
