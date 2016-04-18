using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NBA.Model
{
    public class DashBoardInfoPerTeam
    {
        public String Name { get; set; }
        public string Stadium { get; set; }
        public string Logo { get; set; }
        public string WebPageURL { get; set; }
        public int Played { get; set; }
        public int Won { get; set; }
        public int Lost { get; set; }
        [DisplayName("Played Home")]
        public int PlayedHome { get; set; }
        [DisplayName("Played Away")]
        public int PlayedAway { get; set; }
        [DisplayName("Biggest Win")]
        public string BiggestWin { get; set; }
        [DisplayName("Biggest Loss")]
        public string BiggestLoss { get; set; }
        [DisplayName("Last Game Stadium")]    
        public string LastGameStadium { get; set; }
        [DisplayName("Last Game Date")]  
        public string LastGameDate { get; set; }
        public string MVP { get; set; }
    }
}
