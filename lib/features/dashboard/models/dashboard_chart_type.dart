enum DashboardChartType {
  network('Network Chart'),
  line('Line Chart'),
  bar('Bar Chart'),
  pie('Pie Chart'),
  radar('Radar Chart'),
  heatMap('Heat Map'),
  scatter('Scatter Plot'),
  bubble('Bubble Chart');

  const DashboardChartType(this.title);

  final String title;
}
