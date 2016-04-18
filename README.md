Create a webpage in Visual Studio that replicates the table below (example only) for all teams, pulling the information from the NBA database. The table should be created/calculated in a stored procedure in the database and simply bound to a data grid once returned. 

Name	Stadium	Logo	Played	Won	Lost	Played Home	Played Away	Biggest Win	Biggest Loss	Last Game Stadium	Last Game Date	MVP
Denver Nuggets	Pepsi Center	 
16	11	5	8	8	112-83	92-112	Bankers Life Fieldhouse	2013-12-31	Ty Lawson
Miami Heat	American Airlines Arena	 
16	8	8	8	8	115-83	81-112	Chesapeake Energy Arena	2014-01-01	Labron James
San Antonio Spurs	AT&T Center	 
16	9	7	8	8	116-68	78-101	United Center	2014-01-03	Tim Duncan
Oklahoma City Thunder	Chesapeake Energy Arena	 
16	5	11	8	8	115-92	81-112	Chesapeake Energy Arena	2014-01-01	Kevin Durant
Houston Rockets	Toyota Center	 
16	5	11	8	8	101-83	86-112	Toyota Center	2014-01-02	James Harden

The database table does not include references to the team logos. You will need to find the team logo on Google Images and store them in the project folder in the directory Images/Logos. The location and name of the images should be stored in the database next to the corresponding team enabling you to show the logo next to the team name in the results table you have created. You should be able to click on the logo and it should open the team’s website in another browser tab.

Under the table create a bar chart (asp:chart) that displays the Won column results by default. You should be able to click on the lost column header and it should then chart the lostresults for each team.

Key Points

SQL:	Your T-SQL should be efficient and easy to read. For this task we recommend using CTEs and CROSS APPLY to form a single T-SQL statement. Multiple sub-selects 
and temporary tables should not be used.
.NET:	For this task all database connections and data binding should be done in the code behind to enable us to evaluate your coding ability. 

