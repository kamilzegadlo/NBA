using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NBA.Model;
using NBA.Data;

namespace NBA.Service
{
    public class DashBoardService : IDashBoardService
    {
        private DashBoardData _dashboardData;

        public DashBoardService(DashBoardData dashBoardData)
        {
            _dashboardData = dashBoardData;
        }

        public DashBoardService()
        {
            _dashboardData = new DashBoardData();
        }

        public IEnumerable<DashBoardInfoPerTeam> GetDashBoad()
        {
            return _dashboardData.GetDataForDashboard();
        }

    }
}
