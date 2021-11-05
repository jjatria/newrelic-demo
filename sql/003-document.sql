USE panop;
CREATE TABLE document (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    bucket VARCHAR(255) NOT NULL,
    content TEXT,
    created DATETIME NOT NULL DEFAULT NOW(),
    modified DATETIME,
    deleted TINYINT NOT NULL DEFAULT 0,
    FOREIGN KEY (bucket) REFERENCES bucket(id) ON DELETE CASCADE
);
