using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using NBA.Service;
using NBAWebPage.ViewModels;
using NBA.Model;
using DotNet.Highcharts.Options;
using DotNet.Highcharts.Helpers;
using DotNet.Highcharts;

namespace NBAWebPage.Controllers
{
    public class DashboardController : Controller
    {
        IDashBoardService dashBoardService = new DashBoardService();

        public ActionResult Index()
        {
            IEnumerable<DashBoardInfoPerTeam> dashboard = dashBoardService.GetDashBoad();
            Highcharts wonChart = GenerateWonChart(dashboard);
            Highcharts lostChart = GenerateLostChart(dashboard);

            DashboardViewModel viewModel = new DashboardViewModel(dashboard, wonChart, lostChart);

            return View(viewModel);
        }

        public Highcharts GenerateWonChart(IEnumerable<DashBoardInfoPerTeam> dashboard)
        {
            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("Won")
                .SetXAxis(new XAxis
                {
                    Categories = dashboard.Select(t => t.Name).ToList().ToArray(),
                    Title = new XAxisTitle() { Text = "Team" }
                })
                .SetSeries(new Series
                {
                    Data = new Data(dashboard.Select(t => { Object o; o = t.Won; return o; }).ToList().ToArray()),
                    Name = "Number of wins"
                })
                .SetYAxis(new YAxis { Title = new YAxisTitle() { Text="Wins"} })
                .SetTitle(new Title() { Text = "Number of wins per team" });

            return chart;
        }

        public Highcharts GenerateLostChart(IEnumerable<DashBoardInfoPerTeam> dashboard)
        {
            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("Lost")
                .SetXAxis(new XAxis
                {
                    Categories = dashboard.Select(t => t.Name).ToList().ToArray(),
                    Title= new XAxisTitle(){Text="Team"}
                })
                .SetSeries(new Series
                {
                    Data = new Data(dashboard.Select(t => { Object o; o = t.Lost; return o; }).ToList().ToArray()),
                    Name="Number of losses"
                })
                .SetYAxis(new YAxis { Title = new YAxisTitle() { Text = "Losses" } })
                .SetTitle(new Title() { Text = "Number of losses per team" });

            return chart;
        }
    }
}