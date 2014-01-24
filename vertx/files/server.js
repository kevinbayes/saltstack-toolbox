/* Copyright 2013 Bayes Technologies
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

var vertx = require('vertx');
var container = require('vertx/container');
var console = require('vertx/console');
var config = container.config;

console.log('Starting Application Admin Module');

var config = {
	"modules" : [
  	{
  		"name" : "org.crashub~vertx.shell~2.0.3",
  		"config" : {
  			"cmd":".",
  			"crash.auth": "simple",
  			"crash.auth.simple.username": "admin",
  			"crash.auth.simple.password": "admin",
  			"crash.ssh.port": "2000"
  		}
  	}
  ]
}

var modules = config.modules;

for(var i = 0; i < modules.length; i++) {
	console.log('Deploying module [' + modules[i].name + ']')

	var instances = 1;
	if(modules[i].instances) {
		instance = modules[i].instances;
	}

	container.deployModule(modules[i].name, modules[i].config, instances, function(err, deployId){
	  if (!err) {
	    console.log("The verticle has been deployed, deployment ID is " + deployId);
	  } else {
	    console.log("Deployment failed! " + err.getMessage());
	  }
	});
}

//Todo add a list of running and failed modules.
vertx.createHttpServer().requestHandler(function(req) {
  req.response.end("<html><body><h1>Vertx Container Up and Running!</h1></body></html>");
}).listen(48080);