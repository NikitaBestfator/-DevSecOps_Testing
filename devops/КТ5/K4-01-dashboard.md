	
meta	
type	"db"
canSave	true
canEdit	true
canAdmin	false
canStar	false
canDelete	true
slug	"k4-02-dashboard"
url	"/d/gg6p8n/k4-02-dashboard"
expires	"0001-01-01T00:00:00Z"
created	"2026-11-12T13:22:57Z"
updated	"2026-11-12T13:25:16Z"
updatedBy	"Anonymous"
createdBy	"Anonymous"
version	2
hasAcl	false
isFolder	false
apiVersion	"v0alpha1"
folderId	0
folderUid	""
folderTitle	"General"
folderUrl	""
provisioned	false
provisionedExternalId	""
annotationsPermissions	
dashboard	
canAdd	true
canEdit	true
canDelete	true
dashboard	
annotations	
list	
0	
builtIn	1
datasource	
type	"grafana"
uid	"-- Grafana --"
enable	true
hide	true
iconColor	"rgba(0, 211, 255, 1)"
name	"Annotations & Alerts"
type	"dashboard"
editable	true
fiscalYearStartMonth	0
graphTooltip	0
id	4178137685643264
liveNow	false
panels	
0	
collapsed	false
gridPos	
h	1
w	24
x	0
y	0
id	2
title	"New row"
type	"row"
1	
datasource	
type	"prometheus"
uid	"workshop-prometheus"
fieldConfig	
defaults	
color	
mode	"palette-classic"
custom	
axisBorderShow	false
axisCenteredZero	false
axisColorMode	"text"
axisLabel	""
axisPlacement	"auto"
barAlignment	0
barWidthFactor	0.6
drawStyle	"line"
fillOpacity	0
gradientMode	"none"
hideFrom	
legend	false
tooltip	false
viz	false
insertNulls	false
lineInterpolation	"linear"
lineWidth	1
pointSize	5
scaleDistribution	
type	"linear"
showPoints	"auto"
showValues	false
spanNulls	false
stacking	
group	"A"
mode	"none"
thresholdsStyle	
mode	"off"
thresholds	
mode	"absolute"
steps	
0	{ color: "green", value: 0 }
1	{ color: "red", value: 80 }
unit	"reqps"
gridPos	
h	9
w	8
x	0
y	1
id	1
options	
legend	
calcs	[]
displayMode	"list"
placement	"bottom"
showLegend	true
tooltip	
hideZeros	false
mode	"single"
sort	"none"
pluginVersion	"13.2.3"
targets	
0	
datasource	
type	"prometheus"
uid	"workshop-prometheus"
editorMode	"code"
expr	'rate(devops_http_requests_total{role="web",status="200"}[1m])'
legendFormat	"__auto"
range	true
refId	"A"
title	"Web Requests (200)"
type	"timeseries"
preload	false
refresh	""
schemaVersion	42
time	
from	"now-6h"
to	"now"
timepicker	
refresh_intervals	
0	"5s"
1	"10s"
2	"30s"
3	"1m"
4	"5m"
5	"15m"
6	"30m"
7	"1h"
8	"2h"
9	"1d"
timezone	"browser"
title	"K4-02 Dashboard"
uid	"gg6p8n"
version	2
meta
hasAcl
