using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using NBA.Model;
using NBA.Service;
using System.Web.Mvc;
using DotNet.Highcharts;

namespace NBAWebPage.ViewModels
{
    public class DashboardViewModel
    {
        public IEnumerable<DashBoardInfoPerTeam> Statistics { get; private set; }
        public Highcharts WonChart { get; private set; }
        public Highcharts LostChart { get; private set; }

        public DashboardViewModel(IEnumerable<DashBoardInfoPerTeam> statistics, Highcharts wonChart, Highcharts lostChart)
        {
            Statistics = statistics;
            WonChart=wonChart;
            LostChart=lostChart;
        }
    }
}