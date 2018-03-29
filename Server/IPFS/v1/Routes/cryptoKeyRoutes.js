/** Created by daverogers on 3/15/18. */

// references
var express = require('express');           // web server

const IPFS = require('ipfs-mini');          // ipfs server
const ipfs = new IPFS({ host: 'localhost', port: 5001, protocol: 'http' });

// create function to act as class
var routes = function(CryptoKey, version, endPoint) {

    // router instance
    var cryptoKeyRouter = express.Router();

    // defines the routes, then later we use them
    cryptoKeyRouter.route('/')
        .get(function(req, res) {

            console.log("get all");

            // sample data
            // var responseJson = {hello: "This is my api"};
            // res.json(responseJson);

            // handle queries
            // var query = req.query;

            // scrub the data first
            var query = {};
            //if (req.query.genre)
            //    query.genre = req.query.genre;

            // find takes query optionally, and already of proper json format
            CryptoKey.find(query, function(err, cryptoKeys) {

                if (err)
                {
                    console.log(err);
                    res.status(500).send(err);
                }
                else
                {
                    //console.log("body SL: " + req.body.addSelfLink);
                    //console.log("query SL: " + req.query.addSelfLink);

                    // check from body: exist and set true
                    var addSelfLink = (req.body.addSelfLink && req.body.addSelfLink == 1 ? true : false);

                    // alternatively direct on query string
                    if (!addSelfLink) {

                        addSelfLink = (req.query.addSelfLink && req.query.addSelfLink == 1 ? true : false)
                    }

                    if (!addSelfLink) {

                        // return array of objects
                        res.json(cryptoKeys);
                    }
                    else {

                        // with the array of mongoose modeled class data objects, it'd be nice to
                        // inject in a self referencing link, so user could get to any single
                        // item directly.  since this is a modeled class, we have to create
                        // a new json and add the self link into it, then return that array
                        // note: called HATEOS or Hypermedia as the Engine of Application State
                        var returnCryptoKeys = [];
                        cryptoKeys.forEach(function(element, index, array) {

                            // convert model object class to raw json
                            var newObject = element.toJSON();

                            // add links key
                            //newObject.links = {};

                            // setup self link
                            var link = 'http://' + req.headers.host + '/api/' + version + '/' + endPoint + '/' + newObject._id;
                            console.log("Self Link: " + link);
                            //newObject.links.self = link;
                            newObject._self = link;

                            // add to array
                            returnCryptoKeys.push(newObject);
                        });

                        // return new array instead
                        res.json(returnCryptoKeys);
                    }
                 }
            });
        })
        .post(function(req, res) {

            console.log("post");

            // create a new object to add to database
            var isDirectInsert = req.body.isDirectInsert;
            var cryptoKey;
            console.log("isDirect: ", isDirectInsert);

            if (isDirectInsert) {

                // all fields specified in body with isDirectInsert = 1
                console.log(("direct insert"));
                cryptoKey = new CryptoKey(req.body);
                console.log(cryptoKey)
            }
            else {

                // get text to add to ipfs
                var text = req.body.text;

                // attempt add
                ipfs.add(text, function (err, result) {

                    if (err) {

                        // error check
                        console.log(err);
                        res.status(500).send(err);
                    }
                    else {

                        // success
                        console.log(result);

                        // save key
                        var cipfsCryptographicHashKey = result;

                        // note: only type and text declared in body
                        console.log("implicit insert");

                        // create json for create
                        var json = {
                            id: cipfsCryptographicHashKey,
                            type: req.body.type,
                            nextId: "",
                            userId: "",
                            extra: text,
                            date: Date()
                        };

                        // new mongoose object
                        cryptoKey = new CryptoKey(json);
                        console.log(cryptoKey)

                        // update or insert
                        CryptoKey.findOne({extra: text}, function(err, model) {

                            console.log("find: err:", err, " model: ", model);
                            if (!model && !err) {

                                // doesn't exist - instert
                                console.log("Insert: " + text);

                                // since this is a mongoose object from mongodb, to add object, only need to save object
                                cryptoKey.save(function(err, result) {

                                    let newObj = CryptoKey(result);
                                    if (err)
                                    {
                                        console.log(err);
                                        res.status(500).send(err);
                                    }
                                    else
                                    {
                                        // complete
                                        console.log("Successfully created key. ", newObj);
                                        res.status(201).send(newObj);
                                    }
                                });
                            }
                            else if (model) {

                                // exists - update
                                console.log("Update: " + text);

                                // update
                                model.date = Date()
                                model.save(function(err, result) {

                                    //let newObj = CryptoKey(result);
                                    if (err)
                                    {
                                        console.log(err);
                                        res.status(500).send(err);
                                    }
                                    else
                                    {
                                        // complete
                                        console.log("Successfully updated key. ", model);
                                        res.status(201).send(model);
                                    }
                                });
                            }
                            else if (err) {

                                console.log("Save Failure, returning err")
                                res.status(500).send(err);
                            }
                            else {

                                console.log("Save Unknown Failure, returning nil")
                                res.status(500).send();
                            }
                        });
                    }
                });
            }
        });

    // create middleware for Id route
    cryptoKeyRouter.use('/:cryptoKeyId', function(req, res, next) {

        // individual find (cryptoKeyId comes from above ":cryptoKeyId")
        CryptoKey.findById(req.params.cryptoKeyId, function(err, cryptoKey) {

            if (err)
            {
                console.log(err);
                res.status(500).send(err);
            }
            else if (cryptoKey)
            {
                // make the object part of the request to be used downstream
                req.cryptoKey = cryptoKey;

                // pass on to next middleware, if last, then to routes
                next();
            }
            else
            {
                // not found, send back status
                res.status(404).send('no crypto key found');
            }
        });

    });

    cryptoKeyRouter.route('/:cryptoKeyId')
        .get(function(req, res) {

            console.log("get :Id");

            // note: previous duplicated code moved into common middleware
            // middleware now handles error and no object, so only gets
            // here if a object is found and saved in the req
            res.json(req.cryptoKey);
            // res.json(cryptoKey);
        })
        .put(function(req, res) {

            console.log("put");

            // note: middleware validated / error checked already

            // update - cryptoKey set above / upstream
            req.cryptoKey.id        = req.body.id;
            req.cryptoKey.type      = req.body.type;
            req.cryptoKey.nextId    = req.body.nextId;
            req.cryptoKey.userId    = req.body.userId;
            req.cryptoKey.extra     = req.body.extra;
            req.cryptoKey.date      = req.body.date;

            // save
            req.cryptoKey.save(function(err) {

                if (err)
                {
                    console.log(err);
                    res.status(500).send(err);
                }
                else
                {
                    // send object back on success
                    res.json(req.cryptoKey);
                }
            });
        })
        .patch(function(req, res) {

            console.log("patch");

            // update only those that exist
            //if (req.cryptoKey.cryptoKey)
            //    req.cryptoKey.cryptoKey = req.body.cryptoKey;

            // note: cannot update the Id on a patch
            if (req.body._id)
                delete req.body._id;

            // update every key that exists
            for (var param in req.body)
            {
                console.log('Param: ' + param);
                req.cryptoKey[param] = req.body[param];
            }

            // save updates
            req.cryptoKey.save(function(err) {

                if (err)
                {
                    console.log(err);
                    res.status(500).send(err);
                }
                else
                {
                    // send object back on success
                    res.json(req.cryptoKey);
                }
            });
        })
        .delete(function(req, res) {

            console.log("delete");

            // already have a valid mongoose object, remove it from database
            req.cryptoKey.remove(function(err) {

                if (err)
                {
                    console.log(err);
                    res.status(500).send(err);
                }
                else
                {
                    // send back "removed" http status
                    res.status(204).send('removed');
                }
            });
        });

    return cryptoKeyRouter;
};

// expose this function
module.exports = routes;