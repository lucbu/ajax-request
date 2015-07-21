/*
###############################
####    ADD PROVIDERS :    ####
###############################
Add item like the following example

###
    providerKey:{
        name: 'name',
        url: 'http://api.url/',
        fields: [
            {key:'key', type: 'text', data:'default-data', required:true},
            {key:'boolean', type: 'select', data:['true', 'false']},
            {key:'number', type: 'integer', data:0},
        ]
    },
###
*/

var providers = {
    weather:{
        name: 'weather',
        url: 'http://api.openweathermap.org/data/2.5/weather',
        fields: [
            {key:'q', type: 'text', data:'', required:true},
        ]
    },
}

module.exports = {
  providers: providers
};
