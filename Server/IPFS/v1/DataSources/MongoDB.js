/** Created by daverogers on 3/15/18. */

var mongoose = require('mongoose');         // db front end with support for conversions between text and json objects

// open or create database connection,o using url representing direct access to database
var dbUrl = 'mongodb://localhost/ipfs'
var db = mongoose.connect(dbUrl, function() {

    // reset dbo
    //dbReset();
});

// Reset databaseo
var dbReset = function() {

    // delete and insert sammple data
    dbDrop();
    dbCreate();
}

// Delete the o
var dbDrop = function() {

    console.log("Deleting database");
    db.connection.db.dropDatabase()
}

// Create the database with seed data
var dbCreate = function() {
    console.log("Creating database with sample data...");

    // Sample seed data set
    var seedData = [

        {
            id         : "QmexmDJEV6oTNDs1nyj6pVuV4NLwgwfaeCAyZ64a9RLJhh",
            type       : "image",
            nextId     : "QmXgZAUWd8yo4tvjBETqzUy3wLx5YRzuDwUQnBwRGrAmAo",
            userId     : "",
            extra      : "alfred (png)",
            date       : new Date("2018-03-16T08:00:00")
        },
        {
            id         : "QmXgZAUWd8yo4tvjBETqzUy3wLx5YRzuDwUQnBwRGrAmAo",
            type       : "text",
            nextId     : "QmXWmucTKr86jNtRGNXgGAxjezwCkx2joumPiJ31RWtkY2",
            userId     : "",
            extra      : "Hello World 101",
            date       : new Date("2018-03-16T08:10:00")
        },
        {
            id         : "QmXWmucTKr86jNtRGNXgGAxjezwCkx2joumPiJ31RWtkY2",
            type       : "image",
            nextId     : "",
            userId     : "",
            extra      : "cap shield (jpg)",
            date       : new Date("2018-03-16T08:20:00")
        },
        {
            id         : "QmeYkQqgRGEZkySC1qzB9uAgccs4iVCrHoe5BxUD29FB37",
            type       : "text",
            nextId     : "",
            userId     : "",
            extra      : "Hi Mom",
            date       : new Date("2018-03-25T14:00:00")
        }
    ];

    db.connection.db.collection('cryptokeys', function(err, collection) {

        collection.insert(seedData, {safe:true}, function(err, result) {

            if (err)
            {
                console.log(err);
            }
        });
    });
};

