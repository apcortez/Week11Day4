----CREATE DATABASE Ecommerce;

--CREATE TABLE Prodotto(
--IdProdotto int IDENTITY(1,1) NOT NULL,
--Nome nvarchar(50) NOT NULL,
--Descrizione nvarchar(100) NOT NULL,
--Quantita int NOT NULL,
--Prezzo int NOT NULL,
--CONSTRAINT Pk_prodotto PRIMARY KEY(IdProdotto)
--);

--CREATE TABLE Cliente(
--IdCliente int IDENTITY(1,1) NOT NULL,
--Nome nvarchar(50) NOT NULL,
--Cognome nvarchar(50) NOT NULL,
--DataNascita DATE NOT NULL,
--Constraint Pk_cliente PRIMARY KEY(IdCliente)
--);

--CREATE TABLE Indirizzo(
--IdIndirizzo int IDENTITY(1,1) NOT NULL,
--Tipo nvarchar(50) NOT NULL,
--Via nvarchar(50) NOT NULL,
--NCivico int NOT NULL,
--Città nvarchar(50) NOT NULL,
--Cap int NOT NULL,
--Provincia nvarchar(50) NOT NULL,
--Nazione nvarchar(50) NOT NULL,
--IdCliente int FOREIGN KEY REFERENCES Cliente(IdCliente)
--CONSTRAINT Pk_indirizzo PRIMARY KEY(IdIndirizzo),
--CONSTRAINT CHK_indirizzo check (Tipo IN('Residenza', 'Domicilio'))
--);

--CREATE TABLE Carta(
--IdCarta int IDENTITY(1,1) NOT NULL,
--CodiceCarta char(16) NOT NULL,
--Tipo nvarchar(50) NOT NULL,
--Scadenza DATE NOT NULL,
--Saldo decimal NOT NULL,
--IdCliente int FOREIGN KEY REFERENCES Cliente(IdCliente),
--CONSTRAINT Pk_carta PRIMARY KEY(IdCarta),
--CONSTRAINT CHK_carta check (Tipo IN ('Debito', 'Credito'))
--);

--CREATE TABLE Ordine(
--IdOrdine int IDENTITY(1,1) NOT NULL,
--DataOrdine date NOT NULL,
--Stato bit NOT NULL,
--Totale decimal NOT NULL,
--IdCliente int FOREIGN KEY REFERENCES Cliente(IdCliente),
--IdIndirizzo int FOREIGN KEY REFERENCES Indirizzo(IdIndirizzo),
--IdCarta int FOREIGN KEY REFERENCES Carta(IdCarta)
--CONSTRAINT Pk_Ordine PRIMARY KEY(IdOrdine)
--);

--CREATE TABLE Carrello(
--IdOrdine int FOREIGN KEY REFERENCES Ordine(IdOrdine),
--IdProdotto int FOREIGN KEY REFERENCES Prodotto(IdProdotto),
--Quantita int NOT NULL,
--Subtotale decimal NOT NULL,
--);

--------------------------------------------------------------------------------
CREATE PROCEDURE InsertCliente
@Nome nvarchar(50),
@Cognome nvarchar(50),
@DataNascita date,
@TipoIndirizzo nvarchar(50),
@Via nvarchar(50),
@NCivico int,
@Citta nvarchar(50),
@Cap int,
@Provincia nvarchar(50),
@Nazione nvarchar(50),
@CodiceCarta char(16),
@TipoCarta nvarchar(50),
@Scadenza date,
@Saldo decimal
AS
BEGIN
	BEGIN TRY
	DECLARE @IdCliente int
	INSERT INTO Cliente (Nome, Cognome, DataNascita) VALUES (@Nome, @Cognome, @DataNascita);
	
	SELECT @IdCliente = IdCliente FROM Cliente WHERE Nome = @Nome  and Cognome = @Cognome
	INSERT INTO Indirizzo(Tipo, Via, NCivico, Città, Cap,Provincia, Nazione, IdCliente) VALUES (@TipoIndirizzo, @Via, @NCivico, @Citta, @Cap, @Provincia, @Nazione, @IdCliente);
	INSERT INTO Carta(CodiceCarta, Tipo, Scadenza, Saldo, IdCliente) VALUES (@CodiceCarta, @TipoCarta, @Scadenza, @Saldo, @IdCliente);
	END TRY

	BEGIN CATCH
	SELECT ERROR_MESSAGE(), ERROR_LINE()
	END CATCH
END

EXECUTE InsertCliente 'Pippo', 'Neri', '2000-01-10', 'Residenza', 'Via WaltDisney', 1, 'Milano', 20123, 'Milano', 'Italia', '1111111111111111', 'Debito', '2025-02-10', 2000;