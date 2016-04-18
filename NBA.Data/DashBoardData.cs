using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NBA.Model;

namespace NBA.Data
{
    public class DashBoardData
    {

        public IEnumerable<DashBoardInfoPerTeam> GetDataForDashboard()
        {
            ICollection<DashBoardInfoPerTeam> dashboard = new List<DashBoardInfoPerTeam>();
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["NBAConnection"].ConnectionString;
            using (var conn = new SqlConnection(connectionString))
            using (var command = new SqlCommand("sp_GetDashboardGrid", conn){ CommandType = CommandType.StoredProcedure }) 
            {
               conn.Open();
               SqlDataReader dr = command.ExecuteReader();

               while (dr.Read())
               {
                   DashBoardInfoPerTeam dashpboardInfoPerTeam = new DashBoardInfoPerTeam();
                   dashpboardInfoPerTeam.Name = dr["Name"].ToString();
                   dashpboardInfoPerTeam.Stadium = dr["Stadium"].ToString();
                   dashpboardInfoPerTeam.Logo = dr["Logo"].ToString();
                   dashpboardInfoPerTeam.WebPageURL = dr["URL"].ToString();
                   dashpboardInfoPerTeam.Played = Convert.ToInt32(dr["Played"]);
                   dashpboardInfoPerTeam.Won = Convert.ToInt32(dr["Won"]);
                   dashpboardInfoPerTeam.Lost = Convert.ToInt32(dr["Lost"]);
                   dashpboardInfoPerTeam.PlayedHome = Convert.ToInt32(dr["PlayedHome"]);
                   dashpboardInfoPerTeam.PlayedAway = Convert.ToInt32(dr["PlayedAway"]);
                   dashpboardInfoPerTeam.BiggestWin = dr["BiggestWin"].ToString();
                   dashpboardInfoPerTeam.BiggestLoss = dr["BiggestLoss"].ToString();
                   dashpboardInfoPerTeam.LastGameStadium = dr["LastGameStadium"].ToString();
                   dashpboardInfoPerTeam.LastGameDate = dr["LastGameDate"].ToString();
                   dashpboardInfoPerTeam.MVP = dr["MVP"].ToString();
                   dashboard.Add(dashpboardInfoPerTeam);
               }

               conn.Close();
            }
            return dashboard;
        }


    }
}
