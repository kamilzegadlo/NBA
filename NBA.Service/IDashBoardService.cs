using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NBA.Model;

namespace NBA.Service
{
    public interface IDashBoardService
    {
        IEnumerable<DashBoardInfoPerTeam> GetDashBoad();
    }
}
