CREATE TABLE user (
        username TEXT NOT NULL UNIQUE PRIMARY KEY,
        password TEXT NOT NULL,
        email TEXT,
        gravatar TEXT,
        bio TEXT
);

CREATE TABLE post (
        id INTEGER NOT NULL PRIMARY KEY
        ASC AUTOINCREMENT,
        username TEXT NOT NULL
        CONSTRAINT fk_user_username
        REFERENCES user(username)
        ON DELETE CASCADE,
        content TEXT NOT NULL,
        date INTEGER NOT NULL
);

CREATE TABLE follow (
        id INTEGER NOT NULL PRIMARY KEY
        ASC AUTOINCREMENT,
        source TEXT NOT NULL
            CONSTRAINT fk_user_username
            REFERENCES user(username)
            ON DELETE CASCADE,
        destination TEXT NOT NULL
            CONSTRAINT fk_user_username2
            REFERENCES user(username)
            ON DELETE CASCADE
);
