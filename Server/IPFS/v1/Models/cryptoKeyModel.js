/** Created by daverogers on 3/15/18. */


// setup references
var mongoose = require('mongoose');
var Schema = mongoose.Schema;

// layout what the model object will look like
var cryptoKeyModel = new Schema({

    id:       { type: String,     required: true,     unique: true    },
    type:     { type: String,     required: true                      },
    nextId:   { type: String                                          },
    userId:   { type: String                                          },
    extra:    { type: String                                          },
    date:     { type: Date                                            }
});

// export the schema model, i.e. load it into mongoose
// note: mongoose likes the singular version of the collection's plurarl name defined
//       whereby it then associates itself to the plural collection.  here Agency / agencies
module.exports = mongoose.model('CryptoKey', cryptoKeyModel);