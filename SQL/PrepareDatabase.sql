IF object_id('GetCountPlayed') IS NOT NULL
BEGIN 
   DROP FUNCTION dbo.GetCountPlayed 
END 
GO 

CREATE FUNCTION dbo.GetCountPlayed(@TeamId AS INT)  
RETURNS TABLE 
AS 
RETURN 
   ( 
		SELECT COUNT(*) AS played 
		FROM Games g  
		WHERE g.HomeTeamID=@TeamId OR g.AwayTeamID=@TeamId
   ) 
GO 

IF object_id('GetCountWon') IS NOT NULL
BEGIN 
   DROP FUNCTION dbo.GetCountWon 
END 
GO 

CREATE FUNCTION dbo.GetCountWon(@TeamId AS INT)  
RETURNS TABLE 
AS 
RETURN 
   ( 
	SELECT COUNT(*) AS won 
	FROM Games g  
	WHERE (g.HomeTeamID=@TeamId AND g.HomeScore>g.AwayScore) OR (g.AwayTeamID=@TeamId AND g.AwayScore>g.HomeScore)
   ) 
GO 

IF object_id('GetCountPlayedHome') IS NOT NULL
BEGIN 
   DROP FUNCTION dbo.GetCountPlayedHome 
END 
GO 

CREATE FUNCTION dbo.GetCountPlayedHome(@TeamId AS INT)  
RETURNS TABLE 
AS 
RETURN 
   ( 
	SELECT COUNT(*) AS playedHome 
	FROM Games g  
	WHERE g.HomeTeamID=@TeamId
   ) 
GO 

IF object_id('GetBiggestWin') IS NOT NULL
BEGIN 
   DROP FUNCTION dbo.GetBiggestWin 
END 
GO 

CREATE FUNCTION dbo.GetBiggestWin(@TeamId AS INT)  
RETURNS TABLE 
AS 
RETURN 
   ( 
	SELECT  TOP 1 
		CASE 
			WHEN g.HomeTeamID=@TeamId THEN
				CAST(g.HomeScore AS VARCHAR)+'-'+CAST(g.AwayScore AS VARCHAR)   
			ELSE
				CAST(g.AwayScore AS VARCHAR)+'-'+CAST(g.HomeScore AS VARCHAR) 
		END AS biggestWin 
	FROM Games g  
	WHERE (g.HomeTeamID=@TeamId AND g.HomeScore>g.AwayScore) OR (g.AwayTeamID=@TeamId AND g.AwayScore>g.HomeScore)
	ORDER BY ABS(g.HomeScore-g.AwayScore) DESC, GameDateTime
   ) 
GO 

IF object_id('GetBiggestLoss') IS NOT NULL
BEGIN 
   DROP FUNCTION dbo.GetBiggestLoss 
END 
GO 

CREATE FUNCTION dbo.GetBiggestLoss(@TeamId AS INT)  
RETURNS TABLE 
AS 
RETURN 
   ( 
	SELECT  TOP 1 
		CASE 
			WHEN g.HomeTeamID=@TeamId THEN
				CAST(g.HomeScore AS VARCHAR)+'-'+CAST(g.AwayScore AS VARCHAR)   
			ELSE
				CAST(g.AwayScore AS VARCHAR)+'-'+CAST(g.HomeScore AS VARCHAR) 
		END AS biggestLoss
	FROM Games g  
	WHERE (g.HomeTeamID=@TeamId AND g.HomeScore<g.AwayScore) OR (g.AwayTeamID=@TeamId AND g.AwayScore<g.HomeScore)
	ORDER BY ABS(g.HomeScore-g.AwayScore) DESC, GameDateTime
   ) 
GO 

IF object_id('GetLastGame') IS NOT NULL
BEGIN 
   DROP FUNCTION dbo.GetLastGame 
END 
GO 

CREATE FUNCTION dbo.GetLastGame(@TeamId AS INT)  
RETURNS TABLE 
AS 
RETURN 
   ( 
	SELECT TOP 1 homeTeam.Stadium AS Stadium, g.GameDateTime As GameDate
	FROM Games g
		JOIN Teams homeTeam on g.HomeTeamID=homeTeam.TeamID 
	WHERE g.HomeTeamID=@TeamId OR g.AwayTeamID=@TeamId
	ORDER BY g.GameDateTime DESC
   ) 
GO 

IF object_id('GetMVPMaxValue') IS NOT NULL
BEGIN 
   DROP FUNCTION dbo.GetMVPMaxValue 
END 
GO 

CREATE FUNCTION dbo.GetMVPMaxValue(@TeamId AS INT)  
RETURNS TABLE 
AS 
RETURN 
   ( 
		SELECT TOP 1 COUNT(MVPPlayerID) AS MVPMaxValue
		FROM Games g
			JOIN Team_Player tp ON g.MVPPlayerID=tp.PlayerID
			JOIN Players p ON p.PlayerID=tp.PlayerID
		WHERE tp.TeamID=@TeamId
		GROUP BY p.Name
		ORDER BY COUNT(MVPPlayerID) DESC, p.Name 
   ) 
GO 

IF object_id('GetMVP') IS NOT NULL
BEGIN 
   DROP FUNCTION dbo.GetMVP 
END 
GO 

CREATE FUNCTION dbo.GetMVP(@TeamId AS INT, @TeamMaxMVPValue AS INT)  
RETURNS TABLE 
AS 
RETURN 
   ( 
	SELECT STUFF((SELECT ', '+ p.Name 
		FROM Games g
			JOIN Team_Player tp ON g.MVPPlayerID=tp.PlayerID
			JOIN Players p ON p.PlayerID=tp.PlayerID
		WHERE tp.TeamID=@TeamId 
		GROUP BY p.Name
		HAVING COUNT(MVPPlayerID) = @TeamMaxMVPValue
		ORDER BY COUNT(MVPPlayerID) DESC, p.Name 
	FOR XML PATH('')), 1, 1, '') AS MVP
   ) 
GO 

IF EXISTS ( SELECT 1 
            FROM   sysobjects 
            WHERE  id = object_id(N'[sp_GetDashboardGrid]') 
                   AND OBJECTPROPERTY(id, N'IsProcedure') = 1 )
	DROP PROCEDURE sp_GetDashboardGrid
GO

CREATE PROCEDURE sp_GetDashboardGrid
AS

	SELECT	ISNULL(t.Name,'') AS Name, 
			ISNULL(t.Stadium,'') AS Stadium, 
			ISNULL(t.Logo,'/Images/Logo/undefined.jpg') AS Logo, 
			ISNULL(t.URL,'https://www.google.co.uk/webhp?q='+ISNULL(t.Name,'')) AS URL, 
			ISNULL(played.Played,0) AS Played, 
			ISNULL(won.Won,0) AS Won, 
			ISNULL(played.Played,0)-ISNULL(won.won,0) As Lost, 
			ISNULL(playedHome.PlayedHome,0) AS PlayedHome, 
			ISNULL(played.Played,0)-ISNULL(playedHome.PlayedHome,0) AS PlayedAway, 
			ISNULL(biggestWin.BiggestWin,'') AS BiggestWin, 
			ISNULL(biggestLoss.BiggestLoss,'') AS BiggestLoss, 
			ISNULL(lastGame.Stadium,'') As LastGameStadium, 
			COALESCE(CONVERT(char(10), lastGame.GameDate,126),'') As LastGameDate,
			ISNULL(MVP.MVP,'') AS MVP
	FROM Teams t
		OUTER APPLY GetCountPlayed(t.TeamID) AS played
		OUTER APPLY GetCountWon(t.TeamID) AS won
		OUTER APPLY GetCountPlayedHome(t.TeamID) AS playedHome
		OUTER APPLY GetBiggestWin(t.TeamID) AS biggestWin
		OUTER APPLY GetBiggestLoss(t.TeamID) AS biggestLoss
		OUTER APPLY GetLastGame(t.TeamID) AS lastGame
		OUTER APPLY GetMVPMaxValue(t.TeamID) AS MVPMaxValue
		OUTER APPLY GetMVP(t.TeamID, MVPMaxValue.MVPMaxValue) AS MVP
	ORDER BY t.Name 
GO
