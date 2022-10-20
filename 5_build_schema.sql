-- https://en.wikibooks.org/wiki/SQL_Exercises/Pieces_and_providers

CREATE TABLE Pieces (
    Code INTEGER PRIMARY KEY NOT NULL,
    Name TEXT NOT NULL
);

CREATE TABLE Providers (
    Code TEXT PRIMARY KEY NOT NULL,
    Name TEXT NOT NULL
);

CREATE TABLE Provides (
    Piece INTEGER
    CONSTRAINT Fk_Pieces_Code REFERENCES Pieces(Code),
    Provider TEXT
    CONSTRAINT Fk_Providers_Code REFERENCES Providers(Code),
    Price INTEGER NOT NULL,
    PRIMARY KEY(Piece, Provider)
);

INSERT INTO Providers(Code, Name)
VALUES ('HAL', 'Clarke Enterprises'),
('RBT', 'Susan Calvin Corp.'),
('TNBC', 'Skellington Supplies');

INSERT INTO Pieces(Code, Name)
VALUES (1, 'Sprocket'),
(2, 'Screw'),
(3, 'Nut'),
(4, 'Bolt');

INSERT INTO Provides(Piece, Provider, Price)
VALUES (1, 'HAL', 10),
(1, 'RBT', 15),
(2, 'HAL', 20),
(2, 'RBT', 15),
(2, 'TNBC', 14),
(3, 'RBT', 50),
(3, 'TNBC', 45),
(4, 'HAL', 5),
(4, 'RBT', 7);
