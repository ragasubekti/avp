CREATE TABLE videos (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    name                TEXT,
    codecs              TEXT,
    resolution          TEXT,
    duration            INT,
    watched_duration    INT,
    file_path           TEXT,
    thumbnail_path      TEXT,
    directory           TEXT
)
