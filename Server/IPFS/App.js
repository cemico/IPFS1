/** Created by daverogers on 3/15/18. */

// references
var express = require('express');           // web server
var bodyParser = require('body-parser');    // parse out incoming data for non-GETs

// api root access
var apiPath = "/api"
var version1 = "v1"
var localPath = "."
var version1Path = "/" + version1
var currentVersion = version1
var currentVersionPath = version1Path

// datasource
var dataSourcePath = "/" + "DataSources"
var mongoDBPath = "/" + "MongoDB"
var mockDBPath = "/" + "MockDB"
var currentDBPath = mongoDBPath
var dataSource = localPath + currentVersionPath + dataSourcePath +  currentDBPath
var data = require(dataSource)

// web server instance
var app = express();

// define which port to listen on
var port = process.env.PORT || 8005

// load body parser pieces we use
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// setup top-level support routes

// main root access - good for easy routes, otherwise Router class manages better
var rootPaths = [

    // supported version
    { path : 'api',  description: 'root level access to the data'}
];

// top-level route
app.get('/', function(req, res) {

    var sHTML = "<b>Green Light Server</b><br /><br />" +
                "In brightest day, in blackest night,<br />" +
                "No evil shall escape my sight.<br />" +
                "Let those who worship evil's might<br />" +
                "Beware my power--Green Lantern's light!<br /><br />" +
                "<img src='https://wallscover.com/images/green-lantern-corps-10.jpg' width='640' height='320'><br /><br />" +
                "<i>Supported Paths</i><ul>";

    rootPaths.forEach(function(element, index, array) {

        var sLink = "<a href='http://" + req.headers.host + app.mountpath + element.path+ "'>" + element.path + "</a>";
        console.log(sLink);
        sHTML += "<li>" + sLink + " - " + element.description + "</li>";
    });

    sHTML += "</ul>";

    // simple return
    res.send(sHTML);

    // simple return
    // res.type('text/plain');
    // res.send(rootRestHelp);
});

// api versions
var apiVersions = [

    // supported version
    { path : currentVersion,  description: 'March 2018, initial version'}
];

// api route
app.get(apiPath, function(req, res) {

    var sHTML = "<b>API History</b><br /><ul>";

    apiVersions.forEach(function(element, index, array) {

        var sLink = "<a href='http://" + req.headers.host + apiPath + "/" + element.path+ "'>" + element.path + "</a>";
        console.log(sLink);
        sHTML += "<li>" + sLink + " - " + element.description + "</li>";
    });

    sHTML += "</ul>";

    // simple return
    res.send(sHTML);
});

// endpoints
var v1CryptoKeyEndpoint = "cryptokeys"
var v1CryptoKeyEndpointsPath = "/" + v1CryptoKeyEndpoint
var itemPath = "/:Id"

// api v1 access - good for easy routes, otherwise Router class manages better
var v1RestHelp = [

    // CRYPTOKEYS
    // get all
    { path : apiPath + version1Path + v1CryptoKeyEndpointsPath,              type : 'GET',    description : version1 + ': Get all / select *' },

    // get individual
    { path : apiPath + version1Path + v1CryptoKeyEndpointsPath + itemPath,   type : 'GET',    description : version1 + ': Get one / select 1'},

    // add new
    { path : apiPath + version1Path + v1CryptoKeyEndpointsPath,              type : 'POST',   description : version1 + ': Add new / insert' },

    // update individual with all fields
    { path : apiPath + version1Path + v1CryptoKeyEndpointsPath + itemPath,   type : 'PUT',    description : version1 + ': Update one - all fields / update'},

    // update individual with only new fields
    { path : apiPath + version1Path + v1CryptoKeyEndpointsPath + itemPath,   type : 'PATCH',  description : version1 + ': Update one - select fields / update'},

    // delete individual
    { path : apiPath + version1Path + v1CryptoKeyEndpointsPath + itemPath,   type : 'DELETE', description : version1 + ': Delete one / delete'}
];

// v1 route
app.get(apiPath + version1Path, function(req, res) {

    //// simple return
    //res.type('text/json');
    //res.json(v1RestHelp);

    var returnHelp = [];
    v1RestHelp.forEach(function(element, index, array) {

        // convert model object class to raw json
        var newObject = element;

        // simple link on the get all to provide self link to show all
        if (element.description.indexOf('Get all') > -1) {

            // setup self link
            var link = 'http://' + req.headers.host + element.path;
            console.log("Self Link: " + link);
            element._self = link;
        }

        // add to array
        returnHelp.push(element);
    });

    // return new array instead
    res.json(returnHelp);
});

// setup models for type conversions
var modelsPath = "/Models"
var cryptoKeyModelPath = "/cryptoKeyModel"
var v1CryptoKey = require(localPath + version1Path + modelsPath + cryptoKeyModelPath);

// create router reference (since declared as function, need the parens to execute it)
// also injects the model into the router
var routesPath = "/Routes"
var cryptoKeyRoutesPath = "/cryptoKeyRoutes"
var v1CryptoKeyRouter = require(localPath + version1Path + routesPath + cryptoKeyRoutesPath)(v1CryptoKey, version1, v1CryptoKeyEndpoint);

// load current routes
app.use(apiPath + version1Path + v1CryptoKeyEndpointsPath, v1CryptoKeyRouter);

// general error handling
process.on('uncaughtException', function (err) {

    console.log(err);
});

// have express start listening
app.listen(port, function() {

    console.log('Gulp is running my app on PORT: ' + port);
});