# Copyright 2013 Bayes Technologies
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include:
  - vertx.newrelic

/opt/vertx/vert.x-2.1M2.tar.gz:
  file:
    - managed
    - user: root
    - group: root
    - mode: 777
    - source: salt://vertx/files/vert.x-2.1M2.tar.gz
    - require:
      - pkg: openjdk-7-jdk

Run unzip vertx:
  cmd.run:
    - name: tar -xvf vert.x-2.1M2.tar.gz
    - cwd: /opt/vertx/
    - onlyif: if [ -d "/opt/vertx/vert.x-2.1M2" ]; then false; else true; fi
    - require:
      - file: /opt/vertx/vert.x-2.1M2.tar.gz

Create symbolic link:
  cmd.run:
    - name: ln -s /opt/vertx/vert.x-2.1M2 /opt/vertx/current
    - onlyif: if [ -d "/opt/vertx/current" ]; then false; else true; fi
    - require:
      - cmd: Run unzip vertx

/opt/vertx/current/server.js
  file:
    - managed
    - user: root
    - group: root
    - mode: 777 
    - source: salt://vertx/files/server.js
    - require:
      - cmd: Create symbolic link

/etc/init/vertx.conf
  file:
    - managed
    - user: root
    - group: root
    - mode: 777 
    - source: salt://vertx/files/vertx.conf
