USE panop;
CREATE TABLE document (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    bucket VARCHAR(255) NOT NULL,
    content TEXT,
    FOREIGN KEY (bucket) REFERENCES bucket(id) ON DELETE CASCADE
);
